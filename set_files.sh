PATHS=$(pwd)

echo $PATHS

if [ "$1" -eq 1 ]; then
	rm ~/.zshrc
	ln -s $PATHS/terminal/.zshrc ~/.zshrc
else
	echo "nao modou .zshrc"
fi

#rm ~/.config/terminator/config
#ln -s $PATHS/terminitor/config ~/.config/terminator/config

rm -rf ~/.config/nvim
ln -s $PATHS/nvim/ ~/.config/nvim

rm -rf ~/.tmux
ln -s $PATHS/tmux/.tmux ~/.tmux

rm -rf ~/.tmux.conf
ln -s $PATHS/tmux/.tmux.conf ~/.tumx.conf

rm -rf ~/.tmux.conf.local
ln -s $PATHS/tmux/.tmux.conf.local ~/.tmux.conf.local

cd ~

ln -s -f .tmux/.tmux.conf
