"设置编码
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set fileencodings=utf-8,ucs-bom,chinese
 
"语言设置
set langmenu=zh_CN.UTF-8

"设置行号
set nu
 
"记忆上次编辑位置
au BufReadPost * if line("'\"") > 0 | if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

"设置语法高亮
syntax enable
syntax on
 
"设置搜索高亮
set hlsearch

"设置配色方案
colorscheme koehler

"折叠 展开
nmap @@ zf%

"设置状态栏
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set laststatus=2 "确定状态条总会显示在窗口的倒数第二行

"可以在buffer的任何地方使用鼠标，包含taglist，netrw，miniBufExplorer，quickfix等
set mouse=a
set selection=exclusive
set selectmode=mouse,key

"设置窗口间移动
let g:miniBufExplMapWindowNavVim = 1 "用<C-h,j,k,l>切换上下左右的窗口
let g:miniBufExplMapWindowNavArrows = 1 "用<C-箭头键>切换上下左右窗口
 
"高亮显示匹配的括号
set showmatch
 
"去掉vi一致性
set nocompatible
 
"设置缩进
set tabstop=4
set softtabstop=4
set shiftwidth=4
set backspace=2
set autoindent
set cindent
if &term=="xterm"
    set t_Co=8
    set t_Sb=^[[4%dm
    set t_Sf=^[[3%dm
endif
 
"打开文件类型自动检测功能
filetype on
 
"设置taglist
let Tlist_Show_One_File=0   "显示多个文件的tags
let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
let Tlist_Exit_OnlyWindow=1 "在taglist是最后一个窗口时退出vim
let Tlist_Use_SingleClick=1 "单击时跳转
let Tlist_GainFocus_On_ToggleOpen=1 "打开taglist时获得输入焦点
let Tlist_Process_File_Always=1 "不管taglist窗口是否打开，始终解析文件中的tag
let Tlist_Use_Right_Window=1 "放在右边，默认是左边
" F9 映射:Tlist命令 - 使用tagbar替换
" map <F9> :Tlist<CR>
 
"设置WinManager插件
"let g:winManagerWindowLayout='FileExplorer|TagList'
"nmap wm :WMToggle<cr> "会影响w命令的响应
"map <silent> <F9> :WMToggle<cr> "将F9绑定至WinManager,即打开WimManager
 
"设置CSCOPE
set cscopequickfix=s-,c-,d-,i-,t-,e- "设定是否使用quickfix窗口显示cscope结果
if filereadable("cscope.out") "自动加载cscope.out文件
	execute "cs add cscope.out"
endif
 
"设置Grep插件
" nnoremap <silent> <F3> :Grep<CR>
 
"设置一键编译
" map <F6> :make<CR>
 
"设置c/cpp和h文件跳转
nnoremap <silent> <F7> :A<CR>

"设置SuperTab
"let g:SuperTabRetainCompletionType=2
"let g:SuperTabDefaultCompletionType="<C-X><C-O>"
 
"启动vim时如果存在tags则自动加载
if exists("tags")
set tags=./tags
endif

"设置按F12就更新tags和cscope.out的方法
map <F12> :call Do_CsTag()<CR>
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
function Do_CsTag()
        let dir = getcwd()
        if filereadable("tags") "删除原来的tags文件
            if(g:iswindows==1)
                let tagsdeleted=delete(dir."\\"."tags")
            else
                let tagsdeleted=delete("./"."tags")
            endif
            if(tagsdeleted!=0)
                echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
                return
            endif
        endif
         
        if has("cscope") "终端cscope程序
            silent! execute "cs kill -1"
        endif
         
        if filereadable("cscope.files") "删除cscope.files文件
            if(g:iswindows==1)
                let csfilesdeleted=delete(dir."\\"."cscope.files")
            else
                let csfilesdeleted=delete("./"."cscope.files")
            endif
            if(csfilesdeleted!=0)
                echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
                return
            endif
        endif
                                             
        if filereadable("cscope.out") "删除cscope.out文件
            if(g:iswindows==1)
                let csoutdeleted=delete(dir."\\"."cscope.out")
            else
                let csoutdeleted=delete("./"."cscope.out")
            endif
            if(csoutdeleted!=0)
                echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
                return
            endif
        endif
                                             
        if(executable('ctags')) "重新生成tags文件
            "silent! execute "!ctags -R --c-types=+p --fields=+S *"
            silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
        endif
             
        if(executable('cscope') && has("cscope") ) "重新执行cscope命令
            if(g:iswindows!=1)
                silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
            else
                silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
            endif
            silent! execute "!cscope -b"
            execute "normal :"
                                                                     
            if filereadable("cscope.out") "重新加载cscope.out文件
                execute "cs add cscope.out"
            endif
        endif
endfunction

"设置默认shell
set shell=zsh
 
"设置VIM记录的历史数
set history=800
 
"设置当文件被外部改变的时侯自动读入文件
if exists("&autoread")
    set autoread
endif
 
"设置ambiwidth
set ambiwidth=double
 
"设置文件类型
set ffs=unix,dos,mac
 
"设置增量搜索模式
set incsearch
 
"设置静音模式
set noerrorbells
set novisualbell
 
"不要备份文件
set nobackup
set nowb

"Markdown
"https://github.com/plasticboy/vim-markdown/
"Install:cd ~/.vim	; tar --strip=1 -zxf vim-markdown-master.tar.gz
"Disable Folding
let g:vim_markdown_folding_disabled=1
"Disable Default Key Mappings
let g:vim_markdown_no_default_key_mappings=1
"Syntax extensions
let g:vim_markdown_math=1
"YAML frontmatter
let g:vim_markdown_frontmatter=1


" tagbar
nmap <F9> :TagbarToggle<CR>
let g:tagbar_ctags_bin = 'ctags'
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0  


" vim-go key map
nmap <C-i> <ESC>:GoImports<CR>
nmap <S-d> <ESC>:GoDef<CR>


" ctrlP 文件检索
" <c-j>:down 
" <c-k>:up
" <c-v>:vertical open 
" <c-x>:herizon open
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = 'find %s -type f'    " MacOSX/Linux
set wildignore+=*/tmp/*,*.so,*.swp,*.zip        " MacOSX/Linux
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }


" ****YouCompleteMe****
let g:ycm_global_ycm_extra_conf='~/.vim/ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_show_diagnostics_ui = 0


" ********************************************************************************
set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'https://github.com/Valloric/YouCompleteMe.git'
Plugin 'fatih/vim-go'
Plugin 'SirVer/ultisnips'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'

call vundle#end()            " required
filetype plugin indent on    " required

