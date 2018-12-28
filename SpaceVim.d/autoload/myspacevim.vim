let s:SYS = SpaceVim#api#import('system')
let s:JOB = SpaceVim#api#import('job')

function! myspacevim#before() abort
    set rtp+=~/SpaceVim/SpaceVim/build/vader
    call SpaceVim#logger#info('myspacevim#before called')

    " Windows bin utils {{{
    if s:SYS.isWindows
        " Downloads gun global from:
        " http://adoxa.altervista.org/global/
        " GLOBAL 6.6.3 Win32 (938k)
        let $PATH .= ';D:\Program Files\gtags\bin'
        " Downloads coreutils from
        " https://nchc.dl.sourceforge.net/project/gnuwin32/coreutils/5.3.0/coreutils-5.3.0-bin.zip
        " coreutils-5.3.0-bin.zip
        let $PATH .= ';D:\Program Files\coreutils\bin'
        " Downloads grep from
        " https://nchc.dl.sourceforge.net/project/gnuwin32/grep/2.5.4/grep-2.5.4-setup.exe
        let $PATH .= ';D:\Program Files\GnuWin32\bin'
        " Add bin path, in this path, there are ag, rg, pt, etc.
        " ag: 
        "   sources: https://github.com/ggreer/the_silver_searcher
        "   bin:     https://github.com/k-takata/the_silver_searcher-win32/releases
        " rg:
        "   sources: https://github.com/BurntSushi/ripgrep
        "   bin:     https://github.com/BurntSushi/ripgrep/releases
        " pt:
        "   sources: https://github.com/monochromegane/the_platinum_searcher
        "   bin:     https://github.com/monochromegane/the_platinum_searcher/releases
        let $PATH .= ';D:\bin'
        "
        " When using neovim in windows the only var need to be set is:
        " PYTHON_HOST_PROG 
        " C:\Python27\python.exe
        " PYTHON3_HOST_PROG
        " C:\Users\Administrator\AppData\Local\Programs\Python\Python37\python.exe

        " In windows neovim, if there is space in PATH, the executable()
        " function will not work
        if 1 " here, I do not know which patch will fix this issue
            " let $PATH = substitute($PATH, ' ', '\\ ', 'g')
        endif
    endif
    " }}}

    " here is a list of plugins which are used in SpaceVim, and I need to
    " debug locally:
    " All plugins arg cloned into $MYSRCDIR default is ~/SpaceVim
    let $MYSRCDIR = '~/SpaceVim'
    " defind global var before using it:
    let g:spacevim_disabled_plugins = []
    " vim-nim           {{{
    call add(g:spacevim_disabled_plugins, 'vim-nim')
    call s:add_load_repo('wsdjeg/vim-nim')
    set rtp+=$MYSRCDIR/vim-nim
    " }}}
    " gtags.vim         {{{
    call add(g:spacevim_disabled_plugins, 'gtags.vim')
    call s:add_load_repo('SpaceVim/gtags.vim')
    set rtp+=$MYSRCDIR/gtags.vim
    " }}}
    " vim-markdown      {{{
    call add(g:spacevim_disabled_plugins, 'vim-markdown')
    call s:add_load_repo('SpaceVim/vim-markdown')
    set rtp+=$MYSRCDIR/vim-markdown
    " }}}
    " vim-hug-neovim-rpc      {{{
    call add(g:spacevim_disabled_plugins, 'vim-hug-neovim-rpc')
    call s:add_load_repo('SpaceVim/vim-hug-neovim-rpc')
    set rtp+=$MYSRCDIR/vim-hug-neovim-rpc
    " }}}
    " nvim-yarp      {{{
    call add(g:spacevim_disabled_plugins, 'nvim-yarp')
    call s:add_load_repo('SpaceVim/nvim-yarp')
    set rtp+=$MYSRCDIR/nvim-yarp
    " }}}
    " vim-slumlord      {{{
    call add(g:spacevim_disabled_plugins, 'vim-slumlord')
    call s:add_load_repo('wsdjeg/vim-slumlord')
    set rtp+=$MYSRCDIR/vim-slumlord
    " }}}
    " SourceCounter     {{{
    call add(g:spacevim_disabled_plugins, 'SourceCounter.vim')
    call s:add_load_repo('wsdjeg/SourceCounter.vim')
    set rtp+=$MYSRCDIR/SourceCounter.vim
    " }}}
    " Github.vim        {{{
    call add(g:spacevim_disabled_plugins, 'GitHub-api.vim')
    call s:add_load_repo('wsdjeg/GitHub.vim')
    set rtp+=$MYSRCDIR/GitHub.vim
    " }}}
    " vim-elm           {{{
    call add(g:spacevim_disabled_plugins, 'vim-elm')
    call s:add_load_repo('wsdjeg/vim-elm')
    set rtp+=$MYSRCDIR/vim-elm
    " }}}
    " vim-asciidoc      {{{
    call add(g:spacevim_disabled_plugins, 'vim-asciidoc')
    call s:add_load_repo('wsdjeg/vim-asciidoc')
    set rtp+=$MYSRCDIR/vim-asciidoc
    " }}}
    " perldoc-vim       {{{
    call add(g:spacevim_disabled_plugins, 'perldoc-vim')
    call s:add_load_repo('wsdjeg/perldoc-vim')
    set rtp+=$MYSRCDIR/perldoc-vim
    " }}}
    " JavaUnit.vim      {{{
    call add(g:spacevim_disabled_plugins, 'JavaUnit.vim')
    call s:add_load_repo('wsdjeg/JavaUnit.vim')
    set rtp+=$MYSRCDIR/JavaUnit.vim
    " }}}
    "
    for repo in s:repos
        call s:check_local_repo(repo)
    endfor
    let g:delimitMate_expand_cr = 1
    call add(g:spacevim_project_rooter_patterns, 'package.json')
    set rtp+=~/SpaceVim/ChineseLinter.vim
    augroup myspacevim
        autocmd!
        autocmd FileType defx call s:defx_my_settings()
    augroup END
    let g:spacevim_layer_lang_java_formatter = '/home/wsdjeg/Downloads/google-java-format-1.5-all-deps.jar'
    command! CursorHighlight call s:cursor_highlight()
    let profile = SpaceVim#mapping#search#getprofile('rg')
    let default_opt = profile.default_opts + ['--no-ignore-vcs']
    call SpaceVim#mapping#search#profile({'rg' : {'default_opts' : default_opt}})
endfunction

let s:HI = SpaceVim#api#import('vim#highlight')

function! s:cursor_highlight() abort
    echo s:HI.syntax_at()
endfunction

function! s:defx_my_settings() abort
    " Define mappings
    nnoremap <silent><buffer><expr> <CR>
                \ defx#do_action('open')
    nnoremap <silent><buffer><expr> K
                \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
                \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> d
                \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
                \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> h
                \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
                \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> <Space>
                \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> j
                \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
                \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
                \ defx#do_action('redraw')
endfunction

let s:repos = []
function! s:add_load_repo(repo) abort
    call add(s:repos, a:repo)
endfunction

function! s:check_local_repo(repo) abort
    let dir = $MYSRCDIR . '/' . split(a:repo, '/')[1]
    if !isdirectory(expand(dir))
        call s:JOB.start(['git', 'clone', 'https://github.com/' . a:repo], {'cwd' : expand($MYSRCDIR), 
                    \ 'on_stdout' : function('s:clone_std'),
                    \ 'on_stderr' : function('s:clone_std'),
                    \ })
    endif
endfunction

let g:_mylog = []

function! s:clone_std(id, data, event) abort
    call add(g:_mylog, a:data)
endfunction
