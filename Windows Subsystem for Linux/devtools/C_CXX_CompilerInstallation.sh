echo "Updating Repositories\n";
# updates the repos
sudo apt-get update;
# upgrades the files
sudo apt-get upgrade;

echo "Installing Build Essentials and GDB\n";
# install build essentials
sudo apt-get install build-essential gdb -y

# Test 
gcc --version
g++ --version
gdb --version

# Optional Windows Cross Compiler
echo "Should I Install MINGW-W64?(Y/N)"
read answer;
if[ "$answer" = "y" -o "$answer" = "Y" ]; then
    echo "Installing MINGW-W64\n";
    # install mingw-w64
    sudo apt-get install mingw-w64 -y
fi





