{ pkgs, ... }:
let
  inherit (pkgs.lib) getExe;
  lazygit = getExe pkgs.lazygit;
  htop = getExe pkgs.htop;
  devenv = getExe pkgs.devenv;
in {
  plugins.which-key = {
    settings.spec = [
      {
        __unkeyed-1 = "<localleader>t";
        group = "Terminal";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>tf";
        __unkeyed-2 = "<cmd>ToggleTerm direction=float<cr>";
        desc = "Float";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>th";
        __unkeyed-2 = "<cmd>ToggleTerm size=10 direction=horizontal<cr>";
        desc = "Horizontal";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>tv";
        __unkeyed-2 = "<cmd>ToggleTerm size=50 direction=vertical<cr>";
        desc = "Vertical";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>tg";
        __unkeyed-2 = "<cmd>lua _LAZYGIT_TOGGLE()<CR>";
        desc = "Lazygit";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>tj";
        __unkeyed-2 = "<cmd>lua _JULIA_TOGGLE()<cr>";
        desc = "Julia";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>tp";
        __unkeyed-2 = "<cmd>lua _PYTHON_TOGGLE()<cr>";
        desc = "Python";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>tt";
        __unkeyed-2 = "<cmd>lua _HTOP_TOGGLE()<cr>";
        desc = "Htop";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>tr";
        __unkeyed-2 = "<cmd>lua _R_TOGGLE()<cr>";
        desc = "R";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>u";
        __unkeyed-2 = ''<cmd>lua _send_single_line()<cr>'';
        mode = "n";
        desc = "Send a line to terminal";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>u";
        __unkeyed-2 = ''<cmd>lua _send_multiple_lines()<cr>'';
        mode = "v";
        desc = "Send vitual selected lines to terminal";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>k";
        __unkeyed-2 = ''<cmd>lua _send_selected()<cr>'';
        mode = "v";
        desc = "Send selected parts to terminal";
        nowait = true;
        remap = false;
      }
      {
        __unkeyed-1 = "<localleader>/";
        __unkeyed-2 = ''<cmd>lua _send_matching()<cr>'';
        mode = "n";
        desc = "Send matching parts to terminal";
        nowait = true;
        remap = false;
      }
    ];
  };

  plugins.toggleterm = {
    enable = true;
    settings = {
      size = ''
        function(term)
          if term.direction == "horizontal" then
            return 20
          elseif term.direction == "vertical" then
            return 40
          end
        end
      '';
      open_mapping = "[[<c-\\>]]";
      hide_numbers = true;
      shade_filetypes = [ ];
      shade_terminals = true;
      shading_factor = 2;
      start_in_insert = true;
      insert_mappings = true;
      persist_size = true;
      direction = "float";
      close_on_exit = true;
      shell = { __raw = "vim.o.shell"; };
      float_opts = {
        border = "curved";
        winblend = 0;
        highlights = {
          border = "Normal";
          background = "Normal";
        };
      };
    };

    luaConfig.pre = ''
      local status_ok, toggleterm = pcall(require, "toggleterm")
      if not status_ok then
      	return
      end

      function Set_terminal_keymaps()
        local opts = {noremap = true}
        -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
        -- vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
        vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua Set_terminal_keymaps()')

      local Terminal = require("toggleterm.terminal").Terminal

      local lazygit = Terminal:new({ cmd = "${lazygit}", hidden = true, direction = "float" })
      function _LAZYGIT_TOGGLE()
      	lazygit:toggle()
      end

      local julia_cmd = 'julia --project=. --load ~/.julia/config/startup_nopair.jl'

      local julia = Terminal:new({cmd = '[ -n "$DEVENV_ROOT" ] && ' .. julia_cmd
          .. ' || ${devenv} shell -- ' .. julia_cmd,
        hidden = true,
        direction = "vertical",
      })

      function _JULIA_TOGGLE()
      	julia:toggle()
      end

      local htop = Terminal:new({ cmd = "${htop}", hidden = true, direction = "float" })
      function _HTOP_TOGGLE()
      	htop:toggle()
      end

      local python = Terminal:new({ cmd = '[ -n "$DEVENV_ROOT" ] && python || ${devenv} shell -- python', hidden = true, direction = "vertical" })
      function _PYTHON_TOGGLE()
      	python:toggle()
      end

      local R = Terminal:new({ cmd = '[ -n "$DEVENV_ROOT" ] && R || ${devenv} shell --command R', hidden = true, direction = "vertical" })
      function _R_TOGGLE()
      	R:toggle()
      end

      -- Set trim_spaces=false for sending to REPLs for whitespace-sensitive languages like python.
      local is_trim_spaces = false
      local term_id = 1
      function _send_single_line()
        require("toggleterm").send_lines_to_terminal("single_line", is_trim_spaces, { args = term_id })
      end

      function _send_multiple_lines()
        require("toggleterm").send_lines_to_terminal("visual_lines", is_trim_spaces, { args = term_id })
      end

      function _send_selected()
        require("toggleterm").send_lines_to_terminal("visual_selection", is_trim_spaces, { args = term_id })
      end

      local function get_julia_block_range()
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1

        -- Try treesitter first
        local ok, parser = pcall(vim.treesitter.get_parser, 0, "julia")
        if ok and parser then
          parser:parse()
          local first_col = line:find("%S")
          local col = first_col and (first_col - 1) or cursor[2]
          local node = vim.treesitter.get_node({ pos = { row, col } })
          while node do
            local ntype = node:type()
            if ntype == "function_definition" or ntype == "macro_definition" then
              local srow, _, erow, _ = node:range()
              if row == srow or row == erow then
                return srow + 1, erow + 1
              end
            end
            node = node:parent()
          end
        end

        -- Fallback using searchpairpos
        local all_start_pat = [[\C\<\%(function\|macro\|quote\|let\|if\|for\|while\|try\|struct\|module\|baremodule\|begin\|do\)\>]]
        local mid_pat = [[\C\<\%(elseif\|else\|catch\|finally\)\>]]
        local end_pat = [[\C\<end\>]]

        if line:match("%f[%a]function%f[%A]") or line:match("%f[%a]macro%f[%A]") then
          local end_pos = vim.fn.searchpairpos(all_start_pat, mid_pat, end_pat, "nW")
          if end_pos[1] > 0 then
            return cursor[1], end_pos[1]
          end
        end

        if line:match("%f[%a]end%f[%A]") then
          local start_pos = vim.fn.searchpairpos(all_start_pat, mid_pat, end_pat, "bnW")
          if start_pos[1] > 0 then
            return start_pos[1], cursor[1]
          end
        end

        return nil, nil
      end

      function _send_matching()
        local orig_pos = vim.api.nvim_win_get_cursor(0)
        local start_line, end_line

        if vim.bo.filetype == "julia" then
          start_line, end_line = get_julia_block_range()
        end

        if start_line and end_line then
          vim.api.nvim_win_set_cursor(0, { start_line, 0 })
          vim.cmd("normal! V")
          vim.api.nvim_win_set_cursor(0, { end_line, 0 })
          _send_multiple_lines()
          vim.api.nvim_win_set_cursor(0, orig_pos)
        else
          vim.cmd("normal! V%")
          _send_multiple_lines()
          vim.api.nvim_win_set_cursor(0, orig_pos)
        end
      end
    '';
  };
}
