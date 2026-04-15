local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local asp = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local fmta = require("luasnip.extras.fmt").fmta

local snips = {
  asp({ trig = ";((" }, { t("⦅") }),
  asp({ trig = ";))" }, { t("⦆") }),
  asp({ trig = ";00" }, { t("𝟎") }),
  asp({ trig = ";11" }, { t("𝟙") }),
  asp({ trig = ";A" }, { t("𝒜") }),
  asp({ trig = ";B" }, { t("ℬ") }),
  asp({ trig = ";C" }, { t("𝒞") }),
  asp({ trig = ";D" }, { t("𝒟") }),
  asp({ trig = ";F" }, { t("ℱ") }),
  asp({ trig = ";G" }, { t("𝒢") }),
  asp({ trig = ";J" }, { t("𝒥") }),
  asp({ trig = ";K" }, { t("𝒦") }),
  asp({ trig = ";L" }, { t("ℒ") }),
  asp({ trig = ";M" }, { t("ℳ") }),
  asp({ trig = ";N" }, { t("𝒩") }),
  asp({ trig = ";O" }, { t("𝒪") }),
  asp({ trig = ";P" }, { t("𝒫") }),
  asp({ trig = ";Q" }, { t("𝒬") }),
  asp({ trig = ";S" }, { t("𝒮") }),
  asp({ trig = ";T" }, { t("𝒯") }),
  asp({ trig = ";U" }, { t("𝒰") }),
  asp({ trig = ";V" }, { t("𝒱") }),
  asp({ trig = ";W" }, { t("𝒲") }),
  asp({ trig = ";X" }, { t("𝒳") }),
  asp({ trig = ";Y" }, { t("𝒴") }),
  asp({ trig = ";Z" }, { t("𝒵") }),
  asp({ trig = ";[[" }, { t("⟦") }),
  asp({ trig = ";]]" }, { t("⟧") }),
  asp(
    { trig = ";bar", name = "prefix bar", dscr = "prefix bar" },
    fmta([[\overline{<>} <>]], { i(1), i(0) })
  ),
  asp({ trig = ";bbE" }, { t("\\mathbb{E}") }),
  asp({ trig = ";bbN" }, { t("\\mathbb{N}") }),
  asp({ trig = ";bbP" }, { t("\\mathbb{P}") }),
  asp({ trig = ";bbQ" }, { t("\\mathbb{Q}") }),
  asp({ trig = ";bbR" }, { t("\\mathbb{R}") }),
  asp({ trig = ";caE" }, { t("\\mathcal{E}") }),
  asp({ trig = ";cs" }, { t("$\\cap$-stable") }),
  asp({ trig = ";dCa" }, { t("⋒") }),
  asp({ trig = ";dCu" }, { t("⋓") }),
  asp({ trig = ";dd" }, { t("\\,\\mathrm{d}") }),
  asp({ trig = ";djU" }, { t("⨃") }),
  asp({ trig = ";dju" }, { t("⊍") }),
  asp(
    { trig = ";dl", name = "(dx)", dscr = "(\\mathrm{d}<input>)" },
    fmta([[(\mathrm{d}<>) <>]], { i(1), i(0) })
  ),
  asp({ trig = ";grS" }, { t("\\Sigma") }),
  asp({ trig = ";grl" }, { t("\\lambda") }),
  asp({ trig = ";grs" }, { t("\\sigma") }),
  asp(
    { trig = ";hat", name = "prefix hat", dscr = "prefix hat" },
    fmta([[\hat{<>} <>]], { i(1), i(0) })
  ),
  asp({ trig = ";iy" }, { t("\\infty") }),
  asp(
    {
      trig = ";id",
      name = "independence",
      dscr = "\\mathrel{\\unicode{x2AEB}}",
    },
    { t("⫫") }
  ),
  asp(
    { trig = ";md", name = "math display mode" },
    fmta(
      [[
        $$
        <>
        $$
      ]],
      { i(1) }
    )
  ),
  asp({ trig = ";mm", name = "math mode" }, fmta([[$<>$]], { i(1) })),
  asp({ trig = ";ms" }, { t("(X,𝒜,\\mu)") }),
  asp({ trig = ";ps" }, { t("(\\Omega,𝒜,\\mathbb{P})") }),
  asp({ trig = ";sa" }, { t("$\\sigma$-algebra ") }),
  asp({ trig = ";sf" }, { t("$\\sigma$-finite ") }),
  asp({ trig = ";set", name = "set" }, fmta([[\{<>\} <>]], { i(1), i(0) })),
  asp(
    { trig = ";sum", name = "sum", dscr = "\\sum_{n=1}^{\\infty}" },
    fmta([[\sum_{<>}^{<>} <>]], { i(1, "n=1"), i(2, "\\infty"), i(0) })
  ),
  asp(
    { trig = ";vt", name = "lr vert", desc = "left and right vert" },
    fmta([[\lVert <>\rVert_{<>} <>]], { i(1), i(2, "p"), i(0) })
  ),
}

return snips
