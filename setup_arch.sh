#!/bin/bash

yes | sudo pacman -S yay
yes | yay -S neovim-nightly-bin \
    fzf\
    zsh\
    starship\
    docker\
    docker-compose\
    nodejs\
    npm\
    eza\
    go\
    ghq\
    peco\
    xxd\
    nasm\
    peda


mkdir ~/repo
git config --global ghq.root '~/repo'
ghq get https://github.com/marlonrichert/zsh-autocomplete.git







## font HackGen Nerd Fonts Console
wget https://github.com/yuru7/HackGen/releases/download/v2.9.0/HackGen_NF_v2.9.0.zip
unzip HackGen_NF_v2.9.0.zip
cp -r HackGen_NF_v2.9.0 ~/.local/share/fonts
fc-cache -vf
rm -rf HackGen_NF_v2.9.0 HackGen_NF_v2.9.0.zip



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
# zsh-autocomplete settings

source ~/repo/github.com/marlonrichert/zsh-autocomplete/zsh-autocomplete.plugin.zsh
alias l="ls -l"
alias la="ll -a"
alias vim="nvim"


# peco settings
## 過去に実行したコマンドを選択。ctrl-rにバインド。
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^R' peco-select-history

## 過去に実行したディレクトリ移動を選択。ctrl-gにバインド。
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function peco-cdr () {
  local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
  if [ -n "$selected_dir" ]; then
    BUFFER="cd `echo $selected_dir | awk '{print$2}'`"
    CURSOR=$#BUFFER
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^G' peco-cdr

## ghqとの連携。ghqの管理化にあるリポジトリを一覧表示する。ctrl - ]にバインド。
function peco-repo () {
  local selected_dir=$(ghq list -p | peco --prompt="repo >" --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-repo
bindkey '^]' peco-repo


### 必ず末尾にかく starship
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


