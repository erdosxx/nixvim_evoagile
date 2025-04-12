{ pkgs, ... }: {
  plugins.telescope = {
    enable = true;
    luaConfig.pre = # lua
      ''
        local actions = require "telescope.actions"
      '';
    settings = {
      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
        path_display = [ "smart" ];

        mappings = {
          i = {
            "<C-n>" = { __raw = "actions.cycle_history_next"; };
            "<C-p>" = { __raw = "actions.cycle_history_prev"; };

            "<C-j>" = { __raw = "actions.move_selection_next"; };
            "<C-k>" = { __raw = "actions.move_selection_previous"; };

            "<C-c>" = { __raw = "actions.close"; };

            "<Down>" = { __raw = "actions.move_selection_next"; };
            "<Up>" = { __raw = "actions.move_selection_previous"; };

            "<CR>" = { __raw = "actions.select_default"; };
            "<C-x>" = { __raw = "actions.select_horizontal"; };
            "<C-v>" = { __raw = "actions.select_vertical"; };
            "<C-t>" = { __raw = "actions.select_tab"; };

            "<C-u>" = { __raw = "actions.preview_scrolling_up"; };
            "<C-d>" = { __raw = "actions.preview_scrolling_down"; };

            "<PageUp>" = { __raw = "actions.results_scrolling_up"; };
            "<PageDown>" = { __raw = "actions.results_scrolling_down"; };

            "<Tab>" = {
              __raw = "actions.toggle_selection + actions.move_selection_worse";
            };
            "<S-Tab>" = {
              __raw =
                "actions.toggle_selection + actions.move_selection_better";
            };
            "<C-q>" = {
              __raw = "actions.send_to_qflist + actions.open_qflist";
            };
            "<M-q>" = {
              __raw = "actions.send_selected_to_qflist + actions.open_qflist";
            };
            "<C-l>" = { __raw = "actions.complete_tag"; };
            "<C-_>" = { __raw = "actions.which_key"; };
          };
          n = {
            "<esc>" = { __raw = "actions.close"; };
            "<CR>" = { __raw = "actions.select_default"; };
            "<C-x>" = { __raw = "actions.select_horizontal"; };
            "<C-v>" = { __raw = "actions.select_vertical"; };
            "<C-t>" = { __raw = "actions.select_tab"; };

            "<Tab>" = {
              __raw = "actions.toggle_selection + actions.move_selection_worse";
            };
            "<S-Tab>" = {
              __raw =
                "actions.toggle_selection + actions.move_selection_better";
            };
            "<C-q>" = {
              __raw = "actions.send_to_qflist + actions.open_qflist";
            };
            "<M-q>" = {
              __raw = "actions.send_selected_to_qflist + actions.open_qflist";
            };

            "j" = { __raw = "actions.move_selection_next"; };
            "k" = { __raw = "actions.move_selection_previous"; };
            "H" = { __raw = "actions.move_to_top"; };
            "M" = { __raw = "actions.move_to_middle"; };
            "L" = { __raw = "actions.move_to_bottom"; };

            "<Down>" = { __raw = "actions.move_selection_next"; };
            "<Up>" = { __raw = "actions.move_selection_previous"; };
            "gg" = { __raw = "actions.move_to_top"; };
            "G" = { __raw = "actions.move_to_bottom"; };

            "<C-u>" = { __raw = "actions.preview_scrolling_up"; };
            "<C-d>" = { __raw = "actions.preview_scrolling_down"; };

            "<PageUp>" = { __raw = "actions.results_scrolling_up"; };
            "<PageDown>" = { __raw = "actions.results_scrolling_down"; };

            "?" = { __raw = "actions.which_key"; };
          };
        };
        # layout_config = { prompt_position = "top"; };
        # file_ignore_patterns = [
        #   "^.git/"
        #   "^.mypy_cache/"
        #   "^__pycache__/"
        #   "^output/"
        #   "^data/"
        #   "%.ipynb"
        # ];
        # set_env = { COLORTERM = "truecolor"; };
        # sorting_strategy = "ascending";
      };

    };
    extensions.media-files = {
      enable = true;
      settings = {
        filetypes = [ "png" "webp" "jpg" "jpeg" ];
        find_cmd = "${pkgs.ripgrep}/bin/rg";
      };
    };
  };

  plugins.harpoon = {
    enable = true;
    enableTelescope = true;
    keymaps = {
      # See keymaps.nix. 
      #   addFile = "<localleader>m";
      toggleQuickMenu = "<TAB>";
    };
  };
}
