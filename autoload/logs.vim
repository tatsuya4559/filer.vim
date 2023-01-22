vim9script

export def Error(msg: string): void
  redraw
  echohl Error
  echomsg msg
  echohl None
enddef
