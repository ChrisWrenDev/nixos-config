return {
    -- Lsp notifications
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    -- LSP core
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            {
                "b0o/schemastore.nvim",
                lazy = true, -- only loaded when required
            },
            "saghen/blink.cmp",
            "RRethy/vim-illuminate",
        },
        config = function()
            require("chriswrendev.plugins.lsp.config")
            require("chriswrendev.plugins.lsp.handlers")
        end,
    },
    -- optional: keep none-ls only if you need it
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "nvimtools/none-ls-extras.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local nls = require("null-ls")
            local builtins = nls.builtins
            local diagnostics = builtins.diagnostics

            nls.setup({
                debug = false,
                sources = {
                    diagnostics.yamllint.with({
                        args = require("chriswrendev.plugins.lsp.lang.yamllint"),
                    }),
                    diagnostics.golangci_lint,
                    diagnostics.hadolint, -- dockerfile linting
                    diagnostics.terraform_validate, -- terraform linting
                    -- diagnostics.shellcheck, -- bash linting (archived)
                    diagnostics.checkmake,
                },
            })
        end,
    },
}
