#!/bin/bash

yes | sudo pacman -S yay
yes | yay -S neovim-nightly-bin \
    zsh \
    starship\
    docker \
    docker-compose\
    nodejs\
    npm

sudo systemctl enable docker\
    sshd

mkdir ~/.config/nvim
touch ~/.config/nvim/autoload
touch ~/.config/nvim/init.vim

## vim plug
## https://github.com/junegunn/vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
### nvim settings
###https://github.com/149036/.config


# rust install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# git
git config --global user.email sqrt2c@gmail.com
git config --global user.name 149036
git config -l


# change default shell
cat /etc/shells
chsh -s /bin/zsh
sudo reboot


touch ~/.zshrc
# .zshrc
################################################################################################################
cat << EOF > ~/.zshrc
lias l="ls -l"
alias la="ll -a"
alias vim="nvim"


###
eval "$(starship init zsh)"
EOF
################################################################################################################

touch ~/.config/starship.toml
## starship
################################################################################################################
cat << EOF > ~/.config/starship.toml
"$schema" = 'https://starship.rs/config-schema.json'
add_newline = true
[character]
format = "[\\$](green bold) "

[directory]
truncation_length = 3

[git_branch]
symbol = ''
format = '\([$symbol$branch(:$remote_branch)]($style)\)'

[git_status]
format = '([$all_status$ahead_behind]($style) )'
conflicted = ''
ahead = ''
behind = ''
diverged = ''
up_to_date = '✓'
untracked = ''
stashed = ''
modified = '🔥'
staged = ''
renamed = ''
deleted = ''

[package]
disabled = true

[nodejs]
disabled = true

[gcloud]
disabled = true
EOF
################################################################################################################


