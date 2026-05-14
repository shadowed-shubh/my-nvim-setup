# Neovim Keybinds

Leader: `<Space>`  
Local leader: `\`

## Core LSP

Source: `lua/config/lsp.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to declaration |
| `<leader>lf` | Normal | LSP format buffer |

### LSP Key Explanations

| Key | When to use it |
| --- | --- |
| `gd` | Jump to where the symbol under cursor is defined. This is the main code navigation key. |
| `gD` | Jump to declaration. Most useful in C/C++ or languages with separate declarations/interfaces. |
| `K` | Show docs, type info, or signature details for the symbol under cursor. |
| `grn` | Rename the symbol under cursor across the project. |
| `gra` | Show code actions, such as quick fixes, organize imports, refactors, or apply suggestions. |
| `grr` | List references/usages of the symbol under cursor. |
| `gri` | Jump to implementation, useful for interfaces, traits, abstract classes, and protocol methods. |
| `grt` | Jump to the type definition of the symbol under cursor. |
| `gO` | Show symbols in the current document, such as functions, classes, headings, or methods. |
| `grx` | Run a code lens action when the server provides one. Common in Rust, Go, Java, and tests. |
| `<leader>lf` | Format the current buffer directly through LSP. |
| `<leader>f` | Format through Conform. Prefer this for normal formatting because it can use dedicated tools like `stylua`, `black`, and `prettier`. |
| `<C-s>` | In insert mode, show function argument/signature help. |
| `CTRL-]` | Tag-style jump using LSP. Similar to `gd`, but works through Neovim's tagfunc path. |
| `gq` | Format text using LSP formatexpr where supported. |
| `gx` | Open a link under cursor. Some LSPs provide document links, so this can open docs or URLs from code. |

Most-used set: `gd`, `K`, `grn`, `gra`, `grr`, and `<leader>f`.

## Adding More LSPs

This setup uses native Neovim LSP activation:

- Mason installs language servers.
- Neovim enables LSP configs with `vim.lsp.enable()`.

To add another language server:

1. Add the server to Mason in `lua/plugins/mason.lua`.

```lua
ensure_installed = {
	"lua_ls",
	"rust_analyzer",
	"svelte",
	"ts_ls",
}
```

2. Enable the config in `lua/config/lsp.lua`.

```lua
vim.lsp.enable({
	"lua_ls",
	"pyright",
	"rust_analyzer",
	"svelte",
	"ts_ls",
})
```

3. Optionally add server-specific settings before `vim.lsp.enable()`.

```lua
vim.lsp.config("ts_ls", {
	settings = {
		typescript = {},
		javascript = {},
	},
})
```

Useful commands:

| Command | Purpose |
| --- | --- |
| `:Mason` | Install/check LSP servers and tools. |
| `:checkhealth vim.lsp` | Check enabled configs and attached clients. |
| `:lsp enable <name>` | Enable an LSP config interactively. |
| `:lsp disable <name>` | Disable an LSP config interactively. |
| `:lsp restart` | Restart LSP clients attached to the current buffer. |
| `:lua =vim.lsp.get_configs({ enabled = true })` | Inspect enabled native LSP configs. |

Common LSP config names:

| Language/Area | LSP config name |
| --- | --- |
| Lua | `lua_ls` |
| Python | `pyright` |
| Rust | `rust_analyzer` |
| Svelte | `svelte` |
| TypeScript/JavaScript | `ts_ls` |
| HTML | `html` |
| CSS | `cssls` |
| JSON | `jsonls` |
| YAML | `yamlls` |
| Bash | `bashls` |
| C/C++ | `clangd` |
| Go | `gopls` |
| Docker | `dockerls` |

## Neovim Built-In LSP Defaults

These come from Neovim itself when LSP is active.

| Key | Mode | Action |
| --- | --- | --- |
| `gra` | Normal, Visual | Code action |
| `gri` | Normal | Go to implementation |
| `grn` | Normal | Rename symbol |
| `grr` | Normal | References |
| `grt` | Normal | Type definition |
| `grx` | Normal | Run code lens |
| `gO` | Normal | Document symbols |
| `K` | Normal | Hover documentation |
| `<C-s>` | Insert | Signature help |
| `CTRL-]` | Normal | LSP tag jump |
| `gq` | Normal, Visual | LSP formatexpr formatting where supported |
| `gx` | Normal | Open LSP document link when supported |

## Formatting And Completion

Source: `lua/plugins/complition.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>f` | Normal, Visual | Format buffer/selection with Conform |
| `<C-Space>` | Insert | Open completion menu |
| `<CR>` | Insert | Confirm selected completion item |
| `<Tab>` | Insert, Select | Next completion item or expand/jump snippet |
| `<S-Tab>` | Insert, Select | Previous completion item or jump snippet backward |

