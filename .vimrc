call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'

Plug 'scrooloose/syntastic'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

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

" Misc syntax highlighting
Plug 'cespare/vim-toml'
Plug 'plasticboy/vim-markdown'

" Theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

syntax enable
colorscheme ron


" unicode + unix
set encoding=utf8
set ffs=unix,dos,mac

" wrapping
set whichwrap=b,s,<,>,[,]

" indentation
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
autocmd FileType python set tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType go set tabstop=4 softtabstop=4 shiftwidth=4


" Read when a file is changed outside
set autoread

" Airline
let g:airline_theme = 'badwolf'

" Height of the command bar
set cmdheight=1
" Always show the status line
set laststatus=2
"" Format the status line
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_sh_checkers = ['shellcheck']
" NB: may have to :setf python if it fails to detect

" misc syntax
let g:vim_markdown_folding_disabled = 1

" infinite undo
set undofile
set undodir=~/.vim/undodir

" Line numbers next to git gutter - <number>gg to goto line
set number

" Mouse - allows mouse select and copy to system clipboard
" otherwise use normal y (yank) and p (paste) after doing \v selects
set mouse-=a

" Leader
let mapleader = "\<Space>"

" Code complete - mirror sublime racer key (NB: ctrl-i/o for back/forwards)
nmap <F2> gd <CR>

" Search - \ag around word
nnoremap <leader>ag :LAg <c-r>=expand("<cword>")<cr><cr>

" next and prev results on F3 and F4 (normal search is n and N)
nnoremap <F3> :lnext<cr>
nnoremap <F4> :lprev<cr>

" NERDTree
nnoremap <leader>nt :NERDTreeToggle<cr>
" NB: shift-i toggles hidden files

" fuzzy file find
nnoremap <C-p> :FZF<cr>
" Open files in split towards right
nnoremap <silent> <Leader>v :call fzf#run({
\   'right': winwidth('.') / 2,
\   'sink':  'vertical botright split' })<CR>

" focus windows left and right
noremap <silent> <S-Up> :wincmd h<CR>
noremap <silent> <S-Down> :wincmd l<CR>

" Manage tabs (shift left/right, and new/close with shift t/w)
noremap <silent> <S-Left> :tabp<CR>
noremap <silent> <S-Right> :tabn<CR>

noremap <S-t> :tabnew<CR>:FZF<CR>
noremap <S-w> :tabclose<CR>

" Surround word with quote
noremap <leader>' ysiw'
noremap <leader>" ysiw"
