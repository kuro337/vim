"--------------------------------
" .vim/after/syntax/
"--------------------------------

" after/syntax/jsonc.vim
syntax clear
runtime! syntax/json.vim

" Override comments erroring to be just Comments
hi! def link jsonCommentError Comment
"EOF

