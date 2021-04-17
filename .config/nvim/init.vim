" vim:fdm=marker
" vim:set foldlevel=0

"TODO
"fix keep jumps normal
"startify settings
"add rust devicon-lookup

"Install plugin manager if it doesnt exist {{{
"
" set backupcopy=yes # for when editing a docker mounted file
if empty(glob('$XDG_DATA_HOME/nvim/site/autoload/plug.vim'))
  silent !curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"}}}
"Plugins {{{
augroup pluginscommands
au!
call plug#begin('$XDG_DATA_HOME/nvim/plugged')
">>> UI {{{
    Plug 'yegappan/taglist'
        "config {{{
        nmap <leader>tl :TlistToggle<cr>
        let Tlist_WinWidth=70
        let Tlist_Exit_OnlyWindow=1
        let Tlist_Show_One_File=1
        let Tlist_Use_Right_Window=1
        " let Tlist_GainFocus_On_ToggleOpen=1
        "}}}
    Plug 'scrooloose/nerdtree'
        "config {{{
        nmap <leader>nt :NERDTreeToggle<cr>
        let NERDTreeMapOpenSplit='s'
        let NERDTreeMapActivateNode='l'
        let NERDTreeMapOpenVSplit='v'
        let NERDTreeWinSize=50
        "}}}
    Plug 'mhinz/vim-startify'
    "disabled {{{
    "Plug 'mhinz/vim-grepper'
    "}}}
" }}}
">>> syntax and autofill {{{
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
        "config {{{
        Plug 'Shougo/neco-vim'
        Plug 'neoclide/coc-neco'
		nnoremap <leader>ho :call <SID>show_documentation()<CR>
        let g:coc_global_extensions = [
          \ 'coc-diagnostic',
          \ 'coc-pyright',
          \ 'coc-rls', 
          \ 'coc-eslint',
          \ 'coc-tsserver',
          \ 'coc-lists', 
          \ 'coc-css',
          \ 'coc-json',
          \ 'coc-yaml',
          \ 'coc-snippets',
          \ 'coc-solargraph',
          \ 'coc-html',
          \ 'coc-snippets',
          \ 'coc-stylelint',
          \ 'coc-solargraph',
          \]
        set shortmess+=c | "don't give |ins-completion-menu| messages. (coc)
        nmap <leader>dn <Plug>(coc-definition)zz
        nmap <leader>dt :tab split<cr> <Plug>(coc-definition)zz
        nmap <leader>ds :split<cr> <Plug>(coc-definition)zz
        nmap <leader>dv :vsplit<cr> <Plug>(coc-definition)zz
        nmap <leader>rn <Plug>(coc-rename)
        nmap <leader>rr <Plug>(coc-references)
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)
        command! -nargs=? Fold :call     CocAction('fold', <f-args>)
        command! -nargs=0 ORGI   :call     CocAction('runCommand', 'editor.action.organizeImport')
        nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>
        autocmd CursorHold * silent call CocActionAsync('highlight')
        let g:coc_data_home = stdpath('data') . '/coc'
        " }}}
    Plug 'frazrepo/vim-rainbow'
        "config {{{
        let g:rainbowftToIgnore = ['nerdtree','lazydocker','term']
        " }}}
    Plug 'sheerun/vim-polyglot'
        "config {{{
        let g:polyglot_disabled = ['python-indent']
        "}}}
    "disabled {{{
    "Plug 'vim-python/python-syntax'
    "Plug 'Nader-gator/vim-polyglot'
    "Plug 'andymass/vim-matchup'
    " Plug 'dense-analysis/ale'
        "config :TODO fix linting situation {{{
        "
        " nmap <leader>fd :let b:ale_fix_on_save = 0<cr>
        " nmap <leader>fe :let b:ale_fix_on_save = 1<cr>
        " nmap <leader>tl :ALEToggle<cr>|
        " nmap <leader>fix :ALEFix<cr>
        "
        " let g:ale_fixers = {
        " \   '*': ['remove_trailing_lines', 'trim_whitespace'],
        " \   'javascript': ['eslint'],
        " \   'python': ['autopep8'],
        " \   'ruby': ['standardrb']
        " \   }
        " let g:ale_linters = {
        " \   'ruby': ['standardrb'],
        " \   'python': ['pyls'],
        " \   'rust': ['cargo', 'rls'],
        " \   'javascriptreact': []
        " \   }
        " let g:ale_completion_enabled = 0
        " let g:ale_fix_on_save = 1
        " let g:ale_disable_lsp = 0
        " let g:ale_lint_on_text_changed = 0
        " let g:ale_lint_on_insert_leave = 0
        " let g:ale_lint_on_enter = 0
        " let g:ale_lint_on_save = 0
        " let g:ale_lint_on_filetype_changed = 0
        "
        " nmap <leader>dn :ALEGoToDefinition<cr>zz
        " nmap <leader>dt :tab split<cr> :ALEGoToDefinition<cr>zz
        " nmap <leader>ds :split<cr> :ALEGoToDefinition<cr>zz
        " nmap <leader>dv :vsplit<cr> :ALEGoToDefinition<cr>zz
		" nnoremap <leader>doc :ALEHover<CR>
        "}}}
    "}}}
