" Turn on spelling
set spell

" List possible completions in the statusline
set wildmenu

" Turn on virtual editing in block mode
" This makes some selection tasks easier
set ve="block"

" keep some context always visable around the cursor
set scrolloff=5

" set a title on the terminal
set title

" Allow for some lazyness in searching.
" i.e. ignore cases unless there is a capital letter in the search string.
set ignorecase
set smartcase

" yanking the current line is a bit silly as that can be accomplished by yy whereas y$ sucks to type
nmap Y y$

" lag sucks rather hard. Thus I find not using the arrow F[1..12] keys a fair tradeoff
" for not having to wait a second after leaving insert mode
" If only I had a way to do thing in readline/zle
set noesckeys

" This should turn on matching of if-else clauses and the like.
" I don't know if this is language specific.
runtime macros/matchit.vim

" Briefly flash the matching grouping symbol
" I wish this worked with " in strings as well as other language dependent times
set showmatch
set matchtime=2

" doing :make only to find that I forgot to write the file sucks
" additionally using a good RCS like darcs as well as undo make writing too much
" ok in general
set autowrite

" Tabs suck, to the point that most things should just die and complain about files with them
" unfortunately this is not the case, thus this will expand all tabs and try to be smart wrt
" backspacing.
set expandtab
set smarttab

" Show trailing whitespace visually using an angry red color
highlight SpecialKey ctermfg=Green ctermbg=Red
if (&termencoding == "utf-8") || has("gui_running")
   if v:version >= 700
      set list listchars=tab:,trail:,extends:,nbsp:
   else
      set list listchars=tab:,trail:,extends:
   endif
else
   if v:version >= 700
      set list listchars=tab:>-,trail:\ ,extends:>,nbsp:_
   else
      set list listchars=tab:>-,trail:.,extends:>
   endif
endif

" The other problem with tabs is everyone hates the default of 8 spaces, I am no different,
" and thus uses incompatible values perhaps in non-layout languages this is merely annoying,
" but I like Haskell and Python
set shiftwidth=3

" I pretty much never use a terminal with a light background, however this still feels rather hackish
" as there probably is a nice way to query something and then set this
set background=dark

" Ideally there would be a way to set wraping that does something approaching the right thing
" (ie actually indenting the continued line) and then to move around using the displayed lines
" rather than the logical lines. This doesn't really even provide a good approximation of that
" behavior
set textwidth=120

" Use 256 colors instead of 16. NB this really needs to handle lower color terminals at some point.
set t_Co=256

" This turns on line numbering and takes up as little space as possible
" since numberwidth only works on newer versions of vim, there should
" be some checking to go along with this
" Additionally numbers should be some unobtrusive color.
if version >= 700
   set number
   set numberwidth=1
   highlight LineNr ctermfg=DarkGray
endif

" Turn on Syntax highlighting
syntax on

" Turn on filetype support
filetype plugin on
filetype indent on

" Always refresh syntax from the start of the file
if has("autocmd")
   autocmd BufEnter * syntax sync fromstart
endif

" Use mail highlighting in sup (sup.rubyforge.org)
if has("autocmd")
   au BufRead sup.*        set ft=mail
endif

" Use LaTeX highligting for any tex document
if has("autocmd")
   au BufRead *.tex        set ft=tex
endif

" Enable modelines only on secure vim
if (v:version == 603 && has("patch045")) || (v:version > 603)
   set modeline
else
   set nomodeline
endif

" Always have a status line
set laststatus=2
let &stl = "%f%=%l/%L,%c%V "

" word complete stuff
" Sadly I don't have a fall back for autocompletion when using an old version of vim
"f (version >= 700) && has('autocmd')
"  autocmd BufEnter * call DoWordComplete()
"  autocmd BufEnter * call s:SetComplType()
"ndif

" This tries to set the completion type to be something
" sensible (ie use omnicompletion when available)
" luckily most completion related plugins seem to use
" g:complType to determine how to perform the completion
fu! s:SetComplType ()
   if ((version >= 700) && (&omnifunc != ""))
      let g:complType=["\<C-X>\<C-O>","\<C-P>"]
   else
      let g:complType=["\<C-P>"]
   endif
endf

" I never seem to use anonymous macros
" thus I have ganked q to build and test
"f has('autocmd')
"  autocmd BufEnter * call s:build()
"ndif
"u! s:build ()
"  if (&filetype == 'tex')
"     nmap q :! latexmk --pv<CR>
"  elsei (&filetype == 'haskell')
"     nmap q :make
"  else
"     nmap q <ESC>
"  endif
"ndf

" Turn off search hilite when idle
if has("autocmd")
   autocmd CursorHold * nohls | redraw
endif

" I bet this is dangerous
noremap j gj
noremap k gk
