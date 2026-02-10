# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed or not in PATH, run pkg install git" >&2
    exit 1
fi
sudo apt install zsh fastfetch openssh python3 nvm
# Run Oh My Zsh installer in unattended mode
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

python3 -m venv env
# The Oh My Zsh installer creates a .zshrc, so we back it up before replacing.
cp ~/.zshrc ~/zshrc.bak
cp .zshrc ~/.zshrc
chsh -s zsh
exit