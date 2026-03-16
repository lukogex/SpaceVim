let s:LOGGER =spacevim#logger#derive('vim-mail')

function! mail#logger#info(msg)
  call s:LOGGER.info(a:msg)
endfunction

function! mail#logger#error(msg)
  call s:LOGGER.error(a:msg)
endfunction

function! mail#logger#warn(msg)

  call s:LOGGER.warn(a:msg)
  
endfunction

