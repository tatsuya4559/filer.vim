vim9script

const save_cpo = &cpoptions
set cpoptions&vim

if exists('g:loaded_filer')
  finish
endif
g:loaded_filer = 1

import autoload 'filer.vim'

def ShutupNetrw(): void
  autocmd! FileExplorer *
enddef

augroup __filer__
  autocmd!
  autocmd VimEnter * ShutupNetrw()
  autocmd BufEnter * {
    ShutupNetrw()
    filer.Init()
  }
  autocmd ShellCmdPost * ++nested {
    if exists('b:dir')
      filer.Reload()
    endif
  }
augroup END

nnoremap <silent> <Plug>(filer-start) <ScriptCmd>filer.Start()<CR>

if !hasmapto('<Plug>(filer-start)')
  nmap - <Plug>(filer-start)
endif

&cpoptions = save_cpo
