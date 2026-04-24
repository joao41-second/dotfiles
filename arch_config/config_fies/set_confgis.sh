PATHS=$(pwd)

echo $PATHS
rm -fr  ~/.config/hypr/
ln -s $PATHS/hypr ~/.config/hypr

rm -fr  ~/.config/kitty/
ln -s $PATHS/kitty ~/.config/kitty
