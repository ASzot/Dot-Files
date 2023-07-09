""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lualine/lualine.nvim'

Plug 'junegunn/fzf.vim'

" Nerdtree
Plug 'preservim/nerdtree'

" Auto complete plugin
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" All this is required for vimsnippets
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

Plug 'christoomey/vim-tmux-navigator'

Plug 'lervag/vimtex'
Plug 'majutsushi/tagbar'

" For vim markdown (both required)
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

" Conflict marker
Plug 'rhysd/conflict-marker.vim'

Plug 'junegunn/goyo.vim'
Plug 'sheerun/vim-polyglot'

Plug 'mhartington/formatter.nvim'

Plug 'knsh14/vim-github-link'

"Plug 'github/copilot.vim'
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Setup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set completeopt=menu,menuone,noselect

lua require('config')

" Disable swp files.
set nobackup
set noswapfile

let mapleader = ","

" Change copy and paste to sync with the system clipboard.
set clipboard^=unnamed

" Set default to be  relative numbering. 
set rnu
set nonumber

" To automatically reload the file on external changes
set autoread
au CursorHold * checktime

let &titlestring = @%
set title

set nohlsearch

set conceallevel=2
hi clear Conceal
highlight clear Conceal

" Set popup menu color
highlight Pmenu ctermbg=gray guibg=gray

" SignColumn setup
highlight SignColumn ctermbg=gray guibg=gray

" Visual select color
hi Visual cterm=reverse term=reverse ctermfg=cyan

set updatetime=250
" autocmd CursorHold * lua vim.diagnostic.open_float({scope="line", focus=false})

" Unfold by default
au BufRead * normal zR

" No mouse input.
set mouse=
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Setup 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF settings
set rtp+=~/.fzf
let g:fzf_layout = {'down':'30'}
let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-/']
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" Snipets
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'

" Tagbar
let g:tagbar_autofocus = 0 
let g:tagbar_left = 1

" Vimtex
syntax on
let g:vimtex_view_method = 'skim'
" let g:latex_view_general_viewer = 'zathura'
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_mode = 0
let g:vimtex_fold_enabled=1
let g:vimtex_fold_manual=1

"let g:vimtex_quickfix_autoclose_after_keystrokes=2
"let g:vimtex_quickfix_enabled = 0
let g:vimtex_compiler_latexmk = {
      \ 'build_dir' : '/tmp',
      \ 'options' : [
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=batchmode',
        \ ],
        \}

" Nerdtree
map <C-r> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

let g:tmux_navigator_save_on_switch = 2

let g:black#settings = {
    \ 'line_length': 79
\}

" This is the default
" g:isort_command = 'isort'

" Markdown
let g:vim_markdown_toc_autofit=1

" imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
" let g:copilot_no_tab_map = v:true
" " By default disable copilot for all file types.
" let g:copilot_filetypes = {
"     \ '*': v:false,
"     \ 'gitcommit': v:true,
"     \ 'python': v:true,
"     \ 'yaml': v:true,
"     \ }
" 
let g:semshi#mark_selected_nodes=0

" Options for editing encrypted files.
set backupskip+=*.asc
set viminfo=
augroup GPG
  autocmd!
  autocmd BufReadPost  *.asc :%!gpg -q -d
  autocmd BufReadPost  *.asc |redraw!
  autocmd BufWritePre  *.asc :%!gpg -q -a -c
  autocmd BufWritePost *.asc u
  autocmd VimLeave     *.asc :!clear
augroup END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keyboard Remaps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors
map <leader>1 :call SetDarkMode()<CR>
map <leader>2 :call SetLightMode()<CR>

" Redo
map <F7> :redo <CR>

" Rebind delete to have a no copy version.
nnoremap <leader>d "_d

" Toggle line numbers
nnoremap <leader>w :set relativenumber!<CR>

" Find and replace 
nnoremap <leader>* :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Insert random UUID
nmap <leader>u :put =system('echo \\label{$RANDOM}')<CR>

" Tag viewing
nmap <leader>t :TagbarToggle fj<CR>
nmap <leader>y :BTags<CR>
nmap <leader>m :Marks<CR>

" File commands
nmap <c-f> :Files<CR>
nmap <space>a :Buffers<CR>
nmap <Space>f :Ag<Space>
nmap <Space>t :Ag<Space>(^\%\@).*
" Remove the '!' if you don't want this to open up a new window. 
noremap <Space>e :Ag! <C-r>=expand('<cword>')<CR><CR>
imap <c-x><c-f> <plug>(fzf-complete-path)

" quick fix window
map <leader>h :cn<CR>
map <leader>l :cp<CR>
nnoremap <silent> <leader>o :call ToggleQuickFix()<cr>

