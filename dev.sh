#!/bin/bash

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
mv ~/.gitconfig ~/.gitconfig.bak
ln -s $(pwd)/git/gitconfig ~/.gitconfig
