set ts=2
set shiftwidth=2
set expandtab
retab

set number
autocmd TermOpen * setlocal nonumber norelativenumber

call plug#begin()

" Updated theme
Plug 'vim-airline/vim-airline'

call plug#end()

" move between terminal and window 
" via \[ and \]
map <C-\><C-]> <C-w>li
tmap <C-\><C-[> <C-\><C-n><C-w>h

" bind terminal
nmap \. :lua sniff:terminal()<CR>

" send yanked text
nmap \p :lua sniff:send(vim.fn.getreg('"'))<CR>

" send newline
nmap \<CR> :lua sniff:sendln("")<CR>

" send yanked text and newline
nmap \; \p\<CR>

" send quote 
nmap \' :lua sniff:send("'")<CR>

" send opening bracket 
nmap \9 :lua sniff:send("(")<CR>
" send closing bracket 
nmap \0 :lua sniff:send(")")<CR>

" yank current list and send it
nmap \( ya(\;

" enter file
nmap \> :lua sniff:sendln(',enter (file "'..string.gsub(vim.fn.expand("%"), [[\]], [[\\]])..'")')<CR><CR>

" go upper
nmap \< :lua sniff:sendln(",top")<CR>
