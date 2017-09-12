
" if exists("loaded_foldsearch_tj")
"   finish
" endif
let loaded_foldsearch_tj = v:true


" Default behaviors if nothing else is defined
let s:DEFFOLDMETHOD = &foldmethod
let s:DEFFOLDEXPR   = &foldexpr
let s:DEFFOLDTEXT   = &foldtext
let s:DEFFOLDLEVEL  = 1000


""
" Toggle the folding around the searches
function! fold_search#toggle_search(opts) abort
  " How many lines of context to show
  let b:foldsearch = get(b:, 'foldsearch', {'active': 0})
  let b:foldsearch.fold_text = get(a:opts, 'fold_text', fold_search#conf#get('defaults', 'fold_text'))
  let b:foldsearch.context = get(a:opts, 'context', fold_search#conf#get('defaults', 'context'))

  let &foldminlines = b:foldsearch.context

  " If off, turn on
  if b:foldsearch.active
    let &foldmethod = get(b:foldsearch, 'previous_foldmethod', s:DEFFOLDMETHOD)
    let &foldexpr = get(b:foldsearch, 'previous_foldexpr', s:DEFFOLDEXPR)
    let &foldtext = get(b:foldsearch, 'previous_foldtext', s:DEFFOLDTEXT)
    let &foldlevel = get(b:foldsearch, 'previous_foldlevel', s:DEFFOLDLEVEL)

    " Remove autocommands so that we don't run them outside of fold search
    augroup FoldSearch
      autocmd!
    augroup END

    " Inactivate foldsearch in this buffer
    let b:foldsearch.active = 0

    " If we have a map for special folds, unmap it
    call fold_search#map#remove_fold_alternate()

    " TODO: Figure out why original had 'zE' here. It doesn't really make
    " sense to me. Seems to delete folds in the buffer that it has no reason
    " deleting
    " TODO: Maybe use either zx or zX
    return 'zX'
  else
    " Save off the old settings
    let b:foldsearch.previous_foldmethod = &foldmethod
    let b:foldsearch.previous_foldexpr = &foldexpr
    let b:foldsearch.previous_foldtext  = &foldtext
    let b:foldsearch.previous_foldlevel  = &foldlevel

    " Set up new behavior
    set foldmethod=expr
    let &foldtext = fold_search#conf#get('defaults', 'fold_text')
    let &foldexpr = fold_search#conf#get('defaults', 'fold_expr')
    let &foldlevel = 0

    augroup FoldSearch
      autocmd!
      autocmd CursorMoved   <buffer>    let b:foldsearch.in_open_fold = foldlevel('.') && foldclosed('.') == -1
      autocmd CursorMoved   <buffer>    let &foldexpr = &foldexpr
      autocmd CursorMoved   <buffer>    let &foldlevel = 0
      autocmd CursorMoved   <buffer>    call fold_search#reopen_fold()
    augroup END

    call fold_search#map#enable_fold_alternate()

    let b:foldsearch.active = 1

    return "\<C-L>"
  endif
endfunction

function! fold_search#default_fold_expr() abort " {{{
    " Allow one line of context before and after...
    let startline = v:lnum > 1         ? v:lnum - b:foldsearch.context : v:lnum
    let endline   = v:lnum < line('$') ? v:lnum + b:foldsearch.context : v:lnum
    let context = getline(startline, endline)

    " Simulate smartcase matching...
    let matchpattern = @/

    if fold_search#conf#get('settings', 'smartcase_matching_enabled') && matchpattern =~ '\u'
        let matchpattern = '\C' . matchpattern
    endif

    " Line is folded if surrounding context doesn't match last search pattern...
    return match(context, matchpattern) == -1
endfunction " }}}
function! fold_search#default_fold_text() abort " {{{
  return '___/ line ' . (v:foldend + 1) . ' \' . repeat('_', 300)
endfunction " }}}
function! fold_search#default_fold_noshow_text() abort " {{{
  return repeat('_', 350)
endfunction " }}}
function! fold_search#reopen_fold() abort " {{{
  if !exists('b:foldsearch')
    return
  endif

  if !has_key(b:foldsearch, 'in_open_fold')
    return
  endif


  " Only do this when we'er in an open fold
  if b:foldsearch.in_open_fold
    normal! zo
  endif
endfunction " }}}
