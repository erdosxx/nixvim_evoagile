local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local snips = {
  s({ trig = ";A", snippetType = "autosnippet" }, { t("𝒜") }),
  s({ trig = ";B", snippetType = "autosnippet" }, { t("ℬ") }),
  s({ trig = ";C", snippetType = "autosnippet" }, { t("𝒞") }),
  s({ trig = ";F", snippetType = "autosnippet" }, { t("ℱ") }),
  s({ trig = ";G", snippetType = "autosnippet" }, { t("𝒢") }),
  s({ trig = ";J", snippetType = "autosnippet" }, { t("𝒥") }),
  s({ trig = ";L", snippetType = "autosnippet" }, { t("ℒ") }),
  s({ trig = ";M", snippetType = "autosnippet" }, { t("ℳ") }),
  s({ trig = ";P", snippetType = "autosnippet" }, { t("𝒫") }),
  s({ trig = ";S", snippetType = "autosnippet" }, { t("𝒮") }),
  s({ trig = ";[[", snippetType = "autosnippet" }, { t("⟦") }),
  s({ trig = ";]]", snippetType = "autosnippet" }, { t("⟧") }),
  s({ trig = ";((", snippetType = "autosnippet" }, { t("⦅") }),
  s({ trig = ";))", snippetType = "autosnippet" }, { t("⦆") }),
  s({ trig = ";00", snippetType = "autosnippet" }, { t("𝟎") }),
  s({ trig = ";11", snippetType = "autosnippet" }, { t("𝟙") }),
  s({ trig = ";bbP", snippetType = "autosnippet" }, { t("\\mathbb{P}") }),
  s({ trig = ";bbR", snippetType = "autosnippet" }, { t("\\mathbb{R}") }),
  s({ trig = ";bbN", snippetType = "autosnippet" }, { t("\\mathbb{N}") }),
  s({ trig = ";grs", snippetType = "autosnippet" }, { t("\\sigma") }),
  s({ trig = ";grS", snippetType = "autosnippet" }, { t("\\Sigma") }),
  s({ trig = ";caE", snippetType = "autosnippet" }, { t("\\mathcal{E}") }),
  s({ trig = ";djU", snippetType = "autosnippet" }, { t("⨃") }),
  s({ trig = ";dju", snippetType = "autosnippet" }, { t("⊍") }),
  s({ trig = ";dCu", snippetType = "autosnippet" }, { t("⋓") }),
  s({ trig = ";dCa", snippetType = "autosnippet" }, { t("⋒") }),
}

return snips
