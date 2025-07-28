-- final skid boss of vape v4 (i need to kms)
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/C4ainikT/AugustusB2.6forRoblox'..readfile('Augustus/commit.txt')..'/'..select(1, path:gsub('Augustus/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after augustus updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after augustus updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'Augustus', 'Augustus/games', 'Augustus/configs', 'Augustus/assets', 'Augustus/assets/sounds', 'Augustus/assets/pictures', 'Augustus/libraries'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.AugustusTesting then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/C4ainikT/AugustusB2.6forRoblox')
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('Augustus/commit.txt') and readfile('Augustus/commit.txt') or '') ~= commit then
		wipeFolder('Augustus')
		wipeFolder('Augustus/games')
		wipeFolder('Augustus/guis')
		wipeFolder('Augustus/libraries')
	end
	writefile('Augustus/commit.txt', commit)
end

print(1)

return loadstring(downloadFile('Augustus/main.lua'), 'main')()
