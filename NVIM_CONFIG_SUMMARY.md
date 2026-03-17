# Neovim Configuration Summary

## General Settings
- **Leader key**: `,`
- **Plugin manager**: lazy.nvim (plugins in `lua/custom/plugins/`)
- **Colorscheme**: everforest
- **Indentation**: 4 spaces, expandtab
- **Clipboard**: synced with OS (`unnamedplus`)
- **Grep**: ripgrep (`rg --vimgrep --smart-case`)
- **Swap/backup/undo**: disabled
- **Wildmode**: `longest,list,full` (longest match first, then list, then cycle)
- **Conceallevel**: 2 (hides markup in markdown/json)
- **Folding**: nvim-ufo (LSP folding disabled for clangd, falls back to treesitter/indent)
- **Nerd Font**: enabled

## Key Mappings

### General
| Key | Mode | Action |
|-----|------|--------|
| `,` | n | Leader key |
| `Y` | n | Copy line without newline |
| `<space>` | n | Insert space |
| `<Esc>` | n | Clear search highlight |
| `<Esc><Esc>` | t | Exit terminal mode |
| `<C-h/j/k/l>` | n | Move between windows |
| `,h` / `,l` | n/x/o | Move 20 chars left/right |
| `,a` | n | Select all |

### Quickfix
| Key | Action |
|-----|--------|
| `,q` | Open quickfix |
| `,Q` | Close quickfix |
| `,qd` | Clear quickfix list |
| `<C-n>` | Next quickfix item |
| `<C-p>` | Previous quickfix item |

### File/Buffer
| Key | Action |
|-----|--------|
| `,yf` | Copy filename:line_number |
| `,yF` | Copy full path |
| `,nt` | Find file in NvimTree |
| `,.` | Next buffer |
| `,m` | Previous buffer |
| `,bp` | Pick buffer |
| `,bb` | Pin buffer |
| `,bo` | Close other buffers |
| `,bd` | Delete buffer |

### Completion (nvim-cmp)
| Key | Action |
|-----|--------|
| `<Tab>` | Navigate/trigger completion |
| `<S-Tab>` | Previous item |
| `<CR>` | Confirm |
| `<C-Space>` | Manual trigger |
| `<C-e>` | Expand snippet |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition (`vim.lsp.buf.definition`, buffer-local) |
| `gr` | References (telescope `lsp_references`, global) |
| `gv` | Definition in vsplit |
| `gs` | Definition in hsplit |
| `K` | Hover info |
| `,ln` | Rename symbol |
| `,ga` | Code actions |
| `,gf` | Format buffer (LSP) |
| `[d` / `]d` | Prev/next diagnostic |

### Telescope
| Key | Action |
|-----|--------|
| `,sf` | Find files |
| `,sg` | Live grep |
| `,sc` | Search C++ code |
| `,sw` | Search word under cursor |
| `,sv` | Search visual selection |
| `,sh` | Search help |
| `,sk` | Search keymaps |
| `,sd` | Search diagnostics |
| `,sj` | Search jumplist |
| `,sr` | Resume last search |
| `,s.` | Recent files |
| `,,` | Open buffers |
| `,lw` | Workspace symbols |
| `,/` | Fuzzy find in buffer |
| `,gs` | Git status |
| `,gc` | Git commits |
| `,s/` | Grep in open files |
| `,sn` | Search nvim config |

### Git
| Key | Action |
|-----|--------|
| `,do` | Open diffview (ignore untracked files) |
| `,dc` | Close diffview |
| `,gh` | Git file history |
| `,gn` | Next hunk |
| `,gp` | Previous hunk |
| `,gr` | Revert hunk |
| `,gi` | Preview hunk inline |
| `,gd` | Git diff vsplit |

### Format
| Key | Action |
|-----|--------|
| `,f` | Format buffer (LSP built-in) |

## Installed Plugins
| Plugin | Purpose |
|--------|---------|
| everforest-nvim | Colorscheme |
| lazy.nvim | Plugin manager |
| nvim-cmp + LuaSnip | Autocompletion + snippets |
| nvim-lspconfig + mason | LSP (clangd for C++, lua_ls) |
| telescope.nvim | Fuzzy finder (fzf, live-grep-args) |
| nvim-treesitter | Syntax highlighting (csv disabled) |
| vim-fugitive | Git commands |
| diffview.nvim | Git diff/merge (diff3_vertical) |
| gitsigns.nvim | Git signs in gutter |
| nvim-tree.lua | File explorer (width=50) |
| bufferline.nvim | Buffer tabs (slant style) |
| nvim-bufdel | Buffer delete without closing window |
| which-key.nvim | Keybind hints |
| lualine.nvim | Statusline with LSP progress |
| mini.nvim | Textobjects, surround |
| nvim-ufo | Code folding |
| vim-sleuth | Auto-detect indent |
| todo-comments.nvim | TODO highlighting |
| csv.vim | CSV editing |
| vim-dirdiff | Directory diff |
| vim-fetch | Open file:line:col |
| asyncrun.vim | Async shell commands (`:run` alias) |

## Disabled Plugins
| Plugin | Reason |
|--------|--------|
| auto-session | Disabled (`enabled = false`) |
| toggleterm.nvim | Disabled (`enabled = false`) |
| indent-blankline.nvim | Disabled (`enabled = false`) |
| copilot.vim | Backed up as `copilot.lua.bak`, not loaded |

## LSP Configuration
- **C++ (clangd)**: Background indexing, PCH in memory, 4 threads, 50 completion limit, no header insertion, clang-tidy enabled
- **Lua (lua_ls)**: Configured for Neovim development
- **Custom clangd path**: Applied on `atletx7*` and `atlvibex*` hosts (`/tool/pandora64/.package/llvm-20.1.7-gcc1020/bin/clangd`)
- **Folding range**: Disabled for clangd (nvim-ufo falls back to treesitter/indent)
