vim9script

import autoload 'strings.vim'

final suite = themis#suite('strings')
const assert = themis#helper('assert')

def TestContains(): void
  const tests = [
    {input: ['foobar', 'ob'], want: true},
    {input: ['foobar', 'ub'], want: false},
    {input: ['', 'ob'], want: false},
    {input: ['foobar', ''], want: true},
  ]

  for tt in tests
    const got = call(strings.Contains, tt.input)
    const msg = printf(
      'Contains(%s) want %s, but got %s',
      tt.input, tt.want, got)
    assert.equals(got, tt.want, msg)
  endfor
enddef
suite.TestContains = TestContains

def TestHasPrefix(): void
  const tests = [
    {input: ['', ''], want: true},
    {input: ['foo', ''], want: true},
    {input: ['foo', 'fo'], want: true},
    {input: ['foo', 'oo'], want: false},
    {input: ['', 'f'], want: false},
  ]

  for tt in tests
    const got = call(strings.HasPrefix, tt.input)
    const msg = printf(
      'HasPrefix(%s) want %s, but got %s',
      tt.input, tt.want, got)
    assert.equals(got, tt.want, msg)
  endfor
enddef
suite.TestHasPrefix = TestHasPrefix

def TestHasSuffix(): void
  const tests = [
    {input: ['', ''], want: true},
    {input: ['foo', ''], want: true},
    {input: ['foo', 'fo'], want: false},
    {input: ['foo', 'oo'], want: true},
    {input: ['', 'f'], want: false},
  ]

  for tt in tests
    const got = call(strings.HasSuffix, tt.input)
    const msg = printf(
      'HasSuffix(%s) want %s, but got %s',
      tt.input, tt.want, got)
    assert.equals(got, tt.want, msg)
  endfor
enddef
suite.TestHasSuffix = TestHasSuffix

def TestTrimSuffix(): void
  const tests = [
    {input: ['foo.txt', '.txt'], want: 'foo'},
    {input: ['foo.txt', 'foo'], want: 'foo.txt'},
    {input: ['foo.txt', ''], want: 'foo.txt'},
    {input: ['', 'foo'], want: ''},
  ]

  for tt in tests
    const got = call(strings.TrimSuffix, tt.input)
    const msg = printf(
      'TrimSuffix("%s") want %s, but got %s',
      tt.input, tt.want, got)
    assert.equals(got, tt.want, msg)
  endfor
enddef
suite.TestTrimSuffix = TestTrimSuffix
