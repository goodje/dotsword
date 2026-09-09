# Setup things



## C Programming

Install universal-ctags which is a ctags impelmentation.
For MacOS, refer to https://docs.ctags.io/en/latest/osx.html for more details.
```
brew tap universal-ctags/universal-ctags
brew install --HEAD universal-ctags
```

Follow https://github.com/MaskRay/ccls/wiki to install `ccls`.
```
brew install ccls
```




## Neovim language servers (mason prerequisites)

`mason` builds each LSP server with the toolchain of the language it is written
in, so a missing toolchain surfaces as a failed install on nvim startup rather
than as a mason problem. `:MasonLog` names the missing executable.

Servers in `vim/lua/plugins/plugins.lua` (`ensure_installed`) and what they need:

| server                                      | requires |
| ------------------------------------------- | -------- |
| `gopls`                                     | `go`     |
| `pyright`                                   | `npm`    |
| `typescript-language-server` (`ts_ls`)      | `npm`    |
| `vue-language-server` (`vue_ls`)            | `npm`    |
| `lua-language-server`, `json-lsp`, `html-lsp`, `dockerfile-language-server` | prebuilt, no toolchain |

Install the toolchains, then re-run the servers:

```
brew install go            # gopls
fnm install --lts          # npm, for the node-based servers
nvim --headless '+MasonInstall gopls pyright typescript-language-server vue-language-server' +qa
```

Until `vue-language-server` is present, startup prints

```
Error: @vue/typescript-plugin not found under mason vue-language-server.
```

from `plugins.lua:291` — the guard around `@vue/typescript-plugin`, which must
come from the same mason package as `vue_ls` so the versions match. It is a
warning, not a fatal error; the rest of the config still loads.

## tmux

`tmux.conf` ends with `run '~/.tmux/plugins/tpm/tpm'`, so tpm must be cloned
before the `@plugin` lines do anything:

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source-file ~/.tmux.conf     # then prefix + I to install plugins
```

## Node (fnm)

`fnm` comes from brew; it manages the node versions the mason LSP servers build
against. Installing a version is not enough — set it as the default, otherwise
new shells fall back to `system` (no node) and mason fails again:

```
brew install fnm
fnm install --lts        # v24.20.0 / npm 11.19.0 as of Sep 2026
fnm default lts-latest
```

`~/.zshrc` activates it per-shell with `eval "$(fnm env --shell zsh)"`, guarded
on `/opt/homebrew/opt/fnm/bin` existing. Verify with `node --version` in a new
shell; the path resolves under `~/.local/state/fnm_multishells/`.

## fzf

```
brew install fzf
```

Shell integration lives in `~/.zshrc` (not in this repo, since it is
brew-prefix specific). fzf >= 0.48 generates it, so no `install` script and no
`~/.fzf.zsh` is needed:

```sh
if command -v fzf > /dev/null; then
  source <(fzf --zsh)
  if command -v rg > /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi
```

Bindings: `ctrl-t` file picker, `ctrl-r` history search, `alt-c` cd into a
subdirectory. The `rg` branch is optional — without ripgrep (`brew install
ripgrep`) fzf falls back to its built-in walker, which does not skip `.git/`.

## zoxide

```
brew install zoxide
```

Init goes in `~/.zshrc`, after the fzf block (`zi` uses fzf for its interactive
picker) and after the powerlevel10k lines:

```sh
if command -v zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
fi
```

`z <partial-path>` jumps to a directory by frecency, `zi` picks one
interactively. It shadows nothing here — the `q` / `ws` aliases are plain `cd`.

## gitleaks

```
brew install gitleaks
```

Secret scanning for this repo. Config is `.gitleaks.toml`; CI runs it on every
push and PR via `.github/workflows/gitleaks.yml`. Locally:

```
gitleaks git --config .gitleaks.toml     # full history
gitleaks dir . --config .gitleaks.toml   # working tree
```
