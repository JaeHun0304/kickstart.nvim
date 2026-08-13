# Neovim Configuration Summary

## General Settings
- **Leader key**: `,`
- **Plugin manager**: lazy.nvim (plugins in `lua/custom/plugins/`, one file per plugin/group, auto-loaded via `require("lazy").setup("custom.plugins", ...)`)
- **Load order** (`init.lua`): `custom.setting` → `custom.keymap` → `lazy_config` (which loads `custom.plugins/*`). `custom.state_dirs` exists on disk but is commented out / inactive.
- **Disabled builtin runtime plugins** (`lazy_config.lua`): `tohtml`, `tutor`, `netrwPlugin`, `matchit`, `matchparen`. Built-in `gzip`/`tarPlugin`/`zipPlugin` are kept enabled so `.gz`/`.bz2`/`.xz`/`.zst`/`.tar`/`.zip` files open transparently. `netrw` is also explicitly disabled at the top of `setting.lua`.
- **Colorscheme**: everforest (loaded eagerly, priority 1000; `Comment` highlight forced to `gui=none`)
- **Indentation**: 4 spaces, expandtab, autoindent + smartindent (vim-sleuth auto-detects per-buffer tabstop/shiftwidth)
- **Clipboard**: synced with OS (`unnamedplus`)
- **Grep**: ripgrep for both `:grep` (`rg --vimgrep --smart-case --color=never`) and Telescope live-grep
- **Build**: `:make` runs `cmake --preset default; cmake --build --preset default` (`makeprg`)
- **Swap/backup/undo**: disabled
- **Wildmode**: `longest,list,full` (longest match first, then list, then cycle)
- **Conceallevel**: 2 (hides markup in markdown/json)
- **Folding**: nvim-ufo (LSP folding disabled for clangd via `foldingRangeProvider=false`; falls back to treesitter/indent). `foldlevelstart=99` so files open fully unfolded.
- **Nerd Font**: enabled (`vim.g.have_nerd_font`)
- **File autoreload**: `checktime` triggered on `FocusGained`/`BufEnter`/`CursorHold(I)`, with a warning-message notification on external file changes
- **Diagnostics**: floating window auto-opens on `CursorHold` (rounded border, cursor scope); virtual text/signs/underline enabled, severity-sorted
- **Terminal**: `BASH_ENV=~/.vim_bash_env` so shell aliases expand inside embedded terminals
- **GUI (nvim-qt)**: font `JetBrains Mono:h18` set via `guifont`; GUI tabline/popupmenu disabled, scrollbar enabled, right-click context menu wired (`ginit.vim`)

## Key Mappings

### General
| Key | Mode | Action |
|-----|------|--------|
| `,` | n | Leader key |
| `Y` | n | Copy line without newline |
| `<space>` | n | Insert space |
| `<Esc>` | n | Clear search highlight |
| `<C-\><C-n>` | t | Exit terminal mode (default nvim, safe for running processes) |
| `<C-w>w` | t | Exit terminal mode + focus previous window |
| `<C-h/j/k/l>` | n | Move between windows |
| `,A` | n | Select all (`keepjumps ggVG`) |
| `,dt` | n | Toggle `diffthis`/`diffoff` across all split windows |
| `vsb` | cmdline abbrev | Expands to `vert sb` |

### Quickfix
| Key | Action |
|-----|--------|
| `,q` | Open quickfix (height 15) |
| `,Q` | Close quickfix |
| `,qd` | Clear quickfix list |
| `<C-n>` | Next quickfix item |
| `<C-p>` | Previous quickfix item |

### File/Buffer
| Key | Action |
|-----|--------|
| `,yf` | Copy filename:line_number |
| `,yF` | Copy full path |
| `,e` | Toggle NvimTree |
| `,nf` | Find current file in NvimTree |
| `,.` | Next buffer |
| `,m` | Previous buffer |
| `,bp` | Pick buffer |
| `,bb` | Pin buffer |
| `,bo` | Close other buffers |
| `,bd` | Delete buffer (keep window layout) |

