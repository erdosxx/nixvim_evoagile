{
  plugins.conjure.enable = true;

  extraConfigLua = ''
    vim.api.nvim_set_var("let g:conjure#mapping#prefix", "#")
    vim.g["conjure#filetypes"] = {
    	"clojure",
    	"fennel",
    	"janet",
    	"hy",
    	"racket",
    	"scheme",
    	"lua",
    	"lisp",
    	--[[ "python", ]]
    	"rust",
    	"sql",
    	--[[ "julia", ]]
    }
    --[[ vim.g["conjure#client#julia#stdio#command"] = "julia --project=. -i" ]]
    vim.g["conjure#mapping#eval_current_form"] = "u"
    vim.g["conjure#mapping#eval_root_form"] = "/"
    vim.g["conjure#mapping#eval_visual"] = "k"
  '';
}
