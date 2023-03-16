local function GetLoaderPath()
	return string.format("%s/generated/%s-%s/", common:scriptDir(), _PKG_ARGS.profile, _PKG_ARGS.v)
end

local loaderPath = GetLoaderPath()

externalincludedirs({ loaderPath .. "/Inc/" })

filter("system:windows")
	links({ "opengl32.lib" })

filter("system:macosx")
	frameworks({ "OpenGL.framework" })

filter({})