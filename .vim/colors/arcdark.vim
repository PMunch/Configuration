" Vim color file
" Maintainer:	Hans Fugal <hans@fugal.net>
" Last Change:	$Date: 2004/06/13 19:30:30 $
" Last Change:	$Date: 2004/06/13 19:30:30 $
" URL:		http://hans.fugal.net/vim/colors/desert.vim
" Version:	$Id: desert.vim,v 1.1 2004/06/13 19:30:30 vimboss Exp $

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

set background=dark
if version > 580
  " no guarantees for version 5.8 and below, but this makes it stop
  " complaining
  hi clear
  if exists("syntax_on")
  syntax reset
  endif
endif
let g:colors_name="arcdark"

" Main
hi Normal ctermfg=14 ctermbg=none
hi Comment ctermfg=240 ctermbg=none

" Constant
hi Constant ctermfg=186
hi String ctermfg=187
hi Character ctermfg=187
hi Number ctermfg=7

" Statement
hi Statement ctermfg=1
hi Operator ctermfg=203
hi Keyword ctermfg=160
hi Exception ctermfg=110
hi Type ctermfg=188 cterm=italic
hi Delimiter ctermfg=1 cterm=italic

hi Identifier ctermfg=2 cterm=bold

hi SpecialKey ctermfg=239
"vim: sw=4
