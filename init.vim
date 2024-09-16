" plugin
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'preservim/nerdtree'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'farmergreg/vim-lastplace'
Plug 'romgrk/barbar.nvim'
Plug 'mhinz/vim-startify'
Plug 'chrisbra/NrrwRgn'

Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/conflict-marker.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'mhartington/formatter.nvim'
Plug 'diepm/vim-rest-console'

call plug#end()

" option
set title
set shiftwidth=4
set softtabstop=4
set tabstop=4
set scrolloff=5
set mouse=a
set noswapfile
set updatetime=50
set number
"set termguicolors (only use at windows)

" bind
nmap <silent> <S-f> :Rg <CR> 
nmap <silent> <C-p> :Files <CR>
nmap <silent> <C-f> :BLines <CR>
nmap <silent> <C-e> :NERDTreeToggle <CR>
nmap <silent> <C-d> :GitGutterPreviewHunk <CR>
nmap <silent> <C-q> :qa <CR>
nmap <silent> <C-Left> :bprev <CR>
nmap <silent> <C-Right>	:bnext <CR>
nmap <silent> <2-LeftMouse> <Plug>(coc-definition)

autocmd BufWritePost * silent! call CocAction('format')

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" color & style
colo desert

let NERDTreeMinimalUI=1

let g:conflict_marker_highlight_group = ''
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_end = '^>>>>>>> .*$'

let g:startify_custom_header = []
let g:startify_files_number = 20
let g:startify_enable_special = 0
let g:startify_lists = [{ 'type': 'files', 'header': ['']}]

let g:vrc_output_buffer_name = '__VRC_OUTPUT.json'

highlight ConflictMarkerBegin guibg=#2f7366
highlight ConflictMarkerOurs guibg=#2e5049
highlight ConflictMarkerTheirs guibg=#344f69
highlight ConflictMarkerEnd guibg=#2f628e
highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81

" right click menu
noremenu <silent> .1 PopUp.Forward :bprev<CR>
noremenu <silent> .2 PopUp.Backward :bnext<CR>
noremenu <silent> .3 PopUp.Save :w<CR>
noremenu <silent> .4 PopUp.Narrow :NR!<CR>

aunmenu PopUp.How-to\ disable\ mouse

" lua
lua << END
	require('lualine').setup()
END
