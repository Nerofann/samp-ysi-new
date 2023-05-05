#include <YSI_Coding/y_hooks>

//MySQL
new MySQL: g_SQL;
#define DB_PATH     "../database/mysql_setting.ini"
// #define MYSQL_HOST  "upsilon.optiklink.com"
// #define MYSQL_USER  "u69801_gfnDViBUKJ"
// #define MYSQL_PASS  "Y!6QQMg+6EMxQqZu65ZvyC57"
// #define MYSQL_DB    "s69801_tkk_server"

//Localhost
#define MYSQL_HOST  "localhost"
#define MYSQL_USER  "root"
#define MYSQL_PASS  ""
#define MYSQL_DB    "samp_server"
#define SALT 		""


//COLOR asc
#define COLOR_WHITE 	0xFFFFFFFF
#define COLOR_RED   	0xFF0000FF

//COLOR TEXT / HEXA
#define COLOR_WHITES 	"FFFFFF"
#define COLOR_GREENS	"2EDD00"

//DIALOG
enum {
	DIALOG_MSG,
	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_STATS,
	DIALOG_MSG_ERROR_LOGIN
}

//PLayer Info
enum player_info {
	player_id[MAX_PLAYERS],
	player_name[MAX_PLAYER_NAME],
	ucp_name[MAX_PLAYER_NAME],
	player_password[65],
	player_level,
	player_skin,
	Float: pos_x,
	Float: pos_y,
	Float: pos_z,
	Float: rotation,
	Cache: cache_id,
	timer_id,
	bool:logged_in,
	money,
	jobs
};
new pInfo[MAX_PLAYERS][player_info];
new progressLogin[MAX_PLAYERS];