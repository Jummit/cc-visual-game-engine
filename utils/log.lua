local log = {}

log.clear = function()
	local file = fs.open("out.log", "w")
	file.close()
end

log.write = function(str)
	local file = fs.open("out.log", "a")
	file.write(tostring(str).."\n")
	file.close()
end

return log