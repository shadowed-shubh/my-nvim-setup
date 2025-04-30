-- lsp-config.lua - Put this in your Neovim plugin folder
-- Configuration for LSP support for C++, Python, and Lua

-- Ensure leader is set to space at the top level
-- This needs to be set before plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

return {
  -- Mason setup for LSP server management with more robust configuration
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
          },
          keymaps = {
            toggle_server_expand = "<CR>",
            install_server = "i",
            update_server = "u",
            uninstall_server = "x",
          },
        },
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 4,
        pip = {
          -- Use an alternative to pyright if there are installation issues
          -- Use "--no-cache-dir" to avoid cache issues
          install_args = {
            "--no-cache-dir",
          },
        },
        -- Add registries for more installation sources
        registries = {
          "github:mason-org/mason-registry",
        },
      })
    end
  },
  
  -- Mason-lspconfig integration with fallback options
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        -- We'll manually set up servers to handle potential issues
        ensure_installed = { "clangd", "lua_ls" },
        -- Set automatic_installation to false to avoid installation errors
        automatic_installation = false,
      })
    end
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require('lspconfig')
      
      -- LSP keymaps setup function
      local function setup_lsp_keymaps(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        
        -- Navigation and information
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)                  -- Go to definition
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)                 -- Go to declaration
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)              -- Go to implementation
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)                  -- Find references
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                        -- Show documentation
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)           -- Show signature help
        
        -- Workspace management
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)           -- Add workspace folder
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)        -- Remove workspace folder
        vim.keymap.set('n', '<leader>wl', function() 
          print(vim.inspect(vim.lsp.buf.list_workspace_folders())) 
        end, opts)                                                               -- List workspace folders
        
        -- Code actions and refactoring
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)              -- Rename symbol
        vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)  -- Code actions
        
        -- Diagnostics navigation and display
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)                -- Previous diagnostic
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)                -- Next diagnostic
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)        -- Show diagnostic in float window
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)        -- Add diagnostics to location list
        
        -- Type definition
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)      -- Go to type definition
        
        -- Formatting
        if client.server_capabilities.documentFormattingProvider then
          vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)  -- Format document
        end
        
        -- Show diagnostics on hover with delay
        vim.api.nvim_create_autocmd("CursorHold", {
          buffer = bufnr,
          callback = function()
            local float_opts = {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = 'rounded',
              source = 'always',
              prefix = ' ',
              scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, float_opts)
          end
        })
      end
      
      -- Attach keymaps to any LSP server that connects
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          setup_lsp_keymaps(client, ev.buf)
        end,
      })

      -- C++ Setup with clangd
      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--suggest-missing-includes",
          "--clang-tidy",
          "--header-insertion=iwyu",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern(
            "compile_commands.json",
            "compile_flags.txt",
            ".git",
            "CMakeLists.txt"
          )(fname) or vim.fn.getcwd()
        end,
        init_options = {
          compilationDatabasePath = "build",
        },
      })

      -- Python setup with alternatives to handle pyright installation issues
      -- Option 1: Try to use pyright directly if installed
      pcall(function()
        lspconfig.pyright.setup({
          capabilities = capabilities,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        })
      end)
      
      -- Option 2: Fall back to alternative Python LSP (jedi_language_server)
      -- You can manually install this with :MasonInstall jedi_language_server
      pcall(function()
        lspconfig.jedi_language_server.setup({
          capabilities = capabilities,
        })
      end)
      
      -- Option 3: Fall back to ruff (replacement for deprecated ruff_lsp)
      -- You can manually install this with :MasonInstall ruff
      pcall(function()
        lspconfig.ruff.setup({
          capabilities = capabilities,
          settings = {
            -- Ruff-specific settings
            ruff = {
              lint = {
                run = "onSave",
              },
              organizeImports = true,
            },
          },
        })
      end)

      -- Lua Setup with lua-language-server
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim", "use" }, -- Recognize vim global for Neovim config
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
    end
  },

  -- Completion setup
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
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
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })

      -- Setup for specific filetypes
      cmp.setup.filetype({ 'c', 'cpp' }, {
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      cmp.setup.filetype('python', {
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      cmp.setup.filetype('lua', {
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      -- Cmdline setup
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  }
}
