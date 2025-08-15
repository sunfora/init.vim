require("mason").setup()
require("mason-lspconfig").setup()
require("lspconfig").tsserver.setup {}
require("lspconfig").html.setup {}
require("lspconfig").cssls.setup {}
require("lspconfig").clangd.setup {
  init_options = {
    -- fallbackFlags = {'--std=c++20'}
  },
  clang_user_options = ' -DCLANG_COMPLETE_ONLY',
}
require("lspconfig").hls.setup {}
require("lspconfig").phpactor.setup {}

require('lint').linters_by_ft = {
  haskell = {'hlint'},
}
require("lspconfig").java_language_server.setup {}
require("lspconfig").kotlin_language_server.setup {}

require("lspconfig").racket_langserver.setup{
  cmd = { "racket", "--lib", "racket-langserver" },
  filetypes = { "racket", "scheme" },
  offset_encoding = "utf-8",
  root_dir = function(fname)
    return vim.fn.getcwd()
  end,
  single_file_support = true,
}
