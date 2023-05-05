#include <YSI_Coding/y_hooks>

stock Cek_akun(playerid)
{
	pInfo[playerid][logged_in]	= false;
	progressLogin[player_id]=0;
    GetPlayerName(playerid, pInfo[playerid][player_name], MAX_PLAYER_NAME);
	static query[120];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `view_login_in_game` where nama = '%e' LIMIT 1", pInfo[playerid][player_name]);
	mysql_tquery(g_SQL, query, "onPlayerDataCheck", "i", playerid);
}

forward onPlayerDataCheck(playerid);
public onPlayerDataCheck(playerid)
{
    new rows;
	cache_get_row_count(rows);
	if(rows > 0){
		new bool:password_check;
		cache_get_value(0, "password", pInfo[playerid][player_password], 65);
		cache_get_value(0, "nama_lengkap", pInfo[playerid][ucp_name], MAX_PLAYER_NAME);
		cache_is_value_name_null(0, "password", password_check);
		
		static info[255];
		format(info, sizeof info, "{FFFFFF}Server Account = {2EDD00}%s\n{FFFFFF}Character Name = {2EDD00}%s", pInfo[playerid][ucp_name], pInfo[playerid][player_name]);
		if(password_check){
			ShowPlayerDialog(playerid, DIALOG_MSG_ERROR_LOGIN, DIALOG_STYLE_MSGBOX, "Error", "Sorry, we can't find your password account,\nContact admin or create new issue on forum or try to re-create character", "Quit", "");
			// strcat(info, "\n{2EDD00}Password belum diatur, silahkan membuat password", sizeof info);
			// ShowPlayerDialog(
			// 	playerid,
			// 	DIALOG_REGISTER, 
			// 	DIALOG_STYLE_PASSWORD, 
			// 	"Register", 
			// 	info,
			// 	"Register", 
			// 	"Quit"
			// );
		}else{
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
		}
	}else{
		Kick(playerid);
		ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Error", "Nama yang digunakan belum terdaftar, silahkan daftar terlebih dahulu", "QUIT", "");
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