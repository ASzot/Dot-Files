# Put data from settings to here.
rm -rf ./.vim
cp -R ~/.vim ./

rm ./.gitconfig
cp ~/.gitconfig ./

rm ./.tmux.conf
cp ~/.tmux.conf ./

rm ./.zshrc
cp ~/.zshrc ./

if [ -d ~/.config/alacritty ]; then
  rm -rf ./.config/alacritty
  cp -R ~/.config/alacritty/ ./.config/alactritty/
fi
