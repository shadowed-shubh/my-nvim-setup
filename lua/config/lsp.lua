------------------------------------------------------------
-- Pure LSP config (SAFE)
------------------------------------------------------------

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

vim.lsp.config("*", {
	capabilities = capabilities,
})

vim.lsp.config("pyright", {
	settings = {
		python = {
			analysis = {
				diagnosticSeverityOverrides = {
					reportUnusedExpression = "none",
				},
			},
		},
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "Snacks" },
			},
			workspace = {
				checkThirdParty = false,
			},
		},
	},
})

vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
		},
	},
})

vim.lsp.config("svelte", {})

vim.lsp.enable({
	"lua_ls",
	"pyright",
	"rust_analyzer",
	"svelte",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }

		-- Keep short aliases for common jumps; Neovim provides the gr* defaults.
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "<leader>lf", function()
			vim.lsp.buf.format({ async = true, bufnr = ev.buf })
		end, opts)
	end,
})

vim.diagnostic.config({
	virtual_lines = true,
	underline = true,
	severity_sort = true,
	float = { border = "rounded" },
})
