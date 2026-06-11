#!/usr/bin/sh

sudo apt-get update
sudo apt-get install lsd
cp -r home ${HOME}
dconf load -f / <settings.dconf

# .config
cd /tmp
wget http://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
mkdir "${HOME}/.local/share/fonts/"
unzip JetBrainsMono.zip -d "${HOME}/.local/share/fonts/JetBrains Mono NF"
cd -

# bash
wget https://github.com/git/git/raw/refs/heads/master/contrib/completion/git-prompt.sh
mv git-prompt.sh ${HOME}/.git-prompt.sh

# zsh
echo "==== Installing zsh ===="
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# git
echo "==== Configure git ===="
git config --global user.name "mickleon"
git config --global user.email "mickleon64@gmail.com"
git config --global init.defaultBranch main
git config --global core.editor nvim
ssh-keygen -t ed25519 -C "mickleon64@gmail.com"
echo
echo "==== Add your SSH key to GitHub: ===="
cat ${HOME}/.ssh/id_ed25519.pub

# for nvim >= 0.12 install lua5.1-lpeg from luarocks

# for wifi connecting through ashell add this to /etc/polkit-1/rules.d/10-network-manager.rules
# polkit.addRule(function(action, subject) {
#     if (action.id == "org.freedesktop.NetworkManager.settings.modify.system" &&
#         subject.isInGroup("wheel")) {
#         return polkit.Result.YES;
#     }
# });
sudo usermod -aG wheel $USER
