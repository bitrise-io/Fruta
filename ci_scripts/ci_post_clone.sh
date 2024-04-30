#!/bin/sh
 
xcrun simctl list runtimes -v

printenv

brew config

ls -la $HOMEBREW_REPOSITORY


exit 1
