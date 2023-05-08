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
	if(pInfo[playerid][logged_in]){
		new query[255];
		GetPlayerPos(playerid, Float:pInfo[playerid][pos_x], Float:pInfo[playerid][pos_y], Float:pInfo[playerid][pos_z]);
		mysql_format(g_SQL, query, sizeof(query), "UPDATE `karakter` SET `pos_x`=%f, `pos_y`=%f, `pos_z`=%f, `skin`=%i WHERE `nama`='%e'", 
			pInfo[playerid][pos_x], 
			pInfo[playerid][pos_y], 
			pInfo[playerid][pos_z], 
			pInfo[playerid][player_skin], 
			pInfo[playerid][player_name]
		);
		mysql_tquery(g_SQL, query);
	}

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