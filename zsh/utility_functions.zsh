# Walks up the directory tree to find the root of the current git project (the
# folder containing .git) and cds into it. Stops at ~ if no .git is found.
function cd-root() {
  local dir=${PWD}
  local home=${HOME}

  while [[ "$dir" != "$home" && "$dir" != "/" ]]; do
    if [[ -d "$dir/.git" ]]; then
      cd "$dir"
      return
    fi
    dir=${dir:h}
  done

  cd "$home"
}

function idea() {
  args=("$@")
  (( $# == 0 )) && args=(.)

  command nohup idea "${args[@]}" > /dev/null 2>&1 &
}

# Prints out help dialogue for all utility functions.
function utilities:help() {
  zsh-help ${(%):-%x}
}