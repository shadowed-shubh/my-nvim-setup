local function reload_workspace(bufnr)
	local clients = vim.lsp.get_clients { bufnr = bufnr, name = 'rust_analyzer' }
	for _, client in ipairs(clients) do
		vim.notify 'Reloading Cargo Workspace'
		---@diagnostic disable-next-line:param-type-mismatch
		client:request('rust-analyzer/reloadWorkspace', nil, function(err)
			if err then
				error(tostring(err))
			end
			vim.notify 'Cargo workspace reloaded'
		end, 0)
	end
end

local function is_library(fname)
	local user_home = vim.fs.normalize(vim.env.HOME)
	local cargo_home = os.getenv 'CARGO_HOME' or user_home .. '/.cargo'
	local registry = cargo_home .. '/registry/src'
	local git_registry = cargo_home .. '/git/checkouts'

	local rustup_home = os.getenv 'RUSTUP_HOME' or user_home .. '/.rustup'
	local toolchains = rustup_home .. '/toolchains'

	for _, item in ipairs { toolchains, registry, git_registry } do
		if vim.fs.relpath(item, fname) then
			local clients = vim.lsp.get_clients { name = 'rust_analyzer' }
			return #clients > 0 and clients[#clients].config.root_dir or nil
		end
	end
end

---@type vim.lsp.Config
return {
	cmd = { 'rust-analyzer' },
	filetypes = { 'rust' },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local reused_dir = is_library(fname)
		if reused_dir then
			on_dir(reused_dir)
			return
		end

		local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })
		local cargo_workspace_root

		if cargo_crate_dir == nil then
			on_dir(
				vim.fs.root(fname, { 'rust-project.json' })
				or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
			)
			return
		end

		local cmd = {
			'cargo',
			'metadata',
			'--no-deps',
			'--format-version',
			'1',
			'--manifest-path',
			cargo_crate_dir .. '/Cargo.toml',
		}

		vim.system(cmd, { text = true }, function(output)
			if output.code == 0 then
				if output.stdout then
					local result = vim.json.decode(output.stdout)
					if result['workspace_root'] then
						cargo_workspace_root = vim.fs.normalize(result['workspace_root'])
					end
				end

				on_dir(cargo_workspace_root or cargo_crate_dir)
			else
				vim.schedule(function()
					vim.notify(('[rust_analyzer] cmd failed with code %d: %s\n%s'):format(
						output.code, cmd, output.stderr))
				end)
			end
		end)
	end,
	capabilities = {
		experimental = {
			serverStatusNotification = true,
		},
	},
	before_init = function(init_params, config)
		-- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
		if config.settings and config.settings['rust-analyzer'] then
			init_params.initializationOptions = config.settings['rust-analyzer']
		end
	end,
	on_attach = function(_, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, 'LspCargoReload', function()
			reload_workspace(bufnr)
		end, { desc = 'Reload current cargo workspace' })
	end,
	settings = {
		['rust-analyzer'] = {
			-- CARGO FEATURES --
			-- Controls which features to enable when building
			cargo = {
				allFeatures = true, -- Enable all Cargo features
				loadOutDirsFromCheck = true, -- Load OUT_DIR values by running cargo check
				runBuildScripts = true, -- Run build scripts (build.rs)
				autoreload = true, -- Automatically reload when Cargo.toml changes
				-- buildScripts = {
				-- 	enable = true,              -- Enable build script support
				-- },
			},

			-- CHECK/DIAGNOSTICS FEATURES --
			-- Controls how and when diagnostics are generated
			checkOnSave = {
				command = "clippy", -- Use clippy instead of cargo check (better lints!)
				allTargets = true, -- Check all targets (tests, benches, examples)
				extraArgs = { "--all" }, -- Additional args for cargo check/clippy
			},
			diagnostics = {
				enable = true, -- Enable diagnostics
				experimental = {
					enable = true, -- Enable experimental diagnostics
				},
				disabled = {}, -- List of diagnostics to disable (e.g., {"unresolved-proc-macro"})
				-- styleLints = {
				-- 	enable = true,              -- Enable style lint diagnostics
				-- },
			},

			-- PROCEDURAL MACROS --
			-- Support for proc macros (derive macros, etc.)
			procMacro = {
				enable = true, -- Enable proc macro support
				attributes = {
					enable = true, -- Enable attribute proc macros
				},
				ignored = {}, -- List of proc macros to ignore
			},

			-- INLAY HINTS --
			-- Shows inline type hints, parameter names, etc.
			inlayHints = {
				bindingModeHints = {
					enable = false, -- Show binding mode hints (ref, mut)
				},
				chainingHints = {
					enable = true, -- Show type hints for method chains
				},
				closingBraceHints = {
					enable = true, -- Show hints at closing braces
					minLines = 25, -- Minimum lines before showing hint
				},
				closureReturnTypeHints = {
					enable = "never", -- "never", "always", "with_block"
				},
				discriminantHints = {
					enable = "never", -- Show enum discriminant hints
				},
				lifetimeElisionHints = {
					enable = "never", -- Show lifetime elision hints
					useParameterNames = false, -- Use parameter names in lifetime hints
				},
				maxLength = 25, -- Max length of inlay hints
				parameterHints = {
					enable = true, -- Show parameter name hints
				},
				reborrowHints = {
					enable = "never", -- Show reborrow hints
				},
				renderColons = true, -- Render colons in hints
				typeHints = {
					enable = true, -- Show type hints
					hideClosureInitialization = false, -- Hide type hints for closures
					hideNamedConstructor = false, -- Hide type hints for named constructors
				},
			},

			-- COMPLETION FEATURES --
			-- Controls code completion behavior
			completion = {
				autoimport = {
					enable = true, -- Auto-import completion items
				},
				autoself = {
					enable = true, -- Automatically add self:: in completions
				},
				callable = {
					snippets = "fill_arguments", -- "fill_arguments", "add_parentheses", "none"
				},
				postfix = {
					enable = true, -- Enable postfix completions (.if, .match, etc.)
				},
				privateEditable = {
					enable = false, -- Enable private item completions
				},
				snippets = {
					custom = {}, -- Custom completion snippets
				},
			},

			-- HOVER DOCUMENTATION --
			-- Controls hover popup behavior
			hover = {
				actions = {
					enable = true, -- Show actions in hover
					debug = {
						enable = true, -- Show debug action
					},
					gotoTypeDef = {
						enable = true, -- Show go to type definition action
					},
					implementations = {
						enable = true, -- Show implementations action
					},
					references = {
						enable = true, -- Show references action
					},
					run = {
						enable = true, -- Show run action
					},
				},
				documentation = {
					enable = true, -- Show documentation in hover
				},
				links = {
					enable = true, -- Enable clickable links in hover
				},
			},

			-- IMPORTS/LENS/ASSIST --
			-- Code lens shows inline actions like "Run test", "Debug"
			lens = {
				enable = true, -- Enable all lenses
				debug = {
					enable = true, -- Show debug lens
				},
				implementations = {
					enable = true, -- Show implementations lens
				},
				run = {
					enable = true, -- Show run lens
				},
				references = {
					adt = {
						enable = false, -- Show references for ADTs
					},
					enumVariant = {
						enable = false, -- Show references for enum variants
					},
					method = {
						enable = false, -- Show references for methods
					},
					trait = {
						enable = false, -- Show references for traits
					},
				},
			},

			-- ASSISTS (QUICK FIXES) --
			-- Code actions and quick fixes
			assist = {
				emitMustUse = false, -- Add #[must_use] in assists
				expressionFillDefault = "todo", -- "todo" or "default"
			},

			-- SEMANTIC HIGHLIGHTING --
			-- Better syntax highlighting based on semantic info
			semanticHighlighting = {
				strings = {
					enable = true, -- Enable semantic highlighting for strings
				},
			},

			-- WORKSPACE SYMBOL SEARCH --
			-- Controls symbol search behavior
			workspace = {
				symbol = {
					search = {
						kind = "all_symbols", -- "only_types" or "all_symbols"
						limit = 128, -- Max results
						scope = "workspace", -- "workspace" or "workspace_and_dependencies"
					},
				},
			},

			-- TYPING ASSISTS --
			-- Auto-formatting while typing
			typing = {
				autoClosingAngleBrackets = {
					enable = false, -- Auto-close angle brackets
				},
			},

			-- RUST-SPECIFIC CHECKS --
			-- Additional Rust-specific features
			rustfmt = {
				extraArgs = {}, -- Extra args for rustfmt
				overrideCommand = nil, -- Override rustfmt command
				rangeFormatting = {
					enable = false, -- Enable range formatting
				},
			},

			-- FILES/CACHING --
			files = {
				excludeDirs = {}, -- Directories to exclude
				watcher = "client", -- "client" or "server"
			},

			-- NOTIFICATIONS --
			-- Control which notifications to show
			notifications = {
				cargoTomlNotFound = true, -- Notify when Cargo.toml not found
			},

			-- PERFORMANCE --
			-- Performance-related settings
			cachePriming = {
				enable = true, -- Prime caches on startup
				numThreads = 0, -- 0 = auto
			},
		},
	},
}
