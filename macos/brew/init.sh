#!/usr/bin/env bash

BREW_DIR=$HOME/dotfiles/macos/brew

# Install Homebrew
if ! [[ -x "$(command -v brew)" ]]; then 
  printf "Homebrew not found on this system; Installing...\\n"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Brew bundle
printf "Checking Brewfile for missing packages...\\n"
(cd "$BREW_DIR" && exec brew bundle)

# Update, upgrade, cleanup
brew update
brew upgrade
brew cleanup