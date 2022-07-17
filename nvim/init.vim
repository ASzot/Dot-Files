"" auto install vim-plug
"let plug_install = 0
"let autoload_plug_path = stdpath('data') . '/autoload/plug.vim'
"if !filereadable(autoload_plug_path)
"    execute '!curl -fL --create-dirs -o ' . autoload_plug_path .
"        \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
"    execute 'source ' . fnameescape(autoload_plug_path)
"    let plug_install = 1
"endif
"unlet autoload_plug_path

call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lualine/lualine.nvim'

Plug 'junegunn/fzf.vim'

" Nerdtree
Plug 'preservim/nerdtree'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind-nvim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

Plug 'christoomey/vim-tmux-navigator'

Plug 'lervag/vimtex'
Plug 'majutsushi/tagbar'

" For vim markdown (both required)
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'rhysd/conflict-marker.vim'

call plug#end()

set completeopt=menu,menuone,noselect

lua require('config')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vanilla Editor setup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable swp files.
set nobackup
set noswapfile
let mapleader = ","

" Change copy and paste to sync with the system clipboard.
set clipboard^=unnamed

" Set default to be  relative numbering. 
set rnu
set nonumber

" Redo
map <F7> :redo <CR>

" Rebind delete to have a no copy version.
nnoremap <leader>d "_d

" Toggle line numbers
nnoremap <leader>w :set relativenumber!<CR>

" Find and replace 
nnoremap <leader>* :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Find and replace across multiple files
function FindReplaceUnderWordMultiFile(findStr)
  let find = expand("<cword>")
  let replace = input('Replace: ')

  execute "vimgrep /" . find . a:findStr
  :copen
  execute "cfdo %s/" . find . "/" . replace . "/gc"
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

" quick fix window
map <leader>h :cn<CR>
map <leader>l :cp<CR>
function! ToggleQuickFix()
    " From https://stackoverflow.com/questions/11198382/how-to-create-a-key-map-to-open-and-close-the-quickfix-window-in-vim
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <silent> <leader>o :call ToggleQuickFix()<cr>

" Toggle case sensitive search
nnoremap <leader>i :set ignorecase! ignorecase?<cr>

let g:highlighting = 0
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
nnoremap <silent> <expr> <CR> Highlighting()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Setup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF settings
set rtp+=~/.fzf
nmap <c-f> :Files<CR>
nmap <Space>a :Buffers<CR>
nmap <Space>f :Ag<Space>
nmap <Space>t :Ag<Space>(^\%\@).*
" Remove the '!' if you don't want this to open up a new window. 
noremap <Space>e :Ag! <C-r>=expand('<cword>')<CR><CR>
imap <c-x><c-f> <plug>(fzf-complete-path)
let g:fzf_layout = {'down':'30'}



" Tree
" https://github.com/kyazdani42/nvim-tree.lua
map <C-r> :NvimTreeToggle<CR>
map <C-r> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" LSP
map <leader>j :lua vim.diagnostic.goto_next()<cr>
map <leader>k :lua vim.diagnostic.goto_prev()<cr>
map gd :lua vim.lsp.buf.declaration()<CR>
map K :lua vim.lsp.buf.hover()<CR>
map gK :lua vim.lsp.buf.signature_help()<CR>
map <leader>rn :lua vim.lsp.buf.rename()<CR>
map gr :lua vim.lsp.buf.references()<CR>
" Display all errors.
map <leader>q :lua vim.diagnostic.setloclist()<CR>

" The same as declaration
" map <leader>D :lua vim.lsp.buf.type_definition()<CR>
" map gd :lua vim.lsp.buf.definition()<CR>



let g:tmux_navigator_save_on_switch = 2

" Macro to compile current LaTeX file.
map <F8> :call CompileFile() <CR>
map <F9> :call FastCompileFile() <CR>
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

map <leader>c :call ToggleSpellCheck()<CR>

" Snipets
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
nmap <leader>u :put =system('echo \\label{$RANDOM}')<CR>

" Set popup menu color
highlight Pmenu ctermbg=gray guibg=gray
highlight SignColumn ctermbg=gray guibg=gray

" To automatically reload the file on external changes
set autoread
au CursorHold * checktime

let &titlestring = @%
set title

set nohlsearch

set conceallevel=2
hi clear Conceal
highlight clear Conceal

cnoremap YMD <C-R>=strftime("%Y_%m_%d")<CR>
set wildmode=longest,list,full
" Unfold by default
au BufRead * normal zR
map <leader>e obreakpoint()<C-c>

autocmd BufNewFile,BufRead *.py call SetPythonOptions()
function SetPythonOptions()
  nnoremap <leader>^ :call FindReplaceMultiFile()<CR>
  nnoremap <leader>& :call FindReplaceUnderWordMultiFile("/gj **/*.yaml **/*.py")<CR>

  nmap <leader>y :!ctags -R -f ~/.tags/`pwd`/tags --fields=+l --languages=python --python-kinds=-iv --exclude=.git --exclude=.mypy_cache `pwd` <CR>

  " Create the tags output directory
  :silent exec "!mkdir -p ~/.tags/`pwd`"

endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Options for markdown, md 
function AutoOpenEntry()
  let projName = input('Project: ')
  let projPath = system('python entry.py ' . projName)
  let projPath = projPath[:len(projPath)-2]

  execute "open " . projPath
endfunction
autocmd BufRead,BufNewFile *.md,*.rst call SetMdOptions()
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

  """"""""""""""""""""""""""""""""""""""""""""""""""""""
  " Auto entry wiki options

  nmap <leader>z :call AutoOpenEntry()<CR>
  """"""""""""""""""""""""""""""""""""""""""""""""""""""
endfunction


" Options for LaTex
function AutoTex()
   :VimtexStopAll
   :VimtexCompile
endfunction
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
  map <leader>r O%R: 
  hi Error NONE
  nnoremap j gj
  nnoremap k gk
  set wrap linebreak nolist
  nnoremap <leader>& :call FindReplaceUnderWordMultiFile("/gj **/*.tex")<CR>
  noremap <leader>v :call AutoTex()<CR>
  # Disable the auto complete
  :lua require('cmp').setup.buffer { enabled = false }
endfunction


nmap <leader>t :TagbarOpen fj<CR>
let g:tagbar_autofocus = 0 
let g:tagbar_left = 1

let g:vimtex_view_method = 'skim'
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_mode = 0
"let g:vimtex_quickfix_autoclose_after_keystrokes=2
"let g:vimtex_quickfix_enabled = 0
let g:vimtex_compiler_latexmk = {
            \ 'build_dir' : '/tmp',
            \}


