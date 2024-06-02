#! /bin/sh

# How to stow.
# while being in the dotfiles directory
# stow -t <path_to_where_you_want_to_stow> <folder_to_stow>

printf "Installing Rust\n"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

printf "Installing Homebrew\n"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

name=$(uname)

if [[ $name == "Linux" ]]; then
	sudo apt-get install build-essential procps curl file git cmake ninja jq ripgrep zsh mold
	printf "Installing stow\n"
	brew bundle
	stow -d . -t $HOME .
	source ~/.zshrc
	local WARP_ROOT=${XDG_DATA_HOME:-$HOME/.local/share}/warp-terminal
	mkdir -p $WARP_ROOT
	stow -t $WARP_ROOT .warp
	printf "Warp terminal config was installed\n"
	printf "Install Warp terminal manually\n"
else
	printf "Installing Stuff\n"
	brew bundle
	brew bundle --file=./brew.extra
	stow -d . -t $HOME .
	source ~/.zshrc
fi
