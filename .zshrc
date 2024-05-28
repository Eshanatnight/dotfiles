# Set the directory we want to store zinit and plugins
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"


# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname "$ZINIT_HOME")"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

VCPKG_LOCATION="$HOME/tools/vcpkg"
# Download vcpkg, if it's not there yet
if [ ! -d "$VCPKG_LOCATION" ]; then
   mkdir -p "$(dirname "$VCPKG_LOCATION")"
   git clone https://github.com/microsoft/vcpkg.git "$VCPKG_LOCATION"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

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
zinit snippet OMZP::brew
zinit snippet OMZP::eza
zinit snippet OMZP::fzf


# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# starship prompt
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# fzf
eval "$(fzf --zsh)"

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

# FZF Colors
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

export HOMEBREW_AUTO_UPDATE_SECS=86400
# custom tools
export PATH="$PATH:$HOME/tools"

# source .zsh.linux | .zsh.macos
name=$(uname)

if [[ $name == "Linux" ]]; then
    source ~/.zsh.linux
    if [[ ! "$PATH" == */home/linuxbrew/.linuxbrew/opt/fzf/bin* ]]; then
      PATH="${PATH:+${PATH}:}/home/linuxbrew/.linuxbrew/opt/fzf/bin"
    fi

    eval "$(fzf --zsh)"

else
    source ~/.zsh.macos
    if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
        PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
    fi

    eval "$(fzf --zsh)"
fi

# Rust Config
export RUST_BACKTRACE=1
export RUST_LOG=debug
export CARGO_HOME="$HOME/.cargo"
# export CARGO_TARGET_DIR="$HOME/.rustlang/target/"

# cmake config
export CMAKE_EXPORT_COMPILE_COMMANDS=1

# util functions
function take {
    mkdir -p "$1"
    cd "$1" || exit
}

# things to help manage my dotfiles
export DOTFILES_DIR="$HOME/dotfiles"

# custom aliases
alias cls=clear
## speedtest from cli
alias spt="$HOME"/dotfiles/scripts/python/spt.py
## cheat sheet for nvim
alias cs="$HOME"/dotfiles/scripts/python/cs.py
## vim -> nvim
alias vim="nvim"
## source the zshrc
alias s="source ~/.zshrc"
## list all files in the current directory
alias ls="eza --icons --group-directories-first"
## list all files in the current directory
alias la="eza --icons --group-directories-first -al"
## luajit shorthand
alias lua=luajit
## alias for tree
alias tree="eza --tree --level=3"
## bat diff
alias bd="git diff --name-only --relative --diff-filter=d | xargs bat --diff"
## git aliases
alias gpl="gl"
alias f="gf --prune"
alias lg="git lg"
alias gcr="git clone --recursive"

# dotfiles syncing(i dont want to add the script to my path)
alias dotfiles="$DOTFILES_DIR/bin/dot"
alias dot="$DOTFILES_DIR/bin/dot"

## zinit
alias zstatus="zinit zstatus"
alias zupdate="zinit update --parallel 40"

## open any folder in nvim using fzf
alias v="find . -type f -not -path '*/target/*' -not -path '*/helm*/*' -not -path '*/build/*' -not -path '*/\.git/*' -not -path '*/venv/*' -not -path '*/.mypy*' -not -path '*/\.Trash/*' | fzf --reverse --header='Open A File In NeoVim(Default Current Dir)' --header-first --cycle --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs -o nvim"


## shorthand to extract a zip
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

unalias gc
unalias gd
## use fzf to checkout a git branch
function gc() {
  if [ $# -eq 0 ]
  then
    # search for a branch w/ fuzzy finder and then check it out
    git branch | fzf --reverse --header='Checkout a git branch' --header-first --cycle | xargs git checkout
  else
    # pass the args to git checkout
    git checkout "$*"
  fi
}

## use fzf to switch to a remote git branch
function gs() {
  echo "running gs func"
  if [ $# -eq 0 ]
  then
  git branch -a | grep 'remotes/origin/' | sed 's#remotes/origin/##' | fzf --reverse --header='Switch to a remote git branch' --header-first --cycle | xargs git switch
  else
    git switch "$*"
  fi
}

function gd() {
    branch=$(git branch | fzf --reverse --header='Select branch to Delete' --header-first --disabled --cycle | sed 's#^\* ##;s#^  ##')
    header="Are You Sure You want to Delete $branch"
    response=$(echo "Yes\n No" | fzf --reverse --header="$header" --header-first --cycle)
    if [[ "$response" == "Yes" ]]
    then
        git branch -D "$branch";
    fi
}

function get() {
    git checkout "$1" -- "$2"
}

# shorthand to jump into a directory
function z() {
	cd "$(find ~ -type d -not -path '*/\.Trash/*' -maxdepth 2 | fzf --reverse --cycle)" || exit
}

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# path to scripts and tools
export PATH="$HOME/tools/vcpkg":$PATH
export PATH="$HOME/go/bin":$PATH
export PATH="$HOME/.bun/bin":$PATH

# pnpm
if [[ $(command -v pnpm)  ]]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi
# pnpm end

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ $(command -v wasmer) ] && [ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

