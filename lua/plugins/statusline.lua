return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		local function active_lsp()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				return "no lsp"
			end

			local names = {}
			for _, client in ipairs(clients) do
				names[#names + 1] = client.name
			end
			return table.concat(names, ",")
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				globalstatus = true,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "alpha", "dashboard" },
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					{
						"diff",
						symbols = { added = "+", modified = "~", removed = "-" },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = {
							modified = " [+]",
							readonly = " [ro]",
							unnamed = "[No Name]",
						},
					},
				},
				lualine_x = {
					active_lsp,
					"encoding",
					"fileformat",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
