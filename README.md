# dalailahner dotfiles

---

### install:

```Shell
sudo apt update && sudo apt upgrade -y
```

```Shell
sudo apt install zsh git gh stow
```

```Shell
git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
```

---

### zsh as default shell
```Shell
chsh -s $(which zsh)
```

---

### setup

```Shell
gh auth login
```

(WSL only:)

```Shell
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
```

---

### clone

```Shell
cd ~ && gh repo clone .dotfiles
```

---

### init

```Shell
cd ~/.dotfiles && stow .
```

---
