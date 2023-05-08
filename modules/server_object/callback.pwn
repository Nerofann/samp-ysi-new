#include <YSI_Coding/y_hooks>

//Callback for server object
forward LoadServerObject(); 
public LoadServerObject()
{
    static rows;
    cache_get_row_count(rows);
    static obj_count;
    static query[1000];
    mysql_format(g_SQL, query, sizeof query, "INSERT INTO `server_object` (object_id, object_cid) VALUES");

    if(rows){
        for(new i=0; i < rows; i++){
            static Float:pX, Float:pY, Float:pZ, 
                    Float:rX, Float:rY, Float:rZ, 
                    Float:distance, models, id;

            cache_get_value_name_float(i, "PosX", Float:pX);
            cache_get_value_name_float(i, "PosY", Float:pY);
            cache_get_value_name_float(i, "PosZ", Float:pZ);
            cache_get_value_name_float(i, "RotX", Float:rX);
            cache_get_value_name_float(i, "RotY", Float:rY);
            cache_get_value_name_float(i, "RotZ", Float:rZ);
            cache_get_value_name_float(i, "draw_distance", Float:distance);
            cache_get_value_name_int(i, "object_model", models);
            cache_get_value_name_int(i, "object_id", id);

            new object_ids = CreateObject(models, pX, pY, pZ, rX, rY, rZ, distance);
            static query_plus[255];

            if(IsValidObject(object_ids)){
                obj_count++;
                if(i == (rows - 1)){
                    format(query_plus, sizeof query_plus, "(%i, %i)", id, object_ids);
                }else{
                    format(query_plus, sizeof query_plus, "(%i, %i),", id, object_ids);
                }
                strcat(query, query_plus, sizeof query);
            }
        }

        if(obj_count != 0){
            strcat(query, "ON DUPLICATE KEY UPDATE object_cid = VALUES(object_cid)");
            mysql_tquery(g_SQL, query);
        }
    }
    
    printf("Server object total = %i\nObject success loaded = %i", rows, obj_count);
    return 1;
}