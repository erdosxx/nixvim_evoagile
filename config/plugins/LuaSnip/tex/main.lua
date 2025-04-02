local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local d = ls.dynamic_node
local f = ls.function_node
local t = ls.text_node
local ai = require("luasnip.nodes.absolute_indexer")
local postfix = require("luasnip.extras.postfix").postfix
local c = ls.choice_node
local isn = ls.indent_snippet_node
local r = ls.restore_node
local extras = require("luasnip.extras")
local l = extras.lambda
local m = extras.match

local function get_visual(_, parent)
  -- LS_SELECT_RAW also works
  if #parent.snippet.env.SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else
    return sn(nil, i(1))
  end
end

local function get_visual_str(_, parent)
  -- LS_SELECT_RAW also works
  if #parent.snippet.env.SELECT_RAW > 0 then
    return parent.snippet.env.SELECT_RAW
  else
    return ""
  end
end

local function isempty(st)
  return st == nil or st == ""
end

local tex_utils = {}

function tex_utils.in_mathzone()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

function tex_utils.in_text()
	return not tex_utils.in_mathzone()
end

function tex_utils.in_comment()
	return vim.fn["vimtex#syntax#in_comment"]() == 1
end

function tex_utils.in_env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

function tex_utils.in_equation()
	return tex_utils.in_env("equation")
end

function tex_utils.in_itemize()
	return tex_utils.in_env("itemize")
end

function tex_utils.in_tikz()
	return tex_utils.in_env("tikzpicture")
end

tex_utils.context_math = {
	condition = tex_utils.in_mathzone,
	show_condition = tex_utils.in_mathzone,
}

local line_begin = require("luasnip.extras.expand_conditions").line_begin

ls.filetype_extend("tex", { "python" })

local function count(_, _, old_state)
  old_state = old_state or {
    updates = 0,
  }

  old_state.updates = old_state.updates + 1

  local snip = sn(nil, {
    t(tostring(old_state.updates)),
  })

  snip.old_state = old_state
  return snip
end

local function simple_restore(args, _)
  return sn(nil, { i(1, args[1]), t("--"), r(2, "", i(nil, "user_text")) })
end

local function simple_restore_old(args, _)
  return sn(nil, { i(1, args[1]), t("--"), i(2, "user_text") })
end

