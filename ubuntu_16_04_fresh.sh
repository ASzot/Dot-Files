# Fresh install setup for Ubuntu 16.04
sudo apt-get update
sudo apt-get -y install tmux
sudo apt-get -y install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sh pull.sh

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -P ~/
sudo apt-get install build-essential
sudo apt-get install exuberant-ctags
