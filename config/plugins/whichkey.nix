{
  plugins.which-key = {
    enable = true;
    settings = {
      plugins.marks = true;
      registers = true;

      spelling = {
        enabled = true;
        suggestions = 20;
      };

      presets = {
        operators = false;
        motions = false;
        text_objects = false;
        windows = true;
        nav = true;
        z = true;
        g = true;
      };

      icons = {
        breadcrumb = "»";
        separator = "➜";
        group = "+";
      };

      keys = {
        scroll_down = "<c-d>";
        scroll_up = "<c-u>";
      };

      win = {
        no_overlap = true;
        padding = [ 1 2 ];
        title = true;
        title_pos = "center";
        zindex = 1000;
      };

      layout = {
        height = {
          min = 4;
          max = 25;
        };
        width = {
          min = 20;
          max = 50;
        };
        spacing = 3;
        align = "left";
      };

      show_help = true;
      triggers = [
        {
          __unkeyed-1 = "<auto>";
          mode = "nixsotc";
        }
        {
          __unkeyed-1 = "<leader>";
          mode = [ "n" "v" ];
        }
      ];

      spec = [
        {
          __unkeyed-1 = "<leader>F";
          __unkeyed-2 = "<cmd>Telescope live_grep theme=ivy<cr>";
          desc = "Find Text";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>P";
          __unkeyed-2 = "<cmd>Telescope projects<cr>";
          desc = "Projects";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>b";
          __unkeyed-2 =
            "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>";
          desc = "Buffers";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>c";
          __unkeyed-2 = "<cmd>Bdelete!<CR>";
          desc = "Close Buffer";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<localleader>e";
          __unkeyed-2 = "<cmd>NvimTreeToggle<cr>";
          desc = "Explorer";
          nowait = true;
          remap = false;
          mode = [ "n" "v" ];
        }
        {
          __unkeyed-1 = "<leader>f";
          __unkeyed-2 =
            "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>";
          desc = "Find files";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>gR";
          __unkeyed-2 = "<cmd>lua require 'gitsigns'.reset_buffer()<cr>";
          desc = "Reset Buffer";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>gb";
          __unkeyed-2 = "<cmd>Telescope git_branches<cr>";
          desc = "Checkout branch";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>gc";
          __unkeyed-2 = "<cmd>Telescope git_commits<cr>";
          desc = "Checkout commit";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>gd";
          __unkeyed-2 = "<cmd>Gitsigns diffthis HEAD<cr>";
          desc = "Diff";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>gj";
          __unkeyed-2 = "<cmd>lua require 'gitsigns'.next_hunk()<cr>";
          desc = "Next Hunk";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>gk";
          __unkeyed-2 = "<cmd>lua require 'gitsigns'.prev_hunk()<cr>";
          desc = "Prev Hunk";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>gl";
          __unkeyed-2 = "<cmd>lua require 'gitsigns'.blame_line()<cr>";
          desc = "Blame";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>go";
          __unkeyed-2 = "<cmd>Telescope git_status<cr>";
          desc = "Open changed file";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>gp";
          __unkeyed-2 = "<cmd>lua require 'gitsigns'.preview_hunk()<cr>";
          desc = "Preview Hunk";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>gr";
          __unkeyed-2 = "<cmd>lua require 'gitsigns'.reset_hunk()<cr>";
          desc = "Reset Hunk";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>gs";
          __unkeyed-2 = "<cmd>lua require 'gitsigns'.stage_hunk()<cr>";
          desc = "Stage Hunk";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>gu";
          __unkeyed-2 = "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>";
          desc = "Undo Stage Hunk";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>h";
          __unkeyed-2 = "<cmd>nohlsearch<CR>";
          desc = "No Highlight";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "LSP";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>lI";
          __unkeyed-2 = "<cmd>LspInstallInfo<cr>";
          desc = "Installer Info";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>lS";
          __unkeyed-2 = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>";
          desc = "Workspace Symbols";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>la";
          __unkeyed-2 = "<cmd>lua vim.lsp.buf.code_action()<cr>";
          desc = "Code Action";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>ld";
          __unkeyed-2 = "<cmd>Telescope lsp_document_diagnostics<cr>";
          desc = "Document Diagnostics";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>lf";
          __unkeyed-2 = "<cmd>lua vim.lsp.buf.formatting()<cr>";
          desc = "Format";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>li";
          __unkeyed-2 = "<cmd>LspInfo<cr>";
          desc = "Info";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>lj";
          __unkeyed-2 = "<cmd>lua vim.diagnostic.goto_next()<CR>";
          desc = "Next Diagnostic";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>lk";
          __unkeyed-2 = "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>";
          desc = "Prev Diagnostic";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>ll";
          __unkeyed-2 = "<cmd>lua vim.lsp.codelens.run()<cr>";
          desc = "CodeLens Action";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>lq";
          __unkeyed-2 = "<cmd>lua vim.diagnostic.setloclist()<cr>";
          desc = "Quickfix";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>lr";
          __unkeyed-2 = "<cmd>lua vim.lsp.buf.rename()<cr>";
          desc = "Rename";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>ls";
          __unkeyed-2 = "<cmd>Telescope lsp_document_symbols<cr>";
          desc = "Document Symbols";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>lw";
          __unkeyed-2 = "<cmd>Telescope lsp_workspace_diagnostics<cr>";
          desc = "Workspace Diagnostics";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>q";
          __unkeyed-2 = "<cmd>q!<CR>";
          desc = "Quit";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "Search";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>sC";
          __unkeyed-2 = "<cmd>Telescope commands<cr>";
          desc = "Commands";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>sM";
          __unkeyed-2 = "<cmd>Telescope man_pages<cr>";
          desc = "Man Pages";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>sR";
          __unkeyed-2 = "<cmd>Telescope registers<cr>";
          desc = "Registers";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>sb";
          __unkeyed-2 = "<cmd>Telescope git_branches<cr>";
          desc = "Checkout branch";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>sc";
          __unkeyed-2 = "<cmd>Telescope colorscheme<cr>";
          desc = "Colorscheme";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>sh";
          __unkeyed-2 = "<cmd>Telescope help_tags<cr>";
          desc = "Find Help";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>sk";
          __unkeyed-2 = "<cmd>Telescope keymaps<cr>";
          desc = "Keymaps";
          nowait = true;
          remap = false;
        }
        {
          __unkeyed-1 = "<leader>sr";
          __unkeyed-2 = "<cmd>Telescope oldfiles<cr>";
          desc = "Open Recent File";
          nowait = true;
          remap = false;
        }
      ];
    };
  };
}
