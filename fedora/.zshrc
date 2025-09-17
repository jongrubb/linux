# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(git gh dnf mise)

eval "$(mise activate zsh)"

eval "$(starship init zsh)"
source $ZSH/oh-my-zsh.sh
