return {
	"PhantomYdn/fabric-ai.nvim",
	cmd = { "Fabric" },
	dependencies = {
		{ "nvim-telescope/telescope.nvim", optional = true },
	},
	opts = {
		-- Default configuration (all optional)
		fabric_path = "fabric-ai", -- Path to Fabric CLI
		patterns_path = nil, -- Custom patterns dir (auto-detect if nil)
		timeout = 300000, -- Command timeout in ms (5 minutes)
		window = {
			width = 0.8, -- 80% of editor width
			height = 0.25, -- 80% of editor height
			border = "rounded",
		},
	},
	keys = {
		-- fabric-ai.nvim doesn't have default keymappings
		{ "<leader>fa", ":'<,'>Fabric<CR>", mode = "v", desc = "Fabric AI" },
		{ "<leader>fu", ":Fabric url<CR>",  mode = "n", desc = "Fabric URL" },
	},
}
