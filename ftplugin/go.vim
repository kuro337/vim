"------------------------------------------------
" Go [ftplugin]
" ~/.vim/ftplugin/go.vim
"------------------------------------------------

call NewAbbr('fn!', 'func main() { <CR>fmt.Println("Hello")<CR>}')
call NewAbbr('ife!', 'if err!=nil {<CR> log.Printf("%s\n",err.Error())<CR>}','if err [go]')
call NewAbbr('js!', '`json:"field,omitempty"`' . repeat('<Left>',12),'JSON Struct Tag [go]')
call NewAbbr('for!', 'for k,v := range arr {<CR>fmt.Printf("#%d. %+v\n",k,v)<CR>}<Up>','for loop [go]')
call NewAbbr('if!', 'if err := json.NewDecoder(resp.Body).Decode(&struct); err != nil {<CR>'
      \ . 'fmt.Fprintf(os.Stderr,"ERROR: %s failed Body Decode\n",err.Error())<CR>}',
      \ 'if err shorthand [go]' )
call NewAbbr('get!', 'resp,err := http.Get("url")<CR>'
      \ . 'body,err := io.ReadAll(resp.Body)<CR>'
      \ . 'defer resp.Body.Close()<CR>'
      \ . 'var res map[string]interface{}<CR>'
      \ . 'err = json.Unmarshal(data,&res)<CR>', 'http get [go]')

" Go convention
setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4
setlocal noexpandtab
setlocal autoread
nnoremap <buffer> <silent> <leader>fm :call go#fmt#Format()<CR>
set listchars=tab:\ \ ,eol:¬,trail:⋅ "Set the characters for the invisibles
"EOF

