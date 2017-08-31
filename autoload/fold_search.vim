
if exists("loaded_foldsearch_tj")
  finish
endif
let loaded_foldsearch_tj = v:true

""
" Toggle the folding around the searches
function! fold_search#toggle_search(opts) abort
  " How many lines of context to show
  let b:fold_context = get(a:opts, 'context', fold_search#conf#get('defaults', 'context'))
  let &foldminlines = b:fold_context

  " Show folds in the search?
  let fold_text_key = get(a:opts, 'fold_text', fold_search#conf#get('defaults', 'fold_text'))

  let b:foldsearch = get(b:, 'foldsearch', {'active': 0})

  " If off, turn on
  if b:foldsearch.active
  else
  endif
endfunction

""
" Function for use in special fold mapping
function! fold_search#special_fold_map() abort
  if foldlevel('.')
    return 'zA'
  endif

  if exists('b:fold_search_old_buffer_map')
    return std#mapping#execute_dict(b:fold_search_old_buffer_map)
  endif

  return fold_search#conf#get('mappings', 'special_fold_key')
endfunction

""
" Enable special fold map
function! fold_search#enable_special_fold_map() abort
  " Set up special fold key mapping
  let special_fold_key = fold_search#conf#get('mappings', 'special_fold_key')
  " Only map this if they want us to.
  if special_fold_key != ''
    let b:fold_search_old_buffer_map = maparg(special_fold_key, 'n', v:false, v:true)
    call execute('nnoremap <buffer><expr> ' . special_fold_key . ' fold_search#special_fold_map()<CR>')
  endif
endfunction

""
" Remove special fold map
function! fold_search#remove_special_fold_map() abort
  " Remove special fold key mapping
  let special_fold_key = fold_search#conf#get('mappings', 'special_fold_key')
  call execute('nunmap <buffer>' . special_fold_key)
  if exists('b:fold_search_old_buffer_map')
    call std#mapping#map_dict(b:fold_search_old_buffer_map)
  endif
endfunction
