return {
	"folke/noice.nvim",
	event = "VeryLazy",
	cmd = "Noice",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	keys = {
		{ "<leader>n", "<cmd>Noice history<cr>", desc = "Notification History" },
		{ "<leader>un", "<cmd>Noice dismiss<cr>", desc = "Dismiss Notifications" },
	},
	opts = {
		notify = {
			enabled = true,
			view = "notify",
		},
		messages = {
			enabled = true,
			view = "notify",
			view_error = "notify",
			view_warn = "notify",
			view_history = "messages",
		},
		lsp = {
			progress = { enabled = true },
			hover = { enabled = true },
			signature = { enabled = true },
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			lsp_doc_border = true,
		},
	},
}
