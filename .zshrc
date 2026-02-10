# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
        git
        zsh-autosuggestions
        zsh-syntax-highlighting
        )

source $ZSH/oh-my-zsh.sh
alias rcedit="nano ~/.zshrc && refsh"
alias refsh="source ~/.zshrc"
alias update="sudo apt update -y && sudo apt upgrade -y"
alias get="sudo apt install -y"
alias raspi="ssh rpi@100.92.81.11"
alias kompyuter="ssh kratoes@100.84.180.3"
alias showrc="tail -n 30 ~/.zshrc"
alias code-on="ssh -f -N -L 8385:localhost:8385 kratoes@100.84.180.3"

####################### Ease of use #####################
alias rcedit='nano ~/.zshrc && refsh && clear'
alias refsh='source ~/.zshrc && clear'
alias get='sudo apt -y install'
alias update='sudo apt -y update && sudo apt -y upgrade'
alias remove='sudo apt -y remove'
#################### SysLogs #########################
alias bootlogs='cat ~/logs/*.txt'
alias cronlog='sudo tail -f /var/log/syslog | grep CRON'
alias showrc='tail -n 50 ~/.zshrc'
############## Exports ###############################
source ~/env/bin/activate
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

mkcd () {
mkdir -p "$1"
cd "$1"
}
echo '\e[5 q'
fastfetch
