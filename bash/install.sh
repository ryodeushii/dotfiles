if ! [ -d ~/.oh-my-bash ]; then
    echo "Installing oh-my-bash..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh) --unattended"
    exit
fi
