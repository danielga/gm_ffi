newoption({
	trigger = "gmcommon",
	description = "Sets the path to the garrysmod_common (https://bitbucket.org/danielga/garrysmod_common) directory",
	value = "path to garrysmod_common dir"
})

local gmcommon = _OPTIONS.gmcommon or os.getenv("GARRYSMOD_COMMON")
if gmcommon == nil then
	error("you didn't provide a path to your garrysmod_common (https://bitbucket.org/danielga/garrysmod_common) directory")
end

include(gmcommon)

CreateSolution("ffi")
	warnings("Default")

	SetFilter(FILTER_WINDOWS)
		defines({"LUA_DLL_NAME=lua_shared.dll"})

	CreateProject(SERVERSIDE)
		IncludeLuaShared()

	CreateProject(CLIENTSIDE)
		IncludeLuaShared()
