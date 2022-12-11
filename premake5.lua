PROJECT_GENERATOR_VERSION = 2

newoption({
	trigger = "gmcommon",
	description = "Sets the path to the garrysmod_common (https://github.com/danielga/garrysmod_common) directory",
	value = "path to garrysmod_common directory"
})

include(assert(_OPTIONS.gmcommon or os.getenv("GARRYSMOD_COMMON"),
	"you didn't provide a path to your garrysmod_common (https://github.com/danielga/garrysmod_common) directory"))

local LIBFFI_DIRECTORY = "libffi"
local LUAFFI_DIRECTORY = "cffi-lua"

CreateWorkspace({name = "ffi"})
	CreateProject({serverside = true})
		includedirs(LUAFFI_DIRECTORY .. "/src")
		links({"cffi-lua", "libffi"})
		IncludeLuaShared()

	CreateProject({serverside = false})
		includedirs(LUAFFI_DIRECTORY .. "/src")
		links({"cffi-lua", "libffi"})
		IncludeLuaShared()

	project("cffi-lua")
		kind("StaticLib")
		defines("FFI_LITTLE_ENDIAN")
		includedirs({_GARRYSMOD_COMMON_DIRECTORY .. "/include", LUAFFI_DIRECTORY .. "/src", "include"})
		files({
			LUAFFI_DIRECTORY .. "/src/ast.cc",
			LUAFFI_DIRECTORY .. "/src/ast.hh",
			LUAFFI_DIRECTORY .. "/src/ffi.cc",
			LUAFFI_DIRECTORY .. "/src/ffi.hh",
			LUAFFI_DIRECTORY .. "/src/ffilib.cc",
			LUAFFI_DIRECTORY .. "/src/lib.cc",
			LUAFFI_DIRECTORY .. "/src/lib.hh",
			LUAFFI_DIRECTORY .. "/src/libffi.hh",
			LUAFFI_DIRECTORY .. "/src/lua.cc",
			LUAFFI_DIRECTORY .. "/src/lua.hh",
			LUAFFI_DIRECTORY .. "/src/main.cc",
			LUAFFI_DIRECTORY .. "/src/parser.cc",
			LUAFFI_DIRECTORY .. "/src/parser.hh",
			LUAFFI_DIRECTORY .. "/src/platform.hh",
			LUAFFI_DIRECTORY .. "/src/util.cc",
			LUAFFI_DIRECTORY .. "/src/util.hh"
		})
		vpaths({
			["Header files/*"] = LUAFFI_DIRECTORY .. "/src/*.hh",
			["Source files"] = LUAFFI_DIRECTORY .. "/src/*.cc"
		})

		filter("system:windows")
			disablewarnings({"4291", "4324"})

	project("libffi")
		kind("StaticLib")
		warnings("Default")
		defines({"FFI_BUILDING", "FFI_LITTLE_ENDIAN"})
		includedirs({LIBFFI_DIRECTORY .. "/include", "include"})
		files({
			"include/ffi.h",
			"include/fficonfig.h",
			"include/ffitarget.h",
			LIBFFI_DIRECTORY .. "/include/ffi_cfi.h",
			LIBFFI_DIRECTORY .. "/include/ffi_common.h",
			LIBFFI_DIRECTORY .. "/src/closures.c",
			LIBFFI_DIRECTORY .. "/src/prep_cif.c",
			LIBFFI_DIRECTORY .. "/src/java_raw_api.c",
			LIBFFI_DIRECTORY .. "/src/raw_api.c",
			LIBFFI_DIRECTORY .. "/src/tramp.c",
			LIBFFI_DIRECTORY .. "/src/types.c",
			LIBFFI_DIRECTORY .. "/src/x86/asmnames.h",
			LIBFFI_DIRECTORY .. "/src/x86/ffi.c",
			LIBFFI_DIRECTORY .. "/src/x86/ffi64.c",
			LIBFFI_DIRECTORY .. "/src/x86/ffiw64.c",
			LIBFFI_DIRECTORY .. "/src/x86/internal.h",
			LIBFFI_DIRECTORY .. "/src/x86/internal64.h"
		})
		vpaths({
			["Header files/*"] = {LIBFFI_DIRECTORY .. "/include/*.h", LIBFFI_DIRECTORY .. "/src/x86/*.h", "include"},
			["Source files"] = {LIBFFI_DIRECTORY .. "/src/**.c", LIBFFI_DIRECTORY .. "/src/x86/*.S"}
		})

		filter({"system:windows", "platforms:x86"})
			files(LIBFFI_DIRECTORY .. "/src/x86/sysv_intel.S")

		filter({"system:windows", "platforms:x86_64"})
			files(LIBFFI_DIRECTORY .. "/src/x86/win64_intel.S")

		filter("system:not windows")
			removeflags("UndefinedIdentifiers")
			disablewarnings("deprecated-declarations")
			files({
				LIBFFI_DIRECTORY .. "/src/x86/sysv.S",
				LIBFFI_DIRECTORY .. "/src/x86/unix64.S",
				LIBFFI_DIRECTORY .. "/src/x86/win64.S"
			})

		filter({"system:windows", "platforms:x86", "files:**.S"})
			buildmessage("Compiling %{file.relpath}")
			buildcommands({
				"cl.exe /EP /I \"%{prj.location}/../../../libffi/include\" /I \"%{prj.location}/../../../include\" /DFFI_BUILDING \"%{file.relpath}\" > \"%{cfg.objdir}/%{file.basename}.asm\"",
				"ml.exe /c /Cx /coff /safeseh /Fo \"%{cfg.objdir}/%{file.basename}.obj\" \"%{cfg.objdir}/%{file.basename}.asm\""
			})
			buildoutputs("%{cfg.objdir}/%{file.basename}.obj")

		filter({"system:windows", "platforms:x86_64", "files:**.S"})
			buildmessage("Compiling %{file.relpath}")
			buildcommands({
				"cl.exe /EP /I \"%{prj.location}/../../../libffi/include\" /I \"%{prj.location}/../../../include\" /DFFI_BUILDING \"%{file.relpath}\" > \"%{cfg.objdir}/%{file.basename}.asm\"",
				"ml64.exe /c /Cx /Fo \"%{cfg.objdir}/%{file.basename}.obj\" \"%{cfg.objdir}/%{file.basename}.asm\""
			})
			buildoutputs("%{cfg.objdir}/%{file.basename}.obj")