"}}}
" >>> Themses and visual {{{
    "Plug 'vim-airline/vim-airline-themes'
    Plug 'vim-airline/vim-airline'
        " config {{{
        " WindowNumber (for airline) {{{
        function! WindowNumber(...)
            let builder = a:1
            let context = a:2
            call builder.add_section('airline_c', '%{tabpagewinnr(tabpagenr())}')
            return 0
        endfunction
        " }}}
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_highlighting_cache = 1
        let g:airline_powerline_fonts = 1
        let g:airline#extensions#tabline#show_tab_nr = 1
        let g:airline#extensions#tabline#formatter = 'unique_tail'
        let g:airline#extensions#branch#enabled = 1
        let g:airline#extensions#hunks#enabled = 1
        let g:airline_section_b = '%{strftime("%H:%M")}'
        " }}}
    Plug 'Yggdroot/indentLine'
        " config {{{
        let g:indentLine_char_list = ['│']
        let g:indentLine_leadingSpaceEnabled = 1
        let g:indentLine_leadingSpaceChar = '·'
        let g:indentLine_fileTypeExclude = ['markdown','nerdtree', '']
        let g:indentLine_bufNameExclude = ['_.*', 'NERD_tree.*']
        autocmd FileType nerdtree IndentLinesDisable
        " let g:indentLine_newVersion=0 fuck this thing, don't enable
        " let g:indentLine_faster = 1
        "}}}
    Plug 'junegunn/goyo.vim'
        "config {{{
        nmap <leader>goy :Goyo 90x90<cr>
        "}}}
    " Plug 'joshdick/onedark.vim'
    Plug 'morhetz/gruvbox'
    Plug 'ryanoasis/vim-devicons' "MAYBE, 4 ms startup
    " disabled {{{
     "Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': 'NERDTreeToggle' }
     "Plug 'TaDaa/vimade'
     "}}}
 " }}}
">>> Motion and navigation {{{
    Plug 'justinmk/vim-sneak'
    Plug 'wesQ3/vim-windowswap'
        "config {{{
        autocmd VimEnter * nunmap <leader>yw
        autocmd VimEnter * nunmap <leader>pw
        "}}}
    "disabled {{{
    "Plug 'terryma/vim-multiple-cursors'
    "Plug 'easymotion/vim-easymotion'
        " config {{{
        " let g:EasyMotion_keys='edcrfvtgbyhnujm'
        " map <leader>q <Plug>(easymotion-prefix)
        " }}}
    "}}}
