#include <YSI_Coding/y_hooks>


stock print_tes()
{
    print("testt");
}

//Callback for server object
forward CheckData(playerid);
public CheckData(playerid)
{
    new last_id = cache_insert_id();
    if(last_id){
        SendClientMessage(playerid, COLOR_YELLOW, sprintf("[System] Berhasil membuat object, ID: %i", cache_insert_id()));
    }else{
        SendClientMessage(playerid, COLOR_YELLOW, sprintf("[System] Gagal membubat object"));
    }

    return 1;
}

forward ShowListObject(playerid);
public ShowListObject(playerid)
{
    static list[255] = "";
    static rows;    
    cache_get_row_count(rows);
    new header[255] = "VID\tObject ID\tName\tUser create\tvisible\n";
    list = "";
    strcat(list, header, sizeof list);

    if(rows > 0){
        new vid, objectid, bool:visible, object_name[MAX_OBJECT_NAME], user_create[MAX_PLAYER_NAME];
        for(new i=0; i < rows; i++){
            cache_get_value_name_int(i, "object_id", vid);
            cache_get_value_name_int(i, "object_cid", objectid);
            cache_get_value_name_bool(i, "visible", bool:visible);
            cache_get_value_name(i, "object_name", object_name, MAX_OBJECT_NAME);
            cache_get_value_name(i, "user_create", user_create, MAX_PLAYER_NAME);

            if(visible){
                strcat(list, sprintf("%i\t%i\t%s\t%s\t{"COLOR_GREENS"} true\n", vid, objectid, object_name, user_create), sizeof list);
            }else{
                strcat(list, sprintf("%i\t%i\t%s\t%s\t{"COLOR_CREAMS"} false\n", vid, objectid, object_name, user_create), sizeof list);
            }
        }
    }

    ShowPlayerDialog(playerid, DIALOG_LIST_OBJECT, DIALOG_STYLE_TABLIST_HEADERS, "Server Object", list, "Show Position", "Close");
    return 1;
}


stock testttt()
{
    print("testt");
}

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

        mysql_format(g_SQL, query, sizeof query, "INSERT INTO `server_object` (object_cid, object_model, object_name, object_desc, PosX, PosY, PosZ, user_create) values(%i, %i, '%s', '%s', %f, %f, %f, '%s')", objectid, model_id, object_name, object_desc, Float:x, Float:y, Float:z, GetName(playerid));
        mysql_tquery(g_SQL, query, "CheckData", "i", playerid);

    }else{
        ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Failed", NOT_ADMIN, "Oke", "");
    }
    return 1;
}

CMD:listobject(playerid, params[]){
    if(IsPlayerAdmin(playerid)){
        new model = 0;
        sscanf(params, "i", model);

        new query[255];
        mysql_format(g_SQL, query, sizeof query, "SELECT * FROM `server_object` WHERE object_cid != ''");
        if(model != 0) strcat(query, sprintf("AND `object_model`=%i", model), sizeof query);
        mysql_tquery(g_SQL, query, "ShowListObject", "i", playerid);
    }else{
        ShowPlayerDialog(playerid, DIALOG_MSG, DIALOG_STYLE_MSGBOX, "Failed", NOT_ADMIN, "Oke", "");
    }
    return 1;
}
