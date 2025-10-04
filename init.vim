call plug#begin()

" Updated theme
Plug 'vim-airline/vim-airline'

" Better work with buffers
Plug 'ctrlpvim/ctrlp.vim'

" Try number two
" https://www.youtube.com/watch?v=3a1PCir_aHs
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-lint'

" Better file search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Install themes
Plug 'dohsimpson/vim-macroeditor'
Plug 'morhetz/gruvbox'
Plug 'iibe/gruvbox-high-contrast'
Plug 'Abstract-IDE/Abstract-cs'
Plug 'NLKNguyen/papercolor-theme'

call plug#end()

autocmd vimenter * ++nested colorscheme PaperColor 

map <silent>; :CtrlPBuffer<CR>

set mouse=a
set nohlsearch

set tabstop=2
set shiftwidth=2
set expandtab
retab

set number
autocmd TermOpen * setlocal nonumber norelativenumber

au BufWritePost * lua require('lint').try_lint()

" move between terminal and window 
" via \[ and \]
map <silent><C-\><C-]> <C-w>li
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

" enter file
nmap <silent>\> :lua sniff:sendln(',enter (file "'..string.gsub(vim.fn.expand("%"), [[\]], [[\\]])..'")')<CR><CR>

" go upper
nmap <silent>\< :lua sniff:sendln(",top")<CR>
nnoremap <silent><C-Left> ?[<{[("'`]<CR>
nnoremap <silent><C-Right> /[<{[("'`]<CR>
nnoremap <silent><C-S-Right> <C-Left><C-Right>%<C-Right>
nnoremap <silent><C-S-Left> <C-Left><C-Right>?[]"'`)}>]<CR>%
vnoremap <silent>s( <Esc>`<i(<Esc>`>la)<Esc>`<
vnoremap <silent>s< <Esc>`<i<<Esc>`>la><Esc>`<
vnoremap <silent>s{ <Esc>`<i{<Esc>`>la}<Esc>`<
vnoremap <silent>s[ <Esc>`<i[<Esc>`>la]<Esc>`<
vnoremap <silent>s" <Esc>`<i"<Esc>`>la"<Esc>`<
vnoremap <silent>s' <Esc>`<i'<Esc>`>la'<Esc>`<
vnoremap <silent>s` <Esc>`<i`<Esc>`>la`<Esc>`<
vnoremap <silent><C-Down> <Esc>`>x`<x
nnoremap gp `[v`]

nnoremap <silent>+ :lua vim.diagnostic.open_float()<CR>

nmap <F2> :make<CR>

augroup MyPHPHighlights
  autocmd!
  autocmd FileType php syntax clear phpTodo
augroup END

augroup MyJSHighlights
  autocmd!
  autocmd FileType javascript syntax clear javaScriptCommentTodo
augroup END

augroup CustomTodoHighlights
  autocmd!
  " After colorscheme and plugins load, apply these highlights
  autocmd ColorScheme * call s:SetupTodoHighlights()
  autocmd VimEnter * call s:SetupTodoHighlights()

  function! s:SetupTodoHighlights() abort

    " Define keywords inside comments or anywhere
    syntax keyword Todo   TODO   contained
    syntax keyword Done   DONE   contained
    syntax keyword Note   NOTE   contained
    syntax keyword Usage  USAGE  contained
    syntax keyword Research RESEARCH contained

    syntax match Author "(\zs[^()]*\ze):" contained

    syntax cluster customkwords contains=Todo,Done,Note
    syntax cluster customkwords add=Usage
    syntax cluster customkwords add=Research
    syntax cluster customkwords add=Author

    syntax match LineWithAuthor      "\(NOTE\|TODO\|DONE\|USAGE\|RESEARCH\)\(([^()]\{-}):\)\?" containedin=ALL contains=@customkwords
    " Custom highlight groups
    highlight Todo     ctermfg=208 cterm=bold   gui=bold   guifg=#FF8700
    highlight Done     ctermfg=114 cterm=bold   gui=bold   guifg=#9ACD32
    highlight Note     ctermfg=140 cterm=italic gui=italic guifg=#C8A2C8
    highlight Usage    ctermfg=140 cterm=italic gui=bold   guifg=#C8A2C8
    highlight Research ctermfg=114 cterm=bold   gui=bold   guifg=#9ACD32
    highlight Author   ctermfg=140 cterm=italic gui=italic guifg=#FFD700    
  endfunction
augroup END

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
