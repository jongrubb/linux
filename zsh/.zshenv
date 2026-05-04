# a symbolic link needs to be present to link this file into the home directory. Required for zsh to load all files from
# ~/.zsh folder.
export ZDOTDIR="$HOME/.zsh"
# TODO: need to define JIRA_URL

# The current git project's root directory.
export PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)