" }}}
 ">>> ease of use {{{
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
        "config {{{
        " let $FZF_DEFAULT_COMMAND='ag -l --path-to-ignore ~/.ignore --nocolor --hidden -g ""'
        let $FZF_SPEFICAL_CMD='ag -l --path-to-ignore ~/.ignore --nocolor --hidden -g ""'
        let $FZF_CTRL_T_COMMAND="$FZF_SPEFICAL_CMD"
        let $FZF_DEFAULT_OPTS='--layout=reverse'
        nmap <leader>fj :call Fzf_files_with_dev_icons($FZF_SPEFICAL_CMD,0)<CR>
        nmap <leader>ff :call Fzf_files_with_dev_icons($FZF_SPEFICAL_CMD,1)<CR>
        nmap <leader>git :call Fzf_git_diff_files_with_dev_icons()<CR>
        nmap <C-f> :Files<cr>|    "fuzzy find files in the working directory (where you launched Vim from)
        nmap <leader>fl :Lines<cr>|   "fuzzy find lines in the current file
        nmap <leader>fb :Buffers<cr>|  "fuzzy find an open buffer
        nmap <leader>ft :Tags<cr>|     "fuzzy find text in the working directory
        nmap <leader>fc :Commands<cr>| "fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
        nmap <leader>fg :Ag<cr>
        let g:fzf_action = {
          \ 'ctrl-t': 'tab split',
          \ 'ctrl-s': 'split',
          \ 'ctrl-v': 'vsplit' }
        command! -bang -nargs=+ -complete=dir Rag call fzf#vim#ag_raw(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
        " command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
        command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

        " let g:fzf_layout = { 'window': 'call FloatingFZF()' }
        "}}}
    Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
        "config {{{
        autocmd Filetype tex setl updatetime=1
        let g:livepreview_previewer = 'open -a Preview'
        nmap <leader>ltx :LLPStartPreview<cr>
        "}}}
    Plug 'junegunn/vim-easy-align'
        "config {{{
        xmap ga <Plug>(EasyAlign)
        nmap ga <Plug>(EasyAlign)
        "}}}
    Plug 'tomtom/tcomment_vim'
        "config {{{
        nmap <C-c> gcc
        "}}}
    Plug 'gu-fan/colorv.vim', {'on': 'ColorVEdit'}
        " config {{{
        nmap <leader>ec :ColorVEdit<cr>
        " }}}
    Plug 'FooSoft/vim-argwrap'
        "config {{{
        nnoremap <leader>aw :ArgWrap<CR>
        "}}}
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
        " config {{{
        let g:mkdp_auto_close = 0
        " }}}
    Plug 'tpope/vim-eunuch' "TODO: look up quickfix window for Cfind
    Plug 'tpope/vim-surround'
    Plug 'nader-gator/vim-http-client'
        "config {{{
        let g:http_client_json_ft = 'json'
        let g:http_client_bind_hotkey = 0
        "}}}
    Plug 'lambdalisue/suda.vim'
        "config {{{
        let g:suda_smart_edit = 1
        "}}}
    "disabled {{{
    "Plug 'vimlab/split-term.vim'
    "Plug 'jeetsukumaran/vim-pythonsense' TODO: find replacement
    "Plug 'brooth/far.vim' TODO: find replacement
    "Plug 'vim-scripts/LineJuggler' | Plug 'inkarkat/vim-ingo-library'
    "Plug 'scrooloose/nerdcommenter'
    "Plug 'vim-scripts/greplace.vim'
    "Plug 'mattn/emmet-vim'
        "config {{{
    "     let g:user_emmet_leader_key=','
    "     let g:user_emmet_install_global = 0
    "     let g:user_emmet_mode='i'
    "     autocmd FileType html,css EmmetInstall
        "}}}
    "}}}
 "}}}
">>> invisible help {{{
    Plug 'chemzqm/vim-jsx-improve'
    Plug 'ianding1/leetcode.vim'
        "config {{{
        let g:leetcode_solution_filetype='python'
        let g:leetcode_username='nader-gator'
        "}}}
    Plug 'editorconfig/editorconfig-vim'
        "config {{{
        let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']
        "}}}
    Plug 'alvan/vim-closetag' "auto close html tags with >>
    " Plug 'tmhedberg/SimpylFold' "folding for python
    Plug 'Konfekt/FastFold'
    Plug 'tpope/vim-repeat'
    Plug 'jiangmiao/auto-pairs'
    "disabled {{{
    "Plug 'tpope/vim-sensible'
    "Plug 'ryvnf/readline.vim'
    " Plug 'cohama/lexima.vim'
        "config {{{
        " nmap <leader>lt :let b:lexima_disabled = get(b:, 'lexima_disabled', 1)<cr>
        "}}}
    "Plug 'rizzatti/dash.vim'
        "config {{{
        "nmap <leader>da <Plug>DashSearch
        "}}}
    "Plug 'Raimondi/delimitMate'
        "config {{{
        " nmap <silent> <leader>bt :DelimitMateSwitch<cr>
        " let delimitMate_expand_cr = 2
        " let delimitMate_expand_space = 1
        " let delimitMate_expand_inside_quotes = 1
        " let delimitMate_jump_expansion = 1
        " let delimitMate_balance_matchpairs = 1
        " let delimitMate_excluded_regions = ""
        "}}}
    "}}}
