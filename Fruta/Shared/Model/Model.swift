/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A model representing all of the data the app needs to display in its interface.
*/

import Foundation
import AuthenticationServices
import StoreKit

class Model: ObservableObject {
    @Published var order: Order?
    @Published var account: Account?
    
    var hasAccount: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return userCredential != nil && account != nil
        #endif
    }
    
    @Published var favoriteSmoothieIDs = Set<Smoothie.ID>()
    @Published var selectedSmoothieID: Smoothie.ID?
    
    @Published var searchString = ""
    
    @Published var isApplePayEnabled = true
    @Published var allRecipesUnlocked = false
    @Published var unlockAllRecipesProduct: Product?
    
    let defaults = UserDefaults(suiteName: "group.example.fruta")
    
    private var userCredential: String? {
        get { defaults?.string(forKey: "UserCredential") }
        set { defaults?.setValue(newValue, forKey: "UserCredential") }
    }
    
    private let allProductIdentifiers = Set([Model.unlockAllRecipesIdentifier])
    private var fetchedProducts: [Product] = []
    private var updatesHandler: Task<Void, Error>? = nil
    
    init() {
        // Start listening for transaction info updates, like if the user
        // refunds the purchase or if a parent approves a child's request to
        // buy.
        updatesHandler = Task {
            await listenForStoreUpdates()
        }
        fetchProducts()
        
        guard let user = userCredential else { return }
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: user) { state, error in
            if state == .authorized || state == .transferred {
                DispatchQueue.main.async {
                    self.createAccount()
                }
            }
        }
    }
    
    deinit {
        updatesHandler?.cancel()
    }
    
    func authorizeUser(_ result: Result<ASAuthorization, Error>) {
        guard case .success(let authorization) = result, let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            if case .failure(let error) = result {
                print("Authentication error: \(error.localizedDescription)")
            }
            return
        }
        DispatchQueue.main.async {
            self.userCredential = credential.user
            self.createAccount()
        }
    }
}

// MARK: - Smoothies & Account

extension Model {
    func orderSmoothie(_ smoothie: Smoothie) {
        order = Order(smoothie: smoothie, points: 1, isReady: false)
        addOrderToAccount()
    }
    
    func redeemSmoothie(_ smoothie: Smoothie) {
        guard var account = account, account.canRedeemFreeSmoothie else { return }
        account.pointsSpent += 10
        self.account = account
        orderSmoothie(smoothie)
    }
    
    func orderReadyForPickup() {
        order?.isReady = true
    }
    
    func toggleFavorite(smoothieID: Smoothie.ID) {
        if favoriteSmoothieIDs.contains(smoothieID) {
            favoriteSmoothieIDs.remove(smoothieID)
        } else {
            favoriteSmoothieIDs.insert(smoothieID)
        }
    }
    
    func isFavorite(smoothie: Smoothie) -> Bool {
        favoriteSmoothieIDs.contains(smoothie.id)
    }
    
    func createAccount() {
        guard account == nil else { return }
        account = Account()
        addOrderToAccount()
    }
    
    func addOrderToAccount() {
        guard let order = order else { return }
        account?.appendOrder(order)
    }
    
    func clearUnstampedPoints() {
        account?.clearUnstampedPoints()
    }

    var searchSuggestions: [Ingredient] {
        Ingredient.all.filter {
            $0.name.localizedCaseInsensitiveContains(searchString) &&
            $0.name.localizedCaseInsensitiveCompare(searchString) != .orderedSame
        }
    }
}

// MARK: - Store API

extension Model {
    static let unlockAllRecipesIdentifier = "com.example.apple-samplecode.fruta.unlock-recipes"
    
    func product(for identifier: String) -> Product? {
        return fetchedProducts.first(where: { $0.id == identifier })
    }
    
    func purchase(product: Product) {
        Task { @MainActor in
            do {
                let result = try await product.purchase()
                guard case .success(.verified(let transaction)) = result,
                      transaction.productID == Model.unlockAllRecipesIdentifier else {
                    return
                }
                self.allRecipesUnlocked = true
            } catch {
                print("Failed to purchase \(product.id): \(error)")
            }
        }
    }
    
}

// MARK: - Private Logic

extension Model {
    
    private func fetchProducts() {
        Task { @MainActor in
            self.fetchedProducts = try await Product.products(for: allProductIdentifiers)
            self.unlockAllRecipesProduct = self.fetchedProducts
                .first { $0.id == Model.unlockAllRecipesIdentifier }
            // Check if the user owns all recipes at app launch.
            await self.updateAllRecipesOwned()
        }
    }
    
    @MainActor
    private func updateAllRecipesOwned() async {
        guard let product = self.unlockAllRecipesProduct else {
            self.allRecipesUnlocked = false
            return
        }
        guard let entitlement = await product.currentEntitlement,
              case .verified(_) = entitlement else {
                  self.allRecipesUnlocked = false
                  return
        }
        self.allRecipesUnlocked = true
    }
    
    /// - Important: This method never returns, it will only suspend.
    @MainActor
    private func listenForStoreUpdates() async {
        for await update in Transaction.updates {
            guard case .verified(let transaction) = update else {
                print("Unverified transaction update: \(update)")
                continue
            }
            guard transaction.productID == Model.unlockAllRecipesIdentifier else {
                continue
            }
            // If this transaction was revoked, make sure the user no longer
            // has access to it.
            if transaction.revocationReason != nil {
                print("Revoking access to \(transaction.productID)")
                self.allRecipesUnlocked = false
            } else {
                self.allRecipesUnlocked = true
                await transaction.finish()
            }
        }
    }
    
}
