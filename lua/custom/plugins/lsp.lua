return {
  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local function setup_lsp_document_highlight(client, bufnr)
        if not client.server_capabilities.documentHighlightProvider then
          return
        end

        -- Unique augroup per buffer to avoid collisions on reattach
        local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          group = group,
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
          desc = "LSP: highlight symbol references under cursor",
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          group = group,
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
          desc = "LSP: clear symbol reference highlights",
        })
      end

      local function on_attach(client, bufnr)
        setup_lsp_document_highlight(client, bufnr)
      end

      local caps = vim.lsp.protocol.make_client_capabilities()
      caps.textDocument.foldingRange = nil

      -- C++ LSP (clangd) - your .clangd file handles the configuration
      vim.lsp.config('clangd', {
        cmd = { "clangd", "--header-insertion=never", "--pch-storage=disk" },
        on_attach = on_attach,
        capabilities = caps,
        on_init = function(client)
          -- Belt-and-suspenders: tell Neovim that this client doesn't provide folds
          client.server_capabilities.foldingRangeProvider = false
        end,
      })
      vim.lsp.enable('clangd')

      -- Lua LSP (lua_ls) - configured for Neovim development
      vim.lsp.config('lua_ls', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = {
                'vim',
                'require'
              },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false, -- Disable third-party checking
            },
            telemetry = {
              enable = false, -- Don't send telemetry data
            },
            completion = {
              callSnippet = "Replace"
            },
          },
        },
      })
      vim.lsp.enable('lua_ls')

      -- LSP keymaps
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

      -- Code actions (this applies fixes!)
      vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('v', '<space>ca', vim.lsp.buf.code_action, opts) -- Also works in visual mode

      -- Show diagnostics automatically on cursor hold
      vim.api.nvim_create_autocmd('CursorHold', {
        group = vim.api.nvim_create_augroup('DiagnosticFloat', {}),
        callback = function()
          vim.diagnostic.open_float(nil, {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
          })
        end
      })

      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●', -- Could be '■', '▎', 'x', '●'
          source = "always",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      })

      -- Attach keymaps when LSP connects
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)

          -- Code actions (this applies fixes!)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('v', '<space>ca', vim.lsp.buf.code_action, opts) -- Also works in visual mode

          -- Quick fix - applies the first available code action
          vim.keymap.set('n', '<space>qf', function()
            vim.lsp.buf.code_action({
              filter = function(action)
                return action.isPreferred
              end,
              apply = true,
            })
          end, opts)

          -- Format buffer
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)

          -- Go to definition in splits
          vim.keymap.set('n', 'gs', function()
            vim.cmd('split')
            vim.lsp.buf.definition()
          end, opts)

          vim.keymap.set('n', 'gv', function()
            vim.cmd('vsplit')
            vim.lsp.buf.definition()
          end, opts)
        end,
      })
    end,
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',  -- ✅ Correct
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
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
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
        }
      })
    end,
  },

  -- Install lsp using mason
  {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  config = function() require("mason").setup() end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd" },
      })
    end,
  },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
  },

  -- lspsaga.nvim
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup({ 
        lightbulb = {
          enable = false,
        },
      })
    end,
    vim.keymap.set("n", "gpd", "<cmd>Lspsaga peek_definition<CR>", { desc = "LSP: Peek definition" }),
    vim.keymap.set({ 'n', 't' }, '<leader>t', '<cmd>Lspsaga term_toggle<cr>', { desc = "LSP: Toggle float term" }),
  },
}
