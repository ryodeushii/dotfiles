# git aliases
alias branch="git branch --show-current"
alias gst="git status"
alias gd="git diff"
alias gD="git -c core.pager="" diff"
alias gpr="git pull --rebase"
alias gpl="git pull"

function gdd() {
  git diff origin/$(git branch --show-current)
}

function gdD() {
  git -c core.pager="" diff origin/$(git branch --show-current)
}

function gp() {
  git push origin $(git branch --show-current)
}

function gu() {
  git restore --staged $1
}

alias gp=gp
alias gdd=gdd
alias gdD=gdD
alias gu=gu

# general

alias myip="dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | tr -d '\"'"

alias vim="nvim"
alias pvim="nvim -i NONE"
