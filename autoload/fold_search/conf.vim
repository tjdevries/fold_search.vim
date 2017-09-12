
" Prefix to use for this autoload file
let s:autoload_prefix = "fold_search#conf"

" Set the name of name of your plugin.
" Here is my best guess
call conf#set_name(s:, 'fold_search')

call conf#add_area(s:, 'defaults')
call conf#add_setting(s:, 'defaults', 'context', {
      \ 'default': 1,
      \ 'type': v:t_number,
      \ 'description': 'Default number of lines to show when folding',
      \ })
call conf#add_setting(s:, 'defaults', 'fold_text', {
      \ 'default': 'fold_search#default_fold_text()',
      \ 'type': v:t_string,
      \ 'description': '&foldtext function to set during folding. Set to the function you want to call',
      \ })
call conf#add_setting(s:, 'defaults', 'fold_expr', {
      \ 'default': 'fold_search#default_fold_expr()',
      \ 'type': v:t_string,
      \ 'description': '&foldexpr value to set during active search',
      \ })

call conf#add_area(s:, 'settings')
call conf#add_setting(s:, 'settings', 'smartcase_matching_enabled', {
      \ 'default': v:true,
      \ 'type': v:t_bool,
      \ 'description': 'Enable smart case matching in the default fold_search items',
      \ })

call conf#add_area(s:, 'mappings')
call conf#add_setting(s:, 'mappings', 'fold_alternate_key', {
      \ 'default': '<CR>',
      \ 'type': v:t_string,
      \ 'description': 'Key pattern to use for executing alternate folds while active. Set to "" to disable',
      \ })
call conf#add_setting(s:, 'mappings', 'fold_search', {
      \ 'default': 'zz',
      \ 'type': v:t_string,
      \ 'description': 'Default mapping to toggle the search folding. Set to "" to disable mapping',
      \ 'action': conf#actions#mapping({
          \ 'rhs': 'fold_search#toggle_search({})',
          \ 'mode': 'n',
          \ 'expr': v:true,
          \ 'silent': v:true,
          \ }),
      \ })


""
" fold_search#conf#set
" Set a "value" for the "area.setting"
" See |conf.set_setting|
function! fold_search#conf#set(area, setting, value) abort
  return conf#set_setting(s:, a:area, a:setting, a:value)
endfunction


""
" fold_search#conf#get
" Get the "value" for the "area.setting"
" See |conf.get_setting}
function! fold_search#conf#get(area, setting) abort
  return conf#get_setting(s:, a:area, a:setting)
endfunction


""
" fold_search#conf#view
" View the current configuration dictionary.
" Useful for debugging
function! fold_search#conf#view() abort
  return conf#view(s:)
endfunction


""
" fold_search#conf#menu
" Provide the user with an automatic "quickmenu"
" See |conf.menu|
function! fold_search#conf#menu() abort
  return conf#menu(s:)
endfunction


""
" fold_search#conf#generate_docs
" Returns a list of lines to be placed in your documentation
" 0
function! fold_search#conf#generate_docs() abort
  return conf#docs#generate(s:, s:autoload_prefix)
endfunction
