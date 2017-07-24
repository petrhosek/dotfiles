set nocompatible  " be iMproved, required
filetype off " required

" required, plugins available after
execute pathogen#infect()

" Look & Feel
syntax on " syntax highlighting
colorscheme nord " color scheme to use
set number " show line numbers
set showmode " show current edit mode

" Syntax highlighting
set nocursorcolumn
set nocursorline
set norelativenumber
syntax sync minlines=256

" Spaces for indentation
set softtabstop=2 " backspace deletes indent
set shiftwidth=2 " use 2 spaces for indentation
set tabstop=2 " an indentation every 2 columns
set expandtab " tabs are spaces, not tabs

" Highlight lines longer than 80 columns.
highlight def link Overflow ColorColumn
if v:version >= 702
  au BufWinEnter * let w:m0=matchadd('Overflow', '\%>80v.\+', -1)
else
  au BufRead,BufNewFile * syntax match Overflow /\%>80v.\+/
endif

augroup csrc
  au!
  autocmd FileType *      set nocindent smartindent
  autocmd FileType c,cpp  set cindent
augroup END

set cinoptions=:0,g0,(0,Ws,l1
set smarttab " add and delete spaces in increments of `shiftwidth' for tabs

augroup filetypedetect
  " Don't expand tabs to spaces in Dockerfiles
  autocmd FileType dockerfile set noexpandtab

  " Follow Go conventions
  autocmd FileType go set noexpandtab tabstop=4 softtabstop=4 shiftwidth=4 nolist

  " Don't expand tabs to spaces in Makefiles, since we need the actual tabs
  autocmd FileType make set noexpandtab
augroup END

" Remember last location in file, but not for commit messages
autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
" Switch to working directory of the open file
autocmd BufEnter * if expand('%:p') !~ '://' | cd %:p:h | endif

" Folding
set foldmethod=syntax
set foldlevelstart=1
set foldnestmax=1
set fillchars+=fold:\
set foldopen=hor,mark,percent,quickfix,search,tag,undo

" Search
set hlsearch " highlight search results
set ignorecase " search is case insensitive...
set smartcase " ...unless it contains at least one capital

" Backup
set nobackup " no backup files
set nowritebackup " like seriously (we're using Git after all)
set noswapfile " no swap files either

" Key bindings

" pastetoggle (sane indentation on pastes)
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" map Control-# to switch tabs
map  <C-0> 0gt
imap <C-0> <ESC>0gt
map  <C-1> 1gt
imap <C-1> <ESC>1gt
map  <C-2> 2gt
imap <C-2> <ESC>2gt
map  <C-3> 3gt
imap <C-3> <ESC>3gt
map  <C-4> 4gt
imap <C-4> <ESC>4gt
map  <C-5> 5gt
imap <C-5> <ESC>5gt
map  <C-6> 6gt
imap <C-6> <ESC>6gt
map  <C-7> 7gt
imap <C-7> <ESC>7gt
map  <C-8> 8gt
imap <C-8> <ESC>8gt
map  <C-9> 9gt
imap <C-9> <ESC>9gt

" Tabularize
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a:: :Tabularize /:\zs<CR>
vmap <Leader>a:: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

" clang-format
map <C-K> :pyf ~/.vim/plugin/clang-format.py<CR>
imap <C-K> <C-O> :pyf ~/.vim/plugin/clang-format.py<CR>

function! ClangCheckImpl(cmd)
  if &autowrite | wall | endif
  echo "Running " . a:cmd . " ..."
  let l:output = system(a:cmd)
  cexpr l:output
  cwindow
  let w:quickfix_title = a:cmd
  if v:shell_error != 0
    cc
  endif
  let g:clang_check_last_cmd = a:cmd
endfunction

function! ClangCheck()
  let l:filename = expand('%')
  if l:filename =~ '\.\(cpp\|cxx\|cc\|c\)$'
    call ClangCheckImpl("clang-check " . l:filename)
  elseif exists("g:clang_check_last_cmd")
    call ClangCheckImpl(g:clang_check_last_cmd)
  else
    echo "Can't detect file's compilation arguments and no previous clang-check invocation!"
  endif
endfunction

" clang-check
nmap <silent> <F5> :call ClangCheck()<CR><CR>

" YouCompleteMe
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0

let g:ycm_global_ycm_extra_conf = ''
let g:ycm_confirm_extra_conf = 0

" Lightline
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }

filetype plugin indent on " automatically detect file types
