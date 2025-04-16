# dalailahner dotfiles

---

### install yay:

```Shell
sudo pacman -Syu
```

```Shell
sudo pacman -S --needed base-devel git
```

```Shell
cd ~ && git clone https://aur.archlinux.org/yay.git
```

```Shell
cd yay && makepkg -si
```

```Shell
yay
```

---

### install packages:

terminal
```Shell
yay -S kitty zsh starship zoxide fzf zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting micro
```

yazi
```Shell
# check if the dependencies are still correct
yay -S yazi ffmpegthumbnailer p7zip jq poppler fd ripgrep imagemagick
```

tools
```Shell
yay -S stow unzip github-cli lazygit ttf-liberation ttf-hack-nerd fnm-bin pnpm fastfetch
```

---

### set zsh as default shell
```Shell
sudo chsh -s $(which zsh)
```

open a new terminal and press "q" to the zsh warning

---

### setup

```Shell
gh auth login
```

```Shell
git config --global rebase.updateRefs true
```

### clone

```Shell
cd ~ && gh repo clone dalailahner/.dotfiles
```

### init

```Shell
cd ~/.dotfiles && stow .
```

### kitty theme

choose the dalailahner theme when running:

```Shell
kitten themes
```

and select "copy theme to current-theme.conf without changing the kitty.config"

---

reopen terminal or source the rc files

---

### install tools

```Shell
fnm install --latest
```

```Shell
pnpm install -g @biomejs/biome stylelint stylelint-config-standard stylelint-order stylelint-no-unsupported-browser-features
```

---
