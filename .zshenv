. "$HOME/.cargo/env"

# path to scripts and tools
export PATH="$HOME/tools/vcpkg":$PATH
export PATH="$HOME/go/bin":$PATH
export PATH="$HOME/.bun/bin":$PATH

# things to help manage my dotfiles
export DOTFILES_DIR="$HOME/dotfiles"

# Rust Config
export RUST_BACKTRACE=1
export RUST_LOG=debug
export CARGO_HOME="$HOME/.cargo"
# export CARGO_TARGET_DIR="$HOME/.rustlang/target/"

# cmake config
export CMAKE_EXPORT_COMPILE_COMMANDS=1

# FZF Colors
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

export HOMEBREW_AUTO_UPDATE_SECS=86400
# custom tools
export PATH="$PATH:$HOME/tools"
