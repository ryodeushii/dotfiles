#!/bin/bash

# read flag from command line to indicate if work or personal config should be used using flags

# if flag is set to personal, use personal config
# if flag is set to work, use work config
# if no flags set - show error and exit

config=""

function usage() {
  echo "Usage: $0 [-p] [-w]"
  echo "  -p  Use personal config"
  echo "  -w  Use work config"
  echo "  -h  Show usage"
  echo
}



while getopts ":pwh" opt; do
  case ${opt} in
    p)
        echo "Personal config selected"
        config="personal"
        break
        ;;
    w)
        echo "Work config selected"
        config="work"
        break
        ;;
    h)  usage; exit 0 ;;
    *)
        echo "You need to specify a flag to indicate if you want to use personal or work config"
        exit 1
        ;;
    ?)
        echo "Invalid option: -${OPTARG}"
        usage
        ;;
  esac
done

for arg in config; do
  if [[ -z "${!arg}" ]]; then
    echo "You need to specify a flag to indicate if you want to use personal or work config"
    echo
    usage
    exit 1
  fi
done




# This script is used to run the development environment for the project.
./requirements.sh

./bash/install.sh

# symlink files

echo "Symlink files"
echo "NEOVIM..."
rm -rf ~/.config/nvim
ln -s $(pwd)/neovim ~/.config/nvim

echo "TMUX..."
# if no ~/.tmux/plugins/tpm then clone
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
rm -rf ~/.config/tmux
ln -s $(pwd)/tmux ~/.config/tmux

echo "BASH..."
rm -rf ~/.bash_config
ln -s $(pwd)/bash/bash_config.sh ~/.bash_config

if [ -f ./bash/bash_vars.sh ]; then
    rm  -rf ~/.bash_vars
    ln -s $(pwd)/bash/bash_vars.sh ~/.bash_vars
fi
rm -rf ~/.bash_aliases
ln -s $(pwd)/bash/bash_aliases.sh ~/.bash_aliases

mv ~/.bashrc ~/.bashrc.bak
ln -s $(pwd)/bash/bashrc.sh ~/.bashrc

echo "GIT..."
# if no .gitconfig.bak then backup
[ -f ~/.gitconfig.bak ] ||mv ~/.gitconfig ~/.gitconfig.bak

# if work config is selected then replace include path in gitconfig with work config
# if personal config is selected then replace include path in gitconfig with personal config
rm ~/.gitconfig
rm ~/.user.gitconfig

ln -s $(pwd)/git/.$config.gitconfig ~/.user.gitconfig
ln -s $(pwd)/git/gitconfig ~/.gitconfig