### Completion (nvim-cmp)
| Key | Action |
|-----|--------|
| `<Tab>` | Next item / expand-or-jump snippet |
| `<S-Tab>` | Previous item / jump back in snippet |
| `<CR>` | Confirm selection |
| `<C-Space>` | Manual trigger |
| `<C-e>` | Expand/jump snippet |
| `<Up>`/`<Down>` | Always default cursor movement (not menu nav) |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition (buffer-local `vim.lsp.buf.definition` set on `LspAttach`; Telescope's `telescope.lua` also binds `gd`/`gr` globally to `lsp_definitions`/`lsp_references` at `VimEnter` — whichever set last for a buffer wins) |
| `gr` | References (Telescope `lsp_references`) |
| `gv` | Definition in vsplit |
| `gs` | Definition in hsplit |
| `gp` | Peek definition (goto-preview floating window) |
| `gP` | Peek references (floating window) |
| `gQ` | Close all peek windows |
| `K` | Hover info |
| `,ln` | Rename symbol |
| `,la` | Code actions |
| `,lf` | Format buffer (LSP, set on `LspAttach`) |
| `[d` / `]d` | Prev/next diagnostic (floating) |

### Telescope
| Key | Action |
|-----|--------|
| `,sf` | Find files |
| `,sa` | Find all files, including ignored/hidden |
| `,sg` | Live grep (live-grep-args) |
| `,sc` | Search C++ code (`type_filter = "cpp"`) |
| `,sw` | Search word under cursor |
| `,sv` | Search visual selection |
| `,sh` | Search help |
| `,sk` | Search keymaps |
| `,sd` | Search diagnostics |
| `,ss` | Telescope builtin picker list |
| `,fd` | Find files in prompted directory |
| `,sj` | Search jumplist |
| `,sr` | Resume last search |
| `,s.` | Recent files |
| `,,` | Open buffers |
| `,lw` | Workspace symbols |
| `,/` | Fuzzy find in current buffer |
| `,gs` | Git status (changed files only, no untracked) |
| `,gc` | Git commits |
| `,s/` | Grep in open files |
| `,sn` | Search nvim config files |

### Git
| Key | Action |
|-----|--------|
| `,do` | Open diffview (ignore untracked files) |
| `,dc` | Close diffview |
| `,gh` | Git file history (diffview) |
| `,gn` | Next hunk (gitsigns) |
| `,gp` | Previous hunk (gitsigns) |
| `,gr` | Revert hunk |
| `,gr` (visual) | Revert selected lines only |
| `,gs` (visual) | Stage selected lines only |
| `,gi` | Preview hunk inline |
| `,gd` | Git diff vsplit (`Gvdiffsplit`) |
| `,dd` | Git diff (unified, colored, full tab via `:tab Git! diff`) |
| `,dD` | Git diff staged (unified, full tab via `:tab Git! diff --staged`) |

### Session (auto-session)
| Key | Action |
|-----|--------|
| `,wS` | Session search |
| `,ws` | Session save |
| `,wd` | Session delete |
| `,wr` | Session restore |

### Format
| Key | Action |
|-----|--------|
| `,lf` | Format buffer (LSP built-in) |

## Installed Plugins
| Plugin | Purpose |
|--------|---------|
| everforest-nvim | Colorscheme |
| lazy.nvim | Plugin manager |
| nvim-cmp + LuaSnip | Autocompletion + snippets (copilot source commented out/disabled) |
| nvim-lspconfig + mason + mason-lspconfig | LSP (clangd for C++, lua_ls for Lua); mason ensures clangd installed |
| telescope.nvim | Fuzzy finder (fzf-native, live-grep-args, ui-select) |
| nvim-treesitter | Syntax highlighting (csv disabled; python/ruby also use vim regex highlighting) |
| nvim-treesitter-context | Shows function/class context at top of window (max 3 lines, cursor mode) |
| tpope/vim-fugitive | Git commands (`:G`, `:Git`, etc.) |
| diffview.nvim | Git diff/merge (diff3_vertical, enhanced highlighting) |
| gitsigns.nvim | Git signs in gutter (keymaps only, no default on_attach keymaps) |
| nvim-tree.lua | File explorer (width=50, shows git-ignored files) |
| bufferline.nvim | Buffer tabs (slant style, nvim-tree offset) |
| nvim-bufdel | Buffer delete without closing window |
| which-key.nvim | Keybind hints (custom leader-group labels) |
| lualine.nvim + lsp-progress.nvim | Statusline with live LSP progress in the filename section |
| mini.nvim | mini.ai (textobjects), mini.surround, mini.comment (mini.pairs commented out) |
| nvim-ufo + promise-async | Code folding |
| vim-sleuth | Auto-detect indent per buffer |
| todo-comments.nvim | TODO highlighting (signs disabled) |
| csv.vim | CSV editing (`ft=csv`, treesitter highlighting stopped for csv buffers) |
| vim-dirdiff | Directory diff (`:DirDiff`; excludes build artifacts, `.git`, `.svn`, `.claude`, `.cache`, `compile_commands.json`, etc.) |
| vim-fetch | Open `file:line:col` args directly at that position |
| goto-preview | Peek definition/references in floating window |
| asyncrun.vim | Async shell commands (`:run` cmdline abbrev → `:AsyncRun`; quickfix auto-opens at height 15) |
| auto-session | Session auto-save on exit, auto-restore, auto-create |

## Disabled Plugins
| Plugin | Reason |
|--------|--------|
| indent-blankline.nvim | `enabled = false` in `format.lua` |
| mini.pairs | Commented out in `mini.lua` (auto-bracket-closing not wanted) |
| copilot source | Commented out of nvim-cmp sources in `autocomplete.lua` |

## Custom Commands
| Command | Action |
|---------|--------|
| `:Z7simPushMain` | `git push origin HEAD:refs/for/main` (Gerrit review, async via AsyncRun) |
| `:run` | Cmdline abbreviation for `:AsyncRun` |

## LSP Configuration
- **C++ (clangd)**: `-j=6` background indexing threads, `--limit-results=50`, `--header-insertion=never`, `--log=error`. clang-tidy runs at clangd's default (no override flag). Folding range capability explicitly disabled (`foldingRangeProvider=false`) so nvim-ufo falls back to treesitter/indent.
- **Lua (lua_ls)**: Configured for Neovim development (recognizes `vim`/`require` globals, uses Neovim runtime files as workspace library, LuaJIT runtime, telemetry off).
- **Custom clangd path**: `/tool/pandora64/.package/llvm-20.1.7-gcc1020/bin/clangd` on hosts matching `atletx7*`/`atlvibex*`; otherwise mason-installed clangd (`~/.local/share/nvim/mason/bin/clangd`).
- **Document highlight**: Cursor-hold symbol-reference highlighting wired per-buffer only for real file buffers (skips special buftypes), cleared on cursor move.
- **Diagnostics**: virtual text with source prefix `●`, signs, underline, severity-sorted; floating diagnostic window auto-shown on `CursorHold`.
