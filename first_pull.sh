cd ~/.dot-files

cp sshconfig ~/.ssh/config
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
sh pull.sh
sh install/min_install.sh

cd - 
