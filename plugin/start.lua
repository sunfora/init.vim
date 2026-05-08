local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Navigation & Information
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Show hover documentation" })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: Go to definition" })
  vim.keymap.set('n', 'gl', vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP: Go to implementation" })
  vim.keymap.set('n', '<M-f>', vim.lsp.buf.references, { buffer = bufnr, desc = "LSP: List references" })

  -- Refactoring & Actions
  vim.keymap.set('n', '<M-r>', vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: Rename symbol" })
  vim.keymap.set({ 'n', 'v' }, '<M-c>', vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: Show code actions" })

  -- Diagnostics (Errors, Warnings, etc.)
  vim.keymap.set('n', '<M-d>', vim.diagnostic.open_float, { buffer = bufnr, desc = "LSP: Show line diagnostics" })
end

local on_java_attach = function(client, bufnr)
  on_attach(client, bufnr)
end

require("mason").setup()

require("mason-lspconfig").setup {
  on_attach = on_attach,
}

local function enable_lsp(server_name, opts)
  vim.lsp.config(server_name, opts or {})
  vim.lsp.enable(server_name)
end

-- Настройка всех серверов
enable_lsp("ts_ls", { on_attach = on_attach }) 
enable_lsp("html", { on_attach = on_attach })


enable_lsp("cssls", {
  on_attach = on_attach,
})
enable_lsp("css_variables", {
  on_attach = on_attach,
})

enable_lsp("jdtls", { on_attach = on_java_attach })

enable_lsp("basedpyright", {
  on_attach = on_attach,
  settings = {
    basedpyright = {
      analysis = {
        diagnosticSeverityOverrides = {
          reportExplicitAny = "none",
          reportUnknownVariableType = "none",
          reportUnknownArgumentType = "none",
          reportAny = "none",
        },
      },
    },
  },
})

enable_lsp("clangd", {
  init_options = {
    fallbackFlags = { '-Wall', '-Wextra' } 
  },
  clang_user_options = ' -DCLANG_COMPLETE_ONLY',
  on_attach = on_attach,
})

enable_lsp("hls", { on_attach = on_attach })
enable_lsp("phpactor", { on_attach = on_attach })
enable_lsp("kotlin_language_server", { on_attach = on_attach })

enable_lsp("racket_langserver", {
  cmd = { "racket", "--lib", "racket-langserver" },
  filetypes = { "racket", "scheme" },
  offset_encoding = "utf-8",
  root_dir = function(fname)
    return vim.fn.getcwd()
  end,
  single_file_support = true,
  on_attach = on_attach,
})

enable_lsp("rust_analyzer", {
  cmd = { "rust-analyzer" },
})

-- Линтеры
require('lint').linters_by_ft = {
  haskell = {'hlint'},
}
