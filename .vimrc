set nocompatible                " be iMproved
filetype off                    " required!

if has('win32') || has('win64')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" Dependencies
Bundle 'tpope/vim-sensible'

Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'Lokaltog/vim-easymotion'

if executable('ack-grep')
  let g:ackprg="ack-grep -H --nocolor --nogroup --column"
  Bundle 'mileszs/ack.vim'
elseif executable('ack')
  Bundle 'mileszs/ack.vim'
elseif executable('ag')
  Bundle 'mileszs/ack.vim'
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdcommenter'
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-surround'
if executable('ctags')
  Bundle 'majutsushi/tagbar'
endif

Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'chriskempson/base16-vim'
colorscheme base16-default

" Basic
filetype plugin indent on       " automatically detect file types
syntax on                       " syntax highlighting

set background=dark             " assume a dark background
set number                      " show line numbers
set showmode                    " show current edit mode

set nowrap                      " don't wrap lines
augroup vimc_autocmds           " highlight characters past 78 columns
  autocmd BufEnter * highlight OverLength ctermbg=darkred guibg=#FFD9D9
  autocmd BufEnter * match OverLength /\%78v.*/
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
  autocmd BufEnter *.scons set ft=python

  " use real tabs in Makefile
  autocmd FileType make set noexpandtab
  " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  autocmd FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79
  " wrap Markdown text
  autocmd FileType markdown set wrap linebreak textwidth=72 nolist

  " remember last location in file, but not for commit messages
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g`\"" | endif
  " switch to working directory of the open file
  autocmd BufEnter * if expand('%:p') !~ '://' | cd %:p:h | endif
endif

" Key bindings
nnoremap j gj
nnoremap k gk

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

" NERDTree
map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <Leader>e :NERDTreeFind<CR>
nmap <Leader>nt :NERDTreeFind<CR>

" TagBar
nnoremap <Silent> <Leader>tt :TagbarToggle<CR>
inoremap <Silent> <Leader>tt <ESC>:TagbarToggle<CR>

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
