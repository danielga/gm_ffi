# gm_ffi

A module for Garry's Mod that adds an [FFI library][1] similar to [LuaJIT's FFI][2].

## Info

Mac was not tested at all (sorry but I'm poor).

If stuff starts erroring or fails to work, be sure to check the correct line endings (\n and such) are present in the files for each OS.

This project requires [garrysmod_common][3], a framework to facilitate the creation of compilations files (Visual Studio, make, XCode, etc). Simply set the environment variable 'GARRYSMOD_COMMON' or the premake option 'gmcommon' to the path of your local copy of [garrysmod_common][3].


  [1]: https://github.com/jmckaskill/luaffi
  [2]: http://luajit.org/ext_ffi.html
  [3]: https://bitbucket.org/danielga/garrysmod_common
