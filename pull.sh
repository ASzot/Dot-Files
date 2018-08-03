# Put data from here to your settings.
rm -rf ~/.vim
cp -R ./.vim ~/.vim

rm ~/.zshrc
cp .zshrc ~/.zshrc

rm ~/.tmux.conf
cp .tmux.conf ~/.tmux.conf

rm ~/.gitconfig
cp .gitconfig ~/.gitconfig

#rm -rf ~/.kwm
#cp -R ./.kwm ~/.kwm

if [ ! -d ~/.config ]; then
  mkdir ~/.config/
fi

if [ -d ~/.config/alacritty ]; then
  rm -rf ~/.config/alacritty
fi

cp -R ./.config/alacritty/ ~/.config/alactritty/
