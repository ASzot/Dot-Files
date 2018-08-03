# Put data from settings to here.
rm -rf ./.vim
cp -R ~/.vim ./

rm ./.gitconfig
cp ~/.gitconfig ./

rm ./.zshrc
cp ~/.zshrc ./

rm ./.tmux.conf
cp ~/.tmux.conf ./

if [ -d ~/.config/alacritty ]; then
  rm -rf ./.config/alacritty
  cp -R ~/.config/alacritty/ ./.config/alactritty/
fi
