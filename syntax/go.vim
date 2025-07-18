"------------------------------------------------------------
" go.vim: Vim syntax file for Go.
" ~/.vim/syntax/go.vim
" https://github.com/fatih/vim-go/blob/master/syntax/go.vim
"------------------------------------------------------------
" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn case match

syn keyword     goPackage           package
syn keyword     goImport            import    contained
syn keyword     goVar               var       contained
syn keyword     goConst             const     contained

hi def link     goPackage           Statement
hi def link     goImport            Statement
hi def link     goVar               Keyword
hi def link     goConst             Keyword
hi def link     goDeclaration       Keyword

" Keywords within functions
syn keyword     goStatement         defer go goto return break continue fallthrough
syn keyword     goConditional       if else switch select
syn keyword     goLabel             case default
syn keyword     goRepeat            for range

hi def link     goStatement         Statement
hi def link     goConditional       Conditional
hi def link     goLabel             Label
hi def link     goRepeat            Repeat

" Predefined types
syn keyword     goType              chan map bool string error any comparable
syn keyword     goSignedInts        int int8 int16 int32 int64 rune
syn keyword     goUnsignedInts      byte uint uint8 uint16 uint32 uint64 uintptr
syn keyword     goFloats            float32 float64
syn keyword     goComplexes         complex64 complex128

hi def link     goType              Type
hi def link     goSignedInts        Type
hi def link     goUnsignedInts      Type
hi def link     goFloats            Type
hi def link     goComplexes         Type

" Predefined functions and values
syn keyword     goBuiltins                 append cap clear close complex copy delete imag len
syn keyword     goBuiltins                 make max min new panic print println real recover
syn keyword     goBoolean                  true false
syn keyword     goPredefinedIdentifiers    nil iota

hi def link     goBuiltins                 Identifier
hi def link     goPredefinedIdentifiers    Constant

" Boolean links to Constant by default by vim: goBoolean and goPredefinedIdentifiers
" will be highlighted the same, but having the separate allows users to have
" separate highlighting for them if they desire.
hi def link     goBoolean                  Boolean

" Comments; their contents
syn keyword     goTodo              contained TODO FIXME XXX BUG
syn cluster     goCommentGroup      contains=goTodo
syn region      goComment           start="//" end="$" contains=goGenerate,@goCommentGroup,@Spell
syn region    goComment           start="/\*" end="\*/" contains=@goCommentGroup,@Spell

hi def link     goComment           Comment
hi def link     goTodo              Todo

syn match       goGenerateVariables contained /\%(\$GOARCH\|\$GOOS\|\$GOFILE\|\$GOLINE\|\$GOPACKAGE\|\$DOLLAR\)\>/
syn region      goGenerate          start="^\s*//go:generate" end="$" contains=goGenerateVariables
hi def link     goGenerate          PreProc
hi def link     goGenerateVariables Special
hi def link     goEscapeC           Special

" Go escapes

