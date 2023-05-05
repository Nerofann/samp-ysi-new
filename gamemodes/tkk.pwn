// generated by "sampctl package init"
//Jangan pernah mengubah struktur yang sudah disusun !!

#include <a_samp>
#include <core>
#include <float>
#include <a_mysql>
#include <zcmd>
#include <strlib>
#include <sscanf2>
#include <streamer>

#include <YSI_Coding/y_hooks>
#include <YSI_Data/y_iterate>


//Modules
#include "../config/const.pwn"
#include "../modules/database/database.pwn"
#include "../modules/auth.pwn"

//COMMAND
#include "../modules/command/command.pwn"

//CALLBACK
#include "../modules/callback/server_object_callback.pwn"

//Dialog Response
#include "../modules/a_dialog_response.pwn"

main() 
{
	// write code here and run "sampctl build" to compile
	// then run "sampctl run" to run it
	Mod1_info();
	Mod2_info();
	CekConnection();
}

public OnGameModeInit()
{
    mysql_tquery(g_SQL, "SELECT * FROM `server_object` WHERE `visible` = 1", "LoadServerObject");
	// return 1;
}

public OnPlayerConnect(playerid)
{
	//login
	Cek_akun(playerid);
	return 1;
}	

public OnPlayerDisconnect(playerid, reason)
{
	//Save player data
	SavePlayerData(playerid);
	
	//Message to all
	static message[255];
	format(message, sizeof message, "%s Terputus dari server, %s", pInfo[playerid][player_name], reason);
	SendClientMessageToAll(COLOR_RED, message);
	return 1;
}

static stock SavePlayerData(playerid)
{
	//Save player data jika keadaan sudah login / sudah bermain
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