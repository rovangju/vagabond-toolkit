#!/usr/bin/env bash

brew install antigen
#apt-get install zsh-antigen && [[[ make a link for the antigen.zsh file because the .zshrc is looking for it in /usr/local* ]]]]

cp ../comforts/dotfiles/.zshrc $HOME/.zshrc
cp ../comforts/dotfiles/.p10k.zsh $HOME/.p10k.zsh
