" getsid.vim
"
" description: utility function for getting SID (a.k.a script id).
" install: copy to ~/.vim/plugin/getsid.vim
" author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
"
" specify your script name as full path at each vimscripts like following.
"
"   let mysid = GetSID(expand('<sfile>:p'))
"
" how to use:
"   If you have two vimscript. the first is observable. caller of callback..
"   the second is observer. holder of callback function.
"
"   script1.vim:
"     
"     function! Caller(fn)
"       call a:fn("foo")
"     endfunction

"   script2.vim:
"
"     function! s:Callback(a)
"       echo a:a
"     endfunction
"
"  If calling Caller() in script2.vim, then code perhaps may be following.
"
"    call Caller(function('s:Callback'))
"
"  But it can't. Caller don't know 'What is s:Callback, Where is s:'. 
"  This script is helpful for this case. You can do it as following.
"
"    call Caller(ScriptFuncref('Callback', expand('<sfile>:p')))
"
"  If you want to get own script id in your script, 
"
"    let mysid =  GetSID(expand('<sfile>:p'))
"
"  Or, add into top of the script.
"
"    UseGetSID
"
"  Then
"
"    let mysid =  s:GetSID()
"
function! GetSID(n)
  redir => out | silent! scriptnames | redir END
  return index(map(split(out,"\n"),"substitute(v:val,'^[^:]*:\\s*\\(.*\\)$','\\1','')"),a:n)+1
endfunction

function! ScriptFuncref(n,s)
  return function('<SNR>'.GetSID(a:s).'_'.a:n)
endfunction

command! UseGetSID exe "function! <SNR>".GetSID(expand('<sfile>:p'))."_GetSID()\nreturn GetSID('".expand('<sfile>:p')."')\nendfunction"
