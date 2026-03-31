let s:self = {}


if has('iconv') && !has('nvim')
  function! s:self.iconv(str, from, to) abort
    return iconv(a:str, a:from, a:to)
  endfunction
else
  function! s:self.iconv(str, from, to) abort
    " let errors = get(a:000, 0, 'strict')
    return s:iconv.iconv(a:str, a:from, a:to, 'strict')
  endfunction
endif


function! spacevim#api#iconv#import() abort

  return s:iconv

endfunction

function! spacevim#api#iconv#iconv(expr, from, to, ...) abort
  let errors = get(a:000, 0, 'strict')
  try
    return s:iconv.iconv(a:expr, a:from, a:to, errors)
  endtry
endfunction

function! spacevim#api#iconv#iconvb(expr, from, to, ...) abort
  let errors = get(a:000, 0, 'strict')
  try
    return s:iconv.iconvb(a:expr, a:from, a:to, errors)
  endtry
endfunction

let s:bytes = spacevim#api#iconv#bytes#import()

let s:iconv = {}

function! s:iconv.iconv(expr, from, to, errors) abort
  return s:bytes.bytes2str(self.iconvb(a:expr, a:from, a:to, a:errors))
endfunction

function! s:iconv.iconvb(expr, from, to, errors) abort
  let expr = s:bytes.tobytes(a:expr)
  return self._iconv(expr, a:from, a:to, a:errors)
endfunction

function! s:iconv._iconv(expr, from, to, errors) abort
  let from = tolower(a:from)
  let to = tolower(a:to)

  if !has_key(self.codecs, from)
    throw printf('unknown encoding: %s', from)
  endif

  if !has_key(self.codecs, to)
    throw printf('unknown encoding: %s', to)
  endif

  let decoder_module = call(self.codecs[from], [])
  let encoder_module = call(self.codecs[to], [])

  let decoder = decoder_module.Codec.new()
  let encoder = encoder_module.Codec.new()

  let u = decoder.decode(a:expr, a:errors)
  let s = encoder.encode(u, a:errors)

  return s
endfunction

let s:iconv.codecs = {
      \ 'ascii': function('spacevim#api#iconv#codecs#ascii#import'),
      \ 'utf-8': function('spacevim#api#iconv#codecs#utf8#import'),
      \ 'utf-16': function('spacevim#api#iconv#codecs#utf16#import'),
      \ 'utf-16be': function('spacevim#api#iconv#codecs#utf16be#import'),
      \ 'utf-16le': function('spacevim#api#iconv#codecs#utf16le#import'),
      \ 'utf-32': function('spacevim#api#iconv#codecs#utf32#import'),
      \ 'utf-32be': function('spacevim#api#iconv#codecs#utf32be#import'),
      \ 'utf-32le': function('spacevim#api#iconv#codecs#utf32le#import'),
      \ 'latin1': function('spacevim#api#iconv#codecs#_8859_1#import'),
      \ 'iso-8859-1': function('spacevim#api#iconv#codecs#_8859_1#import'),
      \ 'iso-8859-2': function('spacevim#api#iconv#codecs#_8859_2#import'),
      \ 'iso-8859-3': function('spacevim#api#iconv#codecs#_8859_3#import'),
      \ 'iso-8859-4': function('spacevim#api#iconv#codecs#_8859_4#import'),
      \ 'iso-8859-5': function('spacevim#api#iconv#codecs#_8859_5#import'),
      \ 'iso-8859-6': function('spacevim#api#iconv#codecs#_8859_6#import'),
      \ 'iso-8859-7': function('spacevim#api#iconv#codecs#_8859_7#import'),
      \ 'iso-8859-8': function('spacevim#api#iconv#codecs#_8859_8#import'),
      \ 'iso-8859-9': function('spacevim#api#iconv#codecs#_8859_9#import'),
      \ 'iso-8859-10': function('spacevim#api#iconv#codecs#_8859_10#import'),
      \ 'iso-8859-11': function('spacevim#api#iconv#codecs#_8859_11#import'),
      \ 'iso-8859-13': function('spacevim#api#iconv#codecs#_8859_13#import'),
      \ 'iso-8859-14': function('spacevim#api#iconv#codecs#_8859_14#import'),
      \ 'iso-8859-15': function('spacevim#api#iconv#codecs#_8859_15#import'),
      \ 'cp037': function('spacevim#api#iconv#codecs#_cp037#import'),
      \ 'cp1026': function('spacevim#api#iconv#codecs#_cp1026#import'),
      \ 'cp1250': function('spacevim#api#iconv#codecs#_cp1250#import'),
      \ 'cp1251': function('spacevim#api#iconv#codecs#_cp1251#import'),
      \ 'cp1252': function('spacevim#api#iconv#codecs#_cp1252#import'),
      \ 'cp1253': function('spacevim#api#iconv#codecs#_cp1253#import'),
      \ 'cp1254': function('spacevim#api#iconv#codecs#_cp1254#import'),
      \ 'cp1255': function('spacevim#api#iconv#codecs#_cp1255#import'),
      \ 'cp1256': function('spacevim#api#iconv#codecs#_cp1256#import'),
      \ 'cp1257': function('spacevim#api#iconv#codecs#_cp1257#import'),
      \ 'cp1258': function('spacevim#api#iconv#codecs#_cp1258#import'),
      \ 'cp437': function('spacevim#api#iconv#codecs#_cp437#import'),
      \ 'cp500': function('spacevim#api#iconv#codecs#_cp500#import'),
      \ 'cp737': function('spacevim#api#iconv#codecs#_cp737#import'),
      \ 'cp775': function('spacevim#api#iconv#codecs#_cp775#import'),
      \ 'cp850': function('spacevim#api#iconv#codecs#_cp850#import'),
      \ 'cp852': function('spacevim#api#iconv#codecs#_cp852#import'),
      \ 'cp855': function('spacevim#api#iconv#codecs#_cp855#import'),
      \ 'cp857': function('spacevim#api#iconv#codecs#_cp857#import'),
      \ 'cp860': function('spacevim#api#iconv#codecs#_cp860#import'),
      \ 'cp861': function('spacevim#api#iconv#codecs#_cp861#import'),
      \ 'cp862': function('spacevim#api#iconv#codecs#_cp862#import'),
      \ 'cp863': function('spacevim#api#iconv#codecs#_cp863#import'),
      \ 'cp864': function('spacevim#api#iconv#codecs#_cp864#import'),
      \ 'cp865': function('spacevim#api#iconv#codecs#_cp865#import'),
      \ 'cp866': function('spacevim#api#iconv#codecs#_cp866#import'),
      \ 'cp869': function('spacevim#api#iconv#codecs#_cp869#import'),
      \ 'cp874': function('spacevim#api#iconv#codecs#_cp874#import'),
      \ 'cp875': function('spacevim#api#iconv#codecs#_cp875#import'),
      \ 'cp932': function('spacevim#api#iconv#codecs#_cp932#import'),
      \ 'cp936': function('spacevim#api#iconv#codecs#_cp936#import'),
      \ 'cp949': function('spacevim#api#iconv#codecs#_cp949#import'),
      \ 'cp950': function('spacevim#api#iconv#codecs#_cp950#import'),
      \ 'euc-jp': function('spacevim#api#iconv#codecs#_euc_jp#import'),
      \ }

function! spacevim#api#iconv#get() abort

  return deepcopy(s:self)

endfunction
