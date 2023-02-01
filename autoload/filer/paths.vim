vim9script

import './strings.vim'

export def WithTrailingSlash(dir: string): string
  return strings.HasSuffix(dir, '/') ? dir : dir .. '/'
enddef

export def Join(path: string, ...paths: list<string>): string
  var result = path
  for p in paths
    result = WithTrailingSlash(result) .. p
  endfor
  return result
enddef

export def ToAbsolute(path: string): string
  return fnamemodify(path, ':p')
enddef

export def ToRelative(path: string): string
  const abspath = WithTrailingSlash(ToAbsolute(path))
  const cwd = WithTrailingSlash(getcwd())
  if abspath ==# cwd
    return '.'
  endif
  return substitute(abspath, '^' .. escape(cwd, '/'), '', '')
enddef

export def IsRelative(path: string): bool
  if isabsolutepath(path)
    return false
  endif
  if strings.Contains(strings.TrimSuffix(path, '/'), '/')
    return true
  endif
  return false
enddef
