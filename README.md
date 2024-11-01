# dalailahner dotfiles

---

### install packages:

```Shell
sudo apt update && sudo apt upgrade -y
```

```Shell
sudo apt install zsh curl git gh stow unzip
```

---

### set zsh as default shell
```Shell
chsh -s $(which zsh)
```

open a new terminal and press "q" to the zsh warning

---

### install tools

```Shell
git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
```

```Shell
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
```

```Shell
sudo apt update && sudo apt install fastfetch
```

```Shell
curl -fsSL https://fnm.vercel.app/install | zsh -s -- --skip-shell
```

install a node version with fnm

```Shell
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

```Shell
pnpm install -g npm-check-updates
```

### setup

```Shell
gh auth login
```

(WSL only:)

```Shell
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
```

```Shell
git config --global user.name "YOUR USERNAME"
git config --global user.email "YOUR EMAIL"
```

---

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
