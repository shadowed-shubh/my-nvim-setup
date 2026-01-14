require("lspconfig")["pyright"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
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
