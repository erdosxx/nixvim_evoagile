local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local snips = {
  s({ trig = ";A", snippetType = "autosnippet" }, { t("𝒜") }),
  s({ trig = ";B", snippetType = "autosnippet" }, { t("ℬ") }),
  s({ trig = ";G", snippetType = "autosnippet" }, { t("𝒢") }),
  s({ trig = ";J", snippetType = "autosnippet" }, { t("𝒥") }),
  s({ trig = ";P", snippetType = "autosnippet" }, { t("𝒫") }),
  s({ trig = ";S", snippetType = "autosnippet" }, { t("𝒮") }),
  s({ trig = ";[[", snippetType = "autosnippet" }, { t("⟦") }),
  s({ trig = ";]]", snippetType = "autosnippet" }, { t("⟧") }),
  s({ trig = ";((", snippetType = "autosnippet" }, { t("⦅") }),
  s({ trig = ";))", snippetType = "autosnippet" }, { t("⦆") }),
}

return snips
