#!/usr/bin/env bash

set -euo pipefail

# get directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TARGET_DIR="$HOME/.zsh"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

copy_if_missing() {
	local file_name="$1"
	local src="$SCRIPT_DIR/$file_name"
	local dest="$TARGET_DIR/$file_name"

	if [[ ! -f "$src" ]]; then
		echo -e "${YELLOW}Skipping $file_name because source file does not exist: $src${NC}"
		return
	fi

	if [[ -e "$dest" ]]; then
		echo -e "${GREEN}$dest already exists. Skipping copy.${NC}"
	else
		cp "$src" "$dest"
		echo -e "${GREEN}Copied $file_name to $dest${NC}"
	fi
}

ensure_link() {
	local source_file="$1"
	local link_path="$2"

	if [[ -L "$link_path" ]]; then
		local current_target
		current_target="$(readlink "$link_path")"
		if [[ "$current_target" == "$source_file" ]]; then
			echo -e "${GREEN}$link_path is already linked correctly.${NC}"
			return
		fi

		rm "$link_path"
	elif [[ -e "$link_path" ]]; then
		echo -e "${YELLOW}Skipping $link_path because it already exists and is not a symlink.${NC}"
		return
	fi

	ln -s "$source_file" "$link_path"
	echo -e "${GREEN}Created symlink: $link_path -> $source_file${NC}"
}

mkdir -p "$TARGET_DIR"
echo -e "${GREEN}Ensured directory exists: $TARGET_DIR${NC}"

# Copy files into ~/.zsh if they do not already exist.
copy_if_missing ".zshenv"
copy_if_missing ".zshrc"
copy_if_missing "aliases.zsh"
copy_if_missing "paths.zsh"

# Symlink .zshenv to $HOME.
ensure_link "$TARGET_DIR/.zshenv" "$HOME/.zshenv"

# Symlink function/helper files to $TARGET_DIR.
ensure_link "$SCRIPT_DIR/git_functions.zsh" "$TARGET_DIR/git_functions.zsh"
ensure_link "$SCRIPT_DIR/mvn_functions.zsh" "$TARGET_DIR/mvn_functions.zsh"
ensure_link "$SCRIPT_DIR/utility_functions.zsh" "$TARGET_DIR/utility_functions.zsh"
ensure_link "$SCRIPT_DIR/utils.zsh" "$TARGET_DIR/utils.zsh"
ensure_link "$SCRIPT_DIR/scripts" "$TARGET_DIR/scripts"