"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"               _____            .__                                                  "
"             _/ ____\_______  __|__| ____ ___________ __  _  ________                "
"             \   __\/  _ \  \/  /  |/ __ \\____ \__  \\ \/ \/ /  ___/                "
"              |  | (  <_> >    <|  \  ___/|  |_> > __ \\     /\___ \                 "
"              |__|  \____/__/\_ \__|\___  >   __(____  /\/\_//____  >                "
"                               \/       \/|__|       \/           \/                 "
"                                                                                     "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My .vimrc, requires git, mercurial, curl, python support and probably several other "
" things..                                                                            "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" a given
set encoding=utf8

" VAM setup stuff "{{{

fun SetupVAM()
    let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
    exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'
    if !filereadable(vam_install_path.'/vim-addon-manager/.git/config') && 1 == confirm("git clone VAM into ".vam_install_path."?","&Y\n&N")
        call confirm("Remind yourself that most plugins ship with documentation (README*, doc/*.txt). Its your first source of knowledge. If you can't find the info you're looking for in reasonable time ask maintainers to improve documentation")
        exec '!p='.shellescape(vam_install_path).'; mkdir -p "$p" && cd "$p" && git clone --depth 1 git://github.com/MarcWeber/vim-addon-manager.git'
        exec 'helptags '.fnameescape(vam_install_path.'/vim-addon-manager/doc')
    endif
    call vam#ActivateAddons([], {'auto_install' : 0})
endfun

call SetupVAM()
"}}}

" functions "{{{

" Modeline Helper "{{{
function! AppendModeline()
    let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :", &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), l:modeline)
endfunction
"}}}

" Conditional Activation and Execution "{{{

func! CondActivate(condition,addons)  " Activate certain addons on a condition
    if a:condition == 1
        call vam#ActivateAddons(a:addons)
    endif
endfunc

func! CondExecute(cond,execstr) " executes a string on a condition 
    if a:cond == 1
        exec a:execstr
    endif
endfunc

"}}}

" Lazy colorscheme loading {{{
fun! LazyColorscheme(cs) 
    try
        execute "colorscheme " . a:cs
    catch
        try
            call vam#ActivateAddons(a:cs)
            call LazyColorscheme(a:cs) 
        catch
            echo 'unable to find ' . a:cs
        endtry
    endtry
endfun

fun! LazyColorschemeAlt(cs,VAM) 
    try
        execute "colorscheme " . a:cs
    catch
        try
            call vam#ActivateAddons(a:VAM)
            call LazyColorscheme(a:cs) 
        catch
            echo 'unable to find ' . a:cs
        endtry
    endtry
endfun
"}}}

"}}}

" random settings "{{{
set nocp 
set nu ml si ts=4 sw=4 et ls=2
let g:use7bit = 1
set backspace=indent,eol,start
"}}}

"snipmate {{{
"}}}

" filetypes "{{{

" initial setup "{{{
filetype plugin on
syntax on
filetype plugin indent on
"}}}

" type overrides "{{{
au BufRead,BufNewFile *.md set filetype=markdown
au! BufRead,BufNewFile *.json set filetype=json
au! BufRead,BufNewFile */gradle setf groovy
"}}}


" perl 
"
" quickfix for Perl error formats
set errorformat+=%m\ at\ %f\ line\ %l\.
set errorformat+=%m\ at\ %f\ line\ %l

noremap ,c :!time perlc --critic %<cr>

"}}}

" activate all addons "{{{

" general purpose programming "{{{
"call vam#ActivateAddons(["Git_Branch_Info"]) " self explanitory
call vam#ActivateAddons(["fugitive"])        " git wrapper
call vam#ActivateAddons(["gitignore%2557"])  " git ignore syntax hilighting
call vam#ActivateAddons(["SonicTemplate"])   " Awesome template/snippet stuff supporting multiple languages
call vam#ActivateAddons(["surround"])        " helps with deleting, changing and adding brackets and such (HTML, paren, bracket)
call vam#ActivateAddons(["snipmate"])        " snippet handler
call vam#ActivateAddons(["tComment"])        " comment helper for many languages
call vam#ActivateAddons(["Tabular"])        " comment helper for many languages
call vam#ActivateAddons(["qthelp"])          " qt function help
call vam#ActivateAddons(["VimDebug"])
"}}}

" systems admin"{{{
call vam#ActivateAddons(["irssilog"]) " Irssi log hilighting
"}}}

" Embedded stuff (Arduino and friends){{{

" AVR / Arduino {{{
" call vam#ActivateAddons(["vim-arduino-ino"])
"}}}

"}}}

" themes and eye candy"{{{
"call vam#ActivateAddons(["Solarized"])              " theme
call vam#ActivateAddons(["highlight_current_line"]) " bold the current line.
call vam#ActivateAddons(["vim-airline"])            " status line
call vam#ActivateAddons(["The_NERD_tree"])          " awesome filesystem views
"}}}

" tools"{{{
call vam#ActivateAddons(["WebAPI"])
call vam#ActivateAddons(["Gist"])
call vam#ActivateAddons(["vimshell"])           " run external processes in vim
call vam#ActivateAddons(["Vim_Blog"])
call vam#ActivateAddons(["jsonvim"])
"}}}

" annoying scripts with delayed activation built in "{{{
call vam#ActivateAddons(["c%213"]) " c support (add idioms, comments, etc)
"}}}

" conditional plugins "{{{
function! LoadConditionalPlugins()
    call CondActivate(&ft ==? 'c',["c%1201"]) " better c syntax handling
    call CondActivate(&ft ==? 'python',["pyflakes%2441","Syntastic"])
    call CondActivate(&ft ==? 'perl',['perl-mauke'])
    call CondExecute(&ft ==? 'perl', "let perl_extended_vars=1 | let perl_include_pod=1 | let perl_fold=1 | " .
        \   "let perl_fold_anonymous_subs=1 | let perl_nofold_packages=1 | set fdm=syntax | set syntax=perl" )
    call CondActivate(&ft ==? 'cs',["csharp"])
    call CondActivate(&ft ==? 'html',['jshint%3576'])
    call CondActivate(&ft ==? 'json',['JSON'])
    call CondActivate(&ft ==? 'javascript',['node','jshint%3576'])
endfunction
"}}}

call LoadConditionalPlugins() " load conditionals
au! BufRead,BufNewFile * call LoadConditionalPlugins() " whenever a new file is opened, also load conditionals.
"}}}

" colour scheme related stuff"{{{


"au! ColorScheme * call LoadColorschemeSettings() 

if has('gui_running')
    set guifont=terminus
    set background=light
else
    set background=dark
endif
set t_Co=256

" used by colorschemes during execution.
let g:solarized_termcolors=256 


" lazy load schemes!
call LazyColorschemeAlt('solarized','Solarized')
"call LazyColorschemeAlt('zenburn','Zenburn')
"call LazyColorscheme('molokai')
"call LoadColorschemeSettings()

highlight CurrentLine guibg=bg
"}}}

" airline "{{{
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 0
"}}}

" key bindings "{{{
"
" keybind helper function {{{
fun Dkey(command, key)
    let l:cmdp = split(a:command, '\e')
    if (g:use7bit == 1)
        execute join([l:cmdp[0] , "\e" . a:key, l:cmdp[1]])
    else
        execute join([l:cmdp[0] , "<m-".a:key.">", l:cmdp[1])
    endif
endfun

" }}}
"
" pastetoggle, insert modeline {{{
set pastetoggle=<F12>
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
nnoremap <silent> <Leader>T :Template 
"}}}
" NERDTree "{{{
map <F11> :NERDTreeToggle<CR>
"
"}}}
"tab navigation "{{{
call Dkey("map \e :tabnew<CR>","j")
call Dkey("map \e :tabedit", "k")
call Dkey("map \e  :tabprev<CR>","h")
call Dkey("map \e :tabnext<CR>","l")
"}}}
"}}}

" vim: fdm=marker fen
