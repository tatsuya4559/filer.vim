if exists('b:current_syntax')
  finish
endif

syn match filerDirectory '^.\+/$'
syn match filerHidden '^\(/.\+/\)\?\.[^/]\+\(/\)\?$'

hi! def link filerDirectory Directory
hi! def link filerHidden Comment

let b:current_syntax = 'filer'
