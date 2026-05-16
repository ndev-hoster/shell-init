sudo pacman -Sy --noconfirm nvm vscodium
python3 -m venv env
cp ~/.config/fish/config.fish ~/.config/fish/config.fish.bak
cp config.fish ~/.config/fish/config.fish
exit