#include <amxmodx>
#include <td>
#include <cstrike>
#include <colorchat>

/* 
	MAX_MONSTERS to maksymalna liczba potor�w zdolnych do edycji przez ten plugin \
	Zazwyczaj powinna to by� warto�� r�wna liczbie potwor�w maksymalnych na serwerze.
	Je�li dasz warto�� ni�sz� b�d� wy�sz�[hehe] mo�e doj�c do b��du ew. zatrzymania pluginu.
*/

#define PLUGIN "Tower Defense: Assists"
#define VERSION "1.0"
#define AUTHOR "GT Team"

#define MAX_MONSTERS 35

new g_szPrefix[] = "[TD: ASSISTS]"
new g_AttackerOfEnt[MAX_MONSTERS][33]
new g_MonsterEnt[MAX_MONSTERS]
new g_MonsterNum

new c_On
new c_Gold
new c_Money
new c_GoldSpecial
new c_MoneySpecial
new Float:c_DamagePercent

new g_PlayerDamage[33][MAX_MONSTERS]

public plugin_init() {
	
	register_dictionary("TowerDefense.txt")
	
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	bind_pcvar_num(create_cvar("td_assists_on", "1", _, _, true, 0.0, true, 1.0), c_On)
	
	bind_pcvar_num(create_cvar("td_assists_gold", "1", _, _, true, 0.0, false, 0.0), c_Gold) // Normal, fast, strenght
	bind_pcvar_num(create_cvar("td_assists_money", "75", _, _, true, 0.0, true, 16000.0), c_Money)
	
	bind_pcvar_num(create_cvar("td_assists_gold_special", "2", _, _, true, 0.0, false, 0.0), c_GoldSpecial) // Boss/bonus
	bind_pcvar_num(create_cvar("td_assists_money_special", "150", _, _, true, 0.0, true, 16000.0), c_MoneySpecial) // Boss/bonus

	bind_pcvar_float(create_cvar("td_assists_min_damage_percent", "0.4",_, _, true, 0.01, true, 0.99), c_DamagePercent)
}


public td_take_damage(iPlayer, iEnt, iWeapon, Float:fDamage)
{	
	if(!c_On)
		return
	
	/* Je�li potw�r zosta� ju� postrzelony przez gracza */
	if(was_shooted(iEnt, iPlayer)) {
		new iMonsterID = get_id_by_monster(iEnt)
		if(iMonsterID != -1) g_PlayerDamage[iPlayer][iMonsterID] += floatround(fDamage)
		return
	}
	
	new monsterid
	
	/* Je�li potw�r jest ju� w bazie, to po prostu dodaj obra�enia dla danego potwora danemu graczowi */
	
	if(was_monster(iEnt, monsterid)) {
		g_AttackerOfEnt[monsterid][iPlayer] = iEnt
		g_PlayerDamage[iPlayer][monsterid] += floatround(fDamage)
		return
	}
	/* Je�li jest to nowy potw�r */
	else {
		/* To dodaj go do bazy oraz daj obra�enia */
		if(g_MonsterNum == 0) {
			g_MonsterEnt[0] = iEnt
			g_AttackerOfEnt[0][iPlayer] = iEnt
			g_MonsterNum++
			
			g_PlayerDamage[iPlayer][0] += floatround(fDamage)
		} else {
			g_MonsterEnt[g_MonsterNum] = iEnt
			g_AttackerOfEnt[g_MonsterNum][iPlayer] = iEnt
			g_PlayerDamage[iPlayer][g_MonsterNum++] += floatround(fDamage)
		}
	}

}
public td_startwave(iWave, e_RoundType:iMonsterType, iNum) {
	/* Wyczy�� dane przy nowym wavie */
	for(new i; i < MAX_MONSTERS; i++) {
		g_MonsterEnt[i] = 0
		for(new a = 1; a <= get_maxplayers(); a++) {
			g_PlayerDamage[a][i] = 0
			g_AttackerOfEnt[i][a] = 0
		}
	}
	g_MonsterNum = 0
}
public td_monster_killed(iEnt, iPlayer, e_RoundType:iMonsterType)
{
	if(!c_On)
		return
		
	new numofplayers
	new monsterid = get_id_by_monster(iEnt)

        if(monsterid == -1)
                return
                
	for(new a = 1; a <= get_maxplayers(); a++) {
		if(iPlayer == a)
			continue;
		
		if(!is_user_alive(a) || !is_user_connected(a))
			continue;

		/* Je�li dany gracz "a" nie zaatakowa� w og�le tego potwora [iEnt] */
		if(g_AttackerOfEnt[monsterid][a] != iEnt)
			continue
		
		/* Je�li zadane obra�enia gracza s� mniejsze od procentowej ustawionej liczby to przerwij */
		if(g_PlayerDamage[a][monsterid] < (floatround(c_DamagePercent*td_get_monster_maxhealth(iMonsterType)))) {
			continue
		}
		numofplayers++
		g_AttackerOfEnt[monsterid][a] = 0
		g_PlayerDamage[a][monsterid] = 0
		
		/* Tutaj dajemy to co gracz ma dostac, za asyste przy zabiciu przeciwnika */
		
		new gold = ((iMonsterType==ROUND_BONUS||iMonsterType==ROUND_BOSS)?c_GoldSpecial:c_Gold)
		new money = ((iMonsterType==ROUND_BONUS||iMonsterType==ROUND_BOSS)?c_MoneySpecial:c_Money)
		
		td_set_user_info(a, PLAYER_GOLD, td_get_user_info(a, PLAYER_GOLD) + gold)
		cs_set_user_money(a, (cs_get_user_money(a)+money)>16000?16000:(cs_get_user_money(a)+ money), 1)
		
		ColorChat(a, GREEN, "%s^x01 %L", g_szPrefix, a, "ASSIST_GOT_REWARD", gold, money)
	
	}
	
	if(numofplayers) {
		g_MonsterEnt[monsterid] = 0
		g_MonsterNum--
	}
}

public td_get_monster_maxhealth(e_RoundType:MonsterType) {
	if(MonsterType == ROUND_BONUS || MonsterType == ROUND_BOSS) 
		return td_get_wave_info(td_get_wave(), WAVE_SPECIAL_HEALTH)
	else
		return td_get_wave_info(td_get_wave(), WAVE_MONSTER_HEALTH)
}

public was_shooted(ent, id) {
	for(new i; i < MAX_MONSTERS ; i++)
		if(g_AttackerOfEnt[i][id] == ent)
			return 1;
	return 0
}

public was_monster(ent, monsterid) {
	for(new i; i < MAX_MONSTERS; i++)
		if(g_MonsterEnt[i] == ent) {
			monsterid = i
			return 1
		}
	return 0;
}
public get_id_by_monster(ent) {
	for(new i; i < MAX_MONSTERS; i++)
		if(g_MonsterEnt[i] == ent)
			return i;
	return -1
}
