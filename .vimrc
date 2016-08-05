syntax enable
colorscheme seti

" unicode + unix
set encoding=utf8
set ffs=unix,dos,mac

" BEGIN VUNDLE
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'moll/vim-node'
call vundle#end()
filetype plugin indent on
" END VUNDLE

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

" Mouse?
set mouse=a
