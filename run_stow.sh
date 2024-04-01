#! /bin/zsh


name=$(uname)

if [[ $name == "Linux" ]]; then
    stow -d . -t /home/kellsatnite/ .
else
   echo "message" 
    stow -d . -t /Users/kellsatnite/ .
fi
