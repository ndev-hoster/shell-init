## Set values
# Hide welcome message & ensure we are reporting fish as shell
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -xU MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -xU MANROFFOPT "-c"
set -x SHELL /usr/bin/fish

## Export variable need for qt-theme
if type "qtile" >> /dev/null 2>&1
   set -x QT_QPA_PLATFORMTHEME "qt5ct"
end

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low


## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end


## Starship prompt
if status --is-interactive
   source ("/usr/bin/starship" init fish --print-full-init | psub)
end


## Advanced command-not-found hook
source /usr/share/doc/find-the-command/ftc.fish


## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | string trim --right --chars=/)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Cleanup local orphaned packages
function cleanup
    while pacman -Qdtq
        sudo pacman -R (pacman -Qdtq)
    end
end

## Useful aliases

# Replace ls with eza
alias ll 'eza -al --color=always --group-directories-first --icons' # preferred listing
alias ls 'eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias la 'eza -l --color=always --group-directories-first --icons'  # long format
alias lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
alias l. 'eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles

# Replace some more things with better alternatives
abbr cat 'bat --style header,snip,changes'
if not test -x /usr/bin/yay; and test -x /usr/bin/paru
    alias yay 'paru'
end


# Common use
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias big 'expac -H M "%m\t%n" | sort -h | nl'     # Sort installed packages according to size in MB (expac must be installed)
alias dir 'dir --color=auto'
alias fixpacman 'sudo rm /var/lib/pacman/db.lck'
alias gitpkg 'pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
alias grep 'ugrep --color=auto'
alias egrep 'ugrep -E --color=auto'
alias fgrep 'ugrep -F --color=auto'
alias grubup 'sudo update-grub'
alias hw 'hwinfo --short'                          # Hardware Info
alias ip 'ip -color'
alias psmem 'ps auxf | sort -nr -k 4'
alias psmem10 'ps auxf | sort -nr -k 4 | head -10'
alias rmpkg 'sudo pacman -Rdd'
alias tarnow 'tar -acf '
alias untar 'tar -zxvf '
alias upd '/usr/bin/garuda-update'
alias vdir 'vdir --color=auto'
alias wget 'wget -c '

# Get fastest mirrors
alias mirror 'sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias mirrora 'sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist'
alias mirrord 'sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist'
alias mirrors 'sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist'

# Help people new to Arch
alias apt 'man pacman'
alias apt-get 'man pacman'
alias please 'sudo'
alias tb 'nc termbin.com 9999'
alias helpme 'echo "To print basic information about a command use tldr <command>"'
alias pacdiff 'sudo -H DIFFPROG=meld pacdiff'

# Get the error messages from journalctl
alias jctl 'journalctl -p 3 -xb'

# Recent installed packages
alias rip 'expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl'

## Run fastfetch if session is interactive
if status --is-interactive && type -q fastfetch
   fastfetch --config neofetch.jsonc
end


############### CUSTOM ALIASES ############
alias rcedit='codium ~/.config/fish/config.fish'
alias refsh='source ~/.config/fish/config.fish'
alias get='sudo pacman -Sy --noconfirm'
alias pac-search='pacman -Ss'
alias remove='sudo pacman -Rns --noconfirm'
alias clean='sudo pacman -Sc && sudo pacman -Rns $(pacman -Qtdq) --no-confirm'
alias keybinds='cat ~/keybinds.txt'
alias raspi='ssh rpi@100.92.81.11'
alias nvidia-rescan='echo 1 | sudo tee /sys/bus/pci/rescan'
alias nvidia-detect='lspci | grep -i nvidia'

function focus
    if test (count $argv) -eq 0
        echo "Usage: focus [click|mouse|sloppy]"
        return 1
    end

    set mode $argv[1]
    gsettings set org.gnome.desktop.wm.preferences focus-mode $mode
    echo "Focus mode set to: $mode"
end


############## DOCKER ALIASES ###########
alias excontrm='docker rm -v $(docker ps --filter status=exited -q)'

############# OLLAMA DOCKER ###############
alias oll-docker-it='echo "Does not run a model, just logs you into the ollama image" && docker exec -it ollama bash'
function oll-docker
    set model_name $argv[1]  # Capture the first argument
    docker exec -it ollama ollama run $model_name  # Use it in the Docker command
end

############# ENV VARIABLES ##############
fzf --fish | source
export FZF_ALT_C_COMMAND='find -L . -maxdepth 5 -type d'

# opencode
fish_add_path /home/kratoes/.opencode/bin
# npm global path
fish_add_path ~/.npm-global/bin
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/kratoes/miniconda3/bin/conda
    eval /home/kratoes/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/kratoes/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/kratoes/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/kratoes/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

alias ml-env='conda activate /home/kratoes/learn-ai/ml-env'