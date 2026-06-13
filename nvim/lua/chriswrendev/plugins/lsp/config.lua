local lang = require("chriswrendev.plugins.lsp.lang")
local opts = require("chriswrendev.plugins.lsp.opts")

-- Servers whose binaries are guaranteed by Nix
local servers = {
    dockerls = {},
    buf_ls = {},
    zls = {},
    pyright = lang.python,
    ruff = {},
    ts_ls = lang.ts,
    gopls = lang.go,
    lua_ls = lang.lua,
    yamlls = lang.yaml,
    terraformls = lang.terraform,
    helm_ls = { filetypes = { "helm" } },
    tailwindcss = { filetypes = { "typescriptreact", "javascriptreact", "css" } },
    eslint = {},
    bashls = {},
    sqlls = lang.sql,
    nixd = lang.nix,
    svelte = {},
    vue_ls = { filetypes = { "vue" } },
}

-- Servers that may not have a binary on PATH (checked at runtime)
local optional_servers = {
    prismals = { cmd = "prisma-language-server" },
    jsonls = { config = lang.json, cmd = "vscode-json-languageserver" },
    graphql = { config = { filetypes = { "graphql", "gql" } }, cmd = "graphql-lsp" },
    html = { cmd = "vscode-html-languageserver" },
    mojo = { cmd = "mojo" },
    solidity_ls_nomicfoundation = { config = { filetypes = { "solidity", "sol" } } },
}

for name, cfg in pairs(servers) do
    vim.lsp.config(
        name,
        vim.tbl_deep_extend("force", {
            on_attach = opts.on_attach,
            capabilities = opts.capabilities,
        }, cfg)
    )
    vim.lsp.enable(name)
end

for name, opt in pairs(optional_servers) do
    if opt.cmd and vim.fn.executable(opt.cmd) ~= 1 then
        goto continue
    end
    vim.lsp.config(
        name,
        vim.tbl_deep_extend("force", {
            on_attach = opts.on_attach,
            capabilities = opts.capabilities,
        }, opt.config or {})
    )
    vim.lsp.enable(name)
    ::continue::
end
