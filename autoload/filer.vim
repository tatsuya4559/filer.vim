vim9script

def Name(base: string, fname: string): string
  const path = base .. fname
  var ftype = getftype(path)
  if ftype ==# 'link' || ftype ==# 'junction'
    if isdirectory(resolve(path))
      ftype = 'dir'
    endif
  endif
  return fname .. (ftype ==# 'dir' ? '/' : '')
enddef

def Compare(lhs: string, rhs: string): number
  if lhs[-1 : ] ==# '/' && rhs[-1 : ] !=# '/'
    return -1
  elseif lhs[-1 : ] !=# '/' && rhs[-1 : ] ==# '/'
    return 1
  endif
  if lhs < rhs
    return -1
  elseif lhs > rhs
    return 1
  endif
  return 0
enddef

def Curdir(): string
  return get(b:, 'dir', '')
enddef

def Current(): string
  return getline('.')
enddef

def Fullpath(path: string): string
  return (path =~# '^/' ? '' : Curdir()) .. path
enddef

export def Init(): void
  const path = resolve(expand('%:p'))
  if !isdirectory(path)
    return
  endif
  var dir = fnamemodify(path, ':p')
  if isdirectory(dir) && dir !~# '/$'
    dir ..= '/'
  endif

  if bufname('%') !=# dir
    exe 'noautocmd' 'silent' 'noswapfile' 'file' dir
  endif
  b:dir = dir
  setlocal modifiable
  setlocal filetype=filer buftype=nofile bufhidden=delete nobuflisted noswapfile
  setlocal nowrap cursorline
  final files = readdir(path, '1')->map((_, v) => Name(dir, v))
  if !get(g:, 'filer_show_hidden', false)
    filter(files, (_, v) => v =~# "^[^.]")
  endif
  silent keepmarks keepjumps setline(1, sort(files, Compare))
  setlocal nomodified
enddef

export def Start(): void
  const file_from = expand('%:t')
  var dir = expand('%:h')
  if empty(dir)
    dir = getcwd()
  endif
  exe 'edit' fnameescape(dir) .. '/'
  search('\V\^' .. file_from, 'c')
enddef

export def Down(): void
  exe 'edit' fnameescape(Fullpath(Current()))
enddef

export def Up(): void
  const dir_from = fnamemodify(Curdir(), ':p:h:t')
  const dir_to = fnamemodify(Curdir(), ':p:h:h')
  exe 'edit' fnameescape(dir_to) .. '/'
  search('\V\^' .. dir_from, 'c')
enddef

export def Home(): void
  edit ~/
enddef

export def Reload(): void
  edit
enddef

export def Command(): void
  const path = Fullpath(Current())
  feedkeys(':! ' .. shellescape(path) .. "\<c-home>\<right>", 'n')
enddef

export def ShowFullpath(): void
  silent keepmarks keepjumps setline(1, map(getline('1', '$'), (_, v) => Fullpath(v)))
enddef

export def ToggleHidden(): void
  g:filer_show_hidden = !get(g:, 'filer_show_hidden', false)
  Reload()
enddef

export def Error(msg: string): void
  redraw
  echohl Error
  echomsg msg
  echohl None
enddef
