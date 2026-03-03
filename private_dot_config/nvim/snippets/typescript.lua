local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	s({ trig = "cl (.*)", regTrig = true },
		fmta([[console.log(<>, <>)]], {
			i(1),
			f(function(_, snip) return snip.captures[1] end)
		})
	)
}
