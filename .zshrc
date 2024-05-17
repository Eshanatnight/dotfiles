# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# sync clipboard
# cat /etc/resolv.conf | clip.exe
# Set the directory we want to store zinit and plugins
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
# zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# starship prompt
eval "$(starship init zsh)"


# Keybindings
source ~/.zsh_keys

# History
export HISTSIZE=5000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu nozstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# pnpm
export PNPM_HOME="/home/kellsatnite/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# linuxbrew
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
export HOMEBREW_AUTO_UPDATE_SECS=86400

# custom tools
export PATH="$PATH:/home/kellsatnite/tools"

# Wasmer
export WASMER_DIR="/home/kellsatnite/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"


# Rust Config
export RUST_BACKTRACE=1
export RUST_LOG=debug
export CARGO_HOME=/home/kellsatnite/.cargo
# export CARGO_TARGET_DIR="/home/kellsatnite/.rustlang/target/"

# cmake config
export CMAKE_EXPORT_COMPILE_COMMANDS=1

# Parseable Config
export P_STAGING_DIR=~/dev/parseable/staging
export P_ADDR=0.0.0.0:8000
export P_USERNAME=admin
export P_PASSWORD=admin
export P_S3_URL=http://127.0.0.1:9000
export P_S3_BUCKET=somebucket
export P_S3_ACCESS_KEY=minioadmin
export P_S3_SECRET_KEY=minioadmin
export P_S3_REGION=us-east-1
export P_RECORDS_PER_REQUEST=102400
export P_PARQUET_COMPRESSION_ALGO="gzip"

# Parseable Dev Env
alias q=". /home/kellsatnite/dev/work/env.bash 1"
alias i1=". /home/kellsatnite/dev/work/env.bash 2"
alias i2=". /home/kellsatnite/dev/work/env.bash 3"

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# fzf
eval "$(fzf --zsh)"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

# util functions
function take {
    mkdir -p "$1"
    cd "$1" || exit
}

# shorthand to jump into a directory
function z () {
    cd "$(find ~ -maxdepth 2 -type d | fzf --reverse)" || exit
}

# custom aliases
alias cls=clear
## speedtest from cli
alias spt=/home/kellsatnite/tools/spt.py
## cheat sheet for nvim
alias cs=/home/kellsatnite/dotfiles/scripts/python/cs.py
## vim -> nvim
alias vim="nvim"
## source the zshrc
alias s="source ~/.zshrc"
## list all files in the current directory
alias ls="eza --icons --group-directories-first"
## list all files in the current directory
alias la="eza --icons --group-directories-first -al"
## open any folder in vscode using fzf
alias co="find ~ -maxdepth 2 -type d | fzf --reverse --header='Open A File In VsCode' --header-first | xargs -o code"
## open any folder in nvim using fzf
alias v="find . -type f -not -path '*/target/*' -not -path '*/helm*/*' -not -path '*/build/*' -not -path '*/\.git/*' -not -path '*/venv/*' -not -path '*/.mypy*' | fzf --reverse --header='Open A File In NeoVim(Default Current Dir)' --header-first --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs -o nvim"
## luajit shorthand
alias lua=luajit
## clone a reo recursively
alias gcr="git clone --recursive"
## alias for tree
alias tree="eza --tree --level=3"
## bat diff
alias bd="git diff --name-only --relative --diff-filter=d | xargs bat --diff"
## git aliases
alias pull="git pull"
alias f="git fetch"
alias lg="git lg"

# extract any compressed file
function ex () {

    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *.tar.xz) tar -xf "$1" ;;
            *.tar.zst) unzstd "$1" ;;
            *) echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
	fi
}

# update all packages, even if they are breaking
function update () {
    sudo apt update;
    sudo apt upgrade -y;
    brew update;
    brew upgrade;
}

unalias gc
unalias gco

function gc() {
  echo "running gco func"
  if [ $# -eq 0 ]
  then
    # search for a branch w/ fuzzy finder and then check it out
    git branch | fzf --reverse --header='Checkout a git branch' --header-first | xargs git checkout
  else
    # pass the args to git checkout
    git checkout "$*"
  fi
}

function gs() {
  echo "running gs func"
  if [ $# -eq 0 ]
  then
  git branch -a | grep 'remotes/origin/' | sed 's#remotes/origin/##' | fzf --reverse --header='Switch to a remote git branch' --header-first | xargs git switch
  else
    git switch "$*"
  fi
}

unalias gd

function gd() {
    branch=$(git branch | fzf --reverse --header='Checkout a git branch' --header-first --disabled | sed 's/^\* //;s/^  //')
    header="Are You Sure You want to Delete $branch"
    response=$(echo "Yes\n No" | fzf --reverse --header="$header" --header-first)
    if [[ "$response" == "Yes" ]]
    then
        git branch -D $branch;
    fi
}

function get() {
    git checkout "$1" -- "$2"
}

# bun completions
[ -s "/home/kellsatnite/.bun/_bun" ] && source "/home/kellsatnite/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# warp on wsl thing
export WARP_ENABLE_WAYLAND=1 
export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA

