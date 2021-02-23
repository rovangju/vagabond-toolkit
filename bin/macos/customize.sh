#!/usr/bin/env bash

#cp -aR ../common/git-track /usr/local/bin/git-track

#show user library
chflags nohidden ~/Library

#eth/wifi airdrop
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
#finder list view
defaults write com.apple.Finder FXPreferredViewStyle Nlsv
defaults write com.apple.finder AppleShowAllFiles NO 

defaults write com.apple.coreservices.uiagent CSUIHasSafariBeenLaunched -bool YES
defaults write com.apple.coreservices.uiagent CSUIRecommendSafariNextNotificationDate -date 2050-01-01T00:00:00Z
defaults write com.apple.coreservices.uiagent CSUILastOSVersionWhereSafariRecommendationWasMade -float 10.99
