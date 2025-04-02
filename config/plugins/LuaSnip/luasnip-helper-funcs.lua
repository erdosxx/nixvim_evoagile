local M = {}

local ls = require("luasnip")
local i = ls.insert_node
local sn = ls.snippet_node

function M.get_visual(_, parent)
	-- LS_SELECT_RAW also works
	if #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
	else
		return sn(nil, i(1))
	end
end

function M.get_visual_str(_, parent)
	-- LS_SELECT_RAW also works
	if #parent.snippet.env.SELECT_RAW > 0 then
		return parent.snippet.env.SELECT_RAW
	else
		return ""
	end
end

function M.isempty(s)
	return s == nil or s == ""
end

-- third argument is old_state, which we don't use
function M.get_visual_new(_, parent, _, user_args)
	local ret = (not M.isempty(user_args)) and user_args or ""

	if #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
	else -- If SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1, ret))
	end
end

return M
