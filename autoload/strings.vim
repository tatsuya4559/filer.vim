vim9script

export def Contains(str: string, sub: string): bool
  return stridx(str, sub) >= 0
enddef

export def HasPrefix(str: string, prefix: string): bool
  return str[ : len(prefix) - 1] ==# prefix
enddef

export def HasSuffix(str: string, suffix: string): bool
  return str[len(str) - len(suffix) : ] ==# suffix
enddef

export def TrimSuffix(str: string, suffix: string): string
  if !HasSuffix(str, suffix)
    return str
  endif
  return str[ : len(str) - len(suffix) - 1]
enddef
