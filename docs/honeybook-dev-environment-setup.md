# Development Environment Setup (HoneyBook CRM)

This document records the exact steps required to restore a working Ruby / Rails development environment for the HoneyBook CRM project. It assumes macOS with zsh and Homebrew.

---

## 1. Install Homebrew (if missing)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Verify:

```bash
brew --version
```

---

## 2. Install mise (project Ruby version manager)

```bash
brew install mise
```

---

## 3. Configure zsh so mise always wins (CRITICAL)

Ensure the following lines are at the **VERY TOP** of `~/.zshrc`:

```bash
export PATH="$HOME/.local/share/mise/shims:$PATH"
eval "$(mise activate zsh)"
```

Remove any Homebrew Ruby paths such as:

```
/usr/local/opt/ruby/bin
```

Open a **NEW** terminal after editing (do not reload).

Verify:

```bash
which ruby
ruby -v
```

Expected: Ruby 3.3.x via mise

---

## 4. Install project Ruby

```bash
cd ~/dev/claude-projects/honey-book
mise install ruby@3.3.0
mise use ruby@3.3.0
```

Verify:

```bash
mise current
ruby -v
```

---

## 5. Install Rails (under mise Ruby)

```bash
gem install rails -v "~> 7.2"
```

Verify:

```bash
which rails
rails -v
```

---

## 6. Create Rails API application (already completed)

```bash
ruby -S rails new . -d postgresql --api --skip-test --force
```

---

## 7. Verify Rails boots

```bash
bin/rails server
```

Expected:

- Rails 7.2.x
- Listening on http://127.0.0.1:3000

Stop with `Ctrl+C`

---

## 8. VS Code Terminal Rule

Do **NOT** reload terminals.

Close the terminal tab and open a new one instead to preserve command markers.

---

## 9. Source of Truth

- `mise.toml` controls Ruby version
- `~/.zshrc` controls PATH priority
- This document enables full recovery in minutes