"}}}
">>> Git {{{
    Plug 'airblade/vim-gitgutter'
        "config {{{
        nmap <leader>ggt :GitGutterToggle<cr>
        nmap <Leader>gd <Plug>(GitGutterPreviewHunk)
        nmap <Leader>gu <Plug>(GitGutterUndoHunk)
        let g:gitgutter_preview_win_floating = 0
        " let g:gitgutter_enabled = 0
        "}}}
    "disabled {{{
    "Plug 'tpope/vim-fugitive'
    "}}}
"}}}
call plug#end()
"post plug commands {{{
    "vim-airline/vim-airline {{{
    autocmd VimEnter * call airline#add_statusline_func('WindowNumber')
    autocmd VimEnter * call airline#add_inactive_statusline_func('WindowNumber')
    "}}}
"}}}
augroup END
"}}}
"basic config {{{
" set re=1
set lazyredraw
set guioptions=M
set splitbelow
set splitright
set mouse=a
set fileignorecase
syntax on
" colorscheme onedark
colorscheme gruvbox
highlight CursorLineNr guifg=#e28409
set colorcolumn=120
set updatetime=10 | "gut gutter wants 400 coc wants 300
set signcolumn=yes | "always show signcolumns (coc)
set ignorecase
set number relativenumber
set undofile
set undodir=~/.vim/undodir
"tabs
    set expandtab
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set autoindent
    set smartindent
