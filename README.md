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

### optimize package build:

add `MAKEFLAGS="--jobs=$(nproc)"` to `/etc/makepkg.conf` to enable all cores for building. (test if `nproc` is available beforehand)

change the `PKGEXT` in `/etc/makepkg.conf` from `PKGEXT='.pkg.tar.zst'` to `PKGEXT='.pkg.tar.lz4'`

---

### install packages:

terminal
```Shell
yay -S ghostty zsh starship zoxide fzf zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting micro
```

yazi
```Shell
# check if the dependencies are still correct
yay -S ffmpegthumbnailer p7zip jq poppler fd ripgrep imagemagick yazi
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

---

reopen terminal or source the rc files

---

### setup tools

if using localsend, don't forget to allow the port in the firewall.

```Shell
fnm install --latest
```

```Shell
pnpm install -g @biomejs/biome stylelint stylelint-config-standard stylelint-order stylelint-no-unsupported-browser-features
```

---

### configure system

uncomment and set `SystemMaxUse-50M` in `/etc/systemd/journald.conf`.

---
