enum Dialog_data {
    Dialog_auth,
    Dialog_vehicle,
    Dialog_c_object
};

stock GetName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof name);
    return name;
}