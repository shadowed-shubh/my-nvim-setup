return {
	{
		"benlubas/molten-nvim",
		version = "^1",
		ft = { "python", "markdown", "quarto", "json" },
		lazy = false,
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", lazy = true },
			{ "nvim-tree/nvim-web-devicons",     lazy = true },
		},
		build = ":UpdateRemotePlugins",
		init = function()
			-- Image and output settings
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_auto_init_behavior = "init"
			vim.g.molten_enter_output_behavior = "open_and_enter"
			vim.g.molten_auto_image_popup = false
			vim.g.molten_auto_open_output = false
			vim.g.molten_output_crop_border = false
			vim.g.molten_output_virt_lines = true
			vim.g.molten_output_win_max_height = 55
			vim.g.molten_output_win_style = "minimal"
			vim.g.molten_output_win_hide_on_leave = false
			vim.g.molten_virt_text_output = true
			vim.g.molten_virt_lines_off_by_1 = false
			vim.g.molten_virt_text_max_lines = 10000
			vim.g.molten_cover_empty_lines = false
			vim.g.molten_copy_output = false
			vim.g.molten_output_show_exec_time = true
			vim.g.molten_output_win_border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }
			vim.g.molten_use_border_highlights = true
			vim.g.molten_save_path = "~/dev/python/moltenoutputs"
		end,
		config = function()
			-- Official molten notebook auto-import setup
			local imb = function(e) -- init molten buffer
				vim.schedule(function()
					local kernels = vim.fn.MoltenAvailableKernels()
					local try_kernel_name = function()
						local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))
						    ["metadata"]
						return metadata.kernelspec.name
					end
					local ok, kernel_name = pcall(try_kernel_name)
					if not ok or not vim.tbl_contains(kernels, kernel_name) then
						kernel_name = nil
						local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
						if venv ~= nil then
							kernel_name = string.match(venv, "/.+/(.+)")
						end
					end
					if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
						vim.cmd(("MoltenInit %s"):format(kernel_name))
					end
					vim.cmd("MoltenImportOutput")
				end)
			end

			-- automatically import output chunks from a jupyter notebook
			vim.api.nvim_create_autocmd("BufAdd", {
				pattern = { "*.ipynb" },
				callback = imb,
			})

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = { "*.ipynb" },
				callback = function(e)
					if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
						imb(e)
					end
				end,
			})

			-- Create new notebook command
			local default_notebook = [[
{
  "cells": [
   {
    "cell_type": "markdown",
    "metadata": {},
    "source": [
      ""
    ]
   }
  ],
  "metadata": {
   "kernelspec": {
    "display_name": "Python 3",
    "language": "python",
    "name": "python3"
   },
   "language_info": {
    "codemirror_mode": {
      "name": "ipython"
    },
    "file_extension": ".py",
    "mimetype": "text/x-python",
    "name": "python",
    "nbconvert_exporter": "python",
    "pygments_lexer": "ipython3"
   }
  },
  "nbformat": 4,
  "nbformat_minor": 5
}
]]

			local function new_notebook(filename)
				local path = filename .. ".ipynb"
				local file = io.open(path, "w")
				if file then
					file:write(default_notebook)
					file:close()
					vim.cmd("edit " .. path)
				else
					print("Error: Could not open new notebook file for writing.")
				end
			end

			vim.api.nvim_create_user_command('NewNotebook', function(opts)
				new_notebook(opts.args)
			end, {
				nargs = 1,
				complete = 'file'
			})
		end,
	}
}
