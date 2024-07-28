# dalailahner dotfiles

## install:

```Shell
sudo apt update && sudo apt upgrade -y
&& git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
&& sudo apt install git gh stow
```

### setup

```Shell
gh auth login
&& git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
```

### clone

```Shell
cd ~
&& gh repo clone .dotfiles
```

### init

```Shell
cd ~/.dotfiles
&& stow .
```
