call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'

" Sublime style multi carets: ctrl-n on word or \v selects - then v or c
Plug 'terryma/vim-multiple-cursors'

" JavaScript
Plug 'moll/vim-node'

" Rust
Plug 'rust-lang/rust.vim'
" racer bindings - use `gd` (normal mode)
Plug 'racer-rust/vim-racer'

" Searching using the_silver_searcher - use :Ag <src>
Plug 'rking/ag.vim'

" Nerdtree + gutter
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'

" fuzzy file finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Misc syntax highlighting
Plug 'cespare/vim-toml'

" Theme
Plug 'trusktr/seti.vim'

call plug#end()

syntax enable
colorscheme seti

" unicode + unix
set encoding=utf8
set ffs=unix,dos,mac

" indentation
set expandtab
set tabstop=2
set shiftwidth=2

" Read when a file is changed outside
set autoread

" Height of the command bar
set cmdheight=1
" And add a status line
set laststatus=2
set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ %l:%c

" Line numbers next to git gutter - <n>G to goto line
set number

" Mouse - allows mouse select and copy to system clipboard
" otherwise use normal y (yank) and p (paste) after doing \v selects
set mouse-=a

" Code complete - mirror sublime racer key (NB: ctrl-o for going back)
nmap <F2> gd <CR>

" Search - \ag around word
nnoremap <leader>ag :LAg <c-r>=expand("<cword>")<cr><cr>

" next and prev results \n and \e (normal search is n and N)
nnoremap <leader>n :lnext<cr>
nnoremap <leader>e :lprev<cr>

" focus windows directionally
noremap <silent> <A-Up> :wincmd k<CR>
noremap <silent> <A-Down> :wincmd j<CR>
noremap <silent> <A-Left> :wincmd h<CR>
noremap <silent> <A-Right> :wincmd l<CR>

" splits - \w and \h
nnoremap <leader>w :vsplit<cr>
nnoremap <leader>h :split<cr>

" NERDTree
nnoremap <leader>nt :NERDTreeToggle<cr>
" NB: shift-i toggles hidden files

" FZF
nnoremap <C-p> :FZF<cr>

" Surround word with quote
noremap <leader>' ysiw'
noremap <leader>" ysiw"
