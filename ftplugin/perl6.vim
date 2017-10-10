" Vim filetype plugin file
" Language:      Perl 6
" Maintainer:    vim-perl <vim-perl@googlegroups.com>
" Homepage:      https://github.com/vim-perl/vim-perl6
" Bugs/requests: https://github.com/vim-perl/vim-perl6/issues
" Last Change:   {{LAST_CHANGE}}
" Contributors:  Hinrik Örn Sigurðsson <hinrik.sig@gmail.com>
"
" Based on ftplugin/perl.vim by Dan Sharp <dwsharp at hotmail dot com>

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:save_cpo = &cpo
set cpo-=C

setlocal formatoptions-=t
setlocal formatoptions+=crqol
setlocal keywordprg=p6doc

setlocal comments=:#\|,:#=,:#
setlocal commentstring=#%s

" Change the browse dialog on Win32 to show mainly Perl-related files
if has("gui_win32")
    let b:browsefilter = "Perl Source Files (*.pl)\t*.pl\n" .
               \ "Perl Modules (*.pm)\t*.pm\n" .
               \ "Perl Documentation Files (*.pod)\t*.pod\n" .
               \ "All Files (*.*)\t*.*\n"
endif

" Provided by Ned Konz <ned at bike-nomad dot com>
"---------------------------------------------
setlocal include=\\<\\(use\\\|require\\)\\>
setlocal includeexpr=substitute(substitute(v:fname,'::','/','g'),'$','.pm','')
setlocal define=[^A-Za-z_]

" The following line changes a global variable but is necessary to make
" gf and similar commands work. Thanks to Andrew Pimlott for pointing out
" the problem. If this causes a " problem for you, add an
" after/ftplugin/perl6.vim file that contains
"       set isfname-=:
set isfname+=:
setlocal iskeyword=@,48-57,_,192-255,-

" Set this once, globally.
if !exists("perlpath")
    if executable("perl6")
        try
            if &shellxquote != '"'
                let perlpath = system('perl6 -e  "@*INC.join(q/,/).say"')
            else
                let perlpath = system("perl6 -e  '@*INC.join(q/,/).say'")
            endif
            let perlpath = substitute(perlpath,',.$',',,','')
        catch /E145:/
            let perlpath = ".,,"
        endtry
    else
        " If we can't call perl to get its path, just default to using the
        " current directory and the directory of the current file.
        let perlpath = ".,,"
    endif
endif

" Append perlpath to the existing path value, if it is set.  Since we don't
" use += to do it because of the commas in perlpath, we have to handle the
" global / local settings, too.
if &l:path == ""
    if &g:path == ""
        let &l:path=perlpath
    else
        let &l:path=&g:path.",".perlpath
    endif
else
    let &l:path=&l:path.",".perlpath
endif
"---------------------------------------------

" Convert ascii-based ops into their single-character unicode equivalent
iabbrev <buffer> !(<) ⊄
iabbrev <buffer> !(<=) ⊈
iabbrev <buffer> !(>) ⊅
iabbrev <buffer> !(>=) ⊉
iabbrev <buffer> !(cont) ∌
iabbrev <buffer> !(elem) ∉
iabbrev <buffer> != ≠
iabbrev <buffer> (&) ∩
iabbrev <buffer> (-) ∖
iabbrev <buffer> (<) ⊂
iabbrev <buffer> (<+) ≼
iabbrev <buffer> (<=) ⊆
iabbrev <buffer> (>) ⊃
iabbrev <buffer> (>+) ≽
iabbrev <buffer> (>=) ⊇
iabbrev <buffer> (^) ⊖
iabbrev <buffer> (cont) ∋
iabbrev <buffer> (elem) ∈
iabbrev <buffer> (\|) ∪
iabbrev <buffer> * ×
iabbrev <buffer> **0 ⁰
iabbrev <buffer> **1 ¹
iabbrev <buffer> **2 ²
iabbrev <buffer> **3 ³
iabbrev <buffer> **4 ⁴
iabbrev <buffer> **5 ⁵
iabbrev <buffer> **6 ⁶
iabbrev <buffer> **7 ⁷
iabbrev <buffer> **8 ⁸
iabbrev <buffer> **9 ⁹
iabbrev <buffer> ... …
iabbrev <buffer> / ÷
iabbrev <buffer> << «
iabbrev <buffer> <= ≤
iabbrev <buffer> =~= ≅
iabbrev <buffer> >= ≥
iabbrev <buffer> >> »
iabbrev <buffer> Inf ∞
iabbrev <buffer> set() ∅
iabbrev <buffer> (.) ⊍
iabbrev <buffer> (+) ⊎

" Undo the stuff we changed.
let b:undo_ftplugin = "setlocal fo< com< cms< inc< inex< def< isf< isk< kp< path<" .
        \         " | unlet! b:browsefilter"

" Restore the saved compatibility options.
let &cpo = s:save_cpo
unlet s:save_cpo
