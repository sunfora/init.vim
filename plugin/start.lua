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
  -- client.server_capabilities.semanticTokensProvider = nil
end

require("mason").setup()
require("mason-lspconfig").setup {
  on_attach = on_attach,
}
require("lspconfig").tsserver.setup {
  on_attach = on_attach,
}
require("lspconfig").html.setup {
  on_attach = on_attach,
}
require("lspconfig").cssls.setup {
  on_attach = on_attach,
}
require("lspconfig").jdtls.setup {
  on_attach = on_java_attach,
}
require("lspconfig").clangd.setup {
  init_options = {
    -- fallbackFlags = {'--std=c++20'}
  },
  clang_user_options = ' -DCLANG_COMPLETE_ONLY',
  on_attach = on_attach,
}
require("lspconfig").hls.setup {
  on_attach = on_attach,
}
require("lspconfig").phpactor.setup {
  on_attach = on_attach,
}

require('lint').linters_by_ft = {
  haskell = {'hlint'},
}
require("lspconfig").kotlin_language_server.setup {
  on_attach = on_attach,
}

require("lspconfig").racket_langserver.setup{
  cmd = { "racket", "--lib", "racket-langserver" },
  filetypes = { "racket", "scheme" },
  offset_encoding = "utf-8",
  root_dir = function(fname)
    return vim.fn.getcwd()
  end,
  single_file_support = true,
  on_attach = on_attach,
}

