-- ~/.config/nvim/lua/custom/plugins/autocomplete.lua
return {
    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                'L3MON4D3/LuaSnip',
                dependencise = {
                    'rafamadriz/friendly-snippets',
                },
                config = function()
                    -- ✅ FIX: Require inside the config function
                    local luasnip = require("luasnip")

                    -- Optional: Lazy-load VSCode-style snippets
                    require("luasnip.loaders.from_vscode").lazy_load()

                    -- ✅ Load your Lua-based snippets (table format)
                    require("luasnip.loaders.from_lua").load({
                        paths = { vim.fn.stdpath("config") .. "/snippets" }  -- e.g., ~/.config/nvim/snippets/cpp.lua
                    })

                    -- Optional: settings
                    luasnip.config.set_config({
                        history = true,
                        updateevents = "TextChanged,TextChangedI",
                        enable_autosnippets = true,
                    })
                end
            },
            'saadparwaiz1/cmp_luasnip',

            -- Adds other completion capabilities.
            --  nvim-cmp does not ship with all sources by default. They are split
            --  into multiple repos for maintenance purposes.
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline'
        },
        config = function()
            -- See `:help cmp`
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            luasnip.config.setup {}

            -- Fix `$VAR/` completion for variable names containing digits.
            --
            -- cmp-path resolves "$VAR/" with the pattern '%$([%a_]+)/$', which
            -- matches letters and underscore but NOT digits. So $pl_worksp2,
            -- $pt_scratch1, $nv_corr1 ... never match and _dirname() returns
            -- nil. cmp then falls back to the 'cmdline' source, whose
            -- getcompletion() returns an ABSOLUTE path, and cmp inserts that at
            -- the keyword offset -- which sits after the literal "$pl_worksp2/"
            -- still on the line. Result:
            --     :e $pl_worksp2//proj/pl_tsim_workspace2/jaehjung/mpsim
            -- Names without digits ($ps_corr, $kos_release) were unaffected.
            --
            -- Expand such names ourselves, then delegate. Only the string
            -- cmp-path inspects is rewritten; the real cmdline is untouched, so
            -- the offset cmp replaces is unchanged and "$pl_worksp2/" stays
            -- literal (`:e` expands it on <CR>).
            local ok_path, cmp_path = pcall(require, 'cmp_path')
            if ok_path then
                local orig_dirname = cmp_path._dirname
                cmp_path._dirname = function(self, params, option)
                    local before = params.context.cursor_before_line
                    local expanded = before:gsub('%$([%w_]+)/', function(name)
                        local value = vim.env[name]
                        -- returning nil leaves the original text in place
                        return value and (value .. '/') or nil
                    end)

                    local target = params
                    if expanded ~= before then
                        local ctx = setmetatable(
                            { cursor_before_line = expanded },
                            { __index = params.context })
                        target = setmetatable(
                            { context = ctx }, { __index = params })
                    end

                    local dir = orig_dirname(self, target, option)

                    -- Second quirk, independent of $VAR and affecting plain
                    -- absolute paths too: the partial name being typed is
                    -- stripped with '%a*$' (letters only), so a stem containing
                    -- a digit is mistaken for a directory -- ".../z7sim" is cut
                    -- to ".../z7". That directory does not exist, cmp-path
                    -- returns nothing, and the 'cmdline' fallback doubles the
                    -- path again. The mis-kept remnant is always a single
                    -- component, so stepping up one level is enough.
                    if dir and vim.fn.isdirectory(dir) == 0 then
                        local parent = vim.fn.fnamemodify(dir, ':h')
                        if parent ~= dir and vim.fn.isdirectory(parent) == 1 then
                            return parent
                        end
                    end
                    return dir
                end
            end

            -- '?' cmdline setup.
            cmp.setup.cmdline('?', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })
            -- '/' cmdline setup.
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })
            -- ':' cmdline setup.
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                        {
                            name = 'path',
                            option = {
                                trailing_slash = true,
                            },
                        },
                    },
                    {
                        {
                            name = 'cmdline',
                            option = {
                                ignore_cmds = { 'Man', '!' },
                            },
                        }
                    })
            })
            -- helper: are we after a word character? (so we know when to trigger completion)
            local has_words_before = function()
                local col = vim.fn.col('.') - 1
                if col == 0 then return false end
                local line = vim.fn.getline('.')
                return not line:sub(col, col):match('%s')
            end
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    -- To disable autocomplete for specific buffer do this :lua require('cmp').setup.buffer { enabled = false }
                    autocomplete = false,
                    completeopt = table.concat(vim.opt.completeopt:get(), ","),
                },
                preselect = cmp.PreselectMode.None, -- Do not preselect anything from menu
                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                mapping = cmp.mapping.preset.insert {
                    -- Optional: explicitly fallback to normal behavior
                    ['<Up>'] = cmp.mapping(function(fallback)
                      fallback()   -- Do default Up arrow (move cursor)
                    end, { 'i', 'c' }),

                    ['<Down>'] = cmp.mapping(function(fallback)
                      fallback()   -- Do default Down arrow
                    end, { 'i', 'c' }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),

                    ['<C-e>'] = cmp.mapping(function()
                        luasnip.expand_or_jump()
                    end, { 'i', 's' }),

                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    -- <CR> to confirm completion
                    ['<CR>'] = cmp.mapping.confirm { select = true },
                    -- <Esc> to close completion
                    ['<Esc>'] = cmp.mapping.close(),    -- just closes the menu
                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ['<C-Space>'] = cmp.mapping.complete {},

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-h> is similar, except moving you backwards.
                    --[[
                      ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                          luasnip.expand_or_jump()
                        end
                      end, { 'i', 's' }),
                      ['<C-h>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                          luasnip.jump(-1)
                        end
                      end, { 'i', 's' }),
                      ]]
                    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                },
                sources = cmp.config.sources({
                    -- { name = 'copilot', priority = 1000 }, -- AI suggestions disabled
                    { name = 'nvim_lsp', priority = 900 },
                    { name = 'luasnip', priority = 800 },
                    { name = 'path' },
                    { name = 'buffer' },
                    { name = 'cmdline' },
                }),
            }
        end,
    },
}
