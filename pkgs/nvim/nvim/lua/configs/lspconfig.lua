-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

-- EXAMPLE
-- local servers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
-- for _, lsp in ipairs(servers) do
--  lspconfig[lsp].setup {
--    on_attach = nvlsp.on_attach,
--    on_init = nvlsp.on_init,
--    capabilities = nvlsp.capabilities,
--  }
-- end

lspconfig["lua_lsp"].setup {
on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = {"lua_language_server"},
  fileTypes = {"lua"},
  root_dir = util.root_pattern("lua/", ".git"),
}

lspconfig["rust_analyzer"].setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = {"rust_analyzer"},
  fileTypes = {"rust"},
  root_dir = util.root_pattern("Cargo.toml"),
  settings = {
    ["rust_analyzer"] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
}

lspconfig["gopls"].setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = {"gopls"},
  fileTypes = {"go", "gomod", "gowork", "gotmpl"},
  root_dir = util.root_pattern("go.work","go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      }
    }
  },
}

lspconfig["zls"].setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = {"zls"},
  filetypes = { 'zig', 'zir' },
  root_dir = util.root_pattern('zls.json', 'build.zig', '.git'),
}

lspconfig["ts_ls"].setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
   cmd = { 'typescript-language-server', '--stdio' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    root_dir = util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git'),
}
