let s:username = 'wsdjeg'
let s:gateway = 'spacevim-cn'
let s:port = '9995'

let s:JSON = spacevim#api#import('data#json')
let s:JOB = spacevim#api#import('job')

func! spacevim#dev#send_to_channel#setport(port) abort
	let s:port = a:port
endf
func! spacevim#dev#send_to_channel#send(t) abort

	if a:t ==# 'line'
		call s:sendline()
	endif

endf

func! s:send(msg) abort
	let msg = {
				\   'text' : a:msg,
				\   'username' : s:username,
				\   'gateway' : s:gateway
				\ }
	" run command curl -XPOST -H 'Content-Type: application/json'  -d '{"text":"test","username":"randomuser","gateway":"gateway1"}' http://localhost:4242/api/message
	let cmd = ['curl', '-XPOST', '-H', 'Content-Type: application/json', '-d', s:JSON.json_encode(msg), 'http://localhost:' . s:port . '/api/message']
	call s:JOB.start(cmd)
endf

function! s:sendline() abort
	call s:send(getline('.'))
endfunction

function! s:sendselection() abort

endfunction
