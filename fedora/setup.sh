#!/usr/bin/env bash

# get directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# install zsh
sudo dnf install zsh -y
# change default shell to zsh
chsh -s $(which zsh)
echo -e "${GREEN}Zsh has been installed and set as the default shell.${NC}"

# git
sudo dnf install git -y

# vs code
# https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions0
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code -y
echo -e "${GREEN}Visual Studio Code has been installed successfully.${NC}"

# install oh-my-zsh
echo -e "${GREEN}Determining if Oh My Zsh is installed...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${GREEN}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}Oh My Zsh has been installed successfully.${NC}"
else
    echo -e "${GREEN}Oh My Zsh is already installed.${NC}"
fi

# setting up directory to symlink configs into
mkdir -p $HOME/.config

# symlink .zshrc
rm -f $HOME/.zshrc
ln -s $SCRIPT_DIR/.zshrc $HOME/.zshrc
echo -e "${GREEN}Symlinked .zshrc to home directory.${NC}"

# install ghostty
sudo dnf copr enable scottames/ghostty -y
sudo dnf check-update
sudo dnf install ghostty -y
echo -e "${GREEN}Ghostty has been installed successfully.${NC}"

# symlink ghostty config
rm -rf $HOME/.config/ghostty
ln -s $SCRIPT_DIR/ghostty $HOME/.config/ghostty
echo -e "${GREEN}Symlinked ghostty config to home directory.${NC}"

# setting up flathub on flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# install spotify
flatpak install spotify -y --or-update
echo -e "${GREEN}Spotify has been installed successfully.${NC}"

# install mise-en-place
sudo dnf copr enable jdxcode/mise -y
sudo dnf install mise -y
echo -e "${GREEN}mise-en-place has been installed successfully.${NC}"

# install starship
curl -sS https://starship.rs/install.sh | sh -s -- -y
echo -e "${GREEN}Starship has been installed successfully.${NC}"

# symlink starship config
mkdir -p $HOME/.config
rm -f $HOME/.config/starship.toml
ln -s $ROOT_DIR/starship/starship.toml $HOME/.config/starship.toml
echo -e "${GREEN}Symlinked starship config to home directory.${NC}"

# install BitstreamVeraSansMono
rm -rf $HOME/.local/share/fonts/BitstreamVeraSansMono /tmp/BitstreamVeraSansMono.zip
mkdir -p $HOME/.local/share/fonts/BitstreamVeraSansMono
curl -L -o /tmp/BitstreamVeraSansMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/BitstreamVeraSansMono.zip
unzip /tmp/BitstreamVeraSansMono.zip -d $HOME/.local/share/fonts/BitstreamVeraSansMono
cd $HOME/.local/share/fonts/BitstreamVeraSansMono
kfontinst *.ttf