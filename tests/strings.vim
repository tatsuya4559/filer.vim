vim9script

import '../autoload/strings.vim'

final suite = themis#suite('strings')
const assert = themis#helper('assert')

def TestContains(): void
  const tests = [
    {input: ['foobar', 'ob'], want: true},
    {input: ['foobar', 'ub'], want: false},
    {input: ['', 'ob'], want: false},
    {input: ['foobar', ''], want: true},
  ]

  final child = themis#suite('TestContains')
  for tt in tests
    const description = printf('Contains(%s)', tt.input)
    child[description] = function((input, want) => {
      const got = call(strings.Contains, input)
      assert.equals(got, want)
    }, [tt.input, tt.want])
  endfor
enddef
suite.__TestContains__ = TestContains

def TestHasPrefix(): void
  const tests = [
    {input: ['', ''], want: true},
    {input: ['foo', ''], want: true},
    {input: ['foo', 'fo'], want: true},
    {input: ['foo', 'oo'], want: false},
    {input: ['', 'f'], want: false},
  ]

  final child = themis#suite('TestHasPrefix')
  for tt in tests
    const description = printf('HasPrefix(%s)', tt.input)
    child[description] = function((input, want) => {
      const got = call(strings.HasPrefix, input)
      assert.equals(got, want)
    }, [tt.input, tt.want])
  endfor
enddef
suite.__TestHasPrefix__ = TestHasPrefix

def TestHasSuffix(): void
  const tests = [
    {input: ['', ''], want: true},
    {input: ['foo', ''], want: true},
    {input: ['foo', 'fo'], want: false},
    {input: ['foo', 'oo'], want: true},
    {input: ['', 'f'], want: false},
  ]

  final child = themis#suite('TestHasSuffix')
  for tt in tests
    const description = printf('HasSuffix(%s)', tt.input)
    child[description] = function((input, want) => {
      const got = call(strings.HasSuffix, input)
      assert.equals(got, want)
    }, [tt.input, tt.want])
  endfor
enddef
suite.__TestHasSuffix__ = TestHasSuffix

def TestTrimSuffix(): void
  const tests = [
    {input: ['foo.txt', '.txt'], want: 'foo'},
    {input: ['foo.txt', 'foo'], want: 'foo.txt'},
    {input: ['foo.txt', ''], want: 'foo.txt'},
    {input: ['', 'foo'], want: ''},
  ]

  final child = themis#suite('TestTrimSuffix')
  for tt in tests
    const description = printf('TrimSuffix(%s)', tt.input)
    child[description] = function((input, want) => {
      const got = call(strings.TrimSuffix, input)
      assert.equals(got, want)
    }, [tt.input, tt.want])
  endfor
enddef
suite.__TestTrimSuffix__ = TestTrimSuffix
