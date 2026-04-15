# Adds ghostty alias to open ghostty within a different terminal.
if ! which ghostty &>/dev/null; then
  alias ghostty='open -a /Applications/Ghostty.app/Contents/MacOS/ghostty'
fi
