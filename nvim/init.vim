" plugin
call plug#begin()

"  git 
Plug 'tveskag/nvim-blame-line' " blame
Plug 'rhysd/conflict-marker.vim' " conflict handler
Plug 'airblade/vim-gitgutter' " difference

"  lint & format
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sbdchd/neoformat' " format code

" color & styles
Plug 'ryanoasis/vim-devicons' " icons
Plug 'tyrannicaltoucan/vim-deep-space' " nvim theme
Plug 'nvim-lualine/lualine.nvim'

" navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } 
Plug 'junegunn/fzf.vim'
Plug 'farmergreg/vim-lastplace'

" etc
Plug 'diepm/vim-rest-console' " send/display rest requests

call plug#end()

" options
set title
set shiftwidth=4
set softtabstop=4
set tabstop=4
set scrolloff=5
set mouse=a
set noswapfile
set updatetime=50
set number
set modifiable 
set clipboard=unnamed
set termguicolors

" binds
nmap <silent> <C-w> :w <CR>
nmap <silent> <C-f> :Rg <CR>
nmap <silent> <C-p> :Files <CR>
nmap <silent> <C-h> :History <CR>
nmap <silent> <C-b> :Buffers <CR>
nmap <silent> <C-d> :GitGutterPreviewHunk <CR>
nmap <silent> <C-q> :qa <CR>
nmap <silent> <2-LeftMouse> <Plug>(coc-definition)

" auto commands
autocmd Filetype json setlocal ts=2 sw=2 expandtab
autocmd FileType json set formatprg=jq
autocmd BufWritePre *.tsx Neoformat
autocmd BufWritePre *.ts Neoformat
autocmd BufWritePre *.jsx Neoformat
autocmd BufWritePre *.js Neoformat

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" right click menu
noremenu <silent> .1 PopUp.Blame :ToggleBlameLine <CR>
aunmenu PopUp.How-to\ disable\ mouse

" color & styles
colo deep-space

hi Normal guibg=NONE 
hi CursorLine guibg=NONE 
hi MatchParen guibg=NONE guifg=#E0FFFF
hi Visual guibg=NONE guifg=#E0FFFF

hi CocWarningHighlight guibg=#E0FFFF

hi ConflictMarkerBegin ctermfg=LightGreen
hi ConflictMarkerOurs ctermfg=LightGreen
hi ConflictMarkerTheirs ctermfg=LightCyan
hi ConflictMarkerEnd ctermfg=LightCyan
hi ConflictMarkerCommonAncestorsHunk ctermfg=LightBlue

hi GitGutterAdd ctermfg=LightGreen
hi GitGutterDelete ctermfg=LightCyan

let g:conflict_marker_highlight_group = ''
let g:conflict_marker_begin = '^<<<<<< .*$'
let g:conflict_marker_end = '^>>>>>> .*$'

let g:vrc_response_default_content_type = 'application/json'
let g:vrc_output_buffer_name = '__VRC_OUTPUT.json'

" lua
lua << EOF
require('lualine').setup()
EOF