#include <GarrysMod/Lua/Interface.h>

extern "C" int luaopen_cffi( lua_State *L );

GMOD_MODULE_OPEN( )
{
	if( luaopen_cffi( LUA->GetState( ) ) != 0 )
	{
		LUA->Push( -1 );
		LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "ffi" );
	}

	return 1;
}

GMOD_MODULE_CLOSE( )
{
	LUA->PushNil( );
	LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "ffi" );
	return 0;
}
