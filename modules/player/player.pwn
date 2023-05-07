#include <YSI_Coding/y_hooks>

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