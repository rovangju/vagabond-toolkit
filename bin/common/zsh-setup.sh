#!/usr/bin/env bash

#brew install antigen
#apt-get install zsh-antigen && [[[ make a link for the antigen.zsh file because the .zshrc is looking for it in /usr/local* ]]]]
#apt-get install most
# Tmux plugin
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

cat os.zsh >> ~/.os.zsh

cp ../comforts/dotfiles/.zshrc $HOME/.zshrc
cp ../comforts/dotfiles/.p10k.zsh $HOME/.p10k.zsh
