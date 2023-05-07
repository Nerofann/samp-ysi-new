#include <YSI_Coding/y_hooks>

CMD:mv(playerid, params[])
{
    new pid[MAX_PLAYERS];
    if(sscanf(params, "i", pid)) pid[playerid] = playerid;
    new query[255];
    mysql_format(g_SQL, query, sizeof query, "SELECT * FROM `vehicles` WHERE `veh_owner` = '%s' AND is_destroyed = 0 LIMIT %d", GetName(playerid), MAX_PLAYER_VEHICLE);
    mysql_tquery(g_SQL, query, "LoadVehicleData", "i", playerid);
    return 1;
}