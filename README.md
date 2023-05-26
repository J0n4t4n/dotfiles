# Dotfiles

These are my personal dotfiles that I use on my Personal and Work Macbooks.
They are sorted into folders based on application.

## Install Custom Terminal

Based on: https://www.josean.com/posts/terminal-setup

```bash
brew install iterm2
```

Use iTerm2 from now on.

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

Change in .zshrc

```
ZSH_THEME="powerlevel10k/powerlevel10k"
```

Restart iTerm2 and run (if not automatically):

```bash
p10k configure
```

Download and import:

```bash
curl https://raw.githubusercontent.com/josean-dev/dev-environment-files/main/coolnight.itermcolors --output ~/Downloads/coolnight.itermcolors
```

iTerm preferences: Profiles -> Colors -> Import and select (coolnight)

Install ZSH Plugins:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Configure ZSH Plugins:

```
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)
```

```bash
ln -s ~/Git/dotfiles/zsh/.zshrc.personal .zshrc.custom
ln -s ~/Git/dotfiles/zsh/.p10k.zsh .p10k.zsh
```

```
# --- My config ---
[[ ! -e ~/.zshrc.custom ]] || source ~/.zshrc.custom
```

## NVIM

```sh
ln -s ~/Git/dotfiles/nvim ~/.config
```
