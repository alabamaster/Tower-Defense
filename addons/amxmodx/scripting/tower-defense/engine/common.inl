#if defined td_engine_common_includes
  #endinput
#endif
#define td_engine_common_includes

#define foreach(%1,%2) for( new iCurrentElement = 0 , %2 = %1[ 0 ];  iCurrentElement < sizeof %1 ; iCurrentElement++ , %2 = iCurrentElement < sizeof %1 ? %1[ iCurrentElement ] : 0  )
#define foreach_i(%1,%2,%3) for( new iCurrentElement = 0 , %2 = %1[ 0 ];  iCurrentElement < sizeof %1 ;  %3 = ++iCurrentElement , %2 = iCurrentElement < sizeof %1 ? %1[ iCurrentElement ] : 0 )

new g_MapEntityData[MAP_ENTITIES_ENUM];

new bool:g_IsGamePossible = true;

public getConfigDirectory()
{
    new const configDirectory[] = CONFIG_DIRECTORY;
    return configDirectory;
}

public setGameStatus(const bool:status) 
{
    g_IsGamePossible = status;
}

public bool:getGameStatus()
{
    return g_IsGamePossible;
}

public setMapEntityData(MAP_ENTITIES_ENUM:item, any:value)
{
    g_MapEntityData[item] = value;
}

stock any:getMapEntityData(MAP_ENTITIES_ENUM:item, Float:vector[] = {}, len = 0)
{
    if(len > 0)
    {
        xs_vec_copy(any:g_MapEntityData[item], vector);
    }

    return g_MapEntityData[item];
}