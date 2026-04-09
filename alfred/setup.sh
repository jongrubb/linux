SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TARGET_DIR="$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences"
SOURCE_DIR="$SCRIPT_DIR/Alfred.alfredpreferences"

if [[ -d "$TARGET_DIR" && ! -L "$TARGET_DIR" ]]; then
	rm -rf "$TARGET_DIR"
fi

ln -sfn "$SOURCE_DIR" "$TARGET_DIR"

