{pkgs}: let
  inherit (pkgs.lib) getExe;
  node = getExe pkgs.nodejs;
in {
  # replace obsolete copilot-cmp by blink-cmp.
  plugins.copilot-cmp = {
    enable = true;
    # extraOptions = {
    #   formatters = {
    #     label = copilot_cmp_format.format_label_text;
    #     insert_text = copilot_cmp_format.remove_existing;
    #     preview = copilot_cmp_format.deindent;
    #   };
    # };
  };

  plugins.copilot-lua = {
    enable = true;
    settings = {
      panel = {
        enabled = false;
        autoRefresh = true;
        keymap = {
          # Comment out to resolve error for dupulicated keymaps
          # jumpNext = "<c-j>";
          # jumpPrev = "<c-k>";
          # accept = "<c-a>";
          refresh = "r";
          open = "<M-CR>";
        };
        layout = {
          position = "bottom";
          ratio = 0.4;
        };
      };
      suggestion = {
        enabled = false;
        autoTrigger = true;
        debounce = 75;
        keymap = {
          accept = "<c-a>";
          acceptWord = false;
          acceptLine = false;
          next = "<c-j>";
          prev = "<c-k>";
          dismiss = "<C-e>";
        };
      };
      filetypes = {
        yaml = false;
        markdown = false;
        help = false;
        gitcommit = false;
        gitrebase = false;
        hgcommit = false;
        svn = false;
        cvs = false;
        "." = false;
      };
      copilotNodeCommand = "${node}";
      serverOptsOverrides = {};
    };
  };
}
