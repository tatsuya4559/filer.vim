vim9script

import autoload 'paths.vim'

final suite = themis#suite('strings')
const assert = themis#helper('assert')

def TestWithTrailingSlash(): void
  const tests = [
    {input: ['foo'], want: 'foo/'},
    {input: ['foo/'], want: 'foo/'},
  ]

  for tt in tests
    const got = call(paths.WithTrailingSlash, tt.input)
    const msg = printf(
      'WithTrailingSlash("%s") want %s, but got %s',
      tt.input, tt.want, got)
    assert.equals(got, tt.want, msg)
  endfor
enddef
suite.TestWithTrailingSlash = TestWithTrailingSlash

def TestJoin(): void
  const tests = [
    {input: ['foo', 'bar'], want: 'foo/bar'},
    {input: ['foo/', 'bar'], want: 'foo/bar'},
  ]

  for tt in tests
    const got = call(paths.Join, tt.input)
    const msg = printf(
      'Join("%s") want %s, but got %s',
      tt.input, tt.want, got)
    assert.equals(got, tt.want, msg)
  endfor
enddef
suite.TestJoin = TestJoin
