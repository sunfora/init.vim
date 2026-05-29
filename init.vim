" Welcome to my NeoVim config.
" Sometimes things here are a little messy.
" 
" Index: (#top)
"   1. (#plugin_i)
"   2. (#tree_sitter_i)
"   3. (#color_schemes_i)
"   4. (#settings_i)
"   5. (#sniff_i)
"   6. (#text_object_i)
"   7. (#lsp_i)
"   8. (#build_i)
"   9. (#unsorted_i)
"
"
" -----------------------------------------------------------------------------
"  Plugin (#plugin_i)
" -----------------------------------------------------------------------------
"  Index: (#plugin)
"

call plug#begin()

" Updated theme
Plug 'vim-airline/vim-airline'

" Better work with buffers
Plug 'ctrlpvim/ctrlp.vim'

" Add visibility to marks
Plug 'kshenoy/vim-signature'

" Add editable registers
Plug 'm6z/VimRegDeluxe'

" Add telescopre
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Add lf integration
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'

" Try number two
" https://www.youtube.com/watch?v=3a1PCir_aHs
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-lint'

" Better file search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Add some tree sitter experience
Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'main' }
Plug 'shushtain/incselect.nvim'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Install themes
Plug 'dohsimpson/vim-macroeditor'
Plug 'morhetz/gruvbox'
Plug 'iibe/gruvbox-high-contrast'
Plug 'Abstract-IDE/Abstract-cs'
Plug 'NLKNguyen/papercolor-theme'
Plug 'reobin/olive-crt.nvim'

call plug#end()

" Here ends the plugin section.
" Get to the top: (#plugin)

" -----------------------------------------------------------------------------
"  Tree-Sitter (#tree_sitter_i)
" -----------------------------------------------------------------------------
"  Index: (#tree_sitter)
"

"
" NOTE(ivan): register guix installed tree-sitter languages
"
lua<<EOF
  local guix_dir = vim.fn.expand("~/.guix-profile/lib/tree-sitter/")
  if vim.fn.isdirectory(guix_dir) == 1 then
    for file in vim.fs.dir(guix_dir) do
      local lang = file:match("^libtree%-sitter%-(.+)%.so$")
      if lang then
        vim.treesitter.language.add(lang, { path = guix_dir .. file })
      end
    end
  end
EOF
"
" NOTE(ivan): tell neovim to run tree-sitter in all languages supported
"
lua << EOF
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
        if lang then
            pcall(vim.treesitter.start)
        end
    end,
})
EOF

" Here ends the tree sitter section.
" Get to the top (#tree_sitter)

" -----------------------------------------------------------------------------
"  Color Schemes (#color_schemes_i)
" -----------------------------------------------------------------------------
"  Index: (#color_schemes)

"
" NOTE(ivan): use olive-crt theme
"
autocmd vimenter * ++nested colorscheme olive-crt

augroup CustomTodoHighlights
  autocmd!
  " After colorscheme and plugins load, apply these highlights
  autocmd ColorScheme * call s:SetupTodoHighlights()
  autocmd VimEnter * call s:SetupTodoHighlights()

  function! s:SetupTodoHighlights() abort

    " Define keywords inside comments or anywhere
    syntax keyword Todo      TODO         contained
    syntax keyword Done      DONE         contained
    syntax keyword Note      NOTE         contained
    syntax keyword Usage     USAGE        contained
    syntax keyword Research  RESEARCH     contained
    syntax keyword Canceled  CANCELED     contained
    syntax keyword AiGen     AI_GENERATED contained
    syntax keyword CopyPaste COPYPASTE    contained

    syntax match Author "(\zs[^()]*\ze):" contained

    syntax cluster customkwords contains=Todo,Done,Note
    syntax cluster customkwords add=Usage
    syntax cluster customkwords add=Research
    syntax cluster customkwords add=Canceled
    syntax cluster customkwords add=AiGen
    syntax cluster customkwords add=CopyPaste
    syntax cluster customkwords add=Author

    syntax match LineWithAuthor "\(CANCELED\|NOTE\|TODO\|DONE\|USAGE\|RESEARCH\|AI_GENERATED\|COPYPASTE\)\(([^()]\{-}):\)\?" containedin=ALL contains=@customkwords
  endfunction                                                             
augroup END

