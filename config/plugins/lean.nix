{
  # plugins.lsp.servers.lean3ls.enable = true;

  plugins.lean = {
    enable = true;
    settings = {
      abbreviations = {
        enable = true;
        extra = {
          wknight = "♘";
        };
      };
      ft = {
        default = "lean";
        nomodifiable = [
          "_target"
        ];
      };
      infoview = {
        horizontal_position = "top";
        indicators = "always";
        separate_tab = true;
      };
      lsp = {
        enable = true;
      };
      mappings = false;
      progress_bars = {
        enable = false;
      };
      stderr = {
        on_lines = {
          __raw = "function(lines) vim.notify(lines) end";
        };
      };
    };
  };
}
