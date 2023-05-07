#include <YSI_Coding/y_hooks>

stock LoadObject()
{
    mysql_tquery(g_SQL, "SELECT * FROM `server_object` WHERE `visible` = 1", "LoadServerObject");
    return 1;
} 