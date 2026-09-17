local on_attach = function(_, bufnr)
  -- Replace standard behaviour (gd, K)
  vim.keymap.set('n',          'K',     vim.lsp.buf.hover,          { buffer = bufnr, desc = "LSP: Show hover documentation" })
  vim.keymap.set('n',          'gd',    vim.lsp.buf.definition,     { buffer = bufnr, desc = "LSP: Go to definition"         })

  -- New mappings introduced
  vim.keymap.set('n',          'gl',    vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP: Go to implementation"     })
  vim.keymap.set('n',          '<M-f>', vim.lsp.buf.references,     { buffer = bufnr, desc = "LSP: List references"          })
  vim.keymap.set('n',          '<M-r>', vim.lsp.buf.rename,         { buffer = bufnr, desc = "LSP: Rename symbol"            })
  vim.keymap.set({ 'n', 'v' }, '<M-c>', vim.lsp.buf.code_action,    { buffer = bufnr, desc = "LSP: Show code actions"        })
  vim.keymap.set('n',          '<M-d>', vim.diagnostic.open_float,  { buffer = bufnr, desc = "LSP: Show line diagnostics"    })
end

local on_java_attach = function(client, bufnr)
  on_attach(client, bufnr)
end

require("mason").setup()

require("splitasm").setup({
  compiler_cmd = nil,
  executable_path = nil,
  source_path_mappings = {},
  auto_sync = true,
  hide_address = false,
  source_row_colors = true,
  show_line_numbers = true,
  preferred_objdump = "gnu-objdump"
})

local function enable_lsp(server_name, opts)
  vim.lsp.config(server_name, opts or {})
  vim.lsp.enable(server_name)
end

enable_lsp("ts_ls",                  { on_attach = on_attach      }) 
enable_lsp("html",                   { on_attach = on_attach      })
enable_lsp("cssls",                  { on_attach = on_attach      })
enable_lsp("css_variables",          { on_attach = on_attach      })
enable_lsp("hls",                    { on_attach = on_attach      })
enable_lsp("phpactor",               { on_attach = on_attach      })
enable_lsp("kotlin_language_server", { on_attach = on_attach      })
enable_lsp("bashls",                 { on_attach = on_attach      })
enable_lsp("asm_lsp",                { on_attach = on_attach      })
enable_lsp("jdtls",                  { on_attach = on_java_attach })

enable_lsp("basedpyright", {
  cmd = { "basedpyright-langserver", "--stdio" },
  on_attach = on_attach,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticSeverityOverrides = {},
      },
    },
  },
})

enable_lsp("clangd", {
  cmd = {
    "clangd",
    "--query-driver=*",
    "--background-index",
  },
  on_attach = on_attach,
})

enable_lsp("racket_langserver", {
  cmd = { "racket", "--lib", "racket-langserver" },
  filetypes = { "racket", "scheme" },
  offset_encoding = "utf-8",
  root_dir = function(_)
    return vim.fn.getcwd()
  end,
  single_file_support = true,
  on_attach = on_attach,
})

enable_lsp("rust_analyzer", {
  on_attach = on_attach,
  cmd = { "rust-analyzer" },
})

enable_lsp("lua_ls", {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        disable = { "trailing-space" }, 
      },
    },
  },
})


vim.filetype.add({
  extension = {
    env = "sh",
  },
  filename = {
    [".env"] = "sh",
  },
})

-- Линтеры
require('lint').linters_by_ft = {
  haskell = {'hlint'},
}
