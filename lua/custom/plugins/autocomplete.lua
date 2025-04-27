-- ~/.config/nvim/lua/custom/plugins/autocomplete.lua
return {
    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                'L3MON4D3/LuaSnip',
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                    -- `friendly-snippets` contains a variety of premade snippets.
                    --    See the README about individual language/framework/plugin snippets:
                    --    https://github.com/rafamadriz/friendly-snippets
                    -- {
                    --   'rafamadriz/friendly-snippets',
                    --   config = function()
                    --     require('luasnip.loaders.from_vscode').lazy_load()
                    --   end,
                    -- },
                },
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
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    -- To disable autocomplete for specific buffer do this :lua require('cmp').setup.buffer { enabled = false }
                    -- autocomplete = false,
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

                    -- If you prefer more traditional completion keymaps,
                    ['<CR>'] = cmp.mapping.confirm { select = false },
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),

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
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'buffer' },
                    { name = 'cmdline' },
                },
            }
        end,
    },
}
