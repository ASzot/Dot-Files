brew install tmux
brew install wget

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -P ~/
sh ~/Miniconda3-latest-MacOSX-x86_64.sh
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install Zathura
brew tap zegervdv/zathura
brew install zathura

brew install --cask skim
brew install vim
# Use this instead of exuberant ctags
brew install universal-ctags

sh ~/.dot-files/first_pull.sh
