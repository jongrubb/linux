# Formats help text from stdin, colorizing text wrapped in backticks with terminal color 5.
function _zsh_help_format() {
  local color reset
  color=$(tput setaf 5)
  reset=$(tput sgr0)
  awk -v c="$color" -v r="$reset" '{
    while (match($0, /`[^`]+`/)) {
      printf "%s%s%s%s", substr($0, 1, RSTART-1), c, substr($0, RSTART+1, RLENGTH-2), r
      $0 = substr($0, RSTART+RLENGTH)
    }
    print
  }'
}

# Prints a --help style doc of all functions in a .zsh file, derived from their preceding comments.
# Usage: zsh-help <file.zsh>
function zsh-help() {
  local file="$1"

  if [[ -z "$file" ]]; then
    echo "Usage: zsh-help <file.zsh>"
    return 1
  fi

  if [[ ! -f "$file" ]]; then
    echo "File not found: $file"
    return 1
  fi

  local bold reset color
  bold=$(tput bold)
  color=$(tput setaf 3)
  reset=$(tput sgr0)

  printf "\n%s%s%s\n\n" "$bold" "$(basename $file)" "$reset"

  awk '
    BEGIN { comments = "" }

    /^[[:space:]]*#/ {
      line = $0
      gsub(/^[[:space:]]*# ?/, "", line)
      comments = (comments == "") ? line : comments "\n" line
      next
    }

    /^function [^ ]/ {
      fname = $2
      sub(/\(\).*/, "", fname)
      sub(/\(.*/, "", fname)
      encoded = comments
      gsub(/\n/, "\002", encoded)
      print fname "\001" encoded
      comments = ""
      next
    }

    /^[A-Za-z_][A-Za-z0-9_:.-]*[[:space:]]*\(\)/ {
      fname = $1
      sub(/[[:space:]]*\(.*/, "", fname)
      encoded = comments
      gsub(/\n/, "\002", encoded)
      print fname "\001" encoded
      comments = ""
      next
    }

    { comments = "" }
  ' "$file" | sort | awk -v bold="$bold" -v color="$color" -v reset="$reset" '
    BEGIN { FS = "\001" }
    {
      printf "  %s%s%s%s\n", bold, color, $1, reset
      if ($2 != "") {
        n = split($2, lines, "\002")
        for (i = 1; i <= n; i++) printf "    %s\n", lines[i]
      }
      printf "\n"
    }
  ' | _zsh_help_format
}

# Prints a --help style doc of only the :help functions in a .zsh file.
# Usage: zsh-help-index <file.zsh>
function zsh-help-index() {
  local file="$1"

  if [[ -z "$file" ]]; then
    echo "Usage: zsh-help-index <file.zsh>"
    return 1
  fi

  if [[ ! -f "$file" ]]; then
    echo "File not found: $file"
    return 1
  fi

  local bold reset color
  bold=$(tput bold)
  color=$(tput setaf 3)
  reset=$(tput sgr0)

  printf "\n%s%s%s\n\n" "$bold" "$(basename $file)" "$reset"

  awk -v bold="$bold" -v color="$color" -v reset="$reset" '
    BEGIN { comments = "" }

    /^[[:space:]]*#/ {
      line = $0
      gsub(/^[[:space:]]*# ?/, "", line)
      comments = (comments == "") ? line : comments "\n" line
      next
    }

    /^function [^ ].*:help\(\)/ {
      fname = $2
      sub(/\(\).*/, "", fname)
      sub(/\(.*/, "", fname)
      printf "  %s%s%s%s\n", bold, color, fname, reset
      if (comments != "") {
        n = split(comments, lines, "\n")
        for (i = 1; i <= n; i++) printf "    %s\n", lines[i]
      }
      printf "\n"
      comments = ""
      next
    }

    { comments = "" }
  ' "$file" | _zsh_help_format
}

