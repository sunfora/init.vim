call plug#begin()

" Updated theme
Plug 'vim-airline/vim-airline'

" Better work with buffers
Plug 'ctrlpvim/ctrlp.vim'

Plug 'dohsimpson/vim-macroeditor'
call plug#end()

map <silent>; :CtrlPBuffer<CR>

set mouse=a
set nohlsearch

set tabstop=2
set shiftwidth=2
set expandtab
retab

set number
autocmd TermOpen * setlocal nonumber norelativenumber


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
nnoremap <silent><C-Left> ?[<{[(]<CR>
nnoremap <silent><C-Right> /[<{[(]<CR>
nnoremap <silent><C-S-Right> <C-Left><C-Right>%<C-Right>
nnoremap <silent><C-S-Left> <C-Left><C-Right>?[])}>]<CR>%
vnoremap <silent>s( <Esc>`<i(<Esc>`>la)<Esc>`<
vnoremap <silent>s< <Esc>`<i<<Esc>`>la><Esc>`<
vnoremap <silent>s{ <Esc>`<i{<Esc>`>la}<Esc>`<
vnoremap <silent>s[ <Esc>`<i[<Esc>`>la]<Esc>`<
vnoremap <silent><C-Down> <Esc>`>x`<x
nnoremap gp `[v`]
