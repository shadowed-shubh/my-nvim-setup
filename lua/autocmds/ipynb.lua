local imb = require("your_module_name_here").imb
-- or however imb is defined

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
