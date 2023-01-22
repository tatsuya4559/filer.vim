vim9script

def StrContains(str: string, sub: string): bool
  return stridx(str, sub) >= 0
enddef

def HasPrefix(str: string, prefix: string): bool
  return str[ : len(prefix) - 1] ==# prefix
enddef

def HasSuffix(str: string, suffix: string): bool
  return str[len(str) - len(suffix) : ] ==# suffix
enddef

def TrimSuffix(str: string, suffix: string): string
  if !HasSuffix(str, suffix)
    return str
  endif
  return str[ : len(str) - len(suffix) - 1]
enddef

def WithTrailingSlash(dir: string): string
  return HasSuffix(dir, '/') ? dir : dir .. '/'
enddef

def JoinPath(path: string, ...paths: list<string>): string
  var result = path
  for p in paths
    result = WithTrailingSlash(result) .. p
  endfor
  return result
enddef

def ToAbsolutePath(path: string): string
  return fnamemodify(path, ':p')
enddef

def Name(base: string, fname: string): string
  const path = JoinPath(base, fname)
  var ftype = getftype(path)
  if ftype ==# 'link' || ftype ==# 'junction'
    if isdirectory(resolve(path))
      ftype = 'dir'
    endif
  endif
  return ftype ==# 'dir' ? WithTrailingSlash(fname) : fname
enddef

def Compare(lhs: string, rhs: string): number
  if HasSuffix(lhs, '/') && !HasSuffix(rhs, '/')
    return -1
  elseif !HasSuffix(lhs, '/') && HasSuffix(rhs, '/')
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

# Complete path joining with curdir.
def CompletePath(path: string): string
  if isabsolutepath(path)
    return path
  # elseif IsRelativePath(path)
  #   return path
  else
    return JoinPath(Curdir(), path)
  endif
enddef

export def Init(): void
  const path = resolve(expand('%:p'))
  if !isdirectory(path)
    return
  endif
  const dir = WithTrailingSlash(ToAbsolutePath(path))

  if bufname('%') !=# dir
    exe 'noautocmd' 'silent' 'noswapfile' 'file' dir
  endif
  b:dir = dir
  setlocal modifiable
  setlocal filetype=filer buftype=nofile bufhidden=delete nobuflisted noswapfile
  setlocal nowrap cursorline
  final files = readdir(dir, '1')->map((_, v) => Name(dir, v))
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
  exe 'edit' WithTrailingSlash(fnameescape(dir))
  search('\V\^' .. file_from, 'c')
enddef

export def Down(): void
  exe 'edit' fnameescape(CompletePath(Current()))
enddef

export def Up(): void
  const dir_from = fnamemodify(Curdir(), ':p:h:t')
  const dir_to = fnamemodify(Curdir(), ':p:h:h')
  exe 'edit' WithTrailingSlash(fnameescape(dir_to))
  search('\V\^' .. WithTrailingSlash(dir_from), 'c')
enddef

export def Home(): void
  edit ~/
enddef

export def Reload(): void
  edit
enddef

export def Command(): void
  const path = CompletePath(Current())
  feedkeys(':! ' .. shellescape(path) .. "\<c-home>\<right>", 'n')
enddef

export def ShowFullpath(): void
  silent keepmarks keepjumps setline(1, map(getline(1, '$'), (_, v) => CompletePath(v)))
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
