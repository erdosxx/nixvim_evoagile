{
  plugins.treesitter = {
    enable = true;
    settings = {
      auto_install = true;
      modules = { };
      ensure_installed =
        "all"; # "all" (parsers with maintainers), or a list of languages
      sync_install =
        true; # install languages synchronously (only applied to `ensure_installed`)
      ignore_install = [ ]; # List of parsers to ignore installing
      autopairs = { enable = true; };
      highlight = {
        enable = true;
        disable = [ ];
        # [ "tex" "latex" "cpp" "rust" "markdown" ]; # To prevent error
        additional_vim_regex_highlighting = true;
      };
      indent = {
        enable = true;
        disable = [ "yaml" ];
      };
      rainbow = {
        enable = true;
        # disable = [ "c" ]; # list of languages you want to disable the plugin for
        extended_mode =
          true; # Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines =
          null; # Do not enable for files with more than n lines, int
        # colors = {}; # table of hex strings
        # termcolors = {} # table of colour name strings
      };
      playground = { enable = true; };
    };
  };
}
