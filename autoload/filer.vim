function! s:name(base, fname) abort
  let l:path = a:base .. a:fname
  let l:type = getftype(l:path)
  if l:type ==# 'link' || l:type ==# 'junction'
    if isdirectory(resolve(l:path))
      let l:type = 'dir'
    endif
  endif
  return a:fname .. (l:type ==# 'dir' ? '/' : '')
endfunction

function! s:compare(lhs, rhs) abort
  if a:lhs[-1:] ==# '/' && a:rhs[-1:] !=# '/'
    return -1
  elseif a:lhs[-1:] !=# '/' && a:rhs[-1:] ==# '/'
    return 1
  endif
  if a:lhs < a:rhs
    return -1
  elseif a:lhs > a:rhs
    return 1
  endif
  return 0
endfunction

function! s:curdir() abort
  return get(b:, 'dir', '')
endfunction

function! s:current() abort
  return getline('.')
endfunction

function! s:fullpath(path) abort
  return (a:path =~# '^/' ? '' : s:curdir()) .. a:path
endfunction

function! filer#init() abort
  let l:path = resolve(expand('%:p'))
  if !isdirectory(l:path)
    return
  endif
  let l:dir = fnamemodify(l:path, ':p')
  if isdirectory(l:dir) && l:dir !~# '/$'
    let l:dir ..= '/'
  endif

  if bufname('%') !=# l:dir
    exe 'noautocmd' 'silent' 'noswapfile' 'file' l:dir
  endif
  let b:dir = l:dir
  setlocal modifiable
  setlocal filetype=filer buftype=nofile bufhidden=wipe nobuflisted noswapfile
  setlocal nowrap cursorline
  let l:files = map(readdir(l:path, '1'), {_, v -> s:name(l:dir, v)})
  if !get(g:, 'filer_show_hidden', v:false)
    call filter(l:files, 'v:val =~# "^[^.]"')
  endif
  silent keepmarks keepjumps call setline(1, sort(l:files, function('s:compare')))
  setlocal nomodified
endfunction

function! filer#start() abort
  let l:file_from = expand('%:t')
  let l:dir = expand('%:h')
  if empty(l:dir)
    let l:dir = getcwd()
  endif
  execute 'edit' fnameescape(l:dir) .. '/'
  call search('\V\^' .. l:file_from, 'c')
endfunction

function! filer#down() abort
  exe 'edit' fnameescape(s:fullpath(s:current()))
endfunction

function! filer#up() abort
  let l:dir_from = fnamemodify(s:curdir(),':p:h:t')
  let l:dir_to = fnamemodify(s:curdir(), ':p:h:h')
  exe 'edit' fnameescape(l:dir_to) .. '/'
  call search('\V\^' .. l:dir_from, 'c')
endfunction

function! filer#home() abort
  edit ~/
endfunction

function! filer#reload() abort
  edit
endfunction

function! filer#command() abort
  let l:path = s:fullpath(s:current())
  call feedkeys(':! ' .. shellescape(l:path) .. "\<c-home>\<right>", 'n')
endfunction

function! filer#show_fullpath() abort
  silent keepmarks keepjumps call setline(1, map(getline('1', '$'), {_, v -> s:fullpath(v)}))
endfunction

function! filer#toggle_hidden() abort
  let g:filer_show_hidden = !get(g:, 'filer_show_hidden', v:false)
  call filer#reload()
endfunction

function! filer#error(msg) abort
  redraw
  echohl Error
  echomsg a:msg
  echohl None
endfunction
