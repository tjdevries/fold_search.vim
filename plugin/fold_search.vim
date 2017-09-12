let s:has_confvim = get(s:, 'has_confvim', stridx(&runtimepath, 'conf.vim') >= 0)

if !s:has_confvim
  echoerr '[FOLD_SEARCH] fold_search.vim requires the plugin "tjdevries/conf.vim". Please install it'
  finish
endif

" Load the config and get all the mappings as necessary
runtime! autoload/fold_search/conf.vim
