if exists('b:current_syntax') && b:current_syntax ==# 'spacevim_cpicker_mix'
  finish
endif
let b:current_syntax = 'spacevim_cpicker_mix'
syntax case ignore

syn match spacevimPickerMixProcessBar /[?=+]\+/
syn match spacevimPickerMixColor1P /P1/ contained
syn match spacevimPickerMixColor2P /P2/ contained
syn match spacevimPickerMixColor1 /#[0123456789ABCDEF]\+\s\+P1/ contains=spacevimPickerMixColor1P
syn match spacevimPickerMixColor2 /#[0123456789ABCDEF]\+\s\+P2/ contains=spacevimPickerMixColor2P
syn match spacevimPickerMixColor3 /=\+\s/
syn match spacevimPickerMixColor3Background /\s=\+\s/
syn match spacevimPickerMixColor3Code /\scolor-mix...............................................\|\s#......\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s\s/
syn match spacevimPickerMixMethodFlag /[<>]/ contained
syn match spacevimPickerMixMethod /[<>].\+[<>]/ contains=spacevimPickerMixMethodFlag

highlight spacevimPickerMixProcessBar ctermfg=Gray ctermbg=Gray guifg=Gray guibg=Gray
highlight link spacevimPickerMixMethodFlag EndOfBuffer
highlight spacevimPickerMixMethod ctermfg=Black ctermbg=Gray guifg=Black guibg=Gray
highlight link spacevimPickerMixColor1P Normal
highlight link spacevimPickerMixColor2P Normal

