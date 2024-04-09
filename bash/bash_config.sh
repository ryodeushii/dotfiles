if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.bash_vars ]; then
    source ~/.bash_vars
fi

export TERM=screen-256color
