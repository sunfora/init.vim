require("mason").setup()
require("mason-lspconfig").setup()
require("lspconfig").tsserver.setup {}
require("lspconfig").html.setup {}
require("lspconfig").cssls.setup {}
require("lspconfig").clangd.setup {}
