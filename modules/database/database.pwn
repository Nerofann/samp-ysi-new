#include <YSI_Coding/y_hooks>

stock CekConnection()
{
    new MySQLOpt: option_id = mysql_init_options();
    mysql_set_option(option_id, AUTO_RECONNECT, true);
    g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB, option_id);
    if(g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0){
        printf("[MySQL] Failed to connect");
        SendRconCommand("exit");
        return 0;
    }

    printf("[MySQL] Connection succesfully");
    return 1;
}