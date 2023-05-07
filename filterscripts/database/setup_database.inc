/**
*   Setup database by Fani   
*/

#include <a_mysql>
#define HOST    "153.92.11.27"
#define USER    "n1578212_fani-react-app"
#define PASS    "Males230104"
#define DB      "n1578212_fani-react-app"

// COLOR
#define COLOR_WHITE     0xFFFFFFFF
#define COLOR_GREEN	    0x2EDD00FF
#define COLOR_ORANGE    0xF5C61BFF  
#define COLOR_YELLOW    0xE5E500FF  
#define COLOR_RED       0xE80505FF
#define COLOR_CREAM     0xFFE369FF

#define COLOR_WHITES    "FFFFFF"
#define COLOR_GREENS	"2EDD00"
#define COLOR_ORANGES   "F5C61B"  
#define COLOR_YELLOWS   "EEF205"
#define COLOR_REDS      "E5E500"
#define COLOR_CREAMS    "FFE369"


new MySQL: SQL;

stock connect_db()
{
    new MySQLOpt: option_id = mysql_init_options();
    mysql_set_option(option_id, AUTO_RECONNECT, true);

    SQL = mysql_connect(HOST, USER, PASS, DB, option_id);
    if(SQL == MYSQL_INVALID_HANDLE || mysql_errno(SQL) != 0){
        printf("[MySQL FS] >> Connection Failed");
        SendRconCommand("exit");
        return 0;
    }

    printf("[MySQL FS] >> Connection succesfully");
    return 1;
}