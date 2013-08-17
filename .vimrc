set nocp
set showcmd

filetype on
filetype plugin on
syntax enable
set grepprg=grep\ -nH\ $*

set wildmenu
set wildmode=list:longest,full

set mouse=v

set backspace=2

set ignorecase

set smartcase

set hlsearch

set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

set cul

nore ; :
nore , ;

execute pathogen#infect()

for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

