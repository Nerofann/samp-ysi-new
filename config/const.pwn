#include <YSI_Coding/y_hooks>

//MySQL
new MySQL: g_SQL;
#define DB_PATH     "../database/mysql_setting.ini"
#define MYSQL_HOST  "153.92.11.27"
#define MYSQL_USER  "n1578212_fani-react-app"
#define MYSQL_PASS  "Males230104"
#define MYSQL_DB    "n1578212_fani-react-app"

//Localhost
// #define MYSQL_HOST  "localhost"
// #define MYSQL_USER  "root"
// #define MYSQL_PASS  ""
// #define MYSQL_DB    "samp_server"
#define SALT 		""

//COLOR asc
#define COLOR_WHITE 	0xFFFFFFFF
#define COLOR_RED   	0xFF0000FF
#define COLOR_GREEN	    0x2EDD00FF
#define COLOR_ORANGE    0xF5C61BFF  
#define COLOR_YELLOW    0xE5E500FF  
#define COLOR_CREAM     0xFFE369FF

//COLOR TEXT / HEXA
#define COLOR_WHITES    "FFFFFF"
#define COLOR_REDS      "E5E500"
#define COLOR_GREENS	"2EDD00"
#define COLOR_ORANGES   "F5C61B"  
#define COLOR_YELLOWS   "EEF205"
#define COLOR_CREAMS    "FFE369"

#define MAX_SERVER_VEHICLES     2000
#define MAX_PLAYER_VEHICLE      4
//Vehicle

//DIALOG
enum {
	DIALOG_MSG,
	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_STATS,
	DIALOG_MSG_ERROR_LOGIN,
	DIALOG_LIST_VEH,
    DIALOG_DETAIL_VEHICLE
}