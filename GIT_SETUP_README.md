# Multiple GitHub Accounts Setup Guide

## 1. Generate SSH Keys

```bash
ssh-keygen -t ed25519 -C "personal@email.com" -f ~/.ssh/id_ed25519_personal
ssh-keygen -t ed25519 -C "work@email.com" -f ~/.ssh/id_ed25519_work
```

add keys to ssh

```bash
ssh-add ~/.ssh/id_ed25519_personal
ssh-add ~/.ssh/id_ed25519_work
```

---

## 2. Add SSH Keys to GitHub

Copy each public key and add it to the corresponding GitHub account under **Settings → SSH and GPG Keys → New SSH Key**.

```bash
cat ~/.ssh/id_ed25519_personal.pub
cat ~/.ssh/id_ed25519_work.pub
```

---

## 3. Configure Git Identities

> Note this only works within folders that are repositories.

Store git configs in `~/.config/git/`:

**`~/.config/git/personal`**

```ini
[user]
  name = Your Personal Name
  email = personal@email.com

[core]
  sshCommand = ssh -i ~/.ssh/id_ed25519_personal
```

**`~/.config/git/work`**

```ini
[user]
  name = Your Work Name
  email = work@email.com

[core]
  sshCommand = ssh -i ~/.ssh/id_ed25519_work
```

**`~/.config/git/.gitconfig`** — add conditional includes:

```ini
[includeIf "gitdir:~/github/personal/"]
  path = ~/.config/git/personal

[includeIf "gitdir:~/github/work/"]
  path = ~/.config/git/work
```

---

## 5. Install direnv

**macOS:**

```bash
brew install direnv
```

**Linux:**

```bash
curl -sfL https://direnv.net/install.sh | bash
```

Hook into your shell — add to `~/.zshrc` or `~/.bashrc`:

```bash
eval "$(direnv hook zsh)"   # zsh
eval "$(direnv hook bash)"  # bash
```

Reload your shell:

```bash
source ~/.zshrc  # or ~/.bashrc
```

---

## 6. Set Up GitHub Directories

Create the directories:

```bash
mkdir -p ~/github/personal
mkdir -p ~/github/work
```

**`~/github/personal/.envrc`**

```bash
export GH_CONFIG_DIR=~/.config/gh-personal
```

**`~/github/work/.envrc`**

```bash
export GH_CONFIG_DIR=~/.config/gh-work
```

Allow each `.envrc`:

```bash
direnv allow ~/github/personal
direnv allow ~/github/work
```
