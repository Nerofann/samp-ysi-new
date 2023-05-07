#include <YSI_Coding/y_hooks>

CMD:createobject(playerid, params[]){
    if(IsPlayerAdmin(playerid)){
        new model_id;
        new object_name[MAX_OBJECT_NAME];
        new object_desc[MAX_OBJECT_DESC];
        if(sscanf(params, sprintf("ds[%i]s[%i]", MAX_OBJECT_NAME, MAX_OBJECT_DESC), model_id, object_name, object_desc)) return SendClientMessage(playerid, COLOR_WHITE, "/createobject [model id] [object name] [object desc] (use _ for space)");
        
        static Float:x, Float:y, Float:z;
        new query[256];
        GetPlayerPos(playerid, Float:x, Float:y, Float:z);
        new objectid = CreateObject(model_id, Float:x, Float:y, Float:z, 0, 0, 0, 10);

        mysql_format(SQL, query, sizeof query, "INSERT INTO `server_object` (object_cid, object_model, object_name, object_desc, PosX, PosY, PosZ, user_create) values(%i, %i, '%s', '%s', %f, %f, %f, '%s')", objectid, model_id, object_name, object_desc, Float:x, Float:y, Float:z, GetName(playerid));
        mysql_tquery(SQL, query, "CheckData", "i", playerid);

    }else{
        ShowPlayerDialog(playerid, Dialog[Dialog_c_object][DIALOG_MSG], DIALOG_STYLE_MSGBOX, "Failed", NOT_ADMIN, "Oke", "");
    }
    return 1;
}

CMD:listobject(playerid, params[]){
    if(IsPlayerAdmin(playerid)){
        new model = 0;
        sscanf(params, "i", model);

        new query[255];
        mysql_format(SQL, query, sizeof query, "SELECT * FROM `server_object` WHERE object_cid != ''");
        if(model != 0) strcat(query, sprintf("AND `object_model`=%i", model), sizeof query);
        mysql_tquery(SQL, query, "ShowListObject", "i", playerid);
    }else{
        ShowPlayerDialog(playerid, Dialog[Dialog_c_object][DIALOG_MSG], DIALOG_STYLE_MSGBOX, "Failed", NOT_ADMIN, "Oke", "");
    }
    return 1;
}
