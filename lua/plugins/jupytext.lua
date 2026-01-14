return {
	"GCBallesteros/jupytext.nvim",
	lazy = false,
	opts = {
		style = "percent",
		format = "py",
		output_extension = "py",
		force_ft = "python",
	},
	config = function(_, opts)
		require("jupytext").setup(opts)

		local jupyter_group = vim.api.nvim_create_augroup("JupyterWorkflow", { clear = true })

		-- Auto-convert .ipynb to .py on open
		vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
			group = jupyter_group,
			pattern = "*.ipynb",
			callback = function()
				local ipynb_file = vim.fn.expand("%:p")
				local py_file = vim.fn.expand("%:p:r") .. ".py"

				-- Convert to py:percent format
				vim.fn.system(string.format("jupytext --to py:percent '%s'", ipynb_file))

				-- Open the .py file
				vim.cmd("edit " .. py_file)
			end,
		})

		-- Auto-export outputs and sync on save
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = jupyter_group,
			pattern = "*.py",
			callback = function()
				local py_file = vim.fn.expand("%:p")
				local ipynb_file = vim.fn.expand("%:p:r") .. ".ipynb"

				-- Check if paired ipynb exists
				if vim.fn.filereadable(ipynb_file) == 1 then
					-- Export outputs from molten
					local ok = pcall(vim.cmd, "MoltenExportOutput!")

					if ok then
						-- Sync to ipynb
						vim.fn.system(string.format("jupytext --to ipynb --update '%s'", py_file))
						vim.notify("💾 Saved outputs to .ipynb", vim.log.levels.INFO)
					else
						-- Just sync code if molten isn't running
						vim.fn.system(string.format("jupytext --to ipynb --update '%s'", py_file))
						vim.notify("💾 Synced code to .ipynb", vim.log.levels.INFO)
					end
				end
			end,
		})
	end,
}
