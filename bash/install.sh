if ! [ -d ~/.oh-my-bash ]; then
    echo "Installing oh-my-bash..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh) --unattended"
    exit
fi

if ! [ -d ~/.fzf/bin ]; then
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

    ~/.fzf/install
fi

