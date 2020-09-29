nnoremap <Plug>(filer-open) :<C-u>call filer#open()<CR>
nnoremap <Plug>(filer-up) :<C-u>call filer#up()<CR>
nnoremap <Plug>(filer-reload) :<C-u>call filer#reload()<CR>
nnoremap <Plug>(filer-home) :<C-u>call filer#home()<CR>
nnoremap <Plug>(filer-toggle-hidden) :<C-u>call filer#toggle_hidden()<CR>
nnoremap <Plug>(filer-command) :<C-u>call filer#command()<CR>
nnoremap <Plug>(filer-fullpath) :<C-u>call filer#show_fullpath()<CR>

if !hasmapto('<Plug>(filer-open)')
  nmap <buffer> <CR> <Plug>(filer-open)
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
