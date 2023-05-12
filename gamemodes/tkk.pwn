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
// #include <Dini>

#define YSI_YES_HEAP_MALLOC
#include <YSI_Coding/y_hooks>
#include <YSI_Data/y_iterate>
#include <YSI_Storage/y_ini>


//Modules
#include "../config/const.pwn"
#include "../config/modules_includes.pwn"

main() 
{
	// write code here and run "sampctl build" to compile
	// then run "sampctl run" to run it
	CekConnection();
	LoadObject();
	testttt();
	print_tes();
}

public OnGameModeInit()
{
	// return 1;
}

public OnPlayerConnect(playerid)
{
	//login
	pInfo[playerid][logged_in]	= false;
	progressLogin[player_id]=0;
    GetPlayerName(playerid, pInfo[playerid][player_name], MAX_PLAYER_NAME);
	static query[120];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `view_login_in_game` where nama = '%e' LIMIT 1", pInfo[playerid][player_name]);
	mysql_tquery(g_SQL, query, "onPlayerDataCheck", "i", playerid);

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

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid){
		case DIALOG_LOGIN: {
			if(!response) return Kick(playerid);
			if(response){
				new hash_password[65];
				SHA256_PassHash(inputtext, "", hash_password, sizeof(hash_password));
				if(strcmp(hash_password, pInfo[playerid][player_password]) != 0){
					progressLogin[player_id]++;
					if(progressLogin[player_id] > 3){
						Kick(player_id);
					}else{
						new info[255];
						format(info, sizeof info, DIALOG_LOGIN_INFO, pInfo[playerid][ucp_name], pInfo[playerid][player_name]);
						SendClientMessage(playerid, COLOR_WHITE, "password salah");
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
					pInfo[playerid][logged_in] = true;
					KillTimer(pInfo[playerid][timer_id]);
					SetSpawnInfo(playerid, 0, pInfo[playerid][player_skin], pInfo[playerid][pos_x], pInfo[playerid][pos_y], pInfo[playerid][pos_z], pInfo[playerid][facingAngle], 0, 0, 0, 0, 0, 0);
					SpawnPlayer(playerid);
				}
			}
		}

		case DIALOG_REGISTER: {
			if(!response) return Kick(playerid);
			if(response){
				if(strlen(inputtext) < 8 || strlen(inputtext) > 24){
					// SendClientMessage(playerid, COLOR_NORMAL_PLAYER, "Panjang password harus lebih dari 8 dan kurang dari 24 karakter");
					static info[255];
					format(info, sizeof info, DIALOG_REGISTER_INFO, pInfo[player_id][ucp_name], pInfo[player_id][player_name]);
					ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", info, "Login", "Quit");
					
				}else{
					SHA256_PassHash(inputtext, pInfo[playerid][player_name], pInfo[playerid][player_password], 65);
					SendClientMessage(playerid, COLOR_WHITE, "Berhasil mengatur password, jangan sampai lupa!");
					SetSpawnInfo(playerid, 0, 1, 1955.33, 1343.12, 15.36, 269.15, 0, 0, 0, 0, 0, 0);
					SpawnPlayer(playerid);
				}
			}
		}
	}

	return 1;
}