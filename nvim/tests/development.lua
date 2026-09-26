-- Run: nvim --headless -u NONE -i NONE -l tests/development.lua
local root = vim.fn.getcwd()
local data = vim.fn.stdpath("data")
for _, plugin in ipairs({ "lazy.nvim", "LazyVim", "conform.nvim", "nvim-lspconfig" }) do
	vim.opt.rtp:append(data .. "/lazy/" .. plugin)
end
vim.env.PATH = data .. "/mason/bin:" .. vim.env.PATH
LazyVim = require("lazyvim.util")
dofile(root .. "/.config/nvim/lua/config/options.lua")
local opts = { formatters_by_ft = {}, formatters = {}, default_format_opts = { timeout_ms = 3000 } }
for _, spec in ipairs(require("lazyvim.plugins.extras.formatting.prettier")) do
	if spec[1] == "stevearc/conform.nvim" then
		spec.opts(nil, opts)
	end
end
dofile(root .. "/.config/nvim/lua/plugins/conform.lua").opts(nil, opts)
local conform = require("conform")
conform.setup(opts)
local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp, "p")
local ok, err = pcall(function()
	for _, case in ipairs({
		{ name = "unconfigured", expected = nil },
		{ name = "prettier", files = { ".prettierrc" }, expected = "prettier" },
		{ name = "biome", files = { "biome.json" }, expected = "biome" },
		{ name = "both", files = { "biome.jsonc", ".prettierrc" }, expected = "biome" },
	}) do
		local dir = tmp .. "/" .. case.name
		vim.fn.mkdir(dir .. "/src", "p")
		for _, file in ipairs(case.files or {}) do
			vim.fn.writefile({ "{}" }, dir .. "/" .. file)
		end
		vim.cmd.enew()
		vim.api.nvim_buf_set_name(0, dir .. "/src/test.ts")
		vim.bo.filetype = "typescript"
		local formatters = conform.list_formatters_to_run(0)
		assert(#formatters == (case.expected and 1 or 0), case.name .. ": wrong formatter count")
		assert(not case.expected or formatters[1].name == case.expected, case.name .. ": wrong formatter")
	end
	vim.cmd.enew()
	vim.api.nvim_buf_set_name(0, tmp .. "/test.py")
	vim.bo.filetype = "python"
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "import os", "", "print( 1 )" })
	conform.format({ async = false, lsp_format = "never" }, function(format_err)
		assert(not format_err, format_err)
	end)
	assert(vim.deep_equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), { "import os", "", "print(1)" }))
	dofile(root .. "/.config/nvim/lua/config/autocmds.lua")
	vim.api.nvim_exec_autocmds("InsertLeave", { buffer = 0 })
	assert(not vim.uv.fs_stat(tmp .. "/test.py"), "InsertLeave must not save")
	vim.api.nvim_exec_autocmds("FocusLost", { buffer = 0 })
	assert(vim.fn.readfile(tmp .. "/test.py")[1] == "import os", "FocusLost must preserve imports")
	vim.api.nvim_buf_set_lines(0, 2, 3, false, { "print(2)" })
	vim.o.hidden = true
	vim.cmd.enew()
	assert(vim.fn.readfile(tmp .. "/test.py")[3] == "print(2)", "Switching buffers must save the old file")
	vim.lsp.config("biome", dofile(root .. "/.config/nvim/lua/plugins/lsp.lua")[1].opts.servers.biome)
	vim.lsp.enable("biome")
	vim.cmd.enew()
	vim.api.nvim_buf_set_name(0, tmp .. "/biome/src/diagnostics.js")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "const unused = 1;", "debugger;" })
	vim.bo.filetype = "javascript"
	assert(
		vim.wait(10000, function()
			return #vim.diagnostic.get(0) >= 2
		end, 50),
		"Biome LSP did not publish both diagnostics"
	)
	local found = {}
	for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
		if diagnostic.code == "lint/correctness/noUnusedVariables" then
			assert(diagnostic.lnum == 0 and diagnostic.severity == vim.diagnostic.severity.WARN)
			found.unused = true
		elseif diagnostic.code == "lint/suspicious/noDebugger" then
			assert(diagnostic.lnum == 1 and diagnostic.severity == vim.diagnostic.severity.ERROR)
			found.debugger = true
		end
	end
	assert(found.unused and found.debugger, "Biome diagnostic rules or locations are incorrect")
end)
vim.lsp.enable("biome", false)
for _, client in ipairs(vim.lsp.get_clients()) do
	client:stop(true)
end
vim.fn.delete(tmp, "rf")
assert(ok, err)
print("PASS: formatter selection, Python imports, autosave, and Biome LSP diagnostics")
