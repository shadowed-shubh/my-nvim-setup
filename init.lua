vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.python3_host_prog = "/home/shubh/.conda/envs/ml/bin/python"

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.winborder = "rounded"
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("config.lsp")

-- Setup lazy.nvim
require("lazy").setup("plugins", {
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
})

local ok_colorscheme = pcall(vim.cmd.colorscheme, "tokyonight-night")
if not ok_colorscheme then
	vim.cmd.colorscheme("habamax")
end

-- Transparent background highlights
local transparent_group = vim.api.nvim_create_augroup("UserTransparentHighlights", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
	group = transparent_group,
	callback = function()
		vim.cmd([[
			highlight Normal guibg=none ctermbg=none
			highlight NonText guibg=none ctermbg=none
			highlight NormalFloat guibg=none ctermbg=none
		]])
	end,
})
