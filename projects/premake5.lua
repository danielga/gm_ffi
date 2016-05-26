newoption({
	trigger = "gmcommon",
	description = "Sets the path to the garrysmod_common (https://github.com/danielga/garrysmod_common) directory",
	value = "path to garrysmod_common directory"
})

local gmcommon = _OPTIONS.gmcommon or os.getenv("GARRYSMOD_COMMON")
if gmcommon == nil then
	error("you didn't provide a path to your garrysmod_common (https://github.com/danielga/garrysmod_common) directory")
end

include(gmcommon)

local LUAFFI_DIRECTORY = "../luaffifb"

CreateWorkspace({name = "ffi"})
	warnings("Default")

	filter("system:windows")
		defines("LUA_DLL_NAME=lua_shared.dll")

	CreateProject({serverside = true})
		includedirs(LUAFFI_DIRECTORY)
		links("luaffi")
		IncludeLuaShared()

	CreateProject({serverside = false})
		includedirs(LUAFFI_DIRECTORY)
		links("luaffi")
		IncludeLuaShared()

	project("luaffi")
		kind("StaticLib")
		includedirs(LUAFFI_DIRECTORY)
		files({
			LUAFFI_DIRECTORY .. "/dynasm/dasm_proto.h",
			LUAFFI_DIRECTORY .. "/dynasm/dasm_x86.h",
			LUAFFI_DIRECTORY .. "/call_x64.h",
			LUAFFI_DIRECTORY .. "/call_x64win.h",
			LUAFFI_DIRECTORY .. "/call_x86.h",
			LUAFFI_DIRECTORY .. "/ffi.h",
			LUAFFI_DIRECTORY .. "/call.c",
			LUAFFI_DIRECTORY .. "/ctype.c",
			LUAFFI_DIRECTORY .. "/ffi.c",
			LUAFFI_DIRECTORY .. "/parser.c"
		})
		vpaths({
			["Header files/*"] = LUAFFI_DIRECTORY .. "/**.h",
			["Source files"] = LUAFFI_DIRECTORY .. "/*.c"
		})
		IncludeLuaShared()
