{ pkgs, ... }:

let
  # let julia = "${pkgs.julia}/bin/julia";
  inherit (pkgs.lib) getExe;
  julia = getExe pkgs.julia-bin;
in {
  imports = [
    ./plugins/nvim-tree.nix
    ./plugins/bufferline.nix
    ./plugins/navic.nix
    ./plugins/alpha.nix
    ./plugins/luasnip.nix
    ./plugins/illuminate.nix
    ./options.nix
    ./keymaps.nix
    ./cmp.nix
  ];

  colorschemes.tokyonight.enable = true;

  globals = {
    mapleader = "-";
    maplocalleader = " ";
  };

  diagnostics = {
    virtual_text = false; # disable virtual text
    signs = {
      active = "signs"; # show signs
    };
    update_in_insert = true;
    underline = true;
    severity_sort = true;
    float = {
      focusable = true;
      style = "minimal";
      border = "rounded";
      source = "always";
      header = "";
      prefix = "";
    };
  };

  extraConfigLua = # lua
    ''
      vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])

      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
      	vim.fn.sign_define(
      		sign.name,
      		{ texthl = sign.name, text = sign.text, numhl = "" }
      	)
      end

      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, {
          border = "rounded",
        })

      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = "rounded",
      })

      -- from treesitter
      vim.g.skip_ts_context_commentstring_module = true
    '';

  autoCmd = [
    {
      desc = "Save last cusor position for reopen it with same position";
      event = "BufReadPost";

      callback.__raw = # lua
        ''
          function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end
        '';
    }
    {
      desc = "Auto close nvim tree";
      event = "BufEnter";

      callback.__raw = # lua
        ''
          function()
            local function is_modified_buffer_open(buffers)
              for _, v in pairs(buffers) do
                  if v.name:match("NvimTree_") == nil then
                      return true
                  end
              end
              return false
            end

            if #vim.api.nvim_list_wins() == 1
              and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil
              and is_modified_buffer_open(vim.fn.getbufinfo({ bufmodified = 1 })) == false
            then
              vim.cmd("quit")
            end
          end
        '';
    }
    {
      desc = "Define markdown filetype for calcurse";
      event = [ "BufRead" "BufNewFile" ];
      pattern = "/tmp/calcurse*";

      callback.__raw = # lua
        ''
          function()
            vim.bo.filetype = "markdown"
          end
        '';
    }
    {
      desc = "Define markdown filetype for calcurse";
      event = [ "BufRead" "BufNewFile" ];
      pattern = "~/localgit/myCalcurse/notes/*";

      callback.__raw = # lua
        ''
          function()
            vim.bo.filetype = "markdown"
          end
        '';
    }
  ];

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "julia-repl-vim";
      src = pkgs.fetchFromGitHub {
        owner = "erdosxx";
        repo = "julia-repl-vim";
        rev = "b2fc08feca51d1f6119ca291be6c7fca2fac7c45";
        hash = "sha256-JwOfLBNrR7GRK5IFmeklJK4Z7NOg+6ijOomCS41r4kM=";
      };
    })

    (pkgs.vimUtils.buildVimPlugin {
      name = "jupyter-vim";
      src = pkgs.fetchFromGitHub {
        owner = "jupyter-vim";
        repo = "jupyter-vim";
        rev = "91eef96d0f26ce37db241833341d08d11c8e5215";
        hash = "sha256-p00O3YYbMz5ekx8O9kkX+TLNgNdnR427Zr39t17OfrU=";
      };
    })
  ];

  plugins = {
    web-devicons.enable = true;
    barbecue.enable = true;
    lualine.enable = true;
    telescope.enable = true;
    comment.enable = true;
    which-key.enable = true;
    nvim-autopairs.enable = true;
    gitsigns.enable = true;
    rainbow-delimiters.enable = true;
    coverage.enable = true;
    indent-blankline.enable = true;
    # Error occurred for autocommand FTplugin
    # quarto = {
    #   enable = true;
    #   settings = {
    #     lspFeatures = {
    #       enabled = true;
    #       # With "julia" autocmd error occurred.
    #       languages = [ "r" "python" "bash" "html" ];
    #       completion.enabled = true;
    #       diagnostics.enabled = true;
    #     };
    #   };
    # };

    # Not work
    # efmls-configs = {
    #   enable = true;
    #   setup = {
    #     tex = {
    #       formatter = [ "latexindent" ];
    #       linter = [ "vale" ];
    #     };
    #   };
    # };

    treesitter = {
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

    harpoon = {
      enable = true;
      enableTelescope = true;
      keymaps = {
        # See keymaps.nix. 
        #   addFile = "<localleader>m";
        toggleQuickMenu = "<TAB>";
      };
    };

    toggleterm = {
      enable = true;
      settings = {
        open_mapping = "[[<c-\\>]]";
        direction = "float";
        float_opts = {
          border = "curved";
          height = 30;
          width = 130;
        };
      };
    };

    vimtex = {
      enable = true;
      settings = {
        compiler_method = "latexrun";
        toc_config = {
          split_pos =
            "\n              vert\n              topleft\n              ";
          split_width = 40;
        };
        view_method = "zathura";
        imaps_leader = "¬";
      };
    };

    none-ls = {
      enable = true;
      sources = {
        diagnostics = {
          mypy.enable = true;
          yamllint.enable = true;
          zsh.enable = true;
        };

        formatting = {
          bibclean.enable = true;
          black = {
            enable = true;
            settings = {
              timeout = 2000;
              extra_args = [ "--line-length" "79" "--fast" ];
            };
          };
          nixfmt.enable = true;
          prettier = {
            enable = true;
            disableTsServerFormatter = true;
            settings = {
              disabled_filetypes = [ "lua" ];
              extra_args =
                [ "--no-semi" "--single-quote" "--jsx-single-quote" ];
            };
          };
          shfmt = {
            enable = true;
            settings = { extra_args = [ "-i" "2" "-ci" ]; };
          };
          stylua = {
            enable = true;
            settings = { extra_args = [ "--column-width" "79" ]; };
          };
          # not work
          # just.enable = true;
        };
      };
    };

    lsp = {
      enable = true;
      servers = {
        lua_ls = {
          enable = true;
          settings.format.enable = true;
        };
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
        nixd = {
          enable = true;
          package = pkgs.nixd;
        };
        clangd = {
          enable = true;
          cmd = [ "clangd" "--offset-encoding=utf-16" ];
        };
        cmake.enable = true;
        bashls.enable = true;
        dockerls.enable = true;
        julials = {
          enable = true;
          cmd = [
            "${julia}"
            "--startup-file=no"
            "--history-file=no"
            "--project=~/.julia/environment/nvim-lspconfig"
            "-e"
            ''
              import Pkg; Pkg.add("LanguageServer"); using LanguageServer; runserver()''
          ];
          # rootDir = # lua
          #   ''
          #     function(fname)
          #       return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
          #     end
          #   '';
          package = pkgs.julia-bin;
        };
        # pyright.enable = true;
        pylyzer.enable = true;
        # Generated many error logs in ~/.local/state/nvim/lsp.log
        # ltex.enable = true;
        texlab = {
          enable = true;
          filetypes = [ "tex" ];
        };
      };

      keymaps.lspBuf = {
        K = "hover";
        gD = "references";
        gd = "definition";
        gi = "implementation";
        gt = "type_definition";
      };
    };

  };
}
