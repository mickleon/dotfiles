#!/usr/bin/sh

sudo apt-get update
sudo apt-get install lsd

# Templates
cp Templates -r ${HOME}

# bin
cp bin/* ${HOME}/.local/bin

#.config
cp ghostty -r ${HOME}/.config
cp neofetch -r ${HOME}/.config
# zed
cp zed -r ${HOME}/.config
cd /tmp
wget http://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ${HOME}/.local/share/fonts/JetBrains Mono NF
cd -

# bash
wget https://github.com/git/git/raw/refs/heads/master/contrib/completion/git-prompt.sh
mv git-prompt.sh ${HOME}/.git-prompt.sh
cp bash/.bashrc ${HOME}

# zsh
echo "Installing zsh..."
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp zsh/my_robbyrussell.zsh-theme "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
cp zsh/.zshrc ${HOME}
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# git
echo "Configure git.."
git config --global user.name "mickleon"
git config --global user.email "mickleon64@gmail.com"
git config --global init.defaultBranch main
git config --global core.editor nano
ssh-keygen -t ed25519 -C "mickleon64@gmail.com"
echo
echo "Add your SSH key to GitHub:"
cat ${HOME}/.ssh/id_ed25519.pub
