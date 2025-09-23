SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# install nerd font
brew install font-bitstream-vera-sans-mono-nerd-font

# link ghostty config
rm -rf $HOME/.config/ghostty
mkdir -p $HOME/.config/ghostty
ln -s $SCRIPT_DIR/ghostty/config $HOME/.config/ghostty/config
ln -s $ROOT_DIR/ghostty/themes $HOME/.config/ghostty/themes
echo -e "${GREEN}Symlinked ghostty config to home directory.${NC}"

# install starship
curl -sS https://starship.rs/install.sh | sh -s -- -y
echo -e "${GREEN}Starship has been installed successfully.${NC}"

# link starship config
mkdir -p $HOME/.config
rm -f $HOME/.config/starship.toml
ln -s $ROOT_DIR/starship/starship.toml $HOME/.config/starship.toml
echo -e "${GREEN}Symlinked starship config to home directory.${NC}"
