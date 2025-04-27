return
{
		{
		"hrsh7th/cmp-nvim-lsp"
		},
		{
		-- adds function arg help while typing out functions!!!
		"hrsh7th/cmp-nvim-lsp-signature-help",
	},
{
	"L3MON4D3/LuaSnip",
		dependencies ={
  "saadparwaiz1/cmp_luasnip",
"rafamadriz/friendly-snippets",
"windwp/nvim-autopairs"
}
	},
{
	"hrsh7th/nvim-cmp",
	config = function()
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	local cmp = require("cmp")
	require("luasnip.loaders.from_vscode").lazy_load()

	cmp.event:on("confirm_done",cmp_autopairs.on_confirm_done())

  	cmp.setup({
		preselect = cmp.PreselectMode.None,
    		snippet = {
     		 expand = function(args)
        	 require('luasnip').lsp_expand(args.body)
	end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "nvim_lsp_signature_help" }, -- function arg popups while typing
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