local mat = function(_, parent)
  local rows = tonumber(parent.captures[2])
  local cols = tonumber(parent.captures[3])
  local nodes = {}
  local jump_index = 1

  for row = 1, rows do
    table.insert(nodes, r(jump_index, tostring(row) .. "x1", i(1)))
    jump_index = jump_index + 1

    for col = 2, cols do
      table.insert(nodes, t(" & "))
      table.insert(
        nodes,
        r(jump_index, tostring(row) .. "x" .. tostring(col), i(1))
      )
      jump_index = jump_index + 1
    end
    table.insert(nodes, t({ "\\\\", "" }))
  end
  -- fix last node
  nodes[#nodes] = t("\\\\")
  return sn(nil, nodes)
end

local mat2 = function(_, parent)
  local rows = tonumber(parent.captures[2])
  local cols = tonumber(parent.captures[3])
  local nodes = {}
  local jump_index = 1

  for _ = 1, rows do
    table.insert(
      nodes,
      --[[ r(ins_indx, tostring(row) .. "x1", { i(1), t("x") }) ]]
      i(jump_index, tostring(jump_index))
    )
    jump_index = jump_index + 1

    for _ = 2, cols do
      table.insert(nodes, t(" & "))
      table.insert(nodes, i(jump_index, tostring(jump_index)))
      jump_index = jump_index + 1
    end
    table.insert(nodes, t({ "\\\\", "" }))
  end
  -- fix last node
  nodes[#nodes] = t("\\\\")
  return sn(nil, nodes)
end

-- integral functions
-- generate \int_{<>}^{<>}
local int1 = function(_, snip)
  local vars = tonumber(snip.captures[1])
  local nodes = {}
  for j = 1, vars do
    table.insert(nodes, t("\\int_{"))
    table.insert(nodes, r(2 * j - 1, "lb" .. tostring(j), i(1)))
    table.insert(nodes, t("}^{"))
    table.insert(nodes, r(2 * j, "ub" .. tostring(j), i(1)))
    table.insert(nodes, t("}"))
  end
  return sn(nil, nodes)
end

-- generate \dd <>
local int2 = function(_, snip)
  local vars = tonumber(snip.captures[1])
  local nodes = {}
  for j = 1, vars do
    table.insert(nodes, t(" \\dd "))
    table.insert(nodes, r(j, "var" .. tostring(j), i(1)))
  end
  return sn(nil, nodes)
end

local get_i_times = function(_, parent)
  local inum = tonumber(parent.parent.captures[1])
  local res = string.rep("i", inum)
  return res
end

local autosnippet =
    ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

local generate_label = function(_, _, _, user_args)
  local delims = { "[", "]" }
  if user_args[2] ~= "xargs" then
    delims = { "\\label{", "}" } -- chooses surrounding environment
  end

  if isempty(user_args[1]) then -- creates a general label
    return sn(nil, fmta([[\label{<>}]], { i(1) }))
  else                          -- creates a specialized label
    return sn(
      nil,
      fmta(
        [[<><>:<><>]],
        { t(delims[1]), t(user_args[1]), i(1), t(delims[2]) }
      )
    )
  end
end

local round_bar = function(args, _, user_args)
  return user_args[1] .. string.rep("-", #args[1][1] + 2) .. user_args[2]
end

local capture = function(_, parent, user_args)
  return parent.captures[user_args]
end

local capture_frac = function(_, parent, user_args)
  local cap_str = parent.captures[user_args]
  print(cap_str)
  local depth = 0
  local idx = #cap_str

  while true do
    local cap_str_at_idx = cap_str:sub(idx, idx)
    if cap_str_at_idx == ")" then
      depth = depth + 1
    elseif cap_str_at_idx == "(" then
      depth = depth - 1
    end
    if depth == 0 then
      break
    end
    idx = idx - 1
  end
  return cap_str:sub(1, idx - 1)
      .. "\\frac{"
      .. cap_str:sub(idx + 1, -2)
      .. "}"
end

local is_need_space = function(args)
  local input_first_str = args[1][1]:sub(1, 1)
  print(input_first_str)

  local not_word_chars = { ",", ".", "?", "-", " " }
  for _, nw_char in ipairs(not_word_chars) do
    if input_first_str == nw_char then
      return ""
    end
  end

  return " "
end

local runWolframCmd = function(wolframCmd)
  local cmdFiltered = wolframCmd:gsub(" ", "")
  local wolframRunner = "wolframscript -code 'ToString["
  local cmd = wolframRunner .. cmdFiltered .. ",TeXForm]'"

  local files = {}
  local tmpfile = "/tmp/stmp.txt"
  os.execute(cmd .. " > " .. tmpfile)

  local f = io.open(tmpfile)
  if not f then
    return files
  end

  local line_no = 1
  for line in f:lines() do
    files[line_no] = line
    line_no = line_no + 1
  end

  f:close()
  return files[1]
end

local captureWolfram = function(_, parent, user_args)
  local wolframCmd = parent.captures[user_args]
  return runWolframCmd(wolframCmd)
end

local snips = {
  s({ trig = ";a", snippetType = "autosnippet" }, { t("\\alpha") }),
  s({ trig = ";b", snippetType = "autosnippet" }, { t("\\beta") }),
  s({ trig = ";g", snippetType = "autosnippet" }, { t("\\gamma") }),
  s({
    trig = "tt",
    dscr = "Expands 'tt' into '\texttt{}'",
  }, fmta("\\textt{<>}", { i(1) })),
  s(
    { trig = "eq", desc = "A LaTeX equation environment" },
    fmta(
      [[
				\begin{equation}
					<>
				\end{equation}
			]],
      { i(0) }
    )
  ),
  s(
    {
      trig = "env",
      snippetType = "autosnippet",
    },
    fmta(
      [[
				\begin{<>}
				<>
				\end{<>}
			]],
      {
        i(1),
        i(2),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  s(
    {
      trig = "hr",
      dscr = "The hyperref package's href{}{} command (for url links)",
    },
    fmta([[\href{<>}{<>}]], {
      i(1, "url"),
      i(2, "display name"),
    })
  ),
  s(
    { trig = "tii", dscr = "Expands 'tii' into LaTeX's textit{} command." },
    fmta("\\textit{<>}", {
      d(1, get_visual),
    })
  ),
  s(
    { trig = "([^%a])ee", regTrig = true, wordTrig = false },
    fmta("<>e^{<>}", {
      f(capture, {}, { user_args = { 1 } }),
      d(1, get_visual),
    }),
    tex_utils.context_math
  ),
  s(
    { trig = "ee", regTrig = true, wordTrig = false },
    fmta("<>e^{<>}", {
      f(capture, {}, { user_args = { 1 } }),
      d(1, get_visual),
    }),
    { condition = tex_utils.in_mathzone + line_begin }
  ),
  s(
    {
      trig = "([%a%)%]%}])00",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
    },
    fmta("<>_{<>}", {
      f(capture, {}, { user_args = { 1 } }),
      i(0, "0"),
      --[[ t("0"), ]]
    })
  ),
  s(
    { trig = "h1", dscr = "Top-level section" },
    fmta([[\section{<>}]], { i(1) }),
    { condition = line_begin }
  ),
  s(
    { trig = "new", dscr = "A generic new environment" },
    fmta(
      [[
				\begin{<>}
				<>
				\end{<>}
			]],
      {
        i(1),
        i(2),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "dd" },
    fmta("\\draw [<>] ", {
      i(1, "params"),
    }),
    { condition = tex_utils.in_tikz }
  ),
  s(
    { trig = "df", snippetType = "autosnippet" },
    { t("\\diff") },
    tex_utils.context_math
  ),
  s(
    { trig = "sd", snippetType = "autosnippet", wordTrig = false },
    fmta("_{\\mathrm{<>}}", { d(1, get_visual) }),
    tex_utils.context_math
  ),
  postfix(".br", {
    f(function(_, parent)
      return "[" .. parent.snippet.env.POSTFIX_MATCH .. "]"
    end, {}),
  }),
  s(
    "ternary",
    { i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else") }
  ),
  s("isn2", {
    isn(
      1,
      t({ "//This is", "A multiline", "comment" }),
      "$PARENT_INDENT##"
    ),
  }),
  s(
    "choice",
    c(1, {
      t("Ugh boring, a text node"),
      i(nil, "At least I can edit something now..."),
      f(function(args)
        return "Still only counts as text!!"
      end, {}),
    })
  ),
  s("trig", {
    i(1),
    t(":"),
    i(2),
    t("::"),
    m({ 1, 2 }, l._1:match("^" .. l._2 .. "$"), l._1:gsub("a", "e")),
  }),
  s("extras1", {
    i(1),
    t({ "", "" }),
    m(1, "^ABC$", "A"),
  }),
  s("extras2", {
    i(1, "INPUT"),
    t({ "", "" }),
    m(1, l._1:match(l._1:reverse()), "PALINDROME"),
  }),
  s("extras3", {
    i(1),
    t({ "", "" }),
    i(2),
    t({ "", "" }),
    m({ 1, 2 }, l._1:match("^" .. l._2 .. "$"), l._1:gsub("a", "e")),
  }),
  s("extras4", { i(1), t({ "", "" }), extras.rep(1) }),
  s("today", { extras.partial(os.date, "%F"), t(" ") }),
  s(
    "extras6",
    { i(1, ""), t({ "", "" }), extras.nonempty(1, "not empty!", "empty!") }
  ),
  s(
    "extras7",
    { i(1), t({ "", "" }), extras.dynamic_lambda(2, l._1 .. l._1, 1) }
  ),
  s("paren_change", {
    c(1, {
      sn(nil, { t("("), r(1, "user_text"), t(")") }),
      sn(nil, { t("["), r(1, "user_text"), t("]") }),
      sn(nil, { t("{"), r(1, "user_text"), t("}") }),
    }),
  }, {
    stored = {
      ["user_text"] = i(1, "default_text"),
    },
  }),
  s({ trig = "paren_change2", desc = "Same as paren_change" }, {
    c(1, {
      sn(
        nil,
        { t("("), r(1, "user_text", i(1, "default_text")), t(")") }
      ),
      sn(
        nil,
        { t("["), r(1, "user_text", i(1, "default_text")), t("]") }
      ),
      sn(
        nil,
        { t("{"), r(1, "user_text", i(1, "default_text")), t("}") }
      ),
    }),
  }),
  s("rest", {
    i(1, "preset"),
    t({ "", "" }),
    d(2, simple_restore, { 1 }),
  }),
  s("rest_o", {
    i(1, "preset"),
    t({ "", "" }),
    d(2, simple_restore_old, { 1 }),
  }),
  s("sign", t({ "Yours sincerely,", "", "Norel Oh" })),
  s(
    {
      trig = "(%a)(%d)",
      name = "auto subscript",
      dscr = "subscript for 1 digit",
      regTrig = true,
    },
    fmta([[<>_<>]], {
      f(capture, {}, { user_args = { 1 } }),
      f(capture, {}, { user_args = { 2 } }),
    }),
    tex_utils.context_math
  ),
  s(
    {
      trig = "(%a)_(%d+)",
      name = "auto subscript 2+",
      dscr = "auto subscript for 2+ digits",
      regTrig = true,
    },
    fmta([[<>_{<>}]], {
      f(capture, {}, { user_args = { 1 } }),
      f(capture, {}, { user_args = { 2 } }),
    }),
    tex_utils.context_math
  ),
  autosnippet(
    { trig = "hat", name = "prefix hat", dscr = "prefix hat" },
    fmta([[\hat{<>}<>]], { i(1), i(0) }),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "([%a\\]+)hat",
      name = "suffix hat",
      dscr = "suffix hat",
      regTrig = true,
      wordTrig = false,
    },
    fmta([[\hat{<>}]], {
      f(capture, {}, { user_args = { 1 } }),
    }),
    tex_utils.context_math
  ),
  autosnippet(
    { trig = "bar", name = "prefix bar", dscr = "prefix bar" },
    fmta([[\overline{<>}<>]], { i(1), i(0) }),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "([%a\\]+)bar",
      name = "suffix bar",
      dscr = "suffix bar",
      regTrig = true,
      wordTrig = false,
    },
    fmta([[\overline{<>}]], {
      f(capture, {}, { user_args = { 1 } }),
    }),
    tex_utils.context_math
  ),
  s(
    { trig = "lrv", name = "left right", dscr = "left right" },
    fmta([[\left(<>\right)<>]], {
      f(function(_, snip)
        local res, env = {}, snip.env
        for _, val in ipairs(env.LS_SELECT_RAW) do
          table.insert(res, val)
        end
        return res
      end, {}),
      i(0),
    }),
    tex_utils.context_math
  ),
  s(
    { trig = "qw", name = "inline code", dscr = "inline code, ft escape" },
    fmta([[\mintinline{<>}<>]], {
      i(1, "text"),
      c(2, {
        sn(nil, { t("{"), i(1), t("}") }),
        sn(nil, { t("|"), i(1), t("|") }),
      }),
    })
  ),
  s(
    {
      trig = "([bBpvV])mat(%d+)x(%d+)([ar])",
      name = "matrix",
      dscr = "matrix trigger",
      regTrig = true,
    },
    fmta(
      [[
      \begin{<>}<>
      <>
      \end{<>}
      ]],
      {
        f(function(_, snip)
          return snip.captures[1] .. "matrix"
        end),
        f(function(_, snip)
          if snip.captures[4] == "a" then
            out = string.rep("c", tonumber(snip.captures[3]) - 1)
            return "[" .. out .. "|c]"
          end
          return ""
        end),
        d(1, mat2),
        f(function(_, snip)
          return snip.captures[1] .. "matrix"
        end),
      }
    )
  ),
  s(
    { trig = "set", name = "set", dscr = "set" },
    fmta(
      [[
      \{<>\}<>
      ]],
      {
        c(1, { r(1, ""), sn(nil, { r(1, ""), t(" \\mid "), i(2) }) }),
        i(0),
      }
    ),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "(%d)int",
      name = "multi integrals",
      dscr = "please work",
      regTrig = true,
      hidden = false,
    },
    fmta([[<> <> <> <>]], {
      c(1, {
        fmta([[ \<><>nt_{<>} ]], {
          c(1, { t(""), t("o") }),
          f(get_i_times),
          i(2),
        }),
        d(nil, int1),
      }),
      i(2),
      d(3, int2),
      i(0),
    }),
    tex_utils.context_math
  ),
  s(
    {
      trig = "#",
      name = "generate label",
      dscr = "generate \\section{$1}(\\label{sec:$1)",
      hidden = true,
      priority = 250,
    },
    fmta([[\section{<>}<><>]], {
      i(1),
      c(2, {
        t(""),
        d(1, generate_label, {}, { user_args = { { "sec", "" } } }),
      }),
      i(0),
    })
  ),
  s(
    {
      trig = "adef",
      name = "add definition",
      dscr = "add definition box",
    },
    fmta(
      [[
      \begin{definition}[<>]<>{<>}
      \end{definition}
      ]],
      {
        i(1),
        c(2, {
          t(""),
          d(
            1,
            generate_label,
            {},
            { user_args = { { "def", "xargs" } } }
          ),
        }),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "rbox",
      name = "round box",
      dscr = "generate surrounding box",
    },
    fmta(
      [[
      <>
      | <> |
      <>
      ]],
      {
        f(round_bar, { 1 }, { user_args = { { "┌", "┐" } } }),
        i(1),
        f(round_bar, { 1 }, { user_args = { { "└", "┘" } } }),
      }
    )
  ),
  s({ trig = "jmp", name = "test jump index", dscr = "dscr" }, {
    i(1, "first"),
    t(" "),
    sn(2, { t(" "), i(2, "second"), t(" "), i(1, "third") }),
  }),
  autosnippet(
    {
      trig = "mm",
      name = "inline math mode",
      dscr = "inline math mode with adding automatic space",
      wordTrig = true,
    },
    fmta([[$<>$<><>]], { i(1), f(is_need_space, { 2 }), i(2) }),
    { condition = tex_utils.in_text, show_condition = tex_utils.in_text }
  ),
  autosnippet(
    {
      trig = "dm",
      name = "display math",
      dscr = "display math",
      wordTrig = true,
    },
    fmta(
      [[
      \[
        <>
      \] <>
      ]],
      { i(1), i(0) }
    ),
    { condition = tex_utils.in_text, show_condition = tex_utils.in_text }
  ),
  autosnippet(
    { trig = "sr", name = "^2", dscr = "^2", wordTrig = false },
    t("^2"),
    tex_utils.context_math
  ),
  autosnippet(
    { trig = "cb", name = "^3", dscr = "^3", wordTrig = false },
    t("^3"),
    tex_utils.context_math
  ),
  autosnippet({
    trig = "compl",
    name = "complement",
    dscr = "complement",
    wordTrig = false,
  }, t("^{c}"), tex_utils.context_math),
  autosnippet({
    trig = "td",
    name = "superscript",
    dscr = "superscript",
    wordTrig = false,
  }, fmta([[^{<>}<>]], { i(1), i(0) }), tex_utils.context_math),
  autosnippet(
    { trig = "//", name = "fraction", dscr = "fraction" },
    fmta([[\frac{<>}{<>} <>]], { i(1), i(2), i(0) }),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "(%d+)/",
      name = "digit+ fraction",
      dscr = "digit+ fraction",
      regTrig = true,
      wordTrig = false,
      priority = 250,
    },
    fmta(
      [[\frac{<>}{<>} <>]],
      { f(capture, {}, { user_args = { 1 } }), i(1), i(0) }
    ),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "(%d*\\?[A-Za-z]+^%d)/",
      name = "digit + \\ + ^  fraction",
      dscr = "6\\pi^2 fraction",
      regTrig = true,
      wordTrig = false,
      priority = 500,
    },
    fmta(
      [[\frac{<>}{<>} <>]],
      { f(capture, {}, { user_args = { 1 } }), i(1), i(0) }
    ),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "(%d*\\?[A-Za-z]+^{%d+})/",
      name = "digit + \\ + ^  fraction",
      dscr = "6\\pi^{22} fraction",
      regTrig = true,
      wordTrig = false,
      priority = 500,
    },
    fmta(
      [[\frac{<>}{<>} <>]],
      { f(capture, {}, { user_args = { 1 } }), i(1), i(0) }
    ),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "(%d*\\?[A-Za-z]+_%d)/",
      name = "digit + \\ + _  fraction",
      dscr = "a_2 fraction",
      regTrig = true,
      wordTrig = false,
      priority = 500,
    },
    fmta(
      [[\frac{<>}{<>} <>]],
      { f(capture, {}, { user_args = { 1 } }), i(1), i(0) }
    ),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "(%d*\\?[A-Za-z]+_{%d+})/",
      name = "digit + \\ + _{}  fraction",
      dscr = "a_{22} fraction",
      regTrig = true,
      wordTrig = false,
      priority = 500,
    },
    fmta(
      [[\frac{<>}{<>} <>]],
      { f(capture, {}, { user_args = { 1 } }), i(1), i(0) }
    ),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "^(.*%))/",
      name = "() fraction",
      dscr = "() fraction",
      regTrig = true,
      wordTrig = false,
    },
    fmta(
      [[<>{<>} <>]],
      { f(capture_frac, {}, { user_args = { 1 } }), i(1), i(0) }
    ),
    tex_utils.context_math
  ),
  s(
    { trig = "/", dscr = "frac with visual str" },
    fmta([[\frac{<>}{<>} <>]], {
      f(get_visual_str),
      i(1),
      i(0),
    }),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "math",
      name = "wolfram math",
      dscr = "make input wolfram mathematica",
    },
    fmta([[math <> math<>]], { i(1, "Mathematica expression"), i(0) }),
    tex_utils.context_math
  ),
  s(
    {
      trig = "math (.*) math",
      name = "evaluate Mathematica",
      dscr = "Evaluate Mathematica Expression",
      regTrig = true,
      wordTrig = false,
    },
    fmta([[<>]], { f(captureWolfram, {}, { user_args = { 1 } }) }),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "(\\?%w+),%.",
      name = "Vector postfix ,.",
      dscr = "Vector postfix .,",
      regTrig = true,
      wordTrig = false,
    },
    fmta([[\vec{<>}]], { f(capture, {}, { user_args = { 1 } }) }),
    tex_utils.context_math
  ),
  autosnippet(
    {
      trig = "(\\?%w+)%.,",
      name = "Vector postfix .,",
      dscr = "Vector postfix .,",
      regTrig = true,
      wordTrig = false,
    },
    fmta([[\vec{<>}]], { f(capture, {}, { user_args = { 1 } }) }),
    tex_utils.context_math
  ),
  autosnippet(
    { trig = "!>", name = "mapsto", dscr = "\\mapsto", wordTrig = false },
    { t("\\mapsto ") },
    tex_utils.context_math
  ),
  autosnippet(
    { trig = "->", name = "to", dscr = "\\to", wordTrig = false },
    { t("\\to ") },
    tex_utils.context_math
  ),
  autosnippet(
    { trig = "sq", name = "sqrt", dscr = "sqrt", wordTrig = false },
    fmta([[\sqrt{<>}<>]], { i(1), i(0) }),
    tex_utils.context_math
  ),
  autosnippet(
    { trig = "fun", name = "function R to R", dscr = "f: \\R \to \\R:" },
    fmta([[f: <> \R \to \R: <>]], { i(1), i(0) }),
    tex_utils.context_math
  ),
  autosnippet(
    { trig = "lim", name = "limit", dscr = "\\lim_{n} \to {\\infty}" },
    fmta([[\lim_{<> \to <>} <>]], { i(1, "n"), i(2, "\\infty"), i(0) }),
    tex_utils.context_math
  ),
  autosnippet(
    { trig = "sum", name = "sum", dscr = "\\sum_{n=1}^{\\infty}" },
    fmta([[\sum_{<>}^{<>} <>]], { i(1, "n=1"), i(2, "\\infty"), i(0) }),
    tex_utils.context_math
  ),
  autosnippet(
    { trig = "ooo", name = "infty", dscr = "\\infty", wordTrig = false },
    { t("\\infty") },
    tex_utils.context_math
  ),
  autosnippet(
    { trig = "cc", name = "subset", dscr = "\\subset", wordTrig = false },
    { t("\\subset") },
    tex_utils.context_math
  ),
}

local math_symbs = {
  "arccos",
  "arccot",
  "arccsc",
  "arcsec",
  "arcsin",
  "arctan",
  "cos",
  "cot",
  "csc",
  "exp",
  "ln",
  "log",
  "perp",
  "sin",
  "star",
  "arctan",
  "int",
  "pi",
  "zeta",
}

for _, symb in ipairs(math_symbs) do
  local snip = autosnippet(
    {
      trig = "([^\\])" .. symb,
      name = symb,
      dscr = "\\" .. symb,
      regTrig = true,
      wordTrig = false,
    },
    { f(capture, {}, { user_args = { 1 } }), t("\\" .. symb) },
    tex_utils.context_math
  )

  table.insert(snips, snip)
end

return snips
