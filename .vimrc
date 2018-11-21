set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'easymotion/vim-easymotion'
"Plugin 'severin-lemaignan/vim-minimap'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'ap/vim-css-color'
Plugin 'gcavallanti/vim-noscrollbar'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'Yggdroot/indentLine'
Plugin 'terryma/vim-expand-region'
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-indent'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'zah/nim.vim'
Plugin 'scrooloose/syntastic'
Plugin 'junegunn/goyo.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
set expandtab
set tabstop=2
set shiftwidth=2
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4
autocmd FileType c setlocal shiftwidth=4 tabstop=4

set mouse=a
set incsearch
set t_Co=256
set hlsearch
nnoremap <Esc> :nohlsearch<CR>
let g:airline_powerline_fonts = 1
let g:airline_theme='arcdark'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
"let g:airline_symbols.maxlinenr = ""
let g:airline_symbols.linenr = ""
let g:airline_symbols.whitespace = ""
let g:airline#extensions#tabline#enabled = 1
let ttimeoutlen = 10

let mapleader="\<Space>"

" Remap PgUp and PgDown to something not so drastic, keep default as an option
nnoremap <C-PageDown> <PageDown>
nnoremap <C-PageUp> <PageUp>
nnoremap <PageDown> <C-d>
nnoremap <PageUp> <C-u>
" Use Ctrl-D fol multi cursor select like in Sublime
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key= '<C-d>'
let g:multi_cursor_prev_key= '<C-h>'
let g:multi_cursor_skip_key= '<C-t>'
let g:multi_cursor_quit_key= '<Esc>'

" Enable Ctrl-N to toggle relative numbers
nnoremap <C-n> :set relativenumber!<cr>

" Enable * to search for selection in visual mode
vnoremap * y/<C-R>"<CR>

" Theme and default line numbers
colorscheme arcdark
set number

" Don't hide empty buffers (or something like that)
set hidden
" To open a new empty buffer
nmap <leader>T :enew<cr>
" Move to the next buffer
nmap <leader>s :bnext<CR>
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>
" Close a tab and discard changes
nmap <leader>bQ :bp <BAR> bd! #<CR>
" Show all open buffers and their status
nmap <leader>bl :ls<CR>

" Make sure the minimap is closed before CtrlP is run and open it afterwards
" au BufRead * Minimap
" nmap <C-P> :MinimapClose <CR> :CtrlP<CR>
" let g:ctrlp_map = ''
" Set CtrlP working directory
let g:ctrlp_working_path_mode = 'a'

" Map Easymotion to tab and pritoritise letters in Dvorak order
nmap <tab> <Plug>(easymotion-bd-w)
let g:EasyMotion_keys = 'aoeuidhtnså,.pyfgcrlæqjkxbmwvz'

" Show light lines for space-indented lines
let g:indentLine_color_term = 239
let g:indentLine_char = '│'
" And heavy lines for tab indented lines
set list lcs=tab:\┃\ 

call expand_region#custom_text_objects({
      \ 'a]' :1,
      \ 'ab' :1,
      \ 'aB' :1,
      \ 'ii' :0,
      \ 'ai' :0,
      \ })

" Speed up macro runs by not redrawing while they are in action
set lazyredraw

" Add the noscrollbar to the status line
" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %{noscrollbar#statusline()}
function! Noscrollbar(...)
    "let w:airline_section_z = '%{noscrollbar#statusline(20,"░","█",["▐"],["▌"])}'
    let w:airline_section_z = '%{noscrollbar#statusline(20,"⠒","⠿",["⠺"],["⠗"])}'
    "let w:airline_section_z = '%{%{noscrollbar#statusline(20,'■','◫',['◧'],['◨'])}}'
endfunction
"call airline#add_statusline_func('Noscrollbar')

noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

function! s:goyo_leave()
  colorscheme arcdark
endfunction
autocmd! User GoyoLeave nested call <SID>goyo_leave()
noremap <silent> <Leader>g :Goyo<CR>

" Some remapping to get HJKL as HTNS on Dvorak
map \ <Plug>(expand_region_shrink)

noremap - n
noremap _ N

noremap s l
noremap t j
noremap n k

" Highlight trailing whitespace
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

" Highlight the 80th row
set colorcolumn=81
hi ColorColumn ctermbg=black

" Show JSON quotes
set conceallevel=0

" Make sessions behave a bit better
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds

" Set up automatically tracking sessions
function! MakeSession(overwrite)
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/session.vim'
  if a:overwrite == 0 && !empty(glob(b:filename))
    return
  endif
  exe "mksession! " . b:filename
endfunction

function! LoadSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . "/session.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

" Adding automatons for when entering or leaving Vim
if(argc() == 0)
  au VimEnter * nested :call LoadSession()
  au VimLeave * :call MakeSession(1)
else
  au VimLeave * :call MakeSession(0)
endif

" Let ycm stop with the annoying message
let g:ycm_filetype_specific_completion_to_disable = {
  \ 'cpp': 1,
  \ 'c': 1
  \ }

nnoremap <leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
