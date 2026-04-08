# PATH EXPORTS
source $ZDOTDIR/paths.zsh

# activates mise
eval "$(mise activate zsh)"

# Path to your oh-my-zsh installation.
export ZSH="$ZDOTDIR/ohmyzsh"

# disables the shell's default behavior of reporting an error when a glob pattern (wildcard) fails to match any files. 
setopt +o nomatch

plugins=(git mvn aws node gh jira)

# aliases
source $ZDOTDIR/aliases.zsh

# functions
source $ZDOTDIR/utils.zsh
source $ZDOTDIR/git_functions.zsh
source $ZDOTDIR/mvn_functions.zsh
source $ZDOTDIR/utility_functions.zsh

function help() {
  zsh-help-index $ZDOTDIR/git_functions.zsh
  zsh-help-index $ZDOTDIR/mvn_functions.zsh
  zsh-help-index $ZDOTDIR/utility_functions.zsh
}

eval "$(starship init zsh)"
source $ZSH/oh-my-zsh.sh