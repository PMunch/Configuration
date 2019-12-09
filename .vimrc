scriptencoding utf-8
set encoding=utf-8

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'severin-lemaignan/vim-minimap'
Plugin 'easymotion/vim-easymotion'
Plugin 'zah/nim.vim'
"Plugin 'baabelfish/nvim-nim'
Plugin 'scrooloose/syntastic'
Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'terryma/vim-multiple-cursors'
Plugin 'ap/vim-css-color'
Plugin 'Yggdroot/indentLine'
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-indent'
Plugin 'terryma/vim-expand-region'
Plugin 'junegunn/goyo.vim'
Plugin 'sirtaj/vim-openscad'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'amadeus/vim-mjml'
Plugin 'OmniSharp/omnisharp-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Re-map leader to space
let mapleader="\<Space>"

" Airline theme settings
let g:airline_theme='arcdark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let ttimeoutlen = 10

"let g:minimap_toggle="<leader>mm"
"let g:minimap_highlight="Visual"

let nim_highlight_all=1
set t_Co=256
set mouse=a
set number
set tabstop=2
set softtabstop=2 expandtab
set shiftwidth=2

autocmd FileType c setlocal shiftwidth=4 tabstop=4 softtabstop=4

" Remap PgUp and PgDown to something not so drastic, keep default as an aption
nnoremap <C-PageDown> <PageDown>
nnoremap <C-PageUp> <PageUp>
nnoremap <PageDown> <C-d>
nnoremap <PageUp> <C-u>

" Use Ctrl-D fol multi cursor select like in Sublime
" let g:multi_cursor_next_key='<C-d>'

" Enable Ctrl-N to toggle relative numbers
nmap <C-N> :set relativenumber!<CR>

" Set theme and default syntax highlighting
syntax on
colorscheme arcdark

" Open at same position as last time
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

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

" Easymotion default on tab key
nmap <tab> <Plug>(easymotion-bd-w)

" Make sure the minimap is closed before CtrlP is run and open it afterwards
"au BufRead * Minimap
"nmap <C-P> :MinimapClose <CR> :CtrlP<CR>
"let g:ctrlp_map = ''
" Set CtrlP working directory
let g:ctrlp_working_path_mode = 'ra'

" Options to highlight indentation
set list lcs=tab:\┃\ 
let g:indentLine_color_term = 239
let g:indentLine_char = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_first_char = '│'
" let g:indentLine_conceallevel = 0
" let g:vim_json_syntax_conceal = 0

" Make expand to region consider both inside and outside of a region a region
nnoremap <C-\+> <Plug>(expand_region_shrink)
call expand_region#custom_text_objects({
  \ 'a]' :1,
  \ 'ab' :1,
  \ 'aB' :1,
  \ 'ii' :0,
  \ 'ai' :0,
  \ })

noremap <silent> <Leader>g :Goyo<CR>

function! s:goyo_enter()
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
endfunction

function! s:goyo_leave()
  colorscheme arcdark
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
endfunction

autocmd! User GoyoLeave nested call <SID>goyo_leave()
autocmd! User GoyoEnter nested call <SID>goyo_enter()

set hlsearch
nnoremap <esc><esc> :silent! nohls<cr>

" N is pretty useful for jumping to next search, let's bind that to something
noremap - n
noremap _ N
"noremap _ N
" Remap HJKL to something more Dvorak friendly
"nnoremap h 
noremap t j
noremap n k
noremap s l

" Enable sessions
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

" Highlight whitespace
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

" Highlight column 80, and 128 (GitHub cutoff)
let &colorcolumn="80,128"
highlight ColorColumn ctermbg=52

" Remove annoying bell
set noerrorbells visualbell t_vb=

au User lsp_setup call lsp#register_server({
  \ 'name': 'nimlsp',
  \ 'cmd': {server_info->['/home/peter/Projects/nimlsp/nimlsp']},
  \ 'whitelist': ['nim'],
  \ })

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('/tmp/vim-lsp.log')

" for asyncomplete.vim log
let g:asyncomplete_log_file = expand('/tmp/asyncomplete.log')

let g:asyncomplete_auto_popup = 0

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

