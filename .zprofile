name=$(uname)
# eval homebrew and source .zsh.linux | .zsh.macos
if [[ $name == "Linux" ]]; then
	source ~/.zsh.linux
else
	source ~/.zsh.macos
fi
