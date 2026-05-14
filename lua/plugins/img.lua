return
{
	"3rd/image.nvim",
	ft = { "markdown", "quarto" },
	dependencies = {
		"vhyrro/luarocks.nvim",
		priority = 1001,
		opts = {
			rocks = { "magick" },
		},
	},
	opts = {
		backend = "kitty",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
			},
		},
		hijack_file_patterns = {},
		max_width = 500,
		max_height = 500,
		max_height_window_percentage = math.huge,
		max_width_window_percentage = math.huge,
		window_overlap_clear_enabled = false,
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "noice", "" },
	},
}
