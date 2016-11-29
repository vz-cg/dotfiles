"TABキーを押した時のspaceに
set expandtab
set tabstop=4
set shiftwidth=4
"入力中に、hjklで移動できる様に
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
"[Backspace] で既存の文字を削除できるように設定
"  start - 既存の文字を削除できるように設定
"  eol - 行頭で[Backspace]を使用した場合上の行と連結
"  indent - オートインデントモードでインデントを削除できるように設定
set backspace=start,eol,indent
" 特定のキーに行頭および行末の回りこみ移動を許可する設定
"  b - [Backspace]  ノーマルモード ビジュアルモード
"  s - [Space]      ノーマルモード ビジュアルモード
"   - [→]          ノーマルモード ビジュアルモード
"  [ - [←]          挿入モード 置換モード
"  ] - [→]          挿入モード 置換モード
"  ~ - ~            ノーマルモード
set whichwrap=b,s,[,],,~
" マウス機能有効化
set mouse=a
" シンタックスハイライト有効化 (背景黒向け。白はコメントアウト
" されている設定を使用)
syntax on
highlight Normal ctermbg=black ctermfg=grey
highlight StatusLine term=none cterm=none ctermfg=black ctermbg=grey
highlight CursorLine term=none cterm=none ctermfg=none ctermbg=none

"highlight Normal ctermbg=grey ctermfg=black
"highlight StatusLine term=none cterm=none ctermfg=grey ctermbg=black
"highlight CursorLine term=none cterm=none ctermfg=darkgray ctermbg=none
set nohlsearch " 検索キーワードをハイライトしないように設定
set cursorline " カーソルラインの強調表示を有効化
" 行番号を表示
set number 
highlight number ctermfg=243
" ステータスラインを表示
set laststatus=2 " ステータスラインを常に表示
set statusline=%F%r%h%= " ステータスラインの内容
" インクリメンタル検索を有効化
set incsearch
" 補完時の一覧表示機能有効化
set wildmenu wildmode=list:full
" 自動的にファイルを読み込むパスを設定 ~/.vim/userautoload/*vim
set runtimepath+=~/.vim/
runtime! userautoload/*.vim
" C styleのオートインデント
set cindent shiftwidth=4

" 現在開いているファイルを実行 (only php|ruby|go)
function! ExecuteCurrentFile()
    if &filetype == 'php' || &filetype == 'ruby'
        exe '!' . &filetype . ' %'
    endif
    if &filetype == 'go'
        exe '!go run *.go'
    endif
endfunction
nnoremap <C-e> :call ExecuteCurrentFile()<CR>

"[JAVA] :Makeでコンパイル
 autocmd FileType java :command! Make call s:Make()
  function! s:Make()
       :w
       let path = expand("%")
       let syn = "javac ".path
       let dpath = split(path,".java$")
       let ret = system(syn)
              if ret == ""
                   :echo "=======\r\nCompile Success"
              else
                   :echo "=======\r\nCompile Failure\r\n".ret 
              endif
  endfunction
"[JAVA] :Doでコンパイル後のファイルを実行 
 autocmd FileType java :command! Do call s:Do()
 function! s:Do()
    let path = expand("%") 
    let dpath = split(path,".java$")
    let syn = "java ".dpath[0]
    let ret = system(syn)
        :echo "=======\r\n実行結果:\r\n".ret
 endfunction 

"[JAVA] :Exeでコンパイルしてから実行
 autocmd FileType java :command! Exe call s:Javac()
 function! s:Javac()
  :w
  let path = expand("%")
  let syn = "javac ".path
  let dpath = split(path,".java$")
  let ret = system(syn)
  if ret == ""
     :echo "=======\r\nCompile Success"
     let syn = "java ".dpath[0]
     let ret = system(syn)
     :echo "=======\r\n実行結果:\r\n".ret
  else
     :echo "=======\r\nCompile Failure\r\n".ret
  endif
 endfunction

"======___タブ機能の便利化___========
" Anywhere SID.
function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
    let s = ''
    for i in range(1, tabpagenr('$'))
        let bufnrs = tabpagebuflist(i)
        let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
        let no = i  " display 0-origin tabpagenr.
        let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
        let title = fnamemodify(bufname(bufnr), ':t')
        let title = '[' . title . ']'
        let s .= '%'.i.'T'
        let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
        let s .= no . ':' . title
        let s .= mod
        let s .= '%#TabLineFill# '
    endfor
        let s .= '%#TabLineFill#%T%=%#TabLine#'
    return s
endfunction "}}}
  let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
    execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ
"=======^^^タブ便利化^^^=========

"NeoBundle Scripts-----------------------------
if &compatible
    set nocompatible               " Be iMproved
endif

" Required:
set runtimepath^=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------
