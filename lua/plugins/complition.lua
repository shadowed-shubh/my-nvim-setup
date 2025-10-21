return {
	-- Blink completion engine
	{
		"Saghen/blink.cmp",
		event = "InsertEnter",
		dependencies = {
			"neovim/nvim-lspconfig",
			"supermaven-inc/supermaven-nvim",
		},
		opts = {
			completion = {
				documentation = { auto_show = true },
			},
			sources = {
				default = { "lsp", "path", "buffer", "supermaven" },
			},
		},
	},

	-- Supermaven for AI completion
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
					clear_suggestion = "<C-]>",
				},
			})
		end,
	},
}
