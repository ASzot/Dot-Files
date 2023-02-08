#!/bin/sh
#
rm -rf ~/.config/nvim
cp -R ./nvim ~/.config/nvim

rm ~/.zshrc
cp .zshrc ~/.zshrc

rm ~/.tmux.conf
cp .tmux.conf ~/.tmux.conf

rm ~/.gitconfig
cp .gitconfig ~/.gitconfig

rm ~/.bashrc
cp .bashrc ~/.bashrc

rm ~/.profile
cp .profile ~/.profile