syn match       goEscapeOctal       display contained "\\[0-7]\{3}"
syn match       goEscapeC           display contained +\\[abfnrtv\\'"]+
syn match       goEscapeX           display contained "\\x\x\{2}"
syn match       goEscapeU           display contained "\\u\x\{4}"
syn match       goEscapeBigU        display contained "\\U\x\{8}"
syn match       goEscapeError       display contained +\\[^0-7xuUabfnrtv\\'"]+

hi def link     goEscapeOctal       goSpecialString
hi def link     goEscapeC           goSpecialString
hi def link     goEscapeX           goSpecialString
hi def link     goEscapeU           goSpecialString
hi def link     goEscapeBigU        goSpecialString

" hi def          goSpecialString  guifg=#DDA0DD
hi def link     goEscapeError       Error

" Strings and their contents
syn cluster     goStringGroup       contains=goEscapeOctal,goEscapeC,goEscapeX,goEscapeU,goEscapeBigU,goEscapeError
syn region      goString            start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@goStringGroup
syn region      goRawString         start=+`+ end=+`+

syn match       goImportString      /^\%(\s\+\|import \)\(\h\w* \)\?\zs"[^"]\+"/ contained containedin=goImport

" [n] notation is valid for specifying explicit argument indexes
" 1. Match a literal % not preceded by a %.
" 2. Match any number of -, #, 0, space, or +
" 3. Match * or [n]* or any number or nothing before a .
" 4. Match * or [n]* or any number or nothing after a .
" 5. Match [n] or nothing before a verb
" 6. Match a formatting verb
syn match       goFormatSpecifier   /\
      \%([^%]\%(%%\)*\)\
      \@<=%[-#0 +]*\
      \%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\
      \%(\.\%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\)\=\
      \%(\[\d\+\]\)\=[vTtbcdoqxXUeEfFgGspw]/ contained containedin=goString,goRawString

hi def link     goFormatSpecifier   goSpecialString
hi def link     goImportString      String
hi def link     goString            String
hi def link     goRawString         String

" Characters; their contents
syn cluster     goCharacterGroup    contains=goEscapeOctal,goEscapeC,goEscapeX,goEscapeU,goEscapeBigU
syn region      goCharacter         start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=@goCharacterGroup
hi def link     goCharacter         Character

" Regions
syn region      goParen             start='(' end=')' transparent
syn region    goBlock             start="{" end="}" transparent

" import
syn region    goImport            start='import (' end=')' transparent contains=goImport,goImportString,goComment
syn match     goImport            /^import ()/ transparent contains=goImport

" var, const
syn region    goVar               start='var ('   end='^\s*)$' transparent
      \ contains=ALLBUT,goParen,goBlock,goFunction,goTypeName,goReceiverType,goReceiverVar,goParamName,goParamType,goSimpleParams,goPointerOperator

syn match     goVar               /var ()/ transparent
      \ contains=goVar

syn region    goConst             start='const (' end='^\s*)$' transparent
      \ contains=ALLBUT,goParen,goBlock,goFunction,goTypeName,goReceiverType,goReceiverVar,goParamName,goParamType,goSimpleParams,goPointerOperator

syn match     goConst             /const ()/ transparent
      \ contains=goConst

" Single-line var, const, and import.
syn match       goSingleDecl        /\%(import\|var\|const\) [^(]\@=/ contains=goImport,goVar,goConst

" Integers
syn match       goDecimalInt        "\<-\=\%(0\|\%(\d\|\d_\d\)\+\)\>"
syn match       goHexadecimalInt    "\<-\=0[xX]_\?\%(\x\|\x_\x\)\+\>"
syn match       goOctalInt          "\<-\=0[oO]\?_\?\%(\o\|\o_\o\)\+\>"
syn match       goBinaryInt         "\<-\=0[bB]_\?\%([01]\|[01]_[01]\)\+\>"

hi def link     goDecimalInt        Integer
hi def link     goDecimalError      Error
hi def link     goHexadecimalInt    Integer
hi def link     goHexadecimalError  Error
hi def link     goOctalInt          Integer
hi def link     goOctalError        Error
hi def link     goBinaryInt         Integer
hi def link     goBinaryError       Error
hi def link     Integer             Number

" decimal floats with a decimal point
syn match       goFloat             "\<-\=\%(0\|\%(\d\|\d_\d\)\+\)\.\%(\%(\%(\d\|\d_\d\)\+\)\=\%([Ee][-+]\=\%(\d\|\d_\d\)\+\)\=\>\)\="
syn match       goFloat             "\s\zs-\=\.\%(\d\|\d_\d\)\+\%(\%([Ee][-+]\=\%(\d\|\d_\d\)\+\)\>\)\="

" decimal floats without a decimal point
syn match       goFloat             "\<-\=\%(0\|\%(\d\|\d_\d\)\+\)[Ee][-+]\=\%(\d\|\d_\d\)\+\>"

" hexadecimal floats with a decimal point

syn match       goHexadecimalFloat  "\<-\=0[xX]\%(_\x\|\x\)\+\.\%(\%(\x\|\x_\x\)\+\)\=\%([Pp][-+]\=\%(\d\|\d_\d\)\+\)\=\>"
syn match       goHexadecimalFloat  "\<-\=0[xX]\.\%(\x\|\x_\x\)\+\%([Pp][-+]\=\%(\d\|\d_\d\)\+\)\=\>"

" hexadecimal floats without a decimal point
syn match       goHexadecimalFloat  "\<-\=0[xX]\%(_\x\|\x\)\+[Pp][-+]\=\%(\d\|\d_\d\)\+\>"

hi def link     goFloat             Float
hi def link     goHexadecimalFloat  Float

" Imaginary literals
syn match       goImaginaryDecimal        "\<-\=\%(0\|\%(\d\|\d_\d\)\+\)i\>"
syn match       goImaginaryHexadecimal    "\<-\=0[xX]_\?\%(\x\|\x_\x\)\+i\>"
syn match       goImaginaryOctal          "\<-\=0[oO]\?_\?\%(\o\|\o_\o\)\+i\>"
syn match       goImaginaryBinary         "\<-\=0[bB]_\?\%([01]\|[01]_[01]\)\+i\>"

" imaginary decimal floats with a decimal point
syn match       goImaginaryFloat             "\<-\=\%(0\|\%(\d\|\d_\d\)\+\)\.\%(\%(\%(\d\|\d_\d\)\+\)\=\%([Ee][-+]\=\%(\d\|\d_\d\)\+\)\=\)\=i\>"
syn match       goImaginaryFloat             "\s\zs-\=\.\%(\d\|\d_\d\)\+\%([Ee][-+]\=\%(\d\|\d_\d\)\+\)\=i\>"
" imaginary decimal floats without a decimal point
syn match       goImaginaryFloat             "\<-\=\%(0\|\%(\d\|\d_\d\)\+\)[Ee][-+]\=\%(\d\|\d_\d\)\+i\>"

" imaginary hexadecimal floats with a decimal point
syn match       goImaginaryHexadecimalFloat  "\<-\=0[xX]\%(_\x\|\x\)\+\.\%(\%(\x\|\x_\x\)\+\)\=\%([Pp][-+]\=\%(\d\|\d_\d\)\+\)\=i\>"
syn match       goImaginaryHexadecimalFloat  "\<-\=0[xX]\.\%(\x\|\x_\x\)\+\%([Pp][-+]\=\%(\d\|\d_\d\)\+\)\=i\>"

" imaginary hexadecimal floats without a decimal point
syn match       goImaginaryHexadecimalFloat  "\<-\=0[xX]\%(_\x\|\x\)\+[Pp][-+]\=\%(\d\|\d_\d\)\+i\>"

hi def link     goImaginaryDecimal             Number
hi def link     goImaginaryHexadecimal         Number
hi def link     goImaginaryOctal               Number
hi def link     goImaginaryBinary              Number
hi def link     goImaginaryFloat               Float
hi def link     goImaginaryHexadecimalFloat    Float


" Extra types commonly seen
syn match goExtraType /\<bytes\.\%(Buffer\)\>/
syn match goExtraType /\<context\.\%(Context\)\>/
syn match goExtraType /\<io\.\%(Reader\|ReadSeeker\|ReadWriter\|ReadCloser\|ReadWriteCloser\|Writer\|WriteCloser\|Seeker\)\>/
syn match goExtraType /\<reflect\.\%(Kind\|Type\|Value\)\>/
syn match goExtraType /\<unsafe\.Pointer\>/

hi def link     goExtraType         Type
hi def link     goSpaceError        Error

" Comments; their contents
syn keyword     goTodo              contained NOTE
hi def link     goTodo              Todo

syn match goVarArgs /\.\.\./

" Operators;
" match single-char operators:          - + % < > ! & | ^ * =

" and corresponding two-char operators: -= += %= <= >= != &= |= ^= *= ==
syn match goOperator /[-+%<>!&|^*=]=\?/

" match / and /=
syn match goOperator /\/\%(=\|\ze[^/*]\)/
" match two-char operators:               << >> &^

" and corresponding three-char operators: <<= >>= &^=
syn match goOperator /\%(<<\|>>\|&^\)=\?/

" match remaining two-char operators: := && || <- ++ --
syn match goOperator /:=\|||\|<-\|++\|--/

" match ~
syn match goOperator /\~/

" match ...
hi def link     goPointerOperator   goOperator
hi def link     goVarArgs           goOperator
hi def link     goOperator          Operator

"-> type constraint opening bracket
"|-> start non-counting group
"||  -> any word character
"||  |  -> at least one, as many as possible
"||  |  |    -> start non-counting group
"||  |  |    |   -> match ~
"||  |  |    |   | -> at most once
"||  |  |    |   | |     -> allow a slice type
"||  |  |    |   | |     |      -> any word character
"||  |  |    |   | |     |      | -> start a non-counting group
"||  |  |    |   | |     |      | | -> that matches word characters and |
"||  |  |    |   | |     |      | | |     -> close the non-counting group
"||  |  |    |   | |     |      | | |     | -> close the non-counting group
"||  |  |    |   | |     |      | | |     | |-> any number of matches
"||  |  |    |   | |     |      | | |     | || -> start a non-counting group
"||  |  |    |   | |     |      | | |     | || | -> a comma and whitespace
"||  |  |    |   | |     |      | | |     | || | |      -> at most once
"||  |  |    |   | |     |      | | |     | || | |      | -> close the non-counting group
"||  |  |    |   | |     |      | | |     | || | |      | | -> at least one of those non-counting groups, as many as possible
"||  |  |    |   | | --------   | | |     | || | |      | | | -> type constraint closing bracket
"||  |  |    |   | ||        |  | | |     | || | |      | | | |

syn match goTypeParams        /\[\%(\w\+\s\+\%(\~\?\%(\[]\)\?\w\%(\w\||\)\)*\%(,\s*\)\?\)\+\]/ nextgroup=goSimpleParams,goDeclType contained

" Functions;
syn match goDeclaration       /\<func\>/ nextgroup=goReceiver,goFunction,goSimpleParams skipwhite skipnl
syn match goReceiverDecl      /(\s*\zs\%(\%(\w\+\s\+\)\?\*\?\w\+\%(\[\%(\%(\[\]\)\?\w\+\%(,\s*\)\?\)\+\]\)\?\)\ze\s*)/ contained contains=goReceiverVar,goReceiverType,goPointerOperator
syn match goReceiverVar       /\w\+\ze\s\+\%(\w\|\*\)/ nextgroup=goPointerOperator,goReceiverType skipwhite skipnl contained
syn match goPointerOperator   /\*/ nextgroup=goReceiverType contained skipwhite skipnl
syn match goFunction          /\w\+/ nextgroup=goSimpleParams,goTypeParams contained skipwhite skipnl
syn match goReceiverType      /\w\+\%(\[\%(\%(\[\]\)\?\w\+\%(,\s*\)\?\)\+\]\)\?\ze\s*)/ contained

syn match goSimpleParams      /(\%(\w\|\_s\|[*\.\[\],\{\}<>-]\)*)/ contained contains=goParamName,goType nextgroup=goFunctionReturn skipwhite skipnl
syn match goFunctionReturn   /(\%(\w\|\_s\|[*\.\[\],\{\}<>-]\)*)/ contained contains=goParamName,goType skipwhite skipnl
syn match goParamName        /\w\+\%(\s*,\s*\w\+\)*\ze\s\+\%(\w\|\.\|\*\|\[\)/ contained nextgroup=goParamType skipwhite skipnl
syn match goParamType        /\%([^,)]\|\_s\)\+,\?/ contained nextgroup=goParamName skipwhite skipnl
      \ contains=goVarArgs,goType,goSignedInts,goUnsignedInts,goFloats,goComplexes,goDeclType,goBlock

hi def link   goReceiverVar    goParamName
hi def link   goParamName      Identifier
syn match goReceiver          /(\s*\%(\w\+\s\+\)\?\*\?\s*\w\+\%(\[\%(\%(\[\]\)\?\w\+\%(,\s*\)\?\)\+\]\)\?\s*)\ze\s*\w/ contained nextgroup=goFunction contains=goReceiverDecl skipwhite skipnl

hi def link     goFunction          Function

" Function calls;
syn match goFunctionCall      /\w\+\ze\%(\[\%(\%(\[]\)\?\w\+\(,\s*\)\?\)\+\]\)\?(/ contains=goBuiltins,goDeclaration

hi def link     goFunctionCall      Type

" Fields;
" 1. Match a sequence of word characters coming after a '.'
" 2. Require the following but dont match it: ( \@= see :h E59)
"    - The symbols: / - + * %   OR
"    - The symbols: [] {} <> )  OR
"    - The symbols: \n \r space OR
"    - The symbols: , : .
" 3. Have the start of highlight (hs) be the start of matched
"    pattern (s) offsetted one to the right (+1) (see :h E401)

syn match       goField   /\.\w\+\
      \%(\%([\/\-\+*%]\)\|\
      \%([\[\]{}<\>\)]\)\|\
      \%([\!=\^|&]\)\|\
      \%([\n\r\ ]\)\|\
      \%([,\:.]\)\)\@=/hs=s+1

hi def link    goField              Identifier

" Structs & Interfaces;
syn match goTypeConstructor      /\<\w\+{\@=/
syn match goTypeDecl             /\<type\>/ nextgroup=goTypeName skipwhite skipnl
syn match goTypeName             /\w\+/ contained nextgroup=goDeclType,goTypeParams skipwhite skipnl
syn match goDeclType             /\<\%(interface\|struct\)\>/ skipwhite skipnl

hi def link     goReceiverType      Type
hi def link     goTypeConstructor   Type
hi def link     goTypeName          Type
hi def link     goTypeDecl          Keyword
hi def link     goDeclType          Keyword


" :GoCoverage commands
hi def link goCoverageNormalText Comment

function! s:hi()
  hi def link goSameId Search
  hi def link goDiagnosticError SpellBad
  hi def link goDiagnosticWarning SpellRare
  hi def link goDeclsFzfKeyword        Keyword
  hi def link goDeclsFzfFunction       Function
  hi def link goDeclsFzfSpecialComment SpecialComment
  hi def link goDeclsFzfComment        Comment

  " :GoCoverage commands
  hi def      goCoverageCovered    ctermfg=green guifg=#A6E22E
  hi def      goCoverageUncover    ctermfg=red guifg=#F92672
endfunc

augroup vim-go-hi
  autocmd!
  autocmd ColorScheme * call s:hi()
augroup end

call s:hi()

" Search backwards for a global declaration to start processing the syntax.
" syn sync match goSync grouphere NONE /^\(const\|var\|type\|func\)\>/

" syn sync minlines=500
let b:current_syntax = "go"

" vim: sw=2 ts=2 et
