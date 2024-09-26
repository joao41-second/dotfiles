

PATHS=$(pwd)


echo $PATHS
rm ~/.zshrc
ln -s $PATHS/terminal/.zshrc ~/.zshrc

rm ~/.config/terminator/config
ln -s $PATHS/terminitor/config ~/.config/terminator/config

rm -rf ~/.config/nvim
ln -s $PATHS/nvim/ ~/.config/nvim