## Telescope

Source: `lua/plugins/telescope.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ff` | Normal | Find files |
| `<leader>fc` | Normal | Find Neovim config files |
| `<leader>fg` | Normal | Live grep |
| `<leader>fb` | Normal | Buffers |
| `<leader>fh` | Normal | Help tags |

## Noice

Source: `lua/plugins/noice.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>n` | Normal | Message/notification history |
| `<leader>un` | Normal | Dismiss visible notifications/messages |

## Snacks

Source: `lua/plugins/snacks.lua`

Snacks picker, explorer, zen, gitbrowse, lazygit, and terminal mappings were removed.

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>.` | Normal | Toggle persistent scratch buffer |
| `<leader>bd` | Normal | Delete buffer |
| `<leader>cR` | Normal | Rename current file |
| `]]` | Normal, Terminal | Next reference |
| `[[` | Normal, Terminal | Previous reference |

### Snacks Toggles

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>us` | Normal | Toggle spelling |
| `<leader>uw` | Normal | Toggle wrap |
| `<leader>uL` | Normal | Toggle relative number |
| `<leader>ud` | Normal | Toggle diagnostics |
| `<leader>ul` | Normal | Toggle line number |
| `<leader>uc` | Normal | Toggle conceal level |
| `<leader>uT` | Normal | Toggle Treesitter |
| `<leader>ub` | Normal | Toggle dark/light background |
| `<leader>uh` | Normal | Toggle inlay hints |
| `<leader>ug` | Normal | Toggle indent guides |
| `<leader>uD` | Normal | Toggle dim |

## Floaterm

Source: `lua/plugins/floatterm.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `<C-l>` | Normal | Open/toggle Floaterm in current file directory |
| `<C-l>` | Terminal | Hide Floaterm |
| `<Esc>` | Terminal | Leave terminal mode |

## Flash

Source: `lua/plugins/flash.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `zk` | Normal, Visual, Operator | Flash jump |
| `Zk` | Normal, Visual, Operator | Flash Treesitter jump |
| `r` | Operator | Remote Flash |
| `R` | Operator, Visual | Treesitter search |
| `<C-s>` | Command | Toggle Flash search |

## Notebook Navigator

Source: `lua/plugins/nb.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `]h` | Normal | Move to next/down notebook cell |
| `[h` | Normal | Move to previous/up notebook cell |
| `<leader>X` | Normal | Run current cell |
| `<leader>x` | Normal | Run current cell and move |

## Yazi

Source: `lua/plugins/yazi.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>Y` | Normal | Open Yazi at current file |
| `<leader>cw` | Normal | Open Yazi in Neovim cwd |
| `<C-Up>` | Normal | Resume/toggle last Yazi session |

## Theme Picker

Source: `lua/plugins/colorpick.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ut` | Normal | Pick theme with Themery |

## Which-Key

Source: `lua/plugins/whichkey.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>?` | Normal | Show buffer-local keymaps |

## Markdown

Source: `lua/plugins/markdown.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `<C-Enter>` | Markdown | Follow link |

## Fabric AI

Source: `lua/plugins/fabric.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>fa` | Visual | Run Fabric on selection |
| `<leader>fu` | Normal | Fabric URL command |

## Mini Surround

Source: `lua/plugins/surround.lua`

| Key | Mode | Action |
| --- | --- | --- |
| `sa` | Normal, Visual | Add surrounding |
| `sd` | Normal | Delete surrounding |
| `sf` | Normal | Find surrounding to the right |
| `sF` | Normal | Find surrounding to the left |
| `sh` | Normal | Highlight surrounding |
| `sr` | Normal | Replace surrounding |
| `sn` | Normal | Update number of lines used for surround search |

## Alpha Dashboard

Source: `lua/plugins/alpha.lua`

These apply on the startup dashboard.

| Key | Action |
| --- | --- |
| `b` | Browse files with Yazi |
| `f` | Find file with Telescope |
| `r` | Recent files with Telescope |
| `q` | Quit |

## Hardtime

Source: `lua/plugins/hardtime.lua`

Hardtime discourages repeated inefficient movement keys. This config explicitly allows arrow keys, but Hardtime may still restrict its default movement keys such as `h`, `j`, `k`, and `l` depending on plugin defaults.

## Cleanup Summary

Removed Snacks overlap:

| Area | Replacement |
| --- | --- |
| Snacks picker keymaps | Telescope |
| Snacks notifications/history | Noice |
| Snacks terminal | Floaterm |
| Snacks explorer | Yazi |
| Snacks zen/gitbrowse/lazygit | Removed until needed |

Scratch buffer note: `<leader>.` opens a persistent scratch file for quick notes or temporary code. It auto-saves under Neovim's data directory, so it is more useful than an unnamed temporary buffer.
