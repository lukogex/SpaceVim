if exists('b:current_syntax')
    finish
endif
let b:current_syntax = 'spacevimQuickFix'
syntax case ignore
syn match FileName /^[^ ]*/

hi def link FileName String
