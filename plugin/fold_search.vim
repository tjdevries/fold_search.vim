let s:has_confvim = get(s:, 'has_confvim', stridx(&runtimepath, 'conf.vim') >= 0)
let s:has_standardvim = get(s:, 'has_standardvim', stridx(&runtimepath, 'standard.vim') >= 0)


let g:loaded_fold_search = v:null
if !s:has_confvim
  echoerr '[FOLD_SEARCH] fold_search.vim requires the plugin "tjdevries/conf.vim". Please install it'
  finish
endif

if !s:has_standardvim
  echoerr '[FOLD_SEARCH] fold_search.vim requires the plugin "tjdevries/standard.vim". Please install it.'
  finish
endif

if !conf#util#require_plugins('fold_search', {
      \ 'conf': '0.9.0',
      \ 'std': '1.0.0',
      \ })
  finish
endif

let g:loaded_fold_search = v:true

" Load the config and get all the mappings as necessary
runtime! autoload/fold_search/conf.vim
