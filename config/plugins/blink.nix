{
  plugins = {
    blink-copilot.enable = true;
    blink-pairs.enable = true;
    blink-indent.enable = true;
    blink-cmp-latex.enable = true;
    blink-cmp-avante.enable = true;
    friendly-snippets.enable = true;
  };

  plugins.blink-cmp = {
    enable = true;
    settings = {
      snippets = {
        # preset = "luasnip"; # or "default" if using vim.snippet built-in
        preset = "default"; # or "default" if using vim.snippet built-in
      };

      appearance = {
        use_nvim_cmp_as_default = true;
        nerd_font_variant = "mono";
      };

      completion = {
        # ✅ ADD: documentation window to preview snippet body
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 100;
          window = {
            border = "rounded";
          };
        };

        # ✅ ADD: expand snippet on accept
        list = {
          selection = {
            preselect = false;
            auto_insert = true;
          };
        };

        menu = {
          draw = {
            treesitter = [
              "lsp"
              "snippets"
            ]; # highlight these sources
            columns = [
              {"__unkeyed-1" = "label";}
              {
                "__unkeyed-2" = "label_description";
                gap = 1;
              }
              {
                "__unkeyed-3" = "kind_icon";
                "kind" = "kind";
              }
            ];
          };
        };
      };
      sources = {
        providers = {
          copilot = {
            async = true;
            module = "blink-copilot";
            name = "copilot";
            score_offset = 100;
            # Optional configurations
            opts = {
              max_completions = 3;
              max_attempts = 4;
              kind = "Copilot";
              debounce = 750;
              auto_refresh = {
                backward = true;
                forward = true;
              };
            };
          };
          latex-symbols = {
            module = "blink-cmp-latex";
            name = "Latex";
            opts = {
              # set to true to insert the latex command instead of the symbol
              insert_command = false;
            };
          };
          # avante = {
          #   module = "blink-cmp-avante";
          #   name = "Avante";
          #   opts = {
          #     # options for blink-cmp-avante
          #   };
          # };
          snippets = {
            opts = {
              friendly_snippets = true; # loads rafamadriz/friendly-snippets
            };
          };
        };
        default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
          "copilot"
          # "avante"
          "latex-symbols"
        ];
      };
      keymap = {
        "<Tab>" = [
          "snippet_forward"
          "fallback"
        ];
        "<S-Tab>" = [
          "snippet_backward"
          "fallback"
        ];
        "<C-a>" = [
          "select_and_accept"
        ];
        "<C-j>" = [
          "select_next"
          "fallback"
        ];
        "<C-k>" = [
          "select_prev"
          "fallback"
        ];
        "<C-e>" = [
          "hide"
        ];
        "<C-b>" = [
          "scroll_documentation_up"
          "fallback"
        ];
        "<C-f>" = [
          "scroll_documentation_down"
          "fallback"
        ];
        "<C-space>" = [
          "show"
          "show_documentation"
          "hide_documentation"
        ];
      };
    };
  };
}
