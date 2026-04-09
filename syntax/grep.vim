syntax match grepSource /^[^:]*/
syntax match grepNumber /:[0-9]\+:/ contains=grepSeparator
syntax match grepSeparator /:/ contained
syntax match grepLine /:[0-9]\+:.*$/ contains=grepNumber

hi def link grepSource    Directory
hi def link grepNumber    Constant
hi def link grepSeparator Operator
hi def link grepLine      Normal
