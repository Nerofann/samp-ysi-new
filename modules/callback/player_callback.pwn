#include <YSI_Coding/y_hooks>

//Callback for player
forward AssignPlayerdata(playerid); 
public AssignPlayerdata(playerid)
{
	cache_get_value_int(0, "level", pInfo[playerid][player_level]);
	cache_get_value_int(0, "skin", pInfo[playerid][player_skin]);
	cache_get_value_float(0, "pos_x", pInfo[playerid][pos_x]);
	cache_get_value_float(0, "pos_y", pInfo[playerid][pos_y]);
	cache_get_value_float(0, "pos_z", pInfo[playerid][pos_z]);
	cache_get_value_float(0, "rotation", pInfo[playerid][rotation]);
	cache_get_value(0, "money", pInfo[playerid][money]);

	GivePlayerMoney(playerid, pInfo[playerid][money]);
	SetPlayerSkin(playerid, pInfo[playerid][player_skin]);
	SetSpawnInfo(playerid, 0, pInfo[playerid][player_skin], pInfo[player_id][pos_x], pInfo[player_id][pos_y], pInfo[player_id][pos_z], 0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}