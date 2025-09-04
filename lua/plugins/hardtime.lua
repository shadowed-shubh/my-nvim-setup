return
{
	"m4xshen/hardtime.nvim",
	lazy = false,
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {
		disabled_keys = {
			-- Remove arrow keys from disabled keys to allow their use
			-- Default hardtime disables h, j, k, l and arrow keys
			-- This config only disables h, j, k, l but allows arrow keys
			["<Up>"] = false,
			["<Down>"] = false,
			["<Left>"] = false,
			["<Right>"] = false,
		},
		-- Alternative approach: you can also use restriction_mode
		-- restriction_mode = "hint", -- This will show hints instead of blocking
	},
}
