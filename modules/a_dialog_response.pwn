#include <YSI_Coding/y_hooks>

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid){
		case DIALOG_LOGIN: {
			if(!response) return Kick(playerid);

			new hash_password[65];
			SHA256_PassHash(inputtext, SALT, hash_password, sizeof(hash_password));
			if(strcmp(hash_password, pInfo[playerid][player_password]) != 0){
				progressLogin[player_id]++;
				if(progressLogin[player_id] > 3){
					Kick(player_id);
				}else{
					SendClientMessage(playerid, COLOR_WHITE, "password salah");
					ShowPlayerDialog(
						playerid,
						DIALOG_LOGIN, 
						DIALOG_STYLE_PASSWORD, 
						"Login Page", 
						sprintf("{FFFFFF}Akun Server = {2EDD00} %s \n{FFFFFF}Nama = {2EDD00} %s\nMasukkan password anda", pInfo[player_id][ucp_name], pInfo[player_id][player_name]), 
						"Login", 
						"Quit"
					);
				}
			
			}else{
				new queryy[255];
				mysql_format(g_SQL, queryy, sizeof queryy, "SELECT * FROM `view_login_in_game` WHERE nama='%e'", pInfo[playerid][player_name]);
				mysql_tquery(g_SQL, queryy, "AssignPlayerdata", "i", playerid);
				pInfo[playerid][logged_in] = true;
				KillTimer(pInfo[playerid][timer_id]);
			}
		}

		case DIALOG_REGISTER: {
			if(!response) return Kick(playerid);
			if(strlen(inputtext) < 8 || strlen(inputtext) > 24){
				// SendClientMessage(playerid, COLOR_NORMAL_PLAYER, "Panjang password harus lebih dari 8 dan kurang dari 24 karakter");
				ShowPlayerDialog(playerid,DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Login Page", sprintf("{FFFFFF}Akun Server = {2EDD00} %s \n {FFFFFF}Nama = {2EDD00} %s\n Panjang password harus lebih dari 8 dan kurang dari 24 karakter", pInfo[player_id][ucp_name], pInfo[player_id][player_name]), "Login", "Quit");
				return 0;
			}else{
				SHA256_PassHash(inputtext, pInfo[playerid][player_name], pInfo[playerid][player_password], 65);
				new query[255];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE `karakter` SET `password` = '%e' WHERE nama = '%e'", pInfo[playerid][player_password], pInfo[playerid][player_name]);
				mysql_tquery(g_SQL, query);

				SendClientMessage(playerid, COLOR_WHITE, "Berhasil mengatur password, jangan sampai lupa!");
				SetSpawnInfo(playerid, 0, 1, 1955.33, 1343.12, 15.36, 269.15, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
			}
		}
	}

	return 1;
}