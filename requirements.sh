#!/bin/bash
set -e

if ! command -v proto &>/dev/null; then
    echo "Install moonrepos's proto cli for toolchain management"
    bash <(curl -fsSL https://moonrepo.dev/install/proto.sh) --yes --no-profile
fi

if ! [ -d $HOME/.oh-my-bash ]; then
    echo "Installing oh-my-bash..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh) --unattended"
    exit
fi

if ! command -v cargo &>/dev/null; then
    echo "Install rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
    echo "Activate cargo for setup"
    . "$HOME/.cargo/env"
fi

# remove protools file and link one from repo
[ -d $HOME/.proto ] && rm -rf $HOME/.proto/.prototools
! [ -d $HOME/.proto ] && mkdir -p $HOME/.proto
ln -s $(pwd)/prototools.toml $HOME/.proto/.prototools

cd $HOME/.proto && $HOME/.proto/bin/proto clean plugins --days 0 && $HOME/.proto/bin/proto install && cd -

echo "Temporarily enable proto, later it'll be handled from bashrc"
export PROTO_HOME="$HOME/.proto"
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH"
eval "$(proto activate bash -c global)"

if ! command -v zoxide &>/dev/null; then
    echo "Install zoxide"
    cargo install zoxide --locked
fi

if ! command -v bat &>/dev/null; then
    echo "Install bat"
    cargo install bat --locked
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

if ! command -v lazygit &>/dev/null; then
    echo "Install lazygit"
    go install github.com/jesseduffield/lazygit@latest
fi

if ! command -v slides &>/dev/null; then
    echo "Install slides"
    go install github.com/maaslalani/slides@latest
fi
