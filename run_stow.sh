#! /bin/zsh


name=$(uname)

if [[ $name == "Linux" ]]; then
    stow -d . -t /home/kellsatnite/ .
else
   echo "message"
    stow -d . -t /Users/kellsatnite/ .
fi

# to stow a perticular dir
# stow -d <folder_path> -t <target_folder_path> things to stow from dir