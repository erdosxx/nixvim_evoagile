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
return tex_utils
