local function get_dir(path)
	if vim.fn.isdirectory(path) == 1 then
		return vim.fn.fnamemodify(path, ":p")
	elseif vim.fn.filereadable(path) == 1 then
		return vim.fn.fnamemodify(path, ":p:h")
	else
		return vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
	end
end

vim.keymap.set("n", "<C-l>", function()
	if vim.fn["floaterm#buflist#curr"]() == -1 then
		local dir = vim.fn.escape(
			vim.fn.fnamemodify(get_dir(vim.fn.expand("%")), ":~"),
			' %#|"'
		)
		vim.cmd("FloatermNew --cwd=" .. dir)
	else
		vim.cmd("FloatermToggle")
	end
end, { silent = true })

vim.keymap.set("t", "<C-l>", [[<C-\><C-n>:FloatermToggle<CR>]], { silent = true })

return {
	"voldikss/vim-floaterm",
	event = "VeryLazy",
	config = function()
		vim.g.floaterm_width = 0.9
		vim.g.floaterm_height = 0.85
		vim.g.floaterm_borderchars = "─│─│╭╮╯╰"
		vim.g.floaterm_title = " Terminal "
		vim.g.floaterm_autoclose = 1
		vim.g.floaterm_wintype = "float"
		--keymaps
		vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true })
	end
}
