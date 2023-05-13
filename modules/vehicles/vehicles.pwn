#include <YSI_Coding/y_hooks>

CMD:mv(playerid, params[])
{
    print("/mv terpanggil");
    new pid[MAX_PLAYERS];
    if(sscanf(params, "i", pid)) pid[playerid] = playerid;
    new query[255];
    mysql_format(g_SQL, query, sizeof query, "SELECT * FROM `vehicles` WHERE `veh_owner` = '%s' AND is_destroyed = 0 LIMIT %d", GetName(playerid), MAX_PLAYER_VEHICLE);
    mysql_tquery(g_SQL, query, "LoadVehicleData", "i", playerid);
    return 1;
}


CMD:veh(playerid, params[]){
    static ids;
    if(sscanf(params, "i", ids)) return SendClientMessage(playerid, COLOR_WHITE, "/veh [model id]");
	if(ids < 400) return SendClientMessage(playerid, COLOR_WHITE, "/veh [model id 400..611]");
    // if(!IsValidVehicle(ids)) return SendClientMessage(playerid, COLOR_WHITE, "/veh [model id > 400]"); 

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, Float:x, Float:y, Float:z);
    x += (5 * floatsin(Float:x, degrees));
    y += (5 * floatcos(Float:y, degrees));
    
	new vehicleid;
    vehicleid = CreateVehicle(ids, Float:x, Float:y, Float:z, 0, -1, -1, -1);
    if(!IsValidVehicle(vehicleid)){
		SendClientMessage(playerid, COLOR_RED, "Failed to create vehicle");
	}
	// new lengthh  = sizeof(player_vehicle);
    // for(new i=0; i < lengthh; i++){
    //     if(!IsValidVehicle(pVeh[playerid][i])){
    //         pVeh[playerid][i]   = vehicles;
    //     }
    // }

    return 1;
}


forward LoadVehicleData(playerid);
public LoadVehicleData(playerid)
{
    new rows;
    new info[255] = "Vehicle Name\tJarak\tStatus\n";
    new status[25] = "{"COLOR_GREENS"}spawned"; 
    cache_get_row_count(rows);
    if(rows != 0){
        // new name[50], plate[10], label[50], owner[30];
        // new Float:price, Float:v_x, Float:v_y, Float:v_z, Float:v_a;
        // new bool:lock, bool:destroy;
        // new model, color1, color2;

        for(new i=0; i < rows; i++){
            static id;
            cache_get_value_name(i, "veh_name", vInfo[playerid][id][veh_name], 50);
            cache_get_value_name(i, "veh_plate", vInfo[playerid][id][veh_plate], 10);
            cache_get_value_name(i, "veh_owner", vInfo[playerid][id][veh_owner], MAX_PLAYER_NAME);

            cache_get_value_name_float(i, "veh_price", Float:vInfo[playerid][id][veh_price]);
            cache_get_value_name_float(i, "vehX", Float:vInfo[playerid][id][vehX]);
            cache_get_value_name_float(i, "vehY", Float:vInfo[playerid][id][vehY]);
            cache_get_value_name_float(i, "vehZ", Float:vInfo[playerid][id][vehZ]);
            cache_get_value_name_float(i, "vehA", Float:vInfo[playerid][id][vehA]);

            cache_get_value_name_int(i, "veh_model", vInfo[playerid][id][veh_model]);
            // cache_get_value_name_int(i, "veh_id", vInfo[playerid][i][vehSessionID]);

            cache_get_value_name_bool(i, "is_destroyed", vInfo[playerid][id][is_destroyed]);
            cache_get_value_name_bool(i, "is_spawned", vInfo[playerid][id][is_spawned]);

            if(!vInfo[playerid][id][is_spawned]) status = "{"COLOR_ORANGES"}despawned";

            // vInfo[playerid][i][vehModel]
            strcat(info, sprintf("{"COLOR_WHITES"}%s\t-\t%s\n", getVehicleName(vInfo[playerid][id][veh_model]), status), sizeof info);
        }
    }

    ShowPlayerDialog(playerid, DIALOG_LIST_VEH, DIALOG_STYLE_TABLIST_HEADERS, "My Vehicle", info, "Detail", "Close");
    return 1;
}
