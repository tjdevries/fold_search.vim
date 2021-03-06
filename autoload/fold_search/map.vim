
""
" Function for use in special fold mapping
function! fold_search#map#execute_fold_alternate() abort
  if !exists('b:foldsearch')
    return ''
  endif

  if foldlevel('.')
    return 'zA'
  endif

  if has_key(b:foldsearch, 'original_fold_alternate')
    return std#mapping#execute_dict(b:foldsearch.original_fold_alternate)
  endif

  return std#mapping#execute_global('n', fold_search#conf#get('mappings', 'fold_alternate_key'))
endfunction

""
" Enable special fold map
function! fold_search#map#enable_fold_alternate() abort
  if !exists('b:foldsearch')
    return
  endif

  " Set up special fold key mapping
  let fold_alternate_key = fold_search#conf#get('mappings', 'fold_alternate_key')

  " Only map this if they want us to.
  if fold_alternate_key != ''
    " Store the mapping dictionary for later remapping use
    let map_dict = maparg(fold_alternate_key, 'n', v:false, v:true)

    " Only need to remap buffer items, since we'll be using a buffer mapping
    if get(map_dict, 'buffer', v:false)
      " Cache
      let b:foldsearch.original_fold_alternate  = map_dict
    else
      " Clear old values
      silent! call remove(b:foldsearch, 'original_fold_alternate')
    endif

    " Map the new key
    call execute('nnoremap <buffer><expr> ' . fold_alternate_key . ' fold_search#map#execute_fold_alternate()')
  endif
endfunction

""
" Remove special fold map
function! fold_search#map#remove_fold_alternate() abort
  if !exists('b:foldsearch')
    return
  endif

  " Remove special fold key mapping
  let fold_alternate_key = fold_search#conf#get('mappings', 'fold_alternate_key')

  call execute('nunmap <buffer>' . fold_alternate_key)

  if has_key(b:foldsearch, 'original_fold_alternate')
    call std#mapping#map_dict(b:foldsearch.original_fold_alternate)
  endif
endfunction
