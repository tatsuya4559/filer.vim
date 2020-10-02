let s:save_cpo = &cpoptions
set cpoptions&vim

if exists('g:loaded_filer')
  finish
endif
let g:loaded_filer = 1

function! s:shutup_netrw() abort
  autocmd! FileExplorer *
endfunction

augroup __filer__
  autocmd!
  autocmd VimEnter * call s:shutup_netrw()
  autocmd BufEnter * call s:shutup_netrw() | call filer#init()
  autocmd ShellCmdPost * nested if exists('b:dir') | call filer#reload() | endif
augroup END

nnoremap <silent> <Plug>(filer-start) :<C-u>call filer#start()<CR>

if !hasmapto('<Plug>(filer-start)')
  nmap - <Plug>(filer-start)
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo
