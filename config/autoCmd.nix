{
  autoCmd = [
    {
      desc = "Save last cusor position for reopen it with same position";
      event = "BufReadPost";

      callback.__raw =
        # lua
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

      callback.__raw =
        # lua
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

      callback.__raw =
        # lua
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

      callback.__raw =
        # lua
        ''
          function()
            vim.bo.filetype = "markdown"
          end
        '';
    }
  ];
}