" Toggle case sensitive search
nnoremap <leader>i :set ignorecase! ignorecase?<cr>

map <leader>c :call ToggleSpellCheck()<CR>

" Highlight under current word
let g:highlighting = 0
nnoremap <silent> <expr> <CR> Highlighting()

cnoremap YMD <C-R>=strftime("%Y_%m_%d")<CR>

" LSP Navigate Errors
map <leader>j :lua vim.diagnostic.goto_next()<cr>
map <leader>k :lua vim.diagnostic.goto_prev()<cr>
" Display all errors.
map <leader>q :lua vim.diagnostic.setloclist()<CR>

map <F8> :call CompileFile() <CR>
map <F9> :call FastCompileFile() <CR>

" Toggle focus mode.
nmap <leader>f :Goyo 100x100%<CR>
nmap <leader>g :Goyo 100-25%x100%<CR>

" Copy github link to line numbers.
nmap <leader>m :'<,'>GetCurrentBranchLink<CR>

function SetLspOptions()
  " LSP Symbols
  map <c-]> :lua vim.lsp.buf.definition()<CR>
  map [I :lua vim.lsp.buf.references()<CR>
  map K :lua vim.lsp.buf.hover()<CR>
  map gK :lua vim.lsp.buf.signature_help()<CR>
  " The same as declaration
  " map <leader>D :lua vim.lsp.buf.type_definition()<CR>
  " map gd :lua vim.lsp.buf.definition()<CR>
  "
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File specific settings.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufNewFile,BufRead *.py call SetPythonOptions()

function SetPythonOptions()
  call SetLspOptions()
  nnoremap <leader>^ :call FindReplaceMultiFile()<CR>
  nnoremap <leader>& :call FindReplaceUnderWordMultiFile("/gj **/*.yaml **/*.py")<CR>

  " Create the tags output directory
  :silent exec "!mkdir -p ~/.tags/`pwd`"
  map <leader>e obreakpoint()<C-c>

  " Auto formatters.
  "autocmd BufWritePre *.py silent! call Black()
  " autocmd BufWritePre *.py execute ':Isort'
  " autocmd FocusLost *.py silent! TagbarClose
  " autocmd FocusGained *.py silent! TagbarOpen
  "autocmd BufWritePost *.py silent! Semshi enable
  autocmd VimEnter,BufNewFile,BufRead,VimResized *.py call PythonRefreshWindow()

  set signcolumn=number

endfunction

" Called whenever the window is refreshed
function PythonRefreshWindow()
  " Ensure all syntax highlighting is active.
  :Semshi enable
  if (winwidth(0) > 120)
    :TagbarOpen
  else
    :TagbarClose
  endif
endfunction

autocmd BufRead,BufNewFile *.cmd call SetCmdOptions()
function SetCmdOptions()
	set syntax=sh
  nnoremap j gj
  nnoremap k gk
  set wrap linebreak nolist
  set nonumber
  set norelativenumber
endfunction

" Options for markdown, md 
autocmd BufRead,BufNewFile *.md,*.rst,*.asc call SetMdOptions()
function SetMdOptions()
  setf markdown
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4
	set expandtab
	set autoindent
	set nospell
  nmap <leader>t :Toc<CR>
	set textwidth=0
  nnoremap j gj
  nnoremap k gk
  set wrap linebreak nolist
  set signcolumn=no

  nmap <leader>z :call AutoOpenEntry()<CR>

  " Disable the auto complete
  :lua require('cmp').setup.buffer { enabled = false }
endfunction

" Options for LaTex
autocmd BufNewFile,BufRead *.tex call SetTexOptions()
function SetTexOptions()
	set tabstop=2
	set softtabstop=2
	set shiftwidth=2
	set expandtab
	set autoindent
	set textwidth=0
  set linebreak
	set nospell
  hi Error NONE
  hi clear Conceal
  set signcolumn=no
  nnoremap j gj
  nnoremap k gk
  set wrap linebreak nolist
  nnoremap <leader>& :call FindReplaceUnderWordMultiFile("/gj **/*.tex")<CR>
  noremap <leader>v :call AutoTex()<CR>
  " Disable the auto complete
  :lua require('cmp').setup.buffer { enabled = false }

  noremap <leader>b :call FastTex()<CR>
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Macro to compile current LaTeX file.
function! CompileFile()
	let current_filetype = &filetype
	if current_filetype == 'python'
		:wa | !python %:t
  elseif current_filetype == 'tex'
    :wa | !pdflatex main.tex
	endif
endfunction

function! FastCompileFile()
	let current_filetype = &filetype
  if current_filetype == 'tex'
    :wa | !pdflatex -draftmode main.tex
	endif
endfunction

function! ToggleSpellCheck()
	set spell!
	if &spell
		echo "Spellcheck ON"
	else
		echo "Spellcheck OFF"
	endif
endfunction

" Find and replace across multiple files
function FindReplaceUnderWordMultiFile(findStr)
  let find = expand("<cword>")
  let replace = input('Replace: ')

  execute "vimgrep /" . find . a:findStr
  :copen
  execute "cfdo %s/" . find . "/" . replace . "/gc"
endfunction

function! ToggleQuickFix()
    " From https://stackoverflow.com/questions/11198382/how-to-create-a-key-map-to-open-and-close-the-quickfix-window-in-vim
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

function! Highlighting()
  if g:highlighting == 1 && @/ =~ '^\\<'.expand('<cword>').'\\>$'
    let g:highlighting = 0
    set nohlsearch
    return ":silent nohlsearch\<CR>"
  endif
  let @/ = '\<'.expand('<cword>').'\>'
  let g:highlighting = 1
  return ":silent set hlsearch\<CR>"
endfunction

function AutoOpenEntry()
  :wa
  let projName = input('Project: ')
  let projPath = system('python entry.py ' . projName)
  let projPath = projPath[:len(projPath)-2]

  execute "e " . projPath
endfunction

function AutoTex()
  let b:vimtex_main=expand('%:p')
  :VimtexReloadState
  :VimtexStopAll
  :VimtexCompile
endfunction


function FastTex()
  set updatetime=750
  set so=999
  silent !rm ~/Downloads/fast_build/*.log ; rm ~/Downloads/fast_build/*.out ; rm ~/Downloads/fast_build/*.aux ; mkdir -p ~/Downloads/fast_build/
  silent !touch ~/Downloads/fast_build/note.txt 
  silent !pdflatex -interaction nonstopmode -output-directory ~/Downloads/fast_build/ %

  let curFile = expand('%:t:r')
  silent exec "! open -a Skim ~/Downloads/fast_build/" . curFile . ".pdf"
  autocmd TextChanged,TextChangedI *.tex silent call FastCompile()
endfunction

function FastCompile()
  write

  if !empty(expand(glob("~/Downloads/fast_build/note.txt")))
    exec "! rm ~/Downloads/fast_build/* ; { pdflatex -interaction nonstopmode -output-directory ~/Downloads/fast_build/ " . @% . " ; touch ~/Downloads/fast_build/note.txt } > test.log 2>&1 &"
  endif
endfunction

" Find and replace across multiple files
function FindReplaceMultiFile()
  let findMulti = input('Find: ')
  let replaceMulti = input("Replace: ")
  let searchExtsMulti = input('Search Extensions (ex **/*.yaml): ')
  execute "vimgrep /" . findMulti . "/gj " . searchExtsMulti
  :copen
  execute "cfdo %s/" . findMulti . "/" . replaceMulti . "/gc"
