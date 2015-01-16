set nocompatible                " be iMproved, required
filetype off

if has('win32') || has('win64')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage itself, required
Plugin 'gmarik/Vundle.vim'

" Plugins
Plugin 'kien/ctrlp.vim'
Plugin 'file:///home/ph1310/.vim/bundle/docker'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'gregsexton/gitv'
Plugin 'file:///home/ph1310/.vim/bundle/go'
Plugin 'godlygeek/tabular'
Plugin 'tpope/vim-commentary'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-fugitive'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'mtth/scratch.vim'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vinegar'
Plugin 'Valloric/YouCompleteMe'

" Color schemes
Plugin 'altercation/vim-colors-solarized'

" required, plugins available after
call vundle#end()
filetype plugin indent on       " automatically detect file types

" Basic
syntax on                       " syntax highlighting
set background=dark
colorscheme solarized

set number                      " show line numbers
set showmode                    " show current edit mode
"set colorcolumn=80

set nowrap                      " don't wrap lines
augroup vimc_autocmds           " highlight characters past 78 columns
  autocmd BufWinEnter * highlight def link Overflow ColorColumn
  "autocmd BufWinEnter * let w:m1=matchadd('Search', '\%<81v.\%>77v', -1)
  "autocmd BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
  autocmd BufWinEnter * let w:m=matchadd('Overflow', '\%>80v.\+', -1)
augroup END

" Spaces
set shiftwidth=2                " use 2 spaces for indentation
set tabstop=2                   " an indentation every 2 columns
set softtabstop=2               " backspace deletes indent
set expandtab                   " tabs are spaces, not tabs

" Folding
set foldmethod=syntax
set foldlevelstart=1
set foldnestmax=1
set fillchars+=fold:\
set foldopen=hor,mark,percent,quickfix,search,tag,undo

" Search
set hlsearch                    " highlight search results
set ignorecase                  " search is case insensitive...
set smartcase                   " ...unless it contains at least one capital

" Backup
set nobackup                    " no backup files
set nowritebackup               " like seriously (we're using Git after all)
set noswapfile                  " no swap files either

" Filetypes
if has('autocmd')
  autocmd BufEnter *.json set ft=javascript
  autocmd BufEnter *.{md,markdown,mdown,mkd,mkdn,txt} set ft=markdown

  " use real tabs in Makefile
  autocmd FileType make set noexpandtab
  " make Python follow PEP8 (http://www.python.org/dev/peps/pep-0008/)
  autocmd FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79
  " wrap Markdown text
  autocmd FileType markdown set wrap linebreak textwidth=72 nolist
  " use real tabs in Dockerfile
  autocmd FileType dockerfile set noexpandtab
  " follow Go conventions
  autocmd FileType go set noexpandtab tabstop=4 softtabstop=4 shiftwidth=4 nolist

  " remember last location in file, but not for commit messages
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g`\"" | endif
  " switch to working directory of the open file
  autocmd BufEnter * if expand('%:p') !~ '://' | cd %:p:h | endif
endif

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

" Local settings
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
