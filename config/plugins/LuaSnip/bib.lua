local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local c = ls.choice_node
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local autosnippet =
    ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local capture = function(_, parent, user_args)
  return parent.captures[user_args]
end

local snips = {
  autosnippet(
    { trig = "arf", name = "add 12", dscr = "add @Reading template" },
    fmta(
      [[
      @Reading{1200:<>,
        refnum       = "<>",
        reference    = ekte1200,
        difficulty   = "<>",
        mydifficulty = "<>",
        extended     = "<>",
        text         = "<>",
        author       = "{<>}",
        authoryear   = "<>\endash<>",
        title        = "<>",
        URL          = "<>",
        examuniv     = <>,
      }
      ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(0),
        i(6),
        i(7),
        i(8),
        i(9),
        i(10),
        i(11),
      }
    ),
    { condition = line_begin }
  ),
  autosnippet(
    { trig = "arm", name = "add 12", dscr = "add @Reading template" },
    fmta(
      [[
      @Reading{1200:<>,
        refnum       = "<>",
        reference    = ekte1200,
        difficulty   = "<>",
        mydifficulty = "<>",
        text         = "<>",
        examuniv     = <>,
      }
      ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(0),
        i(5),
      }
    ),
    { condition = line_begin }
  ),
  autosnippet({
    trig = ";dd",
    name = "double cdots",
    desc = "add double cdots",
    wordTrig = false,
  }, { t("\\dcdots ") }),
}

return snips