lua << EOF
local function apply_custom_todo_colors()
  vim.api.nvim_set_hl(0, "@Todo",      { fg = "#FF8700", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "@Canceled",  { fg = "#FA0626", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "@AiGen",     { fg = "#BAF6B6", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "@CopyPaste", { fg = "#00CED1", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "@Done",      { fg = "#9ACD32", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "@Note",      { fg = "#C8A2C8", italic = true, force = true })
  vim.api.nvim_set_hl(0, "@Usage",     { fg = "#C8A2C8", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "@Research",  { fg = "#9ACD32", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "@Author",    { fg = "#FFD700", italic = true, force = true })

  vim.api.nvim_set_hl(0, "Todo",      { fg = "#FF8700", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "Canceled",  { fg = "#FA0626", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "AiGen",     { fg = "#BAF6B6", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "CopyPaste", { fg = "#00CED1", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "Done",      { fg = "#9ACD32", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "Note",      { fg = "#C8A2C8", italic = true, force = true })
  vim.api.nvim_set_hl(0, "Usage",     { fg = "#C8A2C8", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "Research",  { fg = "#9ACD32", bold   = true, force = true })
  vim.api.nvim_set_hl(0, "Author",    { fg = "#FFD700", italic = true, force = true })
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "BufWinEnter" }, {
  callback = function()
    apply_custom_todo_colors()
  end,
})
EOF

" Here ends the tree sitter section.
" Get to the top (#color_schemes)


" -----------------------------------------------------------------------------
"  General Settings (#settings_i)
" -----------------------------------------------------------------------------
"  Index: (#settings)
"

set mouse=a
set nohlsearch

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
retab

" Disable smart asses who override my config
autocmd FileType * setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

set number
autocmd TermOpen * setlocal nonumber norelativenumber

au BufWritePost * lua require('lint').try_lint()

" Here ends the tree sitter section.
" Get to the top (#settings)

" -----------------------------------------------------------------------------
"  Sniff plugin (#sniff_i)
" -----------------------------------------------------------------------------
"  Index: (#sniff)
"

" move between terminal and window 
" via \[ and \]
map  <silent><C-\><C-]> <C-w>li
tmap <silent><C-\><C-[> <C-\><C-n><C-w>h

" bind terminal
nmap <silent>\. :lua sniff:terminal()<CR>

" send yanked text
nmap <silent>\p :lua sniff:send(vim.fn.getreg('"'))<CR>

" send newline
nmap <silent>\<CR> :lua sniff:sendln("")<CR>

" send yanked text and newline
nmap <silent>\; \p\<CR>

" send quote 
nmap <silent>\' :lua sniff:send("'")<CR>

" send opening bracket 
nmap <silent>\9 :lua sniff:send("(")<CR>
" send closing bracket 
nmap <silent>\0 :lua sniff:send(")")<CR>

" yank current list and send it
nmap <silent>\( ya(\;
" yank current { ... } and send it
nmap <silent>\{ ya{\;
nmap <silent>\[ ya[\;

" enter file
nmap <silent>\> :lua sniff:sendln(',enter (file "'..string.gsub(vim.fn.expand("%"), [[\]], [[\\]])..'")')<CR><CR>

" go upper
nmap <silent>\< :lua sniff:sendln(",top")<CR>

" Here ends the sniff plugin section.
" Get to the top (#sniff)

" -----------------------------------------------------------------------------
"  Text-objects operations (#text_object_i)
" -----------------------------------------------------------------------------
" Index: (#text_object):
"    1. (#text_object_walk)
"    2. (#text_object_tree_sitter_swap)
"    3. (#text_object_tree_sitter_walk)
"    4. (#text_object_tree_sitter_select)
"
" NOTE(ivan): you can 
"   1. walk all types of pairs with regexes and tree-sitter 
"      
"      just hold down ctrl and use arrows
"      or for tree sitter hold down ctrl + shift
"
"   2. swap arguments
"      
"      put your cursor on an argument and
"      use alt + arrows
"
"   3. select a node visually and expand selection upwards
"      and undo downwards
"
"      press Enter, then use ctrl shift + arrow up / down
"                          
"

" (#text_object_walk)
nnoremap <silent><C-Left> ?[<{[("'`]<CR>
nnoremap <silent><C-Right> /[<{[("'`]<CR>
vnoremap <silent>s( <Esc>`>a)<Esc>`<i(<Esc>
vnoremap <silent>s< <Esc>`>a><Esc>`<i<<Esc>
vnoremap <silent>s{ <Esc>`>a}<Esc>`<i{<Esc>
vnoremap <silent>s[ <Esc>`>a]<Esc>`<i[<Esc>
vnoremap <silent>s" <Esc>`>a"<Esc>`<i"<Esc>
vnoremap <silent>s' <Esc>`>a'<Esc>`<i'<Esc>
vnoremap <silent>s` <Esc>`>a`<Esc>`<i`<Esc>
vnoremap <silent><C-Down> <Esc>`>x`<x
nnoremap gp `[v`]

" AI_GENERATED(ivan): bindings for tree sitter
"                     to select structures and walk up the tree
"
" (#text_object_tree_sitter_select)
"
lua<<EOF
local ok, incselect = pcall(require, "incselect")
if ok then
  -- Normal mode: Enter to start selection
  vim.keymap.set("n", "<CR>", incselect.init)
  
  -- Visual mode: Ctrl+Up to grow selection, Ctrl+Down to shrink selection
 vim.keymap.set("x", "<C-S-Up>", incselect.parent)
 vim.keymap.set("x", "<C-S-Down>", incselect.undo)
end
EOF

" AI_GENERATED(ivan): bindings for tree sitter
"                     analogous to my own <C-Left> bindings 
"
" (#text_object_tree_sitter_walk)
"
lua<<EOF
local function select_range(sr, sc, er, ec)
  vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
  vim.cmd("normal! v")
  vim.fn.setpos(".", { 0, er + 1, ec, 0 })
end


local function jump_to_pos(row, col)
  vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

-- Get all opening boundaries (like the start of a function call, a table, or a block)
local function get_all_blocks()
  local parser = vim.treesitter.get_parser(0)
  if not parser then return {} end
  local tree = parser:parse()[1]
  local root = tree:root()
  
  local blocks = {}
  -- Walk the entire tree and collect the starting coordinates of every named syntax structure
  local function traverse(node)
    if not node then return end
    local r, c = node:start()
    table.insert(blocks, { row = r, col = c })
    for i = 0, node:named_child_count() - 1 do
      traverse(node:named_child(i))
    end
  end
  traverse(root)
  
  -- Sort them in strict chronological reading order
  table.sort(blocks, function(a, b)
    if a.row == b.row then return a.col < b.col end
    return a.row < b.row
  end)
  return blocks
end

-- Ctrl+Shift+Right: Find the absolute next paren/scope start down the text stream
vim.keymap.set("n", "<C-S-Right>", function()
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  r = r - 1 -- Convert to 0-indexed for treesitter matching
  
  for _, block in ipairs(get_all_blocks()) do
    if block.row > r or (block.row == r and block.col > c) then
      jump_to_pos(block.row, block.col)
      return
    end
  end
end)

-- Ctrl+Shift+Left: Find the absolute previous paren/scope start up the text stream
vim.keymap.set("n", "<C-S-Left>", function()
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))
  r = r - 1
  
  local blocks = get_all_blocks()
  for i = #blocks, 1, -1 do
    local block = blocks[i]
    if block.row < r or (block.row == r and block.col < c) then
      jump_to_pos(block.row, block.col)
      return
    end
  end
end)
EOF

"
" (#text_object_tree_sitter_swap)
"
vnoremap <silent> <M-Right> d:<C-U>lua require('incselect').next()<CR>p
vnoremap <silent> <M-Left>  d:<C-U>lua require('incselect').prev()<CR>p

nnoremap <silent> <M-Right> <cmd>lua require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")<CR>
nnoremap <silent> <M-Left>  <cmd>lua require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")<CR>
"
" Here ends text objects section.
"
" Get to the top: (#text_objects)
"

" -----------------------------------------------------------------------------
"  LSP (#lsp_i)
" -----------------------------------------------------------------------------
" Index: (#lsp)
nnoremap <silent>+ :lua vim.diagnostic.open_float()<CR>
"
" Here ends lsp section.
" Get to the top: (#lsp)

" -----------------------------------------------------------------------------
"  Build (#build_i)
" -----------------------------------------------------------------------------
" Index: (#build)
"
nmap <F2> :make<CR>
"
" Here ends build section.
" Get to the top: (#build)

" -----------------------------------------------------------------------------
"  Unsorted (#unsorted_i)
" -----------------------------------------------------------------------------

function! RunDetached(cmd)
  let job_id = jobstart(a:cmd, {'detach': v:true})
endfunction

function! IsRunning(process_name)
  let pgrep_result = trim(system('pgrep -x ' . shellescape(a:process_name)))
  return !empty(pgrep_result)
endfunction

function! OpenIdea()
  let current_line = line('.')
  let current_file = expand('%:p')
  let project_root = GetProjectRoot()
  let command = ' idea ' . project_root . ' --line ' . current_line . ' ' . current_file

  if IsRunning('idea')
    call system(command)
  else
    call RunDetached(command)
  endif
endfunction

command! OpenIdea :call OpenIdea()
autocmd FileType java nnoremap <F2> :OpenIdea<CR>


function! FindFilesSmart()
  if !empty(finddir('.git', expand('%:p:h') . ';'))
    :GFiles
  else
    :Files
  endif
endfunction


" --- Helper function to determine the project root ---
" Returns the git repo's top-level directory if it exists,
" otherwise returns the current directory '.'.
function! GetProjectRoot()
  let git_root = trim(system('git rev-parse --show-toplevel 2>/dev/null'))

  if v:shell_error == 0
    return git_root
  else
    return '.'
  endif
endfunction

function! PipeAllToFzf()
  let project_root = GetProjectRoot()

  let source_cmd = '(cd ' . shellescape(project_root) . ' && rg --line-number --no-heading ".*" .)'

  let fzf_opts = {
    \ 'dir': project_root,
    \ 'prompt': 'OmniSearch> '
    \ }

  call fzf#vim#grep(source_cmd, 1, fzf#vim#with_preview(fzf_opts))
endfunction

" Command and function to pipe ALL project content into fzf for a pure fuzzy search.
command! FzfAll call PipeAllToFzf()
command! FindFilesSmart call FindFilesSmart()
nnoremap <F3> :FindFilesSmart<CR>
nnoremap <F4> :FzfAll<CR>

au BufRead,BufNewFile *.grep set filetype=grep

map <silent>; :CtrlPBuffer<CR>

" Get to the top (#top)
