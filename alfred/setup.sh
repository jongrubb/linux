SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TARGET_DIR="$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences"
SOURCE_DIR="$SCRIPT_DIR/Alfred.alfredpreferences"
ZSHENV_FILE="$HOME/.zshenv"
WORKFLOW_SCRIPTS_DIR="$ROOT_DIR/workflow-scripts"

if [[ -d "$TARGET_DIR" && ! -L "$TARGET_DIR" ]]; then
	rm -rf "$TARGET_DIR"
fi

ln -sfn "$SOURCE_DIR" "$TARGET_DIR"

if [[ -z "${ALFRED_WORKFLOW_SCRIPTS_DIR:-}" ]]; then
	if [[ ! -f "$ZSHENV_FILE" ]] || ! grep -qE '^\s*(export\s+)?ALFRED_WORKFLOW_SCRIPTS_DIR=' "$ZSHENV_FILE"; then
		printf '\nexport ALFRED_WORKFLOW_SCRIPTS_DIR="%s"\n' "$WORKFLOW_SCRIPTS_DIR" >> "$ZSHENV_FILE"
	fi
fi

