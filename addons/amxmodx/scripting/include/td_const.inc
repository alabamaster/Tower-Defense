#if defined _towerdefense_const_included
  #endinput
#endif
#define _towerdefense_const_included

enum
{
	ROUND_NONE = 0,
	ROUND_NORMAL,
	ROUND_FAST,
	ROUND_STRENGTH,
	ROUND_BOSS,
	ROUND_BONUS	
}

enum ENUM_WAVE_INFO 
{
	WAVE_ROUND_TYPE,
	WAVE_MONSTER_NUM,
	WAVE_MONSTER_HEALTH,
	WAVE_MONSTER_SPEED,
	WAVE_SPECIAL_HEALTH,
	WAVE_SPECIAL_SPEED
}

enum ENUM_PLAYER 
{
	PLAYER_GOLD,
	PLAYER_FRAGS,
	PLAYER_LEVEL,
	PLAYER_EXTRA_DAMAGE,
	PLAYER_EXTRA_SPEED,
	PLAYER_EXTRA_GOLD,
	PLAYER_EXTRA_MONEY,
	PLAYER_NAPALM_NADE,
	PLAYER_FROZEN_NADE,
	PLAYER_CRITICAl_PERCENT
}

enum
{
	PLAYERS_PLAYING,
	PLAYERS_WIN,
	PLAYERS_LOSE
}

enum _:TOTEMS
{
	TOTEM_NONE,
	TOTEM_RANGE,
	TOTEM_DAMAGE,
	TOTEM_FIRERATE,
	TOTEM_ALL,
}

enum _:ENUM_TURRETS_TYPE
{
	TURRET_NONE,
	TURRET_BULLET,
	TURRET_LASER,
	TURRET_LIGHTING,
	TURRET_MULTI_LASER,
	TURRET_ROCKET,
	TURRET_GATLING
}

enum 
{ 
	TURRET_SHOW_NONE, 
	TURRET_SHOW_GLOW, 
	TURRET_SHOW_TRANSPARENT 
}