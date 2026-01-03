return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = true,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },

		-- IMPORTANT: this ensures it loads BEFORE lsp.lua runs
		event = "VeryLazy",

		config = function()
			local servers = {
				"lua_ls",
				"rust_analyzer",
				"pyright",
				"clangd",
				"gopls",
				"bashls",
				"marksman",
			}

			require("mason-lspconfig").setup({
				ensure_installed = servers,
			})

			-- Enable servers safely
			for _, server in ipairs(servers) do
				vim.lsp.enable(server)
			end
		end,
	},
}

