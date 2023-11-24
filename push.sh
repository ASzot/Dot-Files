# Put data from settings to here.
rm -rf ./nvim
cp -R ~/.config/nvim ./

rm -rf ./ranger
cp -R ~/.config/ranger ./

rm ./.gitconfig
cp ~/.gitconfig ./

rm ./.tmux.conf
cp ~/.tmux.conf ./

rm ./.zshrc
cp ~/.zshrc ./

rm ./.bashrc
cp ~/.bashrc ./

if [ -d ~/.config/alacritty ]; then
  rm -rf ./.config/alacritty
  cp -R ~/.config/alacritty/ ./.config/alactritty/
fi
