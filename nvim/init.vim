" plugin
call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'tveskag/nvim-blame-line'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'farmergreg/vim-lastplace'
Plug 'mhinz/vim-startify'
Plug 'chrisbra/NrrwRgn'
Plug 'sbdchd/neoformat'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/conflict-marker.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'diepm/vim-rest-console'

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

" binds
nmap <silent> <S-f> :Rg <CR>
nmap <silent> <S-p> :Files <CR>
nmap <silent> <C-f> :noh <CR> /
nmap <silent> <C-d> :GitGutterPreviewHunk <CR>
nmap <silent> <C-q> :qa <CR>
nmap <silent> <2-LeftMouse> <Plug>(coc-definition)

" auto commands
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

autocmd BufEnter * EnableBlameLine
autocmd Filetype json setlocal ts=2 sw=2 expandtab
autocmd FileType json set formatprg=jq
autocmd BufWritePre *.tsx Neoformat
autocmd BufWritePre *.ts Neoformat
autocmd BufWritePre *.jsx Neoformat
autocmd BufWritePre *.js Neoformat

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" right click menu
noremenu <silent> .1 PopUp.Forward :bprev<CR>
noremenu <silent> .2 PopUp.Backward :bnext<CR>
noremenu <silent> .3 PopUp.Save :w<CR>
noremenu <silent> .4 PopUp.Narrow :NR!<CR>

aunmenu PopUp.How-to\ disable\ mouse

" color & styles
highlight Normal guibg=NONE ctermbg=NONE
highlight CursorLine guibg=NONE ctermbg=NONE
colo slate

let g:conflict_marker_highlight_group = ''
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_end = '^>>>>>>> .*$'

let g:startify_custom_header = []
let g:startify_files_number = 20
let g:startify_enable_special = 0
let g:startify_lists = [{ 'type': 'files', 'header': ['']}]

let g:vrc_response_default_content_type = 'application/json'
let g:vrc_output_buffer_name = '__VRC_OUTPUT.json'

highlight ConflictMarkerBegin ctermfg=LightGreen
highlight ConflictMarkerOurs ctermfg=LightGreen
highlight ConflictMarkerTheirs ctermfg=LightCyan
highlight ConflictMarkerEnd ctermfg=LightCyan
highlight ConflictMarkerCommonAncestorsHunk ctermfg=LightBlue

highlight GitGutterAdd ctermfg=LightGreen
highlight GitGutterDelete ctermfg=LightCyan
highlight MatchParen ctermfg=LightCyan ctermbg=NONE guibg=NONE cterm=NONE
highlight Visual ctermfg=LightCyan ctermbg=NONE guibg=NONE cterm=NONE

" lua
lua << EOF
require("bufferline").setup{}
EOF
