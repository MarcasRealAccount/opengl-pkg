local function GetLoaderPath()
	return string.format("%s/generated/%s-%s/", common:scriptDir(), _PKG_ARGS.profile, _PKG_ARGS.v)
end

local loaderPath = GetLoaderPath()

local function ShouldGenerate()
	local generatedHint = loaderPath .. ".generated"
	return not (os.isdir(loaderPath) and os.isfile(generatedHint))
end

local firstPrint = true
local function DownloadProgress(total, current)
	local ratio = current / total
	ratio = math.min(math.max(ratio, 0), 1)
	local percent = math.floor(ratio * 100)
	if firstPrint then
		io.write(string.format("Download progress (%d%%/100%%)               ", percent))
		firstPrint = false
	else
		io.write(string.format("\rDownload progress (%d%%/100%%)               ", percent))
	end
end

local function DownloadGLSpec()
	local dir = string.format("%s/generated/", common:scriptDir())
	if not os.isdir(dir) then
		common:mkdir(dir)
	end

	local filepath = dir .. "gl.xml"
	if os.isfile(filepath) then
		return
	end

	firstPrint = true
	print("Downloading GL Spec file")
	local response, code = http.download("https://raw.githubusercontent.com/KhronosGroup/OpenGL-Registry/main/xml/gl.xml", filepath, { progress = DownloadProgress })
	if code ~= 200 then
		print(string.format("\rFailed to download GL Spec file (%s, %d)               ", response, code))
	else
		print("\rDownload completed                                             ")
	end
end

local function GenerateGLLoader()
	os.executef("python3 \"%s/generator/generator.py\"", common:scriptDir())
end

if ShouldGenerate() then
	DownloadGLSpec()
	GenerateGLLoader()
end

return true