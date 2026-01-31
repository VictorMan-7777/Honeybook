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

## 6. Install and start PostgreSQL

Install PostgreSQL 16 via Homebrew:

```bash
brew install postgresql@16
```

Start the PostgreSQL service:

```bash
brew services start postgresql@16
```

Verify installation:

```bash
psql --version
pg_isready
```

Expected: `pg_isready` prints `accepting connections`.

**If `psql` or `pg_isready` is not found**, add the PostgreSQL bin directory to your PATH:

```bash
export PATH="$(brew --prefix)/opt/postgresql@16/bin:$PATH"
```

To make this permanent, add the line above to `~/.zshrc` (after the mise lines), then open a **NEW** terminal.

---

## 7. Create Rails API application (already completed)

```bash
ruby -S rails new . -d postgresql --api --skip-test --force
```

---

## 8. Verify Rails boots

Prepare the database:

```bash
bin/rails db:prepare
```

Start the server:

```bash
bin/rails server
```

Verify health endpoint:

```bash
curl -i http://localhost:3000/up
```

Expected: `HTTP/1.1 200 OK`

Stop with `Ctrl+C`.

---

## 9. VS Code Terminal Rule

Do **NOT** reload terminals.

Close the terminal tab and open a new one instead to preserve command markers.

---

## 10. Source of Truth

- `mise.toml` controls Ruby version
- `~/.zshrc` controls PATH priority
- This document enables full recovery in minutes
