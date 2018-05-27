# Fresh install setup for Ubuntu 16.04
sudo apt-get update
sudo apt-get -y install tmux
sudo apt-get -y install zsh
wget -O - https://raw.githubusercontent.com/denysdovhan/spaceship-zsh-theme/master/install.zsh -P ~/ | zsh
sh ubuntu_pull.sh
chsh -s `which zsh`

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -P ~/
sudo apt-get install build-essential
sudo apt-get install exuberant-ctags
