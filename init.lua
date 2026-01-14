require("config.lsp")
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

vim.g.python3_host_prog =
"/home/shubh/.conda/envs/ml/bin/python"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.termguicolors = true
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format({async = false})]])

-- Setup lazy.nvim
require("lazy").setup("plugins", {
	spec = {
		-- add your plugins here
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
})

vim.cmd([[colorscheme tokyonight-night]])

-- Transparent background highlights
vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])

vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.winborder = 'rounded'
