-- Minimal LSP Configuration for C/C++, Python, Lua, and Rust
vim.g.mapleader = " "

return {
	-- Mason for LSP server management
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗"
					}
				}
			})
		end
	},

	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			-- Setup LSP servers
			lspconfig.clangd.setup({
				capabilities = capabilities,
			})
			lspconfig.pylsp.setup({
				capabilities = capabilities,
			})

			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			-- LSP keymaps
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
					vim.keymap.set('n', '<leader>e', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', '<leader>f',
						function() vim.lsp.buf.format({ async = true }) end, opts)
				end,
			})
		end
	},

	-- Completion
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
					['<C-Space>'] = cmp.mapping.complete(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
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
			})

			-- Cmdline completion for search
			cmp.setup.cmdline('/', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})

			-- Cmdline completion for commands
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
