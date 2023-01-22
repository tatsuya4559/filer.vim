vim9script

import './strings.vim'
import './paths.vim'

def Name(base: string, fname: string): string
  const path = paths.Join(base, fname)
  var ftype = getftype(path)
  if ftype ==# 'link' || ftype ==# 'junction'
    if isdirectory(resolve(path))
      ftype = 'dir'
    endif
  endif
  return ftype ==# 'dir' ? paths.WithTrailingSlash(fname) : fname
enddef

def Compare(lhs: string, rhs: string): number
  if strings.HasSuffix(lhs, '/') && !strings.HasSuffix(rhs, '/')
    return -1
  elseif !strings.HasSuffix(lhs, '/') && strings.HasSuffix(rhs, '/')
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
  if isabsolutepath(path) || paths.IsRelative(path)
    return path
  endif
  return paths.Join(Curdir(), path)
enddef

export def Init(): void
  const path = resolve(expand('%:p'))
  if !isdirectory(path)
    return
  endif
  const use_abspath = get(g:, 'filer_use_abspath', false)
  const dir = paths.WithTrailingSlash(use_abspath ? paths.ToAbsolute(path) : paths.ToRelative(path))

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
  exe 'edit' paths.WithTrailingSlash(fnameescape(dir))
  search('\V\^' .. file_from, 'c')
enddef

export def Down(): void
  exe 'edit' fnameescape(CompletePath(Current()))
enddef

export def Up(): void
  const dir_from = fnamemodify(Curdir(), ':p:h:t')
  const dir_to = fnamemodify(Curdir(), ':p:h:h')
  exe 'edit' paths.WithTrailingSlash(fnameescape(dir_to))
  search('\V\^' .. paths.WithTrailingSlash(dir_from), 'c')
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
