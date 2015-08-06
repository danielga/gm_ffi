#include <GarrysMod/Lua/Interface.h>

extern "C" int luaopen_ffi( lua_State *L );

GMOD_MODULE_OPEN( )
{
	if( luaopen_ffi( state ) != 0 )
	{
		LUA->PushSpecial( GarrysMod::Lua::SPECIAL_GLOB );

		LUA->Push( -2 );
		LUA->SetField( -2, "ffi" );
	}

	return 0;
}

GMOD_MODULE_CLOSE( )
{
	LUA->PushSpecial( GarrysMod::Lua::SPECIAL_GLOB );

	LUA->PushNil( );
	LUA->SetField( -2, "ffi" );

	return 0;
}
