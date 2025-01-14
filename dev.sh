#!/bin/bash
set -e

# if no curl present - exit with error
if ! command -v curl &>/dev/null; then
    echo "curl is required to run this script"
    exit 1
fi

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
    h)
        usage
        exit 0
        ;;
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
./requirements.sh && echo "Requirements installed" || (echo "Requirements failed" && exit 1)

./bash/install.sh

# symlink files

echo "Symlink files"
echo "NEOVIM..."

[ -d $HOME/.config/nvim ] && rm -rf $HOME/.config/nvim
[ -d $HOME/.config ] || mkdir -p $HOME/.config/

ln -s $(pwd)/neovim $HOME/.config/nvim

echo "TMUX..."
# if no $HOME/.tmux/plugins/tpm then clone
[ -d $HOME/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
rm -rf $HOME/.config/tmux
ln -s $(pwd)/tmux $HOME/.config/tmux

echo "BASH..."
rm -rf $HOME/.bash_config
ln -s $(pwd)/bash/bash_config.sh $HOME/.bash_config

if [ -f ./bash/bash_vars.sh ]; then
    rm -rf $HOME/.bash_vars
    ln -s $(pwd)/bash/bash_vars.sh $HOME/.bash_vars
fi
rm -rf $HOME/.bash_aliases
ln -s $(pwd)/bash/bash_aliases.sh $HOME/.bash_aliases

if [ -f $HOME/.bashrc ]; then
    mv $HOME/.bashrc $HOME/.bashrc.bak
    ln -s $(pwd)/bash/bashrc.sh $HOME/.bashrc
fi

echo "GIT..."
# if no .gitconfig.bak then backup
if [ -f $HOME/.gitconfig ]; then
    [ -f $HOME/.gitconfig.bak ] || mv $HOME/.gitconfig $HOME/.gitconfig.bak

    # if work config is selected then replace include path in gitconfig with work config
    # if personal config is selected then replace include path in gitconfig with personal config
    rm $HOME/.gitconfig
fi

if [ -f $HOME/.user.gitconfig ]; then
    rm $HOME/.user.gitconfig
fi
ln -s $(pwd)/git/.$config.gitconfig $HOME/.user.gitconfig
ln -s $(pwd)/git/gitconfig $HOME/.gitconfig

if [ -d $HOME/.config/lazygit ]; then
    rm -rf $HOME/.config/lazygit
fi

if [ -d $HOME/.config/wezterm ]; then
    rm -rf $HOME/.config/wezterm
fi

mkdir -p $HOME/.config/lazygit
ln -s $(pwd)/lazygit.config.yml $HOME/.config/lazygit/config.yml

ln -s $(pwd)/wezterm $HOME/.config/wezterm

if [ $config == "personal" ]; then
    echo "Copy gpg config to fix signing issue in neovim"
    if [ -f $HOME/.gnupg/gpg.conf ]; then
        mv $HOME/.gnupg/gpg.conf $HOME/.gnupg/gpg.conf.bak
    fi
    [ -d $HOME/.gnupg ] || mkdir -p $HOME/.gnupg

    ln -s $(pwd)/gpg.conf $HOME/.gnupg/gpg.conf
fi

echo "Running neovim lazy sync"
nvim --headless +"Lazy sync" +q
echo "Running neovim lazy clean"
nvim --headless +"Lazy clean" +q

echo "Install plugins for tmux"
$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh
