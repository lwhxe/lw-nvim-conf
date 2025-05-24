return {
	"dundalek/lazy-lsp.nvim",
	dependencies = {
		"mfussenegger/nvim-dap",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"neovim/nvim-lspconfig",
        "mfussenegger/nvim-dap-python", -- Python DAP
        "nvim-lua/plenary.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local cmp = require("cmp")
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local capabilities = require('blink.cmp').get_lsp_capabilities()

		local dap = require("dap")
		local ui = require("dapui")
		ui.setup()

		require("nvim-dap-virtual-text").setup {
			display_callback = function(variable)
				local name = string.lower(variable.name)
				local value = string.lower(variable.value)
				if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
					return "*****"
				end

				if #variable.value > 15 then
					return " " .. string.sub(variable.value, 1, 15) .. "... "
				end

				return " " .. variable.value
			end,
		}

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = "codelldb.cmd",
				args = {"--port", "${port}"},
			},
		}
		dap.configurations.zig = {
			{
                name = 'Launch',
                type = 'codelldb',
                request = 'launch',
                program = '${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}',
                stopOnEntry = false,
                args = {},
            },
        }

        -- Configure Python debugging
        dap.adapters.python = {
            type = 'executable';
            command = 'pythonw';
            args = { '-m', 'debugpy.adapter' };
        }

        dap.configurations.python = {
            {
                type = 'python';
                request = 'launch';
                name = 'Launch file';
                program = "${file}";  -- This will launch the current file
                pythonPath = function()
                    return 'pythonw'  -- Adjust this to your Python path
                end;
            },
        }

		dap.listeners.before.attach.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.launch.dapui_config = function ()
			ui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			ui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			ui.close()
		end


		-- DAP keymaps
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
		vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)

		vim.keymap.set("n", "<leader>?", function()
			require("dapui").eval(nil, {enter = true})
		end)

		vim.keymap.set("n", "<F1>", dap.continue)
		vim.keymap.set("n", "<F2>", dap.step_into)
		vim.keymap.set("n", "<F3>", dap.step_over)
		vim.keymap.set("n", "<F4>", dap.step_out)
		vim.keymap.set("n", "<F5>", dap.step_back)
		vim.keymap.set("n", "<leader>gg", dap.restart)

		-- Setup Mason
		mason.setup()

		-- Setup nvim-cmp
		cmp.setup({
			mapping = {
				['<tab>'] = cmp.mapping.confirm({ select = true }),
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
			},
			sources = {
				{ name = 'nvim_lsp' }, -- LSP completions
				{ name = 'buffer' },   -- Buffer completions
				{ name = 'path' },     -- Path completions
				{ name = 'vsnip' },    -- Snippet completions (if using vsnip)
			},
			formatting = {
				format = function(entry, vim_item)
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						buffer = "[Buffer]",
						path = "[Path]",
						vsnip = "[Snippet]",
					})[entry.source.name]
					return vim_item
				end,
			},
		})

        function clean_ensure()
            local ensure = {}
            local remain = { "html", "markdown_oxide", "cssls", "rust_analyzer", "lua_ls", "clangd" }

            if vim.fn.executable("zls") == 1 and vim.fn.executable("zig") == 1 then
                table.insert(ensure, "zls")
            end
            if vim.fn.executable("pythonw") == 1 and vim.fn.executable("python") == 1 then
                table.insert(ensure, "pylsp")
            end
            if vim.fn.executable("dotnet") == 1 then
                table.insert(ensure, "csharp_ls")
            end
            if vim.fn.executable("go") == 1 then
                table.insert(ensure, "gopls")
            end
            if vim.fn.executable("node") == 1 then
                table.insert(ensure, "ts_ls")
            end
            if vim.fn.executable("java") == 1 and vim.fn.executable("javac") == 1 then
                table.insert(ensure, "java_language_server")
            end
            if vim.fn.executable("php") == 1 then
                table.insert(ensure, "phpactor")
            end
            -- if vim.fn.executable("") == 1 then
            --     table.insert(ensure, "")
            -- end
            
            for _, part in ipairs(remain) do
                table.insert(ensure, part)
            end

            return ensure
        end

		-- Ensure the language servers are ensure_installed
        local ensure = clean_ensure()

		mason_lspconfig.setup {
			ensure_installed = ensure
		}

		-- Setup the language servers
		mason_lspconfig.setup_handlers = {
			function(server_name)
				local opts = {}
				if server_name == "pylsp" then
                    opts.cmd = {"pythonw"}
					opts.settings = {
						pylsp = {
							plugins = {
								pyflakes = { enabled = true },
								pylint = { enabled = true },
								autopep8 = { enabled = true },
								black = { enabled = true },
								yapf = { enabled = true },
								rope_autoimport = { enabled = true },
							}
						}
					}
				elseif server_name == "zls" then
					opts.root_dir = lspconfig.util.root_pattern(".zig")
                    opts.cmd = {"zls"}
                elseif server_name == "gopls" then
                    opts.root_dir = lspconfig.util.root_pattern(".go")
				elseif server_name == "ts_ls" then
					opts.root_dir = lspconfig.util.root_pattern(".js", ".ts")
				elseif server_name == "lua_ls" then
					opts.root_dir = lspconfig.util.root_pattern(".lua")
					lspconfig.lua_ls.setup { capabilities = capabilities }
				elseif server_name == "csharp_ls" then
					opts.root_dir = lspconfig.util.root_pattern(".cs")
					lspconfig.omnisharp.setup { capabilities = capabilities }
				elseif server_name == "html" or server_name == "cssls" then
					opts.root_dir = lspconfig.util.root_pattern(".html", ".css")
                elseif server_name == "java_language_server" then
                    opts.root_dir = lspconfig.util.root_pattern(".java")
				elseif server_name == "markdown_oxide" then
					opts.root_dir = lspconfig.util.root_pattern(".md")
                elseif server_name == "phpactor" then
                    opts.root_dir = lspconfig.util.root_pattern(".php")
                    lspconfig.phpactor.setup({
                        on_attach = function (client, bufnr)
                        end,
                        capabilities = capabilities
                    })
                elseif server_name == "clangd" then
                    opts.root_dir = lspconfig.util.root_pattern(".c", ".h", ".cpp", ".hpp")
                    lspconfig.codelldb.setup({
                        capabilities = capabilities
                    })
				end

				-- lspconfig[server_name].setup(vim.tbl_deep_extend("force", opts, {
				-- 	on_attach = function(client, bufnr)
				-- 		-- You can add custom key mappings here if needed
				-- 	end,
				-- }))
			end,
		}
	end,
}

