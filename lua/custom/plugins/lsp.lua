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

      local function is_real_file_buffer(bufnr)
        if vim.bo[bufnr].buftype ~= "" then
          return false
        end

        local uri = vim.uri_from_bufnr(bufnr)
        return uri ~= nil and uri:match("^file://") ~= nil
      end

      local function setup_lsp_document_highlight(client, bufnr)
        if not client.server_capabilities.documentHighlightProvider then
          return
        end

        -- Unique augroup per buffer to avoid collisions on reattach
        local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          group = group,
          buffer = bufnr,
          callback = function()
            if is_real_file_buffer(bufnr) then
              vim.lsp.buf.document_highlight()
            end
          end,
          desc = "LSP: highlight symbol references under cursor",
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          group = group,
          buffer = bufnr,
          callback = function()
            if is_real_file_buffer(bufnr) then
              vim.lsp.buf.clear_references()
            end
          end,
          desc = "LSP: clear symbol reference highlights",
        })
      end

      local function on_attach(client, bufnr)
        setup_lsp_document_highlight(client, bufnr)
      end

      local caps = vim.lsp.protocol.make_client_capabilities()
      caps.textDocument.foldingRange = nil

      local clangd_path = vim.fn.stdpath("data") .. "/mason/bin/clangd"
      local clangd_env = nil
      if vim.fn.hostname():match("atletx7") or vim.fn.hostname():match("atletx8") or vim.fn.hostname():match("atlvibex") then
        -- Mirror the llvm module selection in ~/.bashrc so the editor's indexer
        -- stays on the same toolchain as the shell: RHEL7 -> gcc10 build,
        -- RHEL8 -> gcc15 build. Unreadable/unknown release falls back to the
        -- gcc10 build, which runs on both.
        local release = ""
        if vim.fn.filereadable("/etc/redhat-release") == 1 then
          release = vim.fn.readfile("/etc/redhat-release")[1] or ""
        end
        local pandora_clangd = "/tool/pandora64/.package/llvm-20.1.7-gcc1020/bin/clangd"
        if release:match("release 8") then
          pandora_clangd = "/tool/pandora64/.package/llvm-21.1.0-gcc1520/bin/clangd"
        end

        -- Only take the pandora build if it is actually present; otherwise keep
        -- the mason clangd (which needs no injected libs).
        if vim.fn.executable(pandora_clangd) == 1 then
          clangd_path = pandora_clangd
          -- Both pandora clangd builds link against libgrpc++.so.1 / libgrpc.so.15 /
          -- libprotobuf.so.3.14.0.0, supplied only by grpc-1.36.2-gcc1020. The grpc
          -- modulefile does not export LD_LIBRARY_PATH, so inject it here -- this also
          -- covers nvim launched from a shell that never sourced ~/.bashrc (nvim-qt,
          -- desktop launcher, remote spawn).
          local grpc_lib = "/tool/pandora64/.package/grpc-1.36.2-gcc1020/lib"
          local ld = vim.env.LD_LIBRARY_PATH or ""
          if not (":" .. ld .. ":"):find(":" .. grpc_lib .. ":", 1, true) then
            ld = ld ~= "" and (grpc_lib .. ":" .. ld) or grpc_lib
          end
          clangd_env = { LD_LIBRARY_PATH = ld }
        end
      end
      -- C++ LSP (clangd) - your .clangd file handles the configuration
      vim.lsp.config('clangd', {
        cmd = { clangd_path,
        -- Reduce completion items to speed up responses
        "--limit-results=50",
        -- Header insertion can be slow over SSH
        "--header-insertion=never",
        -- Log to file for debugging (optional)
        "--log=error"
        },
        cmd_env = clangd_env,
        on_attach = on_attach,
        capabilities = caps,
        before_init = function(params)
          -- nvim-lspconfig's clangd preset still advertises the deprecated
          -- offsetEncoding extension, which clangd drops in release 23.
          -- Neovim already sends the standard general.positionEncodings, so
          -- removing this loses no negotiation, only the warning.
          params.capabilities.offsetEncoding = nil
        end,
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
          -- LSP: Rename symbol
          vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, { desc = "LSP: Rename symbol"})

          -- LSP keymaps
          vim.keymap.set('n', '[d', function () vim.diagnostic.jump({ count=-1, float=true}) end)
          vim.keymap.set('n', ']d', function () vim.diagnostic.jump({ count=1, float=true}) end)

          -- Code actions (this applies fixes!)
          vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = "Open quickfix suggestions from LSP code actions" })

          -- Format buffer
          vim.keymap.set('n', '<leader>lf', function()
            vim.lsp.buf.format { async = true }
          end, { desc = "Format buffers using LSP "})

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

  -- Install lsp using mason
  {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
  build = ":MasonUpdate",
  config = function() require("mason").setup() end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd" },
      })
    end,
  },

}
