#include <YSI_Coding/y_hooks>

stock LoadServerVehicle()
{
    mysql_tquery(g_SQL, "SELECT * FROM `server_vehicles`", "MuatKendaraanServer");
    return 1;
}

stock GetServerVehiclePath(database_id)
{
    new filename[255];
    format(filename, sizeof filename, PATH_SERVER_VEHICLE, database_id);

    return filename;
}

stock CreateServerVehicle_INI(id)
{
    ServerVehicle = INI_Open(GetServerVehiclePath(id));
    INI_WriteInt(ServerVehicle, "is_detroyed", 0);
    INI_WriteInt(ServerVehicle, "is_spawned", 1);
    INI_WriteFloat(ServerVehicle, "vehA", VSinfo[id][vehA]);
    INI_WriteFloat(ServerVehicle, "vehZ", VSinfo[id][vehZ]);
    INI_WriteFloat(ServerVehicle, "vehY", VSinfo[id][vehY]);
    INI_WriteFloat(ServerVehicle, "vehX", VSinfo[id][vehX]);
    INI_WriteString(ServerVehicle, "veh_label", VSinfo[id][veh_label]);
    INI_WriteInt(ServerVehicle, "veh_color2", VSinfo[id][veh_color2]);
    INI_WriteInt(ServerVehicle, "veh_color1", VSinfo[id][veh_color1]);
    INI_WriteInt(ServerVehicle, "veh_lock", VSinfo[id][veh_lock]);
    INI_WriteInt(ServerVehicle, "veh_price", VSinfo[id][veh_price]);
    INI_WriteString(ServerVehicle, "veh_plate", VSinfo[id][veh_plate]);
    INI_WriteFloat(ServerVehicle, "veh_health", VSinfo[id][veh_health]);
    INI_WriteString(ServerVehicle, "veh_owner", VSinfo[id][veh_owner]);
    INI_WriteString(ServerVehicle, "veh_name", VSinfo[id][veh_name]);
    INI_WriteInt(ServerVehicle, "veh_model", VSinfo[id][veh_model]);
    INI_WriteInt(ServerVehicle, "veh_databaseid", VSinfo[id][veh_databaseid]);
    INI_WriteInt(ServerVehicle, "veh_id", VSinfo[id][veh_id]);
    INI_Close(ServerVehicle);

    return 1;
}

forward LoadVehicle_data(id, name[], vaule[]);
public LoadVehicle_data(id, name[], vaule[])
{

}

forward MuatKendaraanServer();
public MuatKendaraanServer()
{
    static rows, success_loaded = 0;
    cache_get_row_count(rows);
    if(rows){
        for(new i=0; i < rows; i++){
            new id;
            cache_get_value_name_int(i, "veh_id", id);
            cache_get_value_name_int(i, "veh_model", VSinfo[id][veh_model]);
            cache_get_value_name(i, "veh_name", VSinfo[id][veh_name], 25);
            cache_get_value_name_float(i, "veh_health", VSinfo[id][veh_health]);
            cache_get_value_name(i, "veh_plate", VSinfo[id][veh_plate], 25);
            cache_get_value_name_int(i, "veh_lock", VSinfo[id][veh_lock]);
            cache_get_value_name_int(i, "veh_color1", VSinfo[id][veh_color1]);
            cache_get_value_name_int(i, "veh_color2", VSinfo[id][veh_color2]);
            cache_get_value_name(i, "veh_label", VSinfo[id][veh_label]);
            cache_get_value_name_float(i, "vehX", VSinfo[id][vehX]);
            cache_get_value_name_float(i, "vehY", VSinfo[id][vehY]);
            cache_get_value_name_float(i, "vehZ", VSinfo[id][vehZ]);
            cache_get_value_name_float(i, "vehA", VSinfo[id][vehA]);
            cache_get_value_name_int(i, "is_spawned", VSinfo[id][is_spawned]);
            cache_get_value_name_int(i, "is_destroyed", VSinfo[id][is_destroyed]);

            Iter_Add(VS, id);

            VSinfo[id][veh_databaseid] = id;
            VSinfo[id][veh_id] = CreateVehicle(VSinfo[id][veh_model], VSinfo[id][vehX], VSinfo[id][vehY], VSinfo[id][vehZ], 0, -1, -1, -1);

            if(!fexist(GetServerVehiclePath(id))){
                CreateServerVehicle_INI(id);
            }

            if(IsValidVehicle(VSinfo[id][veh_id])){
                success_loaded++;
            }
        }

    }

    printf("ServerVehicle: %i", rows);
    printf("ServerVehicle Berhasil dimuat: %i", success_loaded);
    return 1;
}