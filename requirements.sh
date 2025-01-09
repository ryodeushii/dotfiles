#!/bin/bash

goversion=1.23.3.linux-amd64

if ! command -v proto &>/dev/null; then
    echo "Install moonrepos's proto cli for toolchain management"
    curl -fsSL https://moonrepo.dev/install/proto.sh | bash
fi

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
    # curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    # node_version=$(nvm ls-remote | tail -n 1)
    # nvm install $node_version
    # nvm alias default $node_version
    proto install node latest
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

if ! command -v sesh &>/dev/null; then
    go install github.com/joshmedeski/sesh@latest
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

# install delta diff tool if not found
if ! command -v delta &>/dev/null; then
    echo "Install delta"
    cargo install git-delta
fi

if ! command -v golangci-lint &>/dev/null; then
    echo "Install golangci-lint"
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
fi

if ! command -v gh &>/dev/null; then
    echo "Install gh"
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
    sudo apt-add-repository https://cli.github.com/packages
    sudo apt update
    sudo apt install gh
fi

if ! command -v lazygit &>/dev/null; then
    echo "Install lazygit"
    go install github.com/jesseduffield/lazygit@latest
fi

if ! command -v slides &>/dev/null; then
    echo "Install slides"
    go install github.com/maaslalani/slides@latest
fi
