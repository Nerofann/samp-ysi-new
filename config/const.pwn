#include <YSI_Coding/y_hooks>

//MySQL
new MySQL: g_SQL;
new INI:UserFile;
new INI:ServerVehicle;
new rand;

#define DB_PATH     	"../database/mysql_setting.ini"
#define MYSQL_HOST  	"153.92.11.27"
#define MYSQL_USER  	"n1578212_fani-react-app"
#define MYSQL_PASS  	"Males230104"
#define MYSQL_DB    	"n1578212_fani-react-app"
#define SALT 			""

#define PATH_USER_FILE	        "/userdata/%s.ini"
#define PATH_SERVER_VEHICLE	    "/server_vehicle/%i.ini"
#define DIALOG_LOGIN_INFO       ""COLOR_WHITES"Server Account = "COLOR_GREENS"%s\n"COLOR_WHITES"Character Name = "COLOR_GREENS"%s\nMasukkan password"
#define DIALOG_REGISTER_INFO    ""COLOR_WHITES"Server Account = "COLOR_GREENS"%s\n"COLOR_WHITES"Character Name = "COLOR_GREENS"%s\npassword harus lebih dari 8 dan kurang dari 24 karakter\n"

//COLOR asc
#define COLOR_WHITE 	0xFFFFFFFF
#define COLOR_RED   	0xFF0000FF
#define COLOR_GREEN	    0x2EDD00FF
#define COLOR_ORANGE    0xF5C61BFF  
#define COLOR_YELLOW    0xE5E500FF  
#define COLOR_CREAM     0xFFE369FF

//COLOR TEXT / HEXA
#define COLOR_WHITES    "{FFFFFF}"
#define COLOR_REDS      "{E5E500}"
#define COLOR_GREENS	"{2EDD00}"
#define COLOR_ORANGES   "{F5C61B}"  
#define COLOR_YELLOWS   "{EEF205}"
#define COLOR_CREAMS    "{FFE369}"

#define MAX_SERVER_VEHICLES     2000
#define MAX_PLAYER_VEHICLE      4
#define MAX_SERVER_OBJECT       2000
#define MAX_OBJECT_NAME         30
#define MAX_OBJECT_DESC         50
#define MAX_OBJECT_DATE         50
#define NOT_ADMIN               "Logged into admins mode"

//DIALOG
enum {
	DIALOG_MSG,
	DIALOG_LOGIN,
	DIALOG_REGISTER,
	DIALOG_STATS,
	DIALOG_MSG_ERROR_LOGIN,
	DIALOG_LIST_VEH,
    DIALOG_DETAIL_VEHICLE,
    DIALOG_LIST_OBJECT
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
	Float: facingAngle,
	Cache: cache_id,
	timer_id,
	bool:logged_in,
	money,
	jobs
};
new pInfo[MAX_PLAYERS][player_info];
new progressLogin[MAX_PLAYERS];

new VehicleNames[212][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Pereniel", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus","Voodoo", "Pony",
    "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Mr Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero",
    "Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy",
    "Solair", "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad",
    "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR3 50", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick",
    "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa",
    "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust",
    "Stunt", "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
    "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent", "Bullet",
    "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster A",
    "Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight", "Trailer", "Kart", "Mower",
    "Duneride", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "Newsvan", "Tug", "Trailer A", "Emperor", "Wayfarer", "Euros",
    "Hotdog", "Club", "Trailer B", "Trailer C", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)", "Police Car (LVPD)", "Police Ranger",
    "Picador", "S.W.A.T. Van", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer A", "Luggage Trailer B", "Stair Trailer", "Boxville", "Farm Plow", "Utility Trailer"
};
enum VehiclesData
{
    veh_id,
    veh_databaseid,
    veh_model,
    veh_name[25],
    Float:veh_health,
    veh_plate[10],
    veh_owner[MAX_PLAYER_NAME],
    veh_price,
    veh_lock,
    veh_color1,
    veh_color2,
    // Text3D:veh_label,
    veh_label[255],
    Float:vehX,
    Float:vehY,
    Float:vehZ,
    Float:vehA,
    bool:is_spawned,
    bool:is_destroyed
};
new vInfo[MAX_PLAYERS][MAX_PLAYER_VEHICLE][VehiclesData];
// new Iterator:vInfo<MAX_PLAYERS, >
new VSinfo[MAX_SERVER_VEHICLES][VehiclesData];
new Iterator:VS<MAX_SERVER_VEHICLES>; 
