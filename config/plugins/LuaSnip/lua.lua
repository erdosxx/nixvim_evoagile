-- https://github.com/evesdropper/dotfiles/blob/main/nvim/luasnip/lua.lua
-- Lua Snippets, 90% of which are for neovim/luasnip config.
--

local ls = require("luasnip")
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local sn = ls.snippet_node
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

local autosnippet =
	ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

return {
	s(
		{ trig = "snipf", name = "fmt snippet", dscr = "snippet fmt" },
		fmta(
			[[
      <>({ trig='<>', name='<>', dscr='<>'},
      fmt(<>,
      { <> },
      { delimiters='<>' }
      ), <>)<>,
      ]],
			{
				c(1, { t("s"), t("autosnippet") }),
				i(2, "trig"),
				i(3, "trig"),
				i(4, "dscr"),
				i(5, "fmt"),
				i(6, "inputs"),
				i(7, "<>"),
				i(8, "opts"),
				i(0),
			}
		)
	),
	s(
		{ trig = "snipa", name = "fmta snippet", dscr = "snippet fmta" },
		fmta(
			[[
      <>({ trig='<>', name='<>', dscr='<>'},
      fmta(<>,
      { <> }
      )<>)<>,
      ]],
			{
				c(1, { t("s"), t("autosnippet") }),
				i(2, "trig"),
				i(3, "name"),
				i(4, "dscr"),
				i(5, "fmt"),
				i(6, "inputs"),
				c(7, {
					t(""),
					t(", tex_utils.context_math"),
					fmta(
						[[, { condition=<>, show_condition=<> }]],
						{ i(1, "tex_utils.in_mathzone"), rep(1) }
					),
				}),
				--[[ i(7, "opts"), ]]
				i(0),
			}
		)
	),
	s(
		{ trig = "snipt", name = "snippet text", dscr = "simple text snippet" },
		fmta(
			[[
      <>(<>, {t('<>')}<>
      <>)<>,
      ]],
			{
				c(1, { t("s"), t("autosnippet") }),
				c(2, {
					i(nil, "trig"),
					sn(nil, { t("{trig='"), i(1), t("'}") }),
				}),
				i(3, "text"),
				i(4, "opts"),
				i(5),
				i(0),
			}
		)
	),
	autosnippet(
		{ trig = "sch", name = "choice node", dscr = "add choice node" },
		fmta(
			[[
      c(<>, {<>})
      ]],
			{ i(1), i(0) }
		)
	),
	autosnippet(
		{ trig = "snode", name = "snippet node", dscr = "snippet node" },
		fmta(
			[[
      sn(<>, {<>})
      ]],
			{ i(1, "nil"), i(0) }
		)
	),
	autosnippet(
		{
			trig = "scond",
			name = "snippet conditions",
			dscr = "add snippet conditions",
		},
		fmta(
			[[{ condition=<>, show_condition=<> }]],
			{ i(1, "tex_utils.in_mathzone"), rep(1) }
		)
	),
	autosnippet(
		{
			trig = "sprio",
			name = "snip priority",
			dscr = "Autosnippet to set snippet priority",
		},
		fmta(
			[[
      priority=<>
      ]],
			{ i(1, "1000") }
		)
	),
	autosnippet("sreg", { t("regTrig=true, hidden=true") }),
	autosnippet("shide", { t("hidden=true") }),
	s(
		{ trig = "nkey", name = "nvim keybinds", dscr = "add a nvim keybinds" },
		fmta(
			[[keymap("<>", "<>", "<>", "<>")]],
			{ i(1, "n"), i(2, "keybind"), i(3, "command"), i(4, "options") }
		)
	),
	s(
		{
			trig = "funcl",
			name = "lua function",
			dscr = "creates a function in lua",
		},
		fmta(
			[[
      function <>(<>)
        <>
      end
      ]],
			{ i(1, "name"), i(2, "args"), i(0) }
		)
	),
	s(
		{
			trig = "bude",
			name = "busted describe",
			dscr = "busted describe format",
		},
		fmta(
			[[
      describe("<>", function()
        it("Test <>", function()
          <>
        end)
        <>
      end)
      ]],
			{ i(1, "Test sets"), i(2, "name"), i(3, "test body"), i(0) }
		)
	),
	s(
		{ trig = "buit", name = "busted it", dscr = "busted it env" },
		fmta(
			[[
      it("Test <>", function()
        <>
      end)
      ]],
			{ i(1, "name"), i(2) }
		)
	),
	s(
		{ trig = "asa", name = "assert same", dscr = "assert.are.same" },
		fmta(
			[[
      assert.are.same(<>, <>)
      ]],
			{ i(1, "expected"), i(2, "test value") }
		)
	),
}