"}}}
"sensible stuff {{{
filetype plugin indent on
set modeline
set foldlevel=99
set display+=lastline
set autoindent
set foldmethod=indent
set backspace=start,eol ",indent
set complete-=i "C- P and N
set nrformats-=octal "inc num C-a, decrease C-x
set ttimeout
set ttimeoutlen=100
set incsearch
set synmaxcol=500
set laststatus=2
set ruler
set wildmenu
set scrolloff=0
"}}}
"key mappings {{{
    "simple maps {{{
        nnoremap <leader>v :e ~/.config/nvim/init.vim<cr>
        nnoremap <leader>sv :source ~/.config/nvim/init.vim<cr>
        nmap <BS> \
        nmap <BS><BS> \\
        nnoremap * m`:keepjumps normal! *``<cr>
        nnoremap <Space> :noh<cr>
        nmap <leader>tn :tabnew<cr>
        nmap Q :q<cr>
        nmap ]w :w<cr>
        nmap ]W :noa w<cr>
        nmap <leader>wd 1<C-g>
        nnoremap <leader>tc :tab split<CR>
        nnoremap <expr> <leader>fa &foldlevel ? 'zM' :'zR'
        inoremap <C-l> <Del>
        " nnoremap <silent> <C-p> o<C-r>"<esc>k
        " nnoremap <silent> <C-[> O<C-r>"<esc>j
        nnoremap <leader>bb :Buffers<cr>
    "}}}
    "command line movement {{{
        cnoremap <C-w> <S-Right>
        cnoremap <C-b> <S-Left>
        cnoremap <C-h> <left>
        cnoremap <C-j> <down>
        cnoremap <C-k> <up>
        cnoremap <C-l> <right>
        cnoremap <C-b> <home>
        cnoremap <C-e> <end>
    "}}}
    "window navigation {{{
        nnoremap <C-h> <C-w>h
        nnoremap <C-j> <C-w>j
        nnoremap <C-k> <C-w>k
        nnoremap <C-l> <C-w>l
        nnoremap <C-m> gt
        nnoremap <C-n> gT
    "}}}
    "copy/pasting/pasting {{{
            "Copy to clipboard
            nnoremap  Y  "+Y
            vnoremap  y  "+y
            nnoremap  y  "+y
            nnoremap  yy  "+yy
            nnoremap <leader>p "+p
        "disabled {{{
            "Paste from clipboard
            " nnoremap P "+P
            " vnoremap P "+P
            " nnoremap p "+p
            " vnoremap p "+p
            "deleting pasting
            " nnoremap d "ad
            " vnoremap d "ad
            " nnoremap dd "add
            " nnoremap <leader>pp "ap
            " "Copy to clipboard
            " vnoremap  y  "+y
            " nnoremap  Y  "+yg_
            " nnoremap  y  "+y
            " nnoremap  yy  "+yy
            " "Paste from clipboard
            " nnoremap p "+p
            " nnoremap P "+P
            " vnoremap p "+p
            " vnoremap P "+P
        "}}}
    "}}}
    "floating menu nav {{{
        inoremap <expr> <C-j> pumvisible() ? "\<C-n>": "\<C-j>"
        inoremap <expr> <C-k> pumvisible() ? "\<C-p>": "\<C-k>"
    "}}}
    "Terminal {{{
        nmap <silent><leader>ts :new term://zsh<cr>
        nmap <silent><leader>tv :vnew term://zsh<cr>
        nmap <silent><leader>tt :tabnew term://zsh<cr>
        tnoremap <C-]> <C-\><C-n>
        autocmd BufWinEnter,WinEnter * if &buftype == 'terminal' | call SetTerm() | endif
        function! SetTerm()
            call rainbow#inactivate()
            setlocal bufhidden=hide
            nmap <buffer><silent><leader>bk :bd!<cr>
            nmap <buffer>Q :q<cr>:echo "process sent to background"<cr>
        endfunction
        autocmd TermOpen * startinsert
        autocmd TermOpen * setlocal listchars= nonumber norelativenumber
    "}}}
    "adding newline {{{
        nnoremap <silent> <A-d> :<C-u>call append(line("."),   repeat([""], v:count1))<CR>
        nnoremap <silent> <A-u> :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>
    "}}}
    "function calls {{{
        nnoremap <leader>zz :call VCenterCursor()<CR>
        xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
        nmap <leader>dd :call ToggleLazyDocker()<cr>
        nmap <leader>bdd :call ToggleLazyDockerBackground()<cr>
    "}}}
    "workspace mapping {{{
        if stridx(getcwd(), "Code_stuff/vero") != -1
            nnoremap <silent><leader>gp :!cd ~/Code_stuff/vero/libs/vero_grpc_lib;./compile.sh<cr>
        endif
    "}}}
"}}}
"language specific mapping {{{
augroup ftcheck
autocmd!
    "C{{{
    autocmd FileType c call SetClang()
    function! SetClang()
        nmap <leader>mm :w \|!gcc % && ./a.out<cr>
    endfunction
    "}}}
    "C++{{{
    autocmd FileType cpp call SetCpplang()
    function! SetCpplang()
        nmap <leader>mm :w \|!g++ % && ./a.out<cr>
    endfunction
    "
    "}}}
    "Rust{{{
    autocmd FileType rust call SetRustlang()
    function! SetRustlang()
        if @% == 'src/lib.rs' |
            nmap <leader>mm :w \|!cargo check<cr>
            | else |
            nmap <leader>mm :w \|!cargo run<cr>
            | endif
    endfunction
    "
    "}}}
    "Haskell{{{
    autocmd FileType haskell call SetHaskelllang()
    function! SetHaskelllang()
        nmap <leader>mm :w \|!ghc % && ./%:r<cr>
    endfunction
    "
    "}}}
    "Python{{{
    autocmd FileType python call SetPython()
    function! SetPython()
        nmap <leader>db  obreakpoint(context=10<esc>
        nmap <leader>cl o""""""<esc>3ha
        nmap <leader>co o""""""<esc>3ha<cr><esc>O
        nmap <leader>mp :w \|! mypy %<cr>
        nmap <leader>mm :w \|! python3 %<cr>
        set nofoldenable
        set foldlevel=99
    endfunction
    "}}}
    "HTML{{{
    autocmd FileType html call SetHTML()
    function! SetHTML()
        imap <leader>t {%  %}<Left><Left><Left>
        call rainbow#clear()
    endfunction
    "}}}
    "dtl {{{
      autocmd BufNew,BufRead *.dtl call Setdtl()
      function! Setdtl()
        set syntax=html
        set filetype=html
        call rainbow#clear()
      endfunction
    "}}}
    "Sass {{{
      autocmd BufNew,BufRead *.scss call SetSass()
      function! SetSass()
        call rainbow#clear()
      endfunction
    "}}}
    "CSON {{{
    autocmd BufNew,Bufread *.cson call SetCSON()
    function! SetCSON()
        set filetype=markdown
        IndentLinesDisable
    endfunction
    "}}}
    "HTTP {{{
    autocmd BufNew,Bufread *.http call SetHTTP()
    function! SetHTTP()
        set filetype=http
        set foldmethod=marker
        silent! nnoremap <buffer><Leader>mm :HTTPClientDoRequest<cr>
    endfunction
    "all files {{{
    " 1mb
    autocmd Filetype * call SetAllFiles()
    function! SetAllFiles()
        if getfsize(expand(@%)) > 5000000 || (line2byte(line('$') + 1) / line('$')) > 1000
            setlocal syntax=OFF
            call CocDisable
        endif
        let syntaxFoldft = ['python', 'rust']
        if index(syntaxFoldft,&ft) > -1
            set foldmethod=syntax
        endif
        if index(g:rainbowftToIgnore ,&ft) < 0 && line2byte(line("$") + 1) < 40000
            call rainbow#load()
        endif
    endfunction
    " }}}
    "}}}
    ".env files{{{
    autocmd BufNew,BufRead .env* set filetype=sh
    "}}}
augroup END
"}}}
"autocommands {{{
augroup numbertoggle
autocmd!
let alwaysRelative = ['nerdtree', 'taglist']
let neverRelative = ['startify', 'lazydocker', 'term', '']
let ftToIgnore = ['nerdtree', 'startify', 'lazydocker', 'term', '']
autocmd BufEnter,FocusGained,InsertLeave * if index(neverRelative,&ft) < 0 |:set relativenumber
autocmd BufLeave,FocusLost,InsertEnter * if index(alwaysRelative,&ft) < 0|:set norelativenumber
autocmd FileType nerdtree set relativenumber
" fucks with markdown preview for some reason
" autocmd BufEnter,FocusGained * if &buftype == 'terminal' |:set norelativenumber
" autocmd BufLeave,FocusLost * if  &buftype == 'terminal' |:set norelativenumber
" augroup END
" au BufReadPost *.html set filetype=html
augroup lazydocker
autocmd!
autocmd Filetype lazydocker set norelativenumber
autocmd Filetype lazydocker tmap <silent><buffer>Q <C-\><C-n> Q
" file
augroup END
"}}}
"iterative mapping {{{
let i = 1
while i <= 20
    execute 'nnoremap <Leader>' . i . '<Space>' . ' :' . i . 'wincmd w<CR>'
    execute 'nnoremap ]' . i . '<Space> ' .  i . 'gt'
    execute 'nmap <Leader>di' . i . '<Space>' .
                \ ' :let buffno=bufnr("%")<cr>' .
                \ ':let linepos=line(".")<cr>:let colpos=col(".")<cr> :' . i .
                \ 'wincmd w<cr>:execute("buffer ".buffno)<cr>:call cursor(linepos,colpos)<cr>' .
                \ ' <Plug>(coc-definition)zz'
    let i = i + 1
endwhile
"}}}
"commands {{{
command! -bang -bar -nargs=? -complete=file E :call s:MKDir(<f-args>) | e<bang> <args>
"}}}
"gui related configs {{{
if (has("nvim"))
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
set termguicolors
endif
"}}}
"function definitions {{{
"FZF optiona and DEVICON function {{{
"normal search {{{
function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  " let row = &lines * 80
  let row = &lines * 0.2
  let height = float2nr(&lines - (row * 1.3))
  let width = float2nr(&columns - (&columns * 3 / 10))
  let col = float2nr((&columns - width) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

function! Fzf_files_with_dev_icons(default_command,optional)
   "let l:fzf_files_options = '--preview "rougify {2..-1} | head -'.&lines.'"'
    if a:optional == 1
     let l:fzf_files_options = '--preview "bat --color always --style numbers {2..} | head -'.&lines.'"'
    elseif a:optional == 0
     let l:fzf_files_options = ''
    endif
   function! s:edit_devicon_prepended_file(item)
    let l:file_path = a:item[4:-1]
    execute 'silent e' l:file_path
  endfunction
   call fzf#run({
        \ 'source': a:default_command.' | devicon-lookup',
        \ 'sink':   function('s:edit_devicon_prepended_file'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'window': 'call FloatingFZF()'})
endfunction
"}}}
"git diff {{{
 function! Fzf_git_diff_files_with_dev_icons()
  let l:fzf_files_options = '--ansi --preview "sh -c \"(git diff --color=always -- {3..} | sed 1,4d; bat --color always --style numbers {3..}) | head -'.&lines.'\""'
   function! s:edit_devicon_prepended_file_diff(item)
    "echom a:item
    let l:file_path = a:item[7:-1]
    "echom l:file_path
    let l:first_diff_line_number = system("git diff -U0 ".l:file_path." | rg '^@@.*\+' -o | rg '[0-9]+' -o | head -1")
    execute 'silent e' l:file_path
    execute l:first_diff_line_number
  endfunction
   call fzf#run({
        \ 'source': 'git -c color.status=always status --short --untracked-files=all | devicon-lookup',
        \ 'sink':   function('s:edit_devicon_prepended_file_diff'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'down':    '40%' })
endfunction
"}}}
"}}}
"VCenterCursor {{{
if !exists('*VCenterCursor')
  augroup VCenterCursor
  au!
  au OptionSet *,*.*
    \ if and( expand("<amatch>")=='scrolloff' ,
    \         exists('#VCenterCursor#WinEnter,WinNew,VimResized') )|
    \   au! VCenterCursor WinEnter,WinNew,VimResized|
    \ endif
  augroup END
  function VCenterCursor()
    if !exists('#VCenterCursor#WinEnter,WinNew,VimResized')
      let s:default_scrolloff=&scrolloff
      let &scrolloff=winheight(win_getid())/2
      au VCenterCursor WinEnter,WinNew,VimResized *,*.*
        \ let &scrolloff=winheight(win_getid())/2
    else
      au! VCenterCursor WinEnter,WinNew,VimResized
      let &scrolloff=s:default_scrolloff
    endif
  endfunction
endif
"}}}
"MKDir {{{
function! s:MKDir(...)
    if         !a:0
           \|| isdirectory(a:1)
           \|| filereadable(a:1)
           \|| isdirectory(fnamemodify(a:1, ':p:h'))
        return
    endif
    return mkdir(fnamemodify(a:1, ':p:h'), 'p')
endfunction
"}}}
"ExecuteMacroOverVisualRange {{{
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
"}}}
"show_documentation {{{
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
"}}}

"lazy docker{{{
function! CreateCenteredFloatingWindow()
    let width = float2nr(&columns * 0.8)
    let height = float2nr(&lines * 0.9)
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    autocmd BufWipeout <buffer> exe 'bwipeout '.s:buf
endfunction
function! ToggleTerm(cmd)
    if empty(bufname(a:cmd))
        call CreateCenteredFloatingWindow()
        call termopen(a:cmd, { 'on_exit': function('OnTermExit') })
        set filetype=lazydocker
        startinsert
    else
        call ToggleLazyDockerBackground()
    endif
endfunction
function! ToggleLazyDocker()
    call ToggleTerm('lazydocker')
endfunction
function! ToggleLazyDockerBackground()
    if empty(bufname('lazydocker'))
        tabnew
        term lazydocker
        set filetype=lazydocker
        file lazydocker
    else
        call CreateCenteredFloatingWindow()
        buf lazydocker
        startinsert
        set filetype=lazydocker
        nmap <silent><buffer>Q :q<cr>:q<cr>
    endif
endfunction
function! OnTermExit(job_id, code, event)
    if a:code == 0
        bwipeout!
    endif
endfunction

"}}}
"}}}
" nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
" nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
" :set autoread | au CursorHold * checktime | call feedkeys("G")
" autocmd BufWinEnter,WinEnter * if &buftype == 'terminal' | call SetTerm() | endif
