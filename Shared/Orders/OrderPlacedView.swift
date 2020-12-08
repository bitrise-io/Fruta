/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view presented to the user once they order a smoothie, and when it's ready to be picked up.
*/

import SwiftUI
import AuthenticationServices
import StoreKit

struct OrderPlacedView: View {
    @EnvironmentObject private var model: FrutaModel
    
    #if APPCLIP
    @State private var presentingAppStoreOverlay = false
    #endif
    
    var orderReady: Bool {
        guard let order = model.order else { return false }
        return order.isReady
    }
    
    var presentingBottomBanner: Bool {
        #if APPCLIP
        if presentingAppStoreOverlay { return true }
        #endif
        return !model.hasAccount
    }
    
    var blurView: some View {
        #if os(iOS)
        return VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
        #else
        return VisualEffectBlur()
        #endif
    }
    
    var signUpButton: some View {
        SignInWithAppleButton(.signUp, onRequest: { _ in }, onCompletion: model.authorizeUser)
            .frame(minWidth: 100, maxWidth: 400)
            .padding(.horizontal, 20)
    }
    
/// - Tag: ActiveCompilationConditionTag
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            orderStatusCard
            
            Spacer()
            
            if presentingBottomBanner {
                bottomBanner
            }
            
            #if APPCLIP
            Text("App Store Overlay")
                .hidden()
                .appStoreOverlay(isPresented: $presentingAppStoreOverlay) {
                    SKOverlay.AppClipConfiguration(position: .bottom)
                }
            #endif
        }
        .onChange(of: model.hasAccount) { _ in
            #if APPCLIP
            if model.hasAccount {
                presentingAppStoreOverlay = true
            }
            #endif
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                if let order = model.order {
                    order.smoothie.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color("order-placed-background")
                }
                
                blurView
                    .opacity(model.order!.isReady ? 0 : 1)
            }
            .ignoresSafeArea()
        )
        .animation(.spring(response: 0.25, dampingFraction: 1), value: orderReady)
        .animation(.spring(response: 0.25, dampingFraction: 1), value: model.hasAccount)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.model.orderReadyForPickup()
            }
            #if APPCLIP
            if model.hasAccount {
                presentingAppStoreOverlay = true
            }
            #endif
        }
    }
    
    var orderStatusCard: some View {
        FlipView(visibleSide: orderReady ? .back : .front) {
            Card(
                title: "Thank you for your order!",
                subtitle: "We will notify you when your order is ready."
            )
        } back: {
            Card(
                title: "Your smoothie is ready!",
                subtitle: "\(model.order?.smoothie.title ?? "Your smoothie") is ready to be picked up."
            )
        }
        .animation(.flipCard, value: orderReady)
        .padding()
    }
    
    var bottomBanner: some View {
        VStack {
            if !model.hasAccount {
                Text("Sign up to get rewards!")
                    .font(Font.headline.bold())
                
                #if os(iOS)
                signUpButton
                    .frame(height: 45)
                #else
                signUpButton
                #endif
            } else {
                #if APPCLIP
                if presentingAppStoreOverlay {
                    Text("Get the full smoothie experience!")
                        .font(Font.title2.bold())
                        .padding(.top, 15)
                        .padding(.bottom, 150)
                }
                #endif
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            blurView
                .opacity(orderReady ? 1 : 0)
                .padding(.bottom, -100)
                .ignoresSafeArea()
        )
    }
    
    struct Card: View {
        var title: String
        var subtitle: String
        
        var body: some View {
            Circle()
                .fill(BackgroundStyle())
                .overlay(
                    VStack(spacing: 16) {
                        Text(title)
                            .font(Font.title.bold())
                            .textCase(.uppercase)
                            .layoutPriority(1)
                        Text(subtitle)
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                )
                .frame(width: 300, height: 300)
        }
    }
}

struct OrderPlacedView_Previews: PreviewProvider {
    static let orderReady: FrutaModel = {
        let model = FrutaModel()
        model.orderSmoothie(Smoothie.berryBlue)
        model.orderReadyForPickup()
        return model
    }()
    static let orderNotReady: FrutaModel = {
        let model = FrutaModel()
        model.orderSmoothie(Smoothie.berryBlue)
        return model
    }()
    static var previews: some View {
        Group {
            #if !APPCLIP
            OrderPlacedView()
                .environmentObject(orderNotReady)
            
            OrderPlacedView()
                .environmentObject(orderReady)
            #endif
        }
    }
}
