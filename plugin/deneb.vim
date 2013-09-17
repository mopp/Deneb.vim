" Installation
" NeoBundle 'gist:mopp/', { 'name': 'crazy.vim', 'script_type': 'plugin'}

let s:buf_name = 'Deneb'
let s:signature = '=====DELIMITER====='

" Write opend files
function! s:write_files()
    " echomsg 'call write'
    call cursor(1, 0)
    let now_line = 0

    for fine_name in keys(b:files)
        call cursor(now_line, 0)
        " echomsg line('.')

        let match_line = search(s:signature)

        execute string(now_line) . ',' . string(match_line - 1) . 'write! ' . fine_name

        let now_line = now_line + match_line + 1
    endfor

    return ''
endfunction


function! s:open_files(...)
    let flag = 0
    execute 'silent! edit ' s:buf_name

    " buffer locals
    let b:files = {}
    cnoremap <buffer> <expr> w <SID>write_files()
    setlocal buftype=nowrite
    setlocal noswapfile
    setlocal bufhidden=wipe
    setlocal buftype=nofile

    for i in a:000
        let b:files[i] = {}
        let b:files[i].begin_line = line('.')

        execute 'read '.i

        " 初回のみ先頭の空行削除
        if flag == 0
            let flag = 1
            normal ggdd
        endif
        normal! G

        call append(line('$'), s:signature)
        normal! G

        let b:files[i].end_line = line('.')

        " echomsg string(i)
        " echomsg 'begin:' . string(b:files[i].begin_line)
        " echomsg 'end:' . string(b:files[i].end_line)
    endfor

    call cursor(1, 0)
endfunction

command! -complete=file -nargs=+ OpenDeneb :call s:open_files(<f-args>)
