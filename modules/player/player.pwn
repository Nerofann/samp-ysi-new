#include <YSI_Coding/y_hooks>

CMD:stats(playerid, params[]){
    new info[255];
    strcat(info, sprintf("{%s}Nama = {%s}%s", COLOR_WHITES, COLOR_GREENS, pInfo[playerid][player_name]), sizeof info);
    strcat(info, sprintf("\n{%s}Level = {%s}%d", COLOR_WHITES, COLOR_GREENS, pInfo[playerid][player_level]), sizeof info);
    ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, "Informasi", info, "Close", "");
    return 1;
}

CMD:setskin(playerid, params[]){
    new skinid;
    if(sscanf(params, "i", skinid)){
        SendClientMessage(playerid, COLOR_WHITE, "Skin ID should between 0-311");
    }else{
        pInfo[playerid][player_skin] = skinid;
        SetPlayerSkin(playerid, skinid);
    }

    return 1;
}

CMD:pos(playerid, params[]){
	new Float:x,Float:y, Float:z;
	GetPlayerPos(playerid, Float:x, Float:y, Float:z);

	printf("%f, %f, %f", x, y, z);

	return 1;
}

// Callback for player
forward AssignPlayerdata(playerid); 
public AssignPlayerdata(playerid)
{
	cache_get_value_int(0, "level", pInfo[playerid][player_level]);
	cache_get_value_int(0, "skin", pInfo[playerid][player_skin]);
	cache_get_value_float(0, "pos_x", pInfo[playerid][pos_x]);
	cache_get_value_float(0, "pos_y", pInfo[playerid][pos_y]);
	cache_get_value_float(0, "pos_z", pInfo[playerid][pos_z]);
	cache_get_value_float(0, "facingAngle", pInfo[playerid][facingAngle]);
	cache_get_value_int(0, "money", pInfo[playerid][money]);

	GivePlayerMoney(playerid, pInfo[playerid][money]);
	SetPlayerSkin(playerid, pInfo[playerid][player_skin]);
	SetSpawnInfo(playerid, 0, pInfo[playerid][player_skin], pInfo[player_id][pos_x], pInfo[player_id][pos_y], pInfo[player_id][pos_z], 0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}

forward onPlayerDataCheck(playerid);
public onPlayerDataCheck(playerid)
{
    new rows;
	cache_get_row_count(rows);
	if(rows > 0){
		//Jika nama player sudah terdaftar
		cache_get_value(0, "nama", pInfo[playerid][player_name], MAX_PLAYER_NAME);
		cache_get_value_int(0, "level", pInfo[playerid][player_level]);
		cache_get_value_int(0, "skin", pInfo[playerid][player_skin]);
		cache_get_value_int(0, "money", pInfo[playerid][money]);
		cache_get_value_float(0, "pos_x", pInfo[playerid][pos_x]);
		cache_get_value_float(0, "pos_y", pInfo[playerid][pos_y]);
		cache_get_value_float(0, "pos_z", pInfo[playerid][pos_z]);
		cache_get_value_float(0, "facingAngle", pInfo[playerid][facingAngle]);
		cache_get_value(0, "nama_lengkap", pInfo[playerid][ucp_name], MAX_PLAYER_NAME);
		cache_get_value(0, "password", pInfo[playerid][player_password], 65);
		
		if(!fexist(get_user_path(playerid))){
			CreateFileINI(playerid);
		}

		static info[255];
		format(info, sizeof info, DIALOG_LOGIN_INFO, pInfo[playerid][ucp_name], pInfo[playerid][player_name]);
		pInfo[playerid][timer_id] 	= SetTimerEx("TimeOutLogin", 60000, false, "i", playerid);
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", info, "Login", "Quit");
		
	}else{
		//JIka nama player belum terdaftar
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Error", "Nama yang digunakan belum terdaftar, silahkan daftar di website terlebih dahulu", "QUIT", "");
		Kick(playerid);
	}

	return 1;
}

forward TimeOutLogin(playerid);
public TimeOutLogin(playerid)
{
	SendClientMessage(playerid, COLOR_RED, "Terlalu lama di sesi login");
	KillTimer(pInfo[playerid][timer_id]);
	Kick(playerid);
}