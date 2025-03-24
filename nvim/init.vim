" plugin
call plug#begin()

"  git 
Plug 'tveskag/nvim-blame-line' " blame
Plug 'rhysd/conflict-marker.vim' " conflict handler
Plug 'airblade/vim-gitgutter' " difference

"  lint, code & format
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sbdchd/neoformat' " format code
Plug 'terrortylor/nvim-comment' " toggle comment

" color & styles
Plug 'ryanoasis/vim-devicons' " icons
Plug 'tyrannicaltoucan/vim-deep-space' " nvim theme
Plug 'nvim-lualine/lualine.nvim'

" navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } 
Plug 'junegunn/fzf.vim'
Plug 'farmergreg/vim-lastplace'
Plug 'MunifTanjim/nui.nvim' "dependency for neotree
Plug 'nvim-lua/plenary.nvim' " dependency for neo-tree
Plug 'nvim-neo-tree/neo-tree.nvim'

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
set wrap!

" binds

" make row a comment 
nmap <silent> <C-c> :'<,'>CommentToggle <CR> 
" search in files
nmap <silent> <C-f> :Rg <CR> 
" search files
nmap <silent> <C-p> :Files <CR> 
" search history of open files
nmap <silent> <C-h> :History <CR> 
" open buffers
nmap <silent> <C-b> :Buffers <CR> 
" close buffer
nmap <silent> <S-c> :bp<BAR>bd# <CR> 
" preview committer
nmap <silent> <C-d> :GitGutterPreviewHunk <CR> 
" go to definition
nmap <silent> <S-d> <Plug>(coc-definition) 
" go to previous
nmap <silent> <C-0> :bp <CR> 
" go to next
nmap <silent> <C-+> :bn <CR> 
" replace word
nmap <silent> <C-w> :%s/\<<C-R><C-W>\>/ 

" auto commands
autocmd VimEnter * Neotree buffers right
autocmd Filetype json setlocal ts=2 sw=2 expandtab
autocmd FileType json set formatprg=jq
autocmd BufWritePre *.tsx Neoformat
autocmd BufWritePre *.ts Neoformat
autocmd BufWritePre *.jsx Neoformat
autocmd BufWritePre *.js Neoformat

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" right click menu
noremenu <silent> .2 PopUp.CodeInspection-Blame :ToggleBlameLine <CR>
noremenu <silent> .2 PopUp.Replace-All-Comma-With-Rows :%s/,/\r/g <CR>
noremenu <silent> .2 PopUp.Replace-All-Rows-With-Comma :%s/\n/,/g <CR>

aunmenu PopUp.How-to\ disable\ mouse
aunmenu PopUp.Inspect

" color & styles
colo deep-space

hi Normal guibg=NONE 
hi CursorLine guibg=NONE 
hi MatchParen guibg=NONE guifg=#E0FFFF
hi Visual guibg=NONE guifg=#E0FFFF

hi CocWarningHighlight guibg=NONE

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
require('nvim_comment').setup()
require("neo-tree").setup({source_selector = {
            winbar = true,
            statusline = true
        }})
EOF
