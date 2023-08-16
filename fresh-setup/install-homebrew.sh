cd ~;
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d ~/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -r ~/.profile && echo "eval \"$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
echo "eval \"$($(brew --prefix")/bin/brew shellenv)\"" >> ~/.profile
