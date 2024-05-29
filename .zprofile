TOOL_HOME="$HOME/tools"
[ ! -d "$TOOL_HOME" ] && mkdir -p "$TOOL_HOME"

CMAKE_LINT_PATH="$HOME/.local/share/nvim/mason/packages/cmakelint/venv/bin/cmakelint"
CMAKE_LINT_LINK="$HOME/tools/cmake-lint"

if [ -e "$CMAKE_LINT_PATH" ] && [ ! -e "$CMAKE_LINT_LINK" ]; then
	ln -s "$CMAKE_LINT_PATH" "$CMAKE_LINT_LINK"
fi

VCPKG_LOCATION="$TOOL_HOME/vcpkg"
# Download vcpkg, if it's not there yet
[ ! -d "$VCPKG_LOCATION" ] && git clone https://github.com/microsoft/vcpkg.git "$VCPKG_LOCATION"

name=$(uname)
# eval homebrew and source .zsh.linux | .zsh.macos
if [[ $name == "Linux" ]]; then
	source ~/.zsh.linux
else
	source ~/.zsh.macos
fi
