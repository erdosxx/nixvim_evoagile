{
  opts = {
    ## allow backspacing over everything in insert mode
    ## Ref: https://til.hashrocket.com/posts/f5531b6da0-backspace-options
    backspace = [ "indent" "eol" "start" ];
    ## do not keep a backup file, use versions instead (default = false)
    backup = false;
    ## allows neovim to access the system clipboard
    clipboard = "unnamedplus";
    ## display incomplete commands (default = ture)
    showcmd = true;
    ## keep 10000 lines of command line history (default = 10000)
    history = 10000;
    ## more space in the neovim command line for displaying messages
    cmdheight = 1;
    ## do incremental searching (default = true)
    incsearch = true;
    ## Enable folding: Lines with equal indent form a fold.
    foldmethod = "indent";
    ## When open a file, open all folds, regardless of method used for folding.
    ## With foldlevel=0 all folded, foldlevel=1 only somes, ... higher numbers will
    ## close fewer folds.
    foldlevel = 99;
    ## to ensuring aligned indentation
    ## For more detail, see following.
    ## https://vimtricks.com/p/ensuring-aligned-indentation/
    shiftround = true;
    ## show matching brace
    ## See: https://vimtricks.com/p/vimtrick-highlight-matching-bracket/
    showmatch = true;
    matchtime = 3;
    ## mostly just for cmp
    completeopt = [ "menuone" "noselect" ];
    ## Determine how text with the "conceal" syntax attribute
    ## 0:Text is shown normally (Default)
    ## so that `` is visible in markdown files
    conceallevel = 0;
    ## the encoding written to a file
    fileencoding = "utf-8";
    ## highlight all matches on previous search pattern
    hlsearch = true;
    ## ignore case in search patterns
    ignorecase = true;
    ## allow the mouse to be used in neovim
    mouse = "a";
    ## pop up menu height
    pumheight = 10;
    ## we don't need to see things like -- INSERT -- anymore
    showmode = false;
    ## always show tabs
    showtabline = 2;
    ## Override the 'ignorecase' option if the search pattern contains
    ## upper case characters.
    smartcase = true;
    ## make indenting smarter again
    smartindent = true;
    ## force all horizontal splits to go below current window
    splitbelow = true;
    ## force all vertical splits to go to the right of current window
    splitright = true;
    ## creates a swapfile
    swapfile = false;
    ## Enable 24-bit RGB color for TUI.
    ## termguicolors = true,
    ## time to wait for a mapped sequence to complete (in milliseconds)
    ## Default = 1000
    timeoutlen = 300;
    ## enable persistent undo even after saving
    undofile = true;
    ## faster completion (4000ms default)
    updatetime = 300;
    ## if a file is being edited by another program
    ## (or was written to file while editing with another program),
    ## it is not allowed to be edited
    writebackup = false;
    ## In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
    expandtab = true;
    ## Number of spaces to use for each step of (auto)indent.
    ## Used for 'cindent', >>, <<, etc.
    shiftwidth = 2;
    ## insert 4 spaces for a tab
    tabstop = 2;
    ## highlight the current line
    cursorline = false;
    ## set numbered lines
    number = true;
    ## set relative numbered lines
    relativenumber = true;
    ## set number column width to 2 {default 4}
    numberwidth = 3;
    ## always show the sign column, otherwise it would shift the text each time
    signcolumn = "yes";
    ## display lines as one long line
    wrap = true;
    ## Minimal number of screen lines to keep above and below the cursor.
    scrolloff = 8;
    ## The minimal number of screen columns to keep to the left and to the
    sidescrolloff = 8;
    ## the font used in graphical neovim applications
    ## vim.opt.guifont = "monospace:h17"
    ## show empty lines at the end of a buffer as ` ` {default `~`}
    fillchars.eob = " ";
  };

  extraConfigLua = # lua
    ''
      -- Use short message
      -- c: don't give |ins-completion-menu| messages.
      vim.opt.shortmess:append("c");
      -- keys allowed to move to the previous/next line
      -- when the beginning/end of line is reached
      vim.opt.whichwrap:append("<,>,[,],h,l");
      -- treats words with `-` as single words
      vim.opt.iskeyword:append("-");
      -- c: Auto-wrap comments using 'textwidth', inserting the current comment
      -- leader automatically.
      -- r: Automatically insert the current comment leader after hitting
      -- <Enter> in Insert mode.
      -- o: Automatically insert the current comment leader after hitting
      -- 'o' or 'O' in Normal mode.
      vim.opt.formatoptions:remove({ "c", "r", "o" });
    '';
}
