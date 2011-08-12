" Think real hard  before moving blocks around as it  will most likely break
" things (nocompatible has to be at the beginning, and the autocommands need
" appear before color syntaxing

filetype off 
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

syntax enable
" set background=light
" colorscheme solarized
colorscheme elflord

" Override default options

set nocompatible	" we want vim's features, not stupid vi compatiblity
set ruler		" shows ruler at the bottom of the screen
set bs=2		" allow backspacing over everything in insert mode
set ic			" comment this out if you want to search non case sensitive

set showcmd		" Show (partial) command in status line
set statusline=[T=%Y]\[%p%%]\[L=%L]\ %f%m%r%h%w
set laststatus=2 

" Those 2 are really useful, but they may confuse unsuspecting users -- Marc
set hlsearch		" Switch on syntax highlighting.
set incsearch		" show matches on the fly
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

set fileformats=unix	" I want to see those ^M if I'm editing a dos file. See below (Key Mappings) for ^M removal!
set expandtab		" use spaces as tabs :-) 
set sts=2               " use 2 softtabstops
set sw=2                " shiftwidth fixes tab

set ignorecase		" for pattern machine
set smartcase		" Except when a mix of case is given
set exrc
set secure              " do not allow shell commands in au blocks
set ai
set smartindent
set autoindent
set smarttab


" set swapsync=sync	" the swap is synced with sync, not fsync
set updatecount=20	" Number of characters typed before doing an update
set updatetime=10000	" Number of milliseconds before doing an update
set history=100		" Number of history commands to remember
set viminfo='50,\"200	" read/write a .viminfo file, remember filemarks for 50
			" files and store 200 lines of registers

set confirm		" To get a dialog when a command fails

" For debugging
" set verbose=9

" If bash is called sh on the system, define this
let bash_is_sh=1

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" wildmenu will show you a nice menu with completion
" first tab only shows the list, second tab lets you navigate
set wildmenu
set wildmode=list:longest,full

" folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set foldlevel=1         "this is just what i use
set foldmethod=manual

" For crontab -e
set backupskip=/tmp/*,/private/tmp/*

let mapleader=','

" CommandT
let g:CommandTMaxDepth = 5
let g:CommandTMaxHeight = 20
set wildignore+=bundler/**

filetype on "read file types from $VIMRUNTIME/filetype.vim
filetype indent on
filetype plugin on " enable plugins on filetypes
au BufNewFile,BufRead *.liquid set filetype=liquid |let IndentStyle = "html"
au BufNewFile,BufRead *.rhtml set filetype=html |let IndentStyle = "rhtml"
au BufNewFile,BufRead *.erb set filetype=html |let IndentStyle = "rhtml"
au BufNewFile,BufRead *.less set filetype=less | let IndentStyle = "less"
au BufNewFile,BufRead *.rb set filetype=ruby | let IndentStyle = "ruby"
au BufNewFile,BufRead *.rake set filetype=ruby | let IndentStyle = "ruby"
au BufNewFile,BufRead *.scss set filetype=css 
au BufNewFile,BufRead *.sass set filetype=sass 

" plugins used
" NerdCommenter (leader key is implied)
" cc => comment out
" cu => uncomment
" c<space> => toggle using the topmost line status
" ci => toggle individually 
" cy => comment but yank first
" cA => add comment at the end of line
" i hate this map, change to ce
nmap <leader>ce <leader>cA

" Supertab
" just press tab for tab completion

" Endwise
" correctly adds end for ruby 

" Vim surround
" ds will delete (you need to be in the phrase)
" cs will change surround (the same)
" ys = you surround 
" yss replace the whole line
" t goes for tag (I guess) e.g <div>kot</div> cst<p> => <p>kot</p>
" NICE: s or gs in visual mode (gs will suppress indentation)


"
" Autoload commands
"
" Only do this part when compiled with support for autocommands.
  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" Removes those bloody ^M's in DOS files
fun RmCR()
    let oldLine=line('.')
    exe ":%s/\r//g"
    exe ':' . oldLine
endfun
map ,cr :call RmCR()<CR>

fun BenIndent()
    let oldLine=line('.')
    " our text (whole file) is passed via STDIN (%) to script name, and the output is
    " placed in current buffer (STDOUT)
    if g:IndentStyle == "C"
        :%!tidy -quiet -utf8 -indent -clean
        " :%!indent --gnu-style --no-tabs --indent-level 8 --case-indentation 0 --brace-indent 0 --comment-delimiters-on-blank-lines --start-left-side-of-comments --format-all-comments --format-first-column-comments
    elseif g:IndentStyle == "html"
        " :%!tidy -quiet -utf8 -indent -clean
        :%!htmlbeautifier
    elseif g:IndentStyle == "php"
        :%!tidy -quiet -utf8 -indent -clean
    elseif g:IndentStyle == "rhtml"
        :%!htmlbeautifier
    elseif g:IndentStyle == "erb"
        " :%!htmlbeautifier
        :%!~/.vim/htmlbeautifier.rb
    elseif g:IndentStyle == "liquid"
        :%!~/.vim/htmlbeautifier.rb
    elseif g:IndentStyle == "ruby"
        :%!~/.vim/rubybeautifier.rb
    elseif g:IndentStyle == "rake"
        :%!~/.vim/rubybeautifier.rb
    endif
    exe ':' . oldLine
endfun
map -- :call BenIndent()<CR>

" default values
let Comment="#"
let EndComment=""

