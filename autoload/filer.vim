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
  if a:path[0] ==# '/'
    return a:path
  else
    return  s:curdir() .. a:path
  endif
endfunction

function! filer#init() abort
  let l:path = resolve(expand('%:p'))
  if !isdirectory(l:path)
    return
  endif
  let l:dir = fnamemodify(l:path, ':p:gs?\?/?')
  if isdirectory(l:dir) && l:dir !~# '/$'
    let l:dir ..= '/'
  endif

  if tr(bufname('%'), '\', '/') !=# l:dir
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

function! filer#open() abort
  exe 'edit' s:fullpath(s:current())
endfunction

function! filer#up() abort
  let l:dir = fnamemodify(s:curdir(), ':p:h:h:gs!\!/!')
  exe 'edit' l:dir
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
  let l:show_hidden = get(g:, 'filer_show_hidden', v:false)
  let g:filer_show_hidden = !l:show_hidden
  call filer#reload()
endfunction

function! filer#error(msg) abort
  redraw
  echohl Error
  echomsg a:msg
  echohl None
endfunction
