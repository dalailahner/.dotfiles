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

### install packages:

```Shell
yay -S kitty zsh zoxide fzf zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting micro stow unzip github-cli lazygit ttf-liberation ttf-hack-nerd fnm-bin pnpm fastfetch
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

### clone

```Shell
cd ~ && gh repo clone dalailahner/.dotfiles
```

---

### init

```Shell
cd ~/.dotfiles && stow .
```

---

### install tools

install a node version with fnm

```Shell
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

```Shell
pnpm install -g npm-check-updates
```

---
