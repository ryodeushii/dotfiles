#!/bin/bash

echo "Install rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Install golang from website"
wget -c /tmp/https://go.dev/dl/go1.22.2.linux-amd64.tar.gz

sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go1.22.2.linux-amd64.tar.gz


echo "Install NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash


echo "Install zoxide"
cargo install zoxide --locked

echo "Install bat"
cargo install bat --locked

echo "Install fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