endfunction

" Limelight settings.
function! ToggleFocusMode()
  :Goyo 100-25%x100%
endfunction
autocmd! User GoyoLeave silent! source $HOME/.config/nvim/init.vim

augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWriteLock
augroup END

function! SetDarkMode()
  color default

  hi clear Conceal
  highlight clear Conceal
endfunction
function! SetLightMode()
  " For light color
  color delek
  function MyCustomHighlights()
    " Default
    hi semshiLocal           ctermfg=209 guifg=#ff875f
    hi semshiGlobal          ctermfg=214 guifg=#ffaf00
    hi semshiImported        ctermfg=214 guifg=#ffaf00 cterm=bold gui=bold
    hi semshiParameter       ctermfg=75  guifg=#5fafff
    hi semshiParameterUnused ctermfg=117 guifg=#87d7ff cterm=underline gui=underline
    hi semshiFree            ctermfg=218 guifg=#ffafd7
    hi semshiBuiltin         ctermfg=207 guifg=#ff5fff
    hi semshiAttribute       ctermfg=25   guifg=#5fffaf
    hi semshiSelf            ctermfg=249 guifg=#b2b2b2
    hi semshiUnresolved      ctermfg=58 guifg=#5f5f00  cterm=underline gui=underline
    hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#d7005f

    hi semshiErrorSign       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
    hi semshiErrorChar       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
    sign define semshiError text=E> texthl=semshiErrorSign
  endfunction
  autocmd FileType python call MyCustomHighlights()
  autocmd ColorScheme * call MyCustomHighlights()

  hi clear Conceal
  highlight clear Conceal
endfunction


call SetDarkMode()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

