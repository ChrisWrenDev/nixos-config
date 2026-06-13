return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
        local conform = require("conform")

        conform.setup({
            -- Register custom Mojo formatter
            formatters = {
                mojo = {
                    command = "mojo",
                    args = { "format", "$FILENAME" },
                    stdin = false, -- mojo format operates on files, no stdin
                },
                gosimports = {
                    command = "gosimports",
                },
            },
            formatters_by_ft = {
                javascript = { "prettierd" },
                typescript = { "prettierd" },
                javascriptreact = { "prettierd" },
                typescriptreact = { "prettierd" },
                svelte = { "prettierd" },
                vue = { "prettierd" },
                css = { "prettierd" },
                html = { "prettierd" },
                json = { "prettierd" },
                yaml = { "prettierd" },
                markdown = { "prettierd" },
                graphql = { "prettierd" },
                solidity = { "prettierd" },

                lua = { "stylua" },
                terraform = { "terraform_fmt" },
                python = { "isort", "ruff_format" }, -- optionally: "black" (slower)
                mojo = { "mojo" },
                rust = { "rustfmt" },
                go = { "gosimports", "gofumpt" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                sql = { "sql_formatter" },
                nix = { "alejandra" },
                proto = { "buf" },
            },
            -- default options used by both manual format and format-on-save
            default_format_opts = {
                lsp_format = "fallback",
            },

            -- format on save
            format_on_save = {
                timeout_ms = 1000,
            },
        })
    end,
}
