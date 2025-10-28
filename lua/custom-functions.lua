function file_exists(name)
	if name == nil then
		return false
	end
	local f = io.open(name, "r")
	if f then
		io.close(f)
		return true
	else
		return false
	end
end

-- Inspired from github.com/IlyasYOY/dotfiles
local function matchInDir(file, pattern, plain)
	if plain == nil then
		plain = false
	end
	if pattern == nil then
		return false
	end

	local index = string.find(file, pattern, 1, plain)

	return index == 1
end

-- Inspired from github.com/IlyasYOY/dotfiles
local function findInDir(dir, pattern, plain)
	local targets = vim.fn.readdir(dir, function(file)
		if matchInDir(file, pattern, plain) then
			return 1
		end
	end)
	local target = targets[1]
	if not target then
		error(string.format("No %s target file was found", pattern))
	end
	return dir .. target
end
