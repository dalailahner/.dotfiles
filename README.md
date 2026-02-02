# dalailahner dotfiles

---

## INSTALL YAY

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

## OPTIMIZE PACKAGE BUILD

- add `MAKEFLAGS="--jobs=$(nproc)"` to `/etc/makepkg.conf` to enable all cores for building. (test if `nproc` is available beforehand)

- change the `PKGEXT` in `/etc/makepkg.conf` from `PKGEXT='.pkg.tar.zst'` to `PKGEXT='.pkg.tar.lz4'`

---

## INSTALL PACKAGES

terminal

```Shell
yay -S ghostty zsh starship zoxide fzf zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting fresh-editor-bin
```

McFly

```Shell
yay -S mcfly
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

## SET ZSH AS DEFAULT SHELL

```Shell
sudo chsh -s $(which zsh)
```

open a new terminal and press "q" to the zsh warning

---

## DOTFILES

### setup

```Shell
gh auth login
```

```Shell
git config --global rebase.updateRefs true &&
git config --global pull.ff only &&
git config --global core.autocrlf input
# also setup GPG key
```

### clone

```Shell
cd ~ && gh repo clone dalailahner/.dotfiles
```

### init

```Shell
cd ~/.dotfiles && stow .
```

### reopen terminal or source the rc files

---

## FONT

```Shell
# needs fontforge
~/.dotfiles/font/generateFont.sh
```

```Shell
sudo mkdir -p /usr/local/share/fonts
```

```Shell
sudo ln -s ~/.dotfiles/font/dalailahner.ttf /usr/local/share/fonts/dalailahner.ttf
```

```Shell
fc-cache -v
```

---

## SETUP TOOLS

```Shell
ya pkg install
```

```Shell
fnm install --latest
```

```Shell
pnpm install -g @biomejs/biome stylelint stylelint-config-standard stylelint-order stylelint-no-unsupported-browser-features
```

---

## CONFIGURE SYSTEM

- uncomment and set `SystemMaxUse-50M` in `/etc/systemd/journald.conf`.
- if using localsend, don't forget to allow the port in the firewall.

- if dualbooting with windows, set linux to read the hardware clock as local time:
  ```Shell
  sudo timedatectl set-local-rtc 1
  ```

---
