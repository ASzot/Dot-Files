#!/bin/sh
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -P ~/
sh ~/Miniconda3-latest-Linux-x86_64.sh
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
cd ~/.dot-files
sh pull.sh
cd ~
