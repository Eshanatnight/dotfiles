#! /bin/bash

if [[ -d $HOME/dotfiles ]]; then
	printf "dotfiles needs to be cloned in to '%s'\n" "$HOME"/dotfiles
	exit 1
fi

# How to stow.
# while being in the dotfiles directory
# stow -t <path_to_where_you_want_to_stow> <folder_to_stow>

printf "Installing Rust\n"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

printf "Installing Homebrew\n"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

name=$(uname)

if [[ $name == "Linux" ]]; then
	sudo apt-get install build-essential procps
	source "$HOME"/dotfiles/.zprofile
	printf "Installing stow\n"
	brew bundle
	stow -d . -t "$HOME" .
	source "$HOME"/.zshrc
	WARP_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}"/warp-terminal
	mkdir -p "$WARP_ROOT"
	stow -t "$WARP_ROOT" .warp
	printf "Warp terminal config was installed\n"
	printf "Install Warp terminal manually\n"
else
	printf "Installing Stuff\n"
	source "$HOME"/dotfiles/.zprofile
	brew bundle
	brew bundle --file="$HOME"/dotfiles/brew.extra
	stow -d . -t "$HOME" .
	source "$HOME"/.zshrc
fi
