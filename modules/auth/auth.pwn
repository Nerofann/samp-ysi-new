#include <YSI_Coding/y_hooks>

stock Cek_akun(playerid)
{
	pInfo[playerid][logged_in]	= false;
	progressLogin[player_id]=0;
    GetPlayerName(playerid, pInfo[playerid][player_name], MAX_PLAYER_NAME);
	static query[120];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `view_login_in_game` where nama = '%e' LIMIT 1", pInfo[playerid][player_name]);
	mysql_tquery(g_SQL, query, "onPlayerDataCheck", "i", playerid);
	return 1;
}