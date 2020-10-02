nnoremap <silent> <Plug>(filer-down) :<C-u>call filer#down()<CR>
nnoremap <silent> <Plug>(filer-up) :<C-u>call filer#up()<CR>
nnoremap <silent> <Plug>(filer-reload) :<C-u>call filer#reload()<CR>
nnoremap <silent> <Plug>(filer-home) :<C-u>call filer#home()<CR>
nnoremap <silent> <Plug>(filer-toggle-hidden) :<C-u>call filer#toggle_hidden()<CR>
nnoremap <silent> <Plug>(filer-command) :<C-u>call filer#command()<CR>
nnoremap <silent> <Plug>(filer-fullpath) :<C-u>call filer#show_fullpath()<CR>

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
