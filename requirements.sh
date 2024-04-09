#!/bin/bash

goversion=1.22.2.linux-amd64

if ! command -v cargo &>/dev/null; then
	echo "Install rust"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if ! command -v go &>/dev/null; then
	echo "Install golang from website"
	wget -c https://go.dev/dl/go$goversion.tar.gz
	sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go$goversion.tar.gz
	rm go$goversion.tar.gz
fi

if ! command -v node &>/dev/null; then
	echo "Install NVM, node not found"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	node_version=$(nvm ls-remote | tail -n 1)
	nvm install $node_version
	nvm alias default $node_version
fi

if ! command -v zoxide &>/dev/null; then
	echo "Install zoxide"
	cargo install zoxide --locked
fi

if ! command -v bat &>/dev/null; then
	echo "Install bat"
	cargo install bat --locked
fi

if ! command -v fzf &>/dev/null; then
	echo "Install fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
fi


# if there is cargo - install tree-sitter-cli with cargo
# else if there is npm - install tree-sitter-cli with npm
# else - exit with error
if ! command -v tree-sitter &>/dev/null; then
	echo "Install tree-sitter-cli"
	if command -v cargo &>/dev/null; then
	    cargo install tree-sitter-cli
	elif command -v npm &>/dev/null; then
	    npm install -g tree-sitter-cli
	else
	    echo "No package manager found"
	    exit 1
	fi
fi
