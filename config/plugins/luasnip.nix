{
  plugins = {
    luasnip = {
      enable = true;
      fromLua = [{ paths = ./LuaSnip; }];
      # extraConfig = {
      #   history = true;
      #
      #   # Enable autotriggered snippets
      #   enable_autosnippets = true;
      #
      #   # [[ -- Use Tab (or some other key if you prefer) to trigger visual selection ]]
      #   store_selection_keys = "<C-f>";
      #
      #   # Update text as you type for repeat node
      #   update_events = "TextChanged,TextChangedI";
      # };
    };
  };

  extraConfigLua = # lua
    ''
            require("luasnip").config.set_config({ -- Setting LuaSnip config
      	      history = true,

      	      -- Enable autotriggered snippets
      	      enable_autosnippets = true,

      	      --[[ -- Use Tab (or some other key if you prefer) to trigger visual selection ]]
      	      store_selection_keys = "<C-f>",

      	      -- Update text as you type for repeat node
      	      update_events = "TextChanged,TextChangedI",

            	ext_opts = {
            		[require("luasnip.util.types").choiceNode] = {
            			active = {
            				virt_text = { { "➜", "GruvboxOrange" } },
            			},
            		},
            	},
            })

            -- local ls = require("luasnip")
            -- 
            -- vim.keymap.set({ "i", "s" }, "<C-f>", function()
            -- 	if ls.expand_or_jumpable() then
            -- 		ls.expand()
            -- 	end
            -- end)
            --
            -- vim.keymap.set({ "i", "s" }, "<C-j>", function()
            -- 	if ls.jumpable(1) then
            -- 		ls.jump(1)
            -- 	end
            -- end)
            --
            -- vim.keymap.set({ "i", "s" }, "<C-k>", function()
            -- 	if ls.jumpable(-1) then
            -- 		ls.jump(-1)
            -- 	end
            -- end)
            --
            -- vim.keymap.set({ "i", "s" }, "<C-l>", function()
            -- 	if ls.choice_active() then
            -- 		ls.change_choice(1)
            -- 	end
            -- end)
            --
            -- vim.keymap.set({ "i", "s" }, "<C-h>", function()
            -- 	if ls.choice_active() then
            -- 		ls.change_choice(-1)
            -- 	end
            -- end)
    '';

  keymaps = [
    {
      action.__raw = # lua
        ''
                  function()
          	        if require("luasnip").expand_or_jumpable() then
          		        require("luasnip").expand()
          	        end
                  end
        '';
      key = "<C-f>";
      mode = [ "i" "s" ];
    }
    {
      action.__raw = # lua
        ''
                  function()
          	        if require("luasnip").jumpable(1) then
          		        require("luasnip").jump(1)
          	        end
                  end
        '';
      key = "<C-j>";
      mode = [ "i" "s" ];
    }
    {
      action.__raw = # lua
        ''
                  function()
          	        if require("luasnip").jumpable(-1) then
          		        require("luasnip").jump(-1)
          	        end
                  end
        '';
      key = "<C-k>";
      mode = [ "i" "s" ];
    }
    {
      action.__raw = # lua
        ''
                  function()
          	        if require("luasnip").choice_active() then
          		        require("luasnip").change_choice(1)
          	        end
                  end
        '';
      key = "<C-l>";
      mode = [ "i" "s" ];
    }
    {
      action.__raw = # lua
        ''
                  function()
          	        if require("luasnip").choice_active() then
          		        require("luasnip").change_choice(-1)
          	        end
                  end
        '';
      key = "<C-h>";
      mode = [ "i" "s" ];
    }
  ];
}
