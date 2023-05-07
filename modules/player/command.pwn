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

CMD:veh(playerid, params[]){
    new veh_id;
    if(sscanf(params, "i", veh_id)) return SendClientMessage(playerid, COLOR_WHITE, "/veh [model id]");
    // if(!IsValidVehicle(veh_id)) return SendClientMessage(playerid, COLOR_WHITE, "/veh [model id > 400]"); 

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, Float:x, Float:y, Float:z);
    x += (5 * floatsin(Float:x, degrees));
    y += (5 * floatcos(Float:y, degrees));
    CreateVehicle(veh_id, Float:x, Float:y, Float:z, 0, -1, -1, -1, bool:0);
    // new lengthh  = sizeof(player_vehicle);
    // for(new i=0; i < lengthh; i++){
    //     if(!IsValidVehicle(pVeh[playerid][i])){
    //         pVeh[playerid][i]   = vehicles;
    //     }
    // }

    return 1;
}