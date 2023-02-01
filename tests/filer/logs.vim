vim9script

import '../../autoload/filer/logs.vim'

final suite = themis#suite('strings')
const assert = themis#helper('assert')

def TestError(): void
  logs.Error('Error called.')

  var captured: string
  redir => captured
  messages
  redir END
  const got = split(captured, '\n')

  assert.equals(got[-1], 'Error called.')
enddef
suite.TestError = TestError
