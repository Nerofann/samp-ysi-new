#include <YSI_Coding/y_hooks>

forward onPlayerDataCheck(playerid);
public onPlayerDataCheck(playerid)
{
    new rows;
	cache_get_row_count(rows);
	if(rows > 0){
		cache_get_value(0, "password", pInfo[playerid][player_password], 65);
		cache_get_value(0, "nama_lengkap", pInfo[playerid][ucp_name], MAX_PLAYER_NAME);
		
		if(fexist(get_user_path(playerid))){
			static info[255];
			format(info, sizeof info, "{FFFFFF}Server Account = {2EDD00}%s\n{FFFFFF}Character Name = {2EDD00}%s", pInfo[playerid][ucp_name], pInfo[playerid][player_name]);
		
			pInfo[playerid][timer_id] 	= SetTimerEx("TimeOutLogin", 30000, false, "i", playerid);
			strcat(info, "\n{2EDD00}Masukkan password", sizeof info);
			ShowPlayerDialog(
				playerid,
				DIALOG_LOGIN, 
				DIALOG_STYLE_PASSWORD, 
				"Login", 
				info,
				"Login", 
				"Quit"
			);

		}else{
			CreateFileINI(playerid);
			ShowPlayerDialog(playerid,DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Login Page", sprintf(""COLOR_WHITES"Akun Server = "COLOR_GREENS" %s \n"COLOR_WHITES"Nama = "COLOR_GREENS" %s\npassword harus lebih dari 8 dan kurang dari 24 karakter\n", pInfo[player_id][ucp_name], pInfo[player_id][player_name]), "Login", "Quit");
			// ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", ""COLOR_WHITES"Atur password untuk akun.", "Register", "Close");
		}
		
	}else{
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Error", "Nama yang digunakan belum terdaftar, silahkan daftar terlebih dahulu", "QUIT", "");
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

forward LoadUser_data(playerid, name[], value[]);
public LoadUser_data(playerid, name[], value[])
{
	INI_String("username", pInfo[playerid][player_name]);
	INI_String("password", pInfo[playerid][player_password]);
	INI_Int("level", pInfo[playerid][player_level]);
	INI_Int("skin", pInfo[playerid][player_skin]);
	INI_Float("pos_x", pInfo[playerid][pos_x]);
	INI_Float("pos_y", pInfo[playerid][pos_y]);
	INI_Float("pos_z", pInfo[playerid][pos_z]);
	INI_Float("facingAngle", pInfo[playerid][facingAngle]);
	INI_Int("money", pInfo[playerid][money]);
	return 1;
}