command! -nargs=*
            \ -complete=custom,spacevim#commands#complete_plugin
            \ SPUpdate call spacevim#commands#update_plugin(<f-args>)

command! -nargs=+
            \ -complete=custom,spacevim#commands#complete_plugin
            \ SPReinstall call spacevim#commands#reinstall_plugin(<f-args>)

command! -nargs=* SPInstall call spacevim#commands#install_plugin(<f-args>)


command! -nargs=*
            \ -complete=custom,spacevim#commands#complete_plugin
            \ DeinUpdate call spacevim#commands#update_plugin(<f-args>)

let g:spacevim_plugin_manager_max_processes =
      \ get(g:, 'spacevim_plugin_manager_max_processes', 8)
let g:spacevim_plugin_manager =
      \ get(g:, 'spacevim_plugin_manager', 'dein')
