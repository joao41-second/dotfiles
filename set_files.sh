PATHS=$(pwd)

echo $PATHS


mkdir ~/.config/
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

cd ~ 
ln -s -f ./.config/dconf $PATHS/dconf 
