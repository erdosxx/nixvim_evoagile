{ nixpkgs-unfree }: {
  plugins = {
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-cmdline.enable = true;
    cmp_luasnip.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lua.enable = true;

    copilot-cmp = {
      enable = true;
      # extraOptions = {
      #   formatters = {
      #     label = copilot_cmp_format.format_label_text;
      #     insert_text = copilot_cmp_format.remove_existing;
      #     preview = copilot_cmp_format.deindent;
      #   };
      # };
    };

    copilot-lua = {
      enable = true;
      settings = {
        panel = {
          enabled = false;
          autoRefresh = true;
          keymap = {
            jumpNext = "<c-j>";
            jumpPrev = "<c-k>";
            accept = "<c-a>";
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
        copilotNodeCommand = "node";
        serverOptsOverrides = { };
      };
    };

    cmp-tabnine = {
      enable = true;
      settings = {
        max_lines = 1000;
        max_num_results = 20;
        sort = true;
        run_on_every_keystroke = true;
        snippet_placeholder = "..";
        ignored_file_types = { };
        show_prediction_strength = false;
      };
      package = nixpkgs-unfree.vimPlugins.cmp-tabnine;
    };

    cmp = {
      enable = true;
      autoEnableSources = true;

      filetype = {
        tex = { sources = [ { name = "luasnip"; } { name = "nvim_lsp"; } ]; };
      };

      settings = {
        snippet.exapnd = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
        experimental = {
          ghost_text = false;
          native_menu = false;
        };
        mapping = {
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-b>" = ''cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" })'';
          "<C-f>" = ''cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" })'';
          "<C-Space>" = ''cmp.mapping(cmp.mapping.complete(), { "i", "c" })'';
          "<C-y>" = "cmp.config.disable";
          "<C-e>" = ''
            cmp.mapping({
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            })'';
          "<CR>" = ''
            cmp.mapping.confirm ({
              behavior = cmp.ConfirmBehavior.Replace,
              select = false,
            })'';
          "<Tab>" = ''
            cmp.mapping(
              function(fallback)
                local snip_status_ok, luasnip = pcall(require, "luasnip")
                if not snip_status_ok then
            	    return
                end

                local check_backspace = function()
                  local col = vim.fn.col(".") - 1
                  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
                  end

                local has_words_before = function()
            	    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
            		    return false
            	    end
            	    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            	    return col ~= 0
            		    and vim.api
            		      .nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
            		      :match("^%s*$")
            		    == nil
                end

               	if cmp.visible() and has_words_before() then
                	cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
               	elseif luasnip.expandable() then
                	luasnip.expand()
               	elseif luasnip.expand_or_jumpable() then
                	luasnip.expand_or_jump()
               	elseif check_backspace() then
                	fallback()
               	else
                	fallback()
               	end
              end, { "i", "s", })
          '';
          "<S-Tab>" = ''
            cmp.mapping(
              function(fallback)
                local snip_status_ok, luasnip = pcall(require, "luasnip")
                if not snip_status_ok then
                  return
                end

            	  if cmp.visible() then
            		  cmp.select_prev_item()
            	  elseif luasnip.jumpable(-1) then
            		  luasnip.jump(-1)
            	  else
            		  fallback()
            	  end
              end, { "i", "s", })
          '';
        };
        formatting = {
          fields = [ "kind" "abbr" "menu" ];
          format = ''
            function(entry, vim_item)
              local kind_icons = {
              	Text = "󰉿",
              	Method = "m",
              	Function = "󰊕",
              	Constructor = "",
              	Field = "",
              	Variable = "󰆧",
              	Class = "󰌗",
              	Interface = "",
              	Module = "",
              	Property = "",
              	Unit = "",
              	Value = "󰎠",
              	Enum = "",
              	Keyword = "",
              	Snippet = "",
              	Color = "󰏘",
              	File = "󰈙",
              	Reference = "",
              	Folder = "󰉋",
              	EnumMember = "",
              	Constant = "󰇽",
              	Struct = "",
              	Event = "",
              	Operator = "󰆕",
              	TypeParameter = "󰊄",
              	Copilot = "",
              }
              vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
              vim_item.menu = ({
                copilot = "[Copilot]",
                cmp_tabnine = "[TN]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[NVIM_LUA]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              if entry.source.name == "cmp_tabnine" then
                local detail = (entry.completion_item.labelDetails or {}).detail
                vim_item.kind = ""
                if detail and detail:find(".*%%.*") then
                  vim_item.kind = vim_item.kind .. " " .. detail
                end
                if (entry.completion_item.data or {}).multiline then
                  vim_item.kind = vim_item.kind .. " " .. "[ML]"
                end
              end
              local maxwidth = 80
              vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
              return vim_item
            end
          '';
        };
        sources = [
          { name = "copilot"; }
          { name = "cmp_tabnine"; }
          { name = "nvim_lsp"; }
          { name = "nvim_lua"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "path"; }
        ];
        window.documentation.border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
      };
    };
  };
}
