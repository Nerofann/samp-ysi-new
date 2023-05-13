#include <YSI_Coding/y_hooks>


stock CekConnection()
{
    new MySQLOpt: option_id = mysql_init_options();
    mysql_set_option(option_id, AUTO_RECONNECT, true);
    g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB, option_id);
    if(g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0){
        printf("[MySQL] Failed to connect");
        SendRconCommand("exit");
        return 0;
    }

    printf("[MySQL] Connection succesfully");
    return 1;
}

stock CreateFileINI(playerid)
{
	static filename[255];
	rand = random(100);
	format(filename, sizeof filename, PATH_USER_FILE, GetName(playerid));  
	UserFile = INI_Open(filename);
	INI_SetTag(UserFile, "data");
	INI_WriteString(UserFile, "username", GetName(playerid));
	INI_WriteString(UserFile, "password", pInfo[playerid][player_password]);
	INI_WriteString(UserFile, "ucp_name", pInfo[playerid][ucp_name]);
	INI_WriteInt(UserFile, "level", 1);
	INI_WriteInt(UserFile, "skin", rand);
	INI_WriteFloat(UserFile, "posX", 193.562);
	INI_WriteFloat(UserFile, "posY", -78.5008);
	INI_WriteFloat(UserFile, "posZ", 1.57812);
	INI_WriteFloat(UserFile, "facingAngle", 0);
	INI_WriteInt(UserFile, "money", pInfo[playerid][money]);

	INI_Close(UserFile);
	return 1;
}

stock SavePlayerData(playerid)
{
	// if(pInfo[playerid][logged_in]){
    new query[255];
    GetPlayerPos(playerid, Float:pInfo[playerid][pos_x], Float:pInfo[playerid][pos_y], Float:pInfo[playerid][pos_z]);
    GetPlayerFacingAngle(playerid, Float:pInfo[playerid][facingAngle]);

    mysql_format(g_SQL, query, sizeof(query), "UPDATE `karakter` SET `pos_x`=%f, `pos_y`=%f, `pos_z`=%f, `facingAngle`=%f `skin`=%i WHERE `nama`='%e'", 
        pInfo[playerid][pos_x], 
        pInfo[playerid][pos_y], 
        pInfo[playerid][pos_z], 
        pInfo[playerid][facingAngle], 
        pInfo[playerid][player_skin], 
        pInfo[playerid][player_name]
    );
    mysql_tquery(g_SQL, query);
	// }

    //save ke file.ini
    static filename[255];
    format(filename, sizeof filename, PATH_USER_FILE, GetName(playerid));
    UserFile = INI_Open(filename);
	INI_WriteFloat(UserFile, "facingAngle", pInfo[playerid][facingAngle]);
	INI_WriteFloat(UserFile, "posZ", pInfo[playerid][pos_z]);
	INI_WriteFloat(UserFile, "posY", pInfo[playerid][pos_y]);
	INI_WriteFloat(UserFile, "posX", pInfo[playerid][pos_x]);
	INI_WriteInt(UserFile, "money", pInfo[playerid][money]);
	INI_WriteInt(UserFile, "skin", rand);
    INI_WriteInt(UserFile, "level", 1);
    INI_WriteString(UserFile, "nama", GetName(playerid));
	INI_SetTag(UserFile, "data");
    INI_Close(UserFile);

	return 1;
}

stock GetName(playerid)
{
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof name);
	return name;
}

stock getVehicleName(modelid)
{
    new string[20];
    format(string, sizeof string, "%s", VehicleNames[modelid - 400]);
    return string;
}

stock get_user_path(playerid)
{
	static path[255];
	format(path, sizeof path, PATH_USER_FILE, GetName(playerid));
	return path;
} 

stock LoadObject(){
	static query[255];
	mysql_format(g_SQL, query, sizeof query, "SELECT * FROM server_object WHERE visible = 1");
    mysql_tquery(g_SQL, query, "LoadServerObject");
}

forward LoadServerObject(); 
public LoadServerObject()
{
    static rows;
    cache_get_row_count(rows);
    static obj_count;
    static query[1000];
    mysql_format(g_SQL, query, sizeof query, "INSERT INTO `server_object` (object_id, object_cid) VALUES");

    if(rows){
        for(new i=0; i < rows; i++){
            static Float:pX, Float:pY, Float:pZ, 
                    Float:rX, Float:rY, Float:rZ, 
                    Float:distance, models, id;

            cache_get_value_name_float(i, "PosX", Float:pX);
            cache_get_value_name_float(i, "PosY", Float:pY);
            cache_get_value_name_float(i, "PosZ", Float:pZ);
            cache_get_value_name_float(i, "RotX", Float:rX);
            cache_get_value_name_float(i, "RotY", Float:rY);
            cache_get_value_name_float(i, "RotZ", Float:rZ);
            cache_get_value_name_float(i, "draw_distance", Float:distance);
            cache_get_value_name_int(i, "object_model", models);
            cache_get_value_name_int(i, "object_id", id);

            new object_ids = CreateObject(models, pX, pY, pZ, rX, rY, rZ, distance);
            static query_plus[255];

            if(IsValidObject(object_ids)){
                obj_count++;
                if(i == (rows - 1)){
                    format(query_plus, sizeof query_plus, "(%i, %i)", id, object_ids);
                }else{
                    format(query_plus, sizeof query_plus, "(%i, %i),", id, object_ids);
                }
                strcat(query, query_plus, sizeof query);
            }
        }

        if(obj_count != 0){
            strcat(query, "ON DUPLICATE KEY UPDATE object_cid = VALUES(object_cid)");
            mysql_tquery(g_SQL, query);
        }
    }
    
    printf("Server object total = %i\nObject success loaded = %i", rows, obj_count);
    return 1;
}