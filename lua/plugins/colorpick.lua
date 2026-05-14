return {
	"zaldih/themery.nvim",
	cmd = "Themery",
	keys = {
		{ "<leader>ut", "<cmd>Themery<cr>", desc = "Pick Theme" },
	},
	config = function()
		require("themery").setup({
			themes = { "tokyonight-night", "vague" },
			livePreview = true,
		})
	end,
}
