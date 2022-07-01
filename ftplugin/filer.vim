vim9script

import autoload 'filer.vim' as filer
nnoremap <silent> <Plug>(filer-down) <ScriptCmd>filer.Down()<CR>
nnoremap <silent> <Plug>(filer-up) <ScriptCmd>filer.Up()<CR>
nnoremap <silent> <Plug>(filer-reload) <ScriptCmd>filer.Reload()<CR>
nnoremap <silent> <Plug>(filer-home) <ScriptCmd>filer.Home()<CR>
nnoremap <silent> <Plug>(filer-toggle-hidden) <ScriptCmd>filer.ToggleHidden()<CR>
nnoremap <silent> <Plug>(filer-command) <ScriptCmd>filer.Command()<CR>
nnoremap <silent> <Plug>(filer-fullpath) <ScriptCmd>filer.ShowFullpath()<CR>

if !hasmapto('<Plug>(filer-down)')
  nmap <buffer> <CR> <Plug>(filer-down)
endif
if !hasmapto('<Plug>(filer-up)')
  nmap <buffer> - <Plug>(filer-up)
endif
if !hasmapto('<Plug>(filer-reload)')
  nmap <buffer> R <Plug>(filer-reload)
endif
if !hasmapto('<Plug>(filer-home)')
  nmap <buffer> ~ <Plug>(filer-home)
endif
if !hasmapto('<Plug>(filer-toggle-hidden)')
  nmap <buffer> . <Plug>(filer-toggle-hidden)
endif
if !hasmapto('<Plug>(filer-command)')
  nmap <buffer> x <Plug>(filer-command)
endif
if !hasmapto('<Plug>(filer-fullpath)')
  nmap <buffer> F <Plug>(filer-fullpath)
endif
