vim9script

import autoload 'paths.vim'

final suite = themis#suite('strings')
const assert = themis#helper('assert')

def TestWithTrailingSlash(): void
  const tests = [
    {input: ['foo'], want: 'foo/'},
    {input: ['foo/'], want: 'foo/'},
  ]

  final child = themis#suite('TestWithTrailingSlash')
  for tt in tests
    const description = printf('WithTrailingSlash(%s)', tt.input)
    child[description] = function((input, want) => {
      const got = call(paths.WithTrailingSlash, input)
      assert.equals(got, want)
    }, [tt.input, tt.want])
  endfor
enddef
suite.__TestWithTrailingSlash__ = TestWithTrailingSlash

def TestJoin(): void
  const tests = [
    {input: ['foo', 'bar'], want: 'foo/bar'},
    {input: ['foo/', 'bar'], want: 'foo/bar'},
  ]

  final child = themis#suite('TestJoin')
  for tt in tests
    const description = printf('Join(%s)', tt.input)
    child[description] = function((input, want) => {
      const got = call(paths.Join, input)
      assert.equals(got, want)
    }, [tt.input, tt.want])
  endfor
enddef
suite.__TestJoin__ = TestJoin
