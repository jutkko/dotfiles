#!/bin/bash

set -ex

FORMULAS=(
  "caskroom/cask/brew-cask"
  ag
  chruby
  coreutils
  direnv
  fasd
  fzf
  git
  git-duet
  go
  gpg
  htop
  jq
  pstree
  reattach-to-user-namespace
  tig
  tmate
  tmux
  tree
  watch
)

CASKS=(
  flycut
  screenhero
  slack
  vagrant
  virtualbox
)

function keep_sudo {
  # Ask for password upfront
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until the script has finished.
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

function check_ssh_keys {
  ssh-add -l || return 1
}

function brew_stuff {
  which brew || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  for tap in ${TAPS[@]}; do
    brew tap $tap
  done

  brew update
  brew upgrade

  for formula in ${FORMULAS[@]}; do
    brew install $formula
  done

  for cask in ${CASKS[@]}; do
    brew cask install $cask
  done
}

keep_sudo
check_ssh_keys || (echo "Make sure your ssh keys are set up (e.g. run ssh-keygen or put in your USB key) before running" && exit 1)
brew_stuff
