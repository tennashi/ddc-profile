let s:profiles = {}

function! ddc#custom#profile#new(name) abort
  let s:profiles[a:name] = {}
endfunction

function! ddc#custom#profile#ensure(name) abort
  if !has_key(s:profiles, a:name)
    call ddc#custom#profile#new(a:name)
  endif
endfunction

function! ddc#custom#profile#insert_source(name, source, index) abort
  if !has_key(s:profiles[a:name], 'sources')
    let s:profiles[a:name]['sources'] = []
  endif

  let l:cur_sources = s:profiles[a:name]['sources']
  let l:sources = insert(l:cur_sources, a:source, a:index)

  let s:profiles[a:name]['sources'] = l:sources
endfunction

function! ddc#custom#profile#add_source(name, source) abort
  if !has_key(s:profiles[a:name], 'sources')
    let s:profiles[a:name]['sources'] = []
  endif

  let l:cur_sources = s:profiles[a:name]['sources']
  let l:sources = add(l:cur_sources, a:source)

  let s:profiles[a:name]['sources'] = l:sources
endfunction

function! ddc#custom#profile#load(name) abort
  let l:profile = s:profiles[a:name]
  call ddc#custom#patch_local(a:name, l:profile)
endfunction

augroup DDCProfile
  autocmd!
  autocmd VimEnter * call s:install_profile()
augroup END

function! s:install_profile() abort
  call map(s:profiles, { name -> ddc#custom#profile#load(l:name) })
endfunction
