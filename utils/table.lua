local tableUtils = {}

function tableUtils.clear(t)
	for k, _ in pairs(t) do
		t[k] = nil
	end
end

function tableUtils.copy(t)
	local n = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			n[k] = tableUtils.copy(v)
		else
			n[k] = v
		end
	end
	return n
end

function tableUtils.fromFiles(folder)
	local t = {}
	for _, f in ipairs(fs.list(folder)) do
		local file = fs.combine(folder, f)
		if fs.isDir(file) then
			t[f] = tableUtils.fromFiles(file)
		else
			local requirePath = file:gsub("/", "."):match("(.*)[%.].*$")
			local fileName = requirePath:match("[^%.]*$")
			t[fileName] = require(requirePath)
		end
	end
	return t
end

return tableUtils
