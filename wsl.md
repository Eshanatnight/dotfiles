# Windows Subsystem For Linux

## Installation

Run the following command

```terminal
wsl --install -d Ubuntu
```

---

## Setting Up ZSH

### Installing ZSH

run the following

```terminal
sudo apt install zsh -y;
```

```terminal
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Installing Auto Suggestions for ZSH

run the following

```terminal
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### Installing Powerlevel 10K

run the following

```terminal
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k;
```

---

## Installing C/CPP Devtools

```terminal
sudo apt-get update;
```

```terminal
sudo apt-get upgrade;
```

```terminal
sudo apt-get install build-essential gdb -y
```

## Installing MINGW-W64 Cross Compiler

Run the following

```terminal
sudo apt-get install mingw-w64 -y
```

### mingw-w64: Windows Binaries on Linux

#### CXX Compiler

~ For 64-bit use: x86_64-w64-mingw32-g++
~ For 32-bit use: i686-w64-mingw32-g++

#### C Compiler

~ For 64-bit use: x86_64-w64-mingw32-gcc
~ For 32-bit use: i686-w64-mingw32-gcc

> @brief: For Building Windows Binaries in a Linux Environment
> uses the Cross Compiler ```MINGW```
> For running the made executable a Compatibility Layer is
> required.
>
> @suggestion: Use of the Wine Compatibiliy Layer is Recomended.
> @useage: ```sudo apt-get install wine```

---

## Installing Rust

run the following

```terminal
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Installing Nettools

```terminal
sudo apt update
```

```terminal
sudo apt upgrade
```

```terminal
sudo apt install net-tools
```

```terminal
sudo apt-get install traceroute
```
