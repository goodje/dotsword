return {
	-- graphic font
	{ "nvim-tree/nvim-web-devicons" },
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		opts = {
			-- A list of parser names, or "all" (the listed parsers MUST always be installed)
			ensure_installed = {
				"c",
				"go",
				"gomod",
				"gosum",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"gitignore",
				"json",
				"yaml",
				"toml",
				"html",
				"css",
				"javascript",
				"typescript",
				"vue",
				"python",
				"rust",
				"java",
				"php",
				"cpp",
				"cmake",
				"lua",
				"nginx",
				"dockerfile",
				"bash",
				"sql",
			},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			-- List of parsers to ignore installing (or "all")
			-- ignore_install = { "javascript" },

			---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
			-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

			highlight = {
				enable = true,

				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- list of language that will be disabled
				-- disable = { "c", "rust" },
				-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },

	-- theme, inspired by gruvbox
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.gruvbox_material_enable_italic = true

			-- Theme: Gruvbox Material
			vim.opt.background = "dark" -- Set background to dark

			-- Gruvbox Material options
			vim.g.gruvbox_material_background = "hard" -- Background option: 'hard', 'medium', 'soft'
			vim.g.gruvbox_material_foreground = "material" -- Foreground option: 'material', 'mix', 'original'
			vim.g.gruvbox_material_better_performance = 1 -- Enable better performance
			vim.g.gruvbox_material_enable_italic = 1 -- Enable italics
			vim.g.gruvbox_material_disable_italic_comment = 0 -- Enable italics in comments
			vim.g.gruvbox_material_enable_bold = 0 -- Disable bold text
			vim.g.gruvbox_material_dim_inactive_windows = 1 -- Dim inactive windows (only works in Neovim)
			vim.g.gruvbox_material_colors_override = { -- Override specific colors
				bg_dim = { "#1f2223", "236" },
			}

			-- Use system background by setting `Normal` highlight group with no background color
			vim.api.nvim_set_hl(0, "Normal", { ctermbg = "NONE" })

			vim.cmd.colorscheme("gruvbox-material")
		end,
	},

	-- status bar
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				-- make sure theme gruvbox-material is installed
				theme = "gruvbox-material",
			},
			--   on_attach = function(bufnr)
			-- 	local api = require "lualine.api"
			--
			-- 	local function opts(desc)
			--       local trouble = require("trouble")
			--       local symbols = trouble.statusline({
			--         mode = "lsp_document_symbols",
			--         groups = {},
			--         title = false,
			--         filter = { range = true },
			--         format = "{kind_icon}{symbol.name:Normal}",
			--         -- The following line is needed to fix the background color
			--         -- Set it to the lualine section you want to use
			--         hl_group = "lualine_c_normal",
			--       })
			--       lualine.table.insert(opts.sections.lualine_c, {
			--         symbols.get,
			--         cond = symbols.has,
			--       })
			-- 	  end
			--   end
		},
	},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 30,
			},
			renderer = {
				-- show as one folder when middle folders are empty
				group_empty = true,
			},
			filters = {
				dotfiles = false, -- show dotfiles
			},
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					}
				end

				-- default mappings
				api.config.mappings.default_on_attach(bufnr)

				-- the cursorline is not obvious using theme gruvbox-material with "hard"
				-- so we change the color
				vim.api.nvim_command("hi NvimTreeCursorLine ctermbg=235 guibg=#282828")

				-- custom mappings
				vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
				vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
			end,
		},
		config = function(_, opts)
			require("nvim-tree").setup(opts)
			-- Make the NvimTree cursor line more visible with the "hard" style of gruvbox-material

			-- vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { ctermbg = 235, guibg = "#282828" })
			-- the line above doesn't work, so we use the following line
			vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { ctermbg = 235, bg = "#282828" })

			vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
			-- locate the buffer in the tree
			vim.keymap.set("n", "<leader>l", ":NvimTreeFindFile<CR>")
		end,
	},

	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})

			vim.keymap.set("n", "<leader>f", require("fzf-lua").files, { desc = "Fzf Files" })
			vim.keymap.set("n", "<C-f>", require("fzf-lua").live_grep, { desc = "Fzf Search" })
			vim.keymap.set("n", "<leader>t", require("fzf-lua").tags, { desc = "Fzf Tags" })
			-- require("trouble").setup{}
			-- local config = require("fzf-lua.config")
			-- local actions = require("trouble.sources.fzf").actions
			-- config.defaults.actions.files["ctrl-t"] = actions.open
			-- vim.keymap.set("n", "<leader>d", require('trouble.sources.fzf').open, { desc = "Fzf Trouble" })
		end,
	},

	-- LSP
	-- Manage LSP servers, DAP servers, linters and formatters
	-- The order of setup matters 1. mason, 2. mason-lspconfig, 3. language servers via lspconfig
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},

		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"pyright",
					"gopls",
					"vuels",
					"yamlls",
					"sqlls",
					"html",
					"dockerls",
					"docker_compose_language_service",
					"lua_ls",
				},
			})
			-- mason-lspconfig doesn't support ccls yet

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Tell the server the capability of foldingRange,
			-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			local lspconfig = require("lspconfig")
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
			})
			lspconfig.postgres_lsp.setup({
				capabilities = capabilities,
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})
			-- lspconfig.gradle_ls.setup{
			--   capabilities = capabilities
			-- }
			lspconfig.vuels.setup({
				capabilities = capabilities,
			})

			lspconfig.ccls.setup({
				capabilities = capabilities,
				init_options = {
					compilationDatabaseDirectory = "build",
					index = {
						threads = 0,
					},
					clang = {
						excludeArgs = { "-frounding-math" },
					},
					cache = {
						directory = ".ccls-cache",
					},
				},
			})

			lspconfig.yamlls.setup({
				capabilities = capabilities,
				settings = {
					yaml = {
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
							["https://run.googleapis.com/$discovery/rest?version=v1"] = "/.gcr/*-service.yml",
							["https://json.schemastore.org/prettierrc"] = { "/.prettierrc", "/function/.prettierrc" },
						},
					},
				},
			})

			-- don't get confused with sqls(https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sqlls)
			-- refer to https://github.com/joe-re/sql-language-server
			lspconfig.sqlls.setup({
				capabilities = capabilities,
			})

			lspconfig.dockerls.setup({
				capabilities = capabilities,
				settings = {
					docker = {
						languageserver = {
							formatter = {
								ignoreMultilineInstructions = false,
							},
						},
					},
				},
			})

			lspconfig.docker_compose_language_service.setup({})

			--Enable (broadcasting) snippet capability for completion
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			lspconfig.html.setup({
				capabilities = capabilities,
			})

			-- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
			-- for _, ls in ipairs(language_servers) do
			--     require('lspconfig')[ls].setup({
			--         capabilities = capabilities
			--     })
			-- end

			-- nvim-lspconfig
			vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
			vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
			vim.keymap.set("n", "gc", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>")
			vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
			vim.keymap.set("n", ",r", "<cmd>lua vim.lsp.buf.rename()<CR>")
			vim.keymap.set("n", ",a", "<cmd>lua vim.lsp.buf.code_action()<CR>")
		end,
	},

	-- Snippet Engine for Neovim written in Lua
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},

	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
						-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					-- { name = 'vsnip' }, -- For vsnip users.
					{ name = "luasnip" }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
				}, {
					{ name = "buffer" },
				}),
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},

	{ "saadparwaiz1/cmp_luasnip" },

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},

	{
		"kevinhwang91/promise-async",
	},

	-- fold and unfold
	{
		"kevinhwang91/nvim-ufo",
		-- optional for icon support
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

			-- Option 2: nvim lsp as LSP client
			-- Tell the server the capability of foldingRange,
			-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
			for _, ls in ipairs(language_servers) do
				require("lspconfig")[ls].setup({
					capabilities = capabilities,
					-- you can add other fields for setting up lsp server in this table
				})
			end
			require("ufo").setup()
		end,
	},

	-- Golang
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },

		-- if you need to install/update all binaries
		build = ':lua require("go.install").update_all_sync()',
	},

	-- Debug Adapter Protocol client implementation
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			-- Set keymaps to control the debugger
			vim.keymap.set("n", "<F5>", require("dap").continue)
			vim.keymap.set("n", "<F10>", require("dap").step_over)
			vim.keymap.set("n", "<F11>", require("dap").step_into)
			vim.keymap.set("n", "<F12>", require("dap").step_out)
			vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint)
			vim.keymap.set("n", "<leader>B", function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end)
		end,
	},

	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = { "mfussenegger/nvim-dap" },
		build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
		opts = {
			-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
			debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
			-- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
			adapters = {
				"chrome",
				"pwa-node",
				"pwa-chrome",
				"pwa-msedge",
				"node-terminal",
				"pwa-extensionHost",
				"node",
				"chrome",
			}, -- which adapters to register in nvim-dap
			-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
			-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
			-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
		},
		config = function(_, opts)
			-- Adapter for DAP and clients
			require("dap-vscode-js").setup(opts)

			-- TS/JS adapter
			local js_based_languages = { "typescript", "javascript", "typescriptreact" }
			for _, language in ipairs(js_based_languages) do
				require("dap").configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-chrome",
						request = "launch",
						name = 'Start Chrome with "localhost"',
						url = "http://localhost:3000",
						webRoot = "${workspaceFolder}",
						userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
					},
				}
			end
		end,
	},

	-- DAP UI
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("dapui").setup()

			local dap, dapui = require("dap"), require("dapui")

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			vim.keymap.set("n", "<leader>ui", require("dapui").toggle)
		end,
	},

	-- Git signs similar to but more powerful than vim-fugitive
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- Actions
				map("n", "<leader>hs", gitsigns.stage_hunk)
				map("n", "<leader>hr", gitsigns.reset_hunk)
				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
				map("n", "<leader>hS", gitsigns.stage_buffer)
				map("n", "<leader>hu", gitsigns.undo_stage_hunk)
				map("n", "<leader>hR", gitsigns.reset_buffer)
				map("n", "<leader>hp", gitsigns.preview_hunk)
				map("n", "<leader>hb", function()
					gitsigns.blame_line({ full = true })
				end)
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
				map("n", "<leader>hd", gitsigns.diffthis)
				map("n", "<leader>hD", function()
					gitsigns.diffthis("~")
				end)
				map("n", "<leader>td", gitsigns.toggle_deleted)

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		},
	},

	-- Formatter
	-- formatter conform.nvim
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "black" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				-- rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettier", "prettierd", stop_after_first = true },
				typescript = { "prettier", "prettierd", stop_after_first = true },
				go = { "gofumports" },
			},
			-- format_on_save = {
			--   -- These options will be passed to conform.format()
			--   timeout_ms = 500,
			--   lsp_format = "fallback",
			-- },
		},
		config = function(_, opts)
			require("conform").setup(opts)
			-- Alternatively, run the formatter before saving the buffer
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
			-- TODO Read .prettierrc in root folder and root/functions/
			-- require("conform.formatters.prettier").args = function(ctx)
			-- local default_args = prettier.args
			-- end
		end,
	},

	-- use mason to install formatters used in conform
	-- there are some restrictions, refer to
	-- https://github.com/zapling/mason-conform.nvim
	-- {
	-- 	"zapling/mason-conform.nvim",
	-- 	dependencies = {
	-- 		"williamboman/mason.nvim",
	-- 		"stevearc/conform.nvim",
	-- 	},
	-- 	opts = {},
	-- },

	-- highlight and remove trailing whitespace
	{
		"johnfrankmorgan/whitespace.nvim",
		config = function()
			require("whitespace-nvim").setup({
				-- configuration options and their defaults

				-- `highlight` configures which highlight is used to display
				-- trailing whitespace
				highlight = "DiffDelete",

				-- `ignored_filetypes` configures which filetypes to ignore when
				-- displaying trailing whitespace
				ignored_filetypes = { "TelescopePrompt", "Trouble", "help", "dashboard" },

				-- `ignore_terminal` configures whether to ignore terminal buffers
				ignore_terminal = true,

				-- `return_cursor` configures if cursor should return to previous
				-- position after trimming whitespace
				return_cursor = true,
			})

			-- remove trailing whitespace with a keybinding
			vim.keymap.set("n", "<Leader>t", require("whitespace-nvim").trim)
		end,
	},

	{ "github/copilot.vim" },

	-- open the link of current line on github,Bitbucket,
	-- self-deployed GitHub, Googlesource, GitLab, and SourceHut
	{ "ruanyl/vim-gh-line" },

	{ "tyru/open-browser.vim" },

	-- for Python, static syntax and style checker
	{ "nvie/vim-flake8" },
}
