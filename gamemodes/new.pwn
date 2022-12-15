
//INCLUDE
#include <a_samp>
#include <foreach>
#include <streamer>
#include <sscanf2>
#include <dini>
#include <zcmd>

//MODUL
#include "MODUL\COLOR.pwn"

//DIALOG REGISTER
#define DIALOG_LOGIN 1
#define DIALOG_REGISTER 2
#define DIALOG_CONFIRM 3
#define UserFile "\\UCP\\Users\\%s.ini"
//HOUSE SISTEM
#define MAX_HOUSES 200

//enum
new aVehicleNames[212][] =
{
	{"Landstalker"},
	{"Bravura"},
	{"Buffalo"},
	{"Linerunner"},
	{"Perrenial"},
	{"Sentinel"},
	{"Dumper"},
	{"Firetruck"},
	{"Trashmaster"},
	{"Stretch"},
	{"Manana"},
	{"Infernus"},
	{"Voodoo"},
	{"Pony"},
	{"Mule"},
	{"Cheetah"},
	{"Ambulance"},
	{"Leviathan"},
	{"Moonbeam"},
	{"Esperanto"},
	{"Taxi"},
	{"Washington"},
	{"Bobcat"},
	{"Mr Whoopee"},
	{"BF Injection"},
	{"Hunter"},
	{"Premier"},
	{"Enforcer"},
	{"Securicar"},
	{"Banshee"},
	{"Predator"},
	{"Bus"},
	{"Rhino"},
	{"Barracks"},
	{"Hotknife"},
	{"Trailer 1"},
	{"Previon"},
	{"Coach"},
	{"Cabbie"},
	{"Stallion"},
	{"Rumpo"},
	{"RC Bandit"},
	{"Romero"},
	{"Packer"},
	{"Monster"},
	{"Admiral"},
	{"Squalo"},
	{"Seasparrow"},
	{"Pizzaboy"},
	{"Tram"},
	{"Trailer 2"},
	{"Turismo"},
	{"Speeder"},
	{"Reefer"},
	{"Tropic"},
	{"Flatbed"},
	{"Yankee"},
	{"Caddy"},
	{"Solair"},
	{"Berkley's RC Van"},
	{"Skimmer"},
	{"PCJ-600"},
	{"Faggio"},
	{"Freeway"},
	{"RC Baron"},
	{"RC Raider"},
	{"Glendale"},
	{"Oceanic"},
	{"Sanchez"},
	{"Sparrow"},
	{"Patriot"},
	{"Quad"},
	{"Coastguard"},
	{"Dinghy"},
	{"Hermes"},
	{"Sabre"},
	{"Rustler"},
	{"ZR-350"},
	{"Walton"},
	{"Regina"},
	{"Comet"},
	{"BMX"},
	{"Burrito"},
	{"Camper"},
	{"Marquis"},
	{"Baggage"},
	{"Dozer"},
	{"Maverick"},
	{"News Chopper"},
	{"Rancher"},
	{"FBI Rancher"},
	{"Virgo"},
	{"Greenwood"},
	{"Jetmax"},
	{"Hotring"},
	{"Sandking"},
	{"Blista Compact"},
	{"Police Maverick"},
	{"Boxville"},
	{"Benson"},
	{"Mesa"},
	{"RC Goblin"},
	{"Hotring Racer A"},
	{"Hotring Racer B"},
	{"Bloodring Banger"},
	{"Rancher"},
	{"Super GT"},
	{"Elegant"},
	{"Journey"},
	{"Bike"},
	{"Mountain Bike"},
	{"Beagle"},
	{"Cropdust"},
	{"Stunt"},
	{"Tanker"},
	{"Roadtrain"},
	{"Nebula"},
	{"Majestic"},
	{"Buccaneer"},
	{"Shamal"},
	{"Hydra"},
	{"FCR-900"},
	{"NRG-500"},
	{"HPV1000"},
	{"Cement Truck"},
	{"Tow Truck"},
	{"Fortune"},
	{"Cadrona"},
	{"FBI Truck"},
	{"Willard"},
	{"Forklift"},
	{"Tractor"},
	{"Combine"},
	{"Feltzer"},
	{"Remington"},
	{"Slamvan"},
	{"Blade"},
	{"Freight"},
	{"Streak"},
	{"Vortex"},
	{"Vincent"},
	{"Bullet"},
	{"Clover"},
	{"Sadler"},
	{"Firetruck LA"},
	{"Hustler"},
	{"Intruder"},
	{"Primo"},
	{"Cargobob"},
	{"Tampa"},
	{"Sunrise"},
	{"Merit"},
	{"Utility"},
	{"Nevada"},
	{"Yosemite"},
	{"Windsor"},
	{"Monster A"},
	{"Monster B"},
	{"Uranus"},
	{"Jester"},
	{"Sultan"},
	{"Stratum"},
	{"Elegy"},
	{"Raindance"},
	{"RC Tiger"},
	{"Flash"},
	{"Tahoma"},
	{"Savanna"},
	{"Bandito"},
	{"Freight Flat"},
	{"Streak Carriage"},
	{"Kart"},
	{"Mower"},
	{"Duneride"},
	{"Sweeper"},
	{"Broadway"},
	{"Tornado"},
	{"AT-400"},
	{"DFT-30"},
	{"Huntley"},
	{"Stafford"},
	{"BF-400"},
	{"Newsvan"},
	{"Tug"},
	{"Trailer 3"},
	{"Emperor"},
	{"Wayfarer"},
	{"Euros"},
	{"Hotdog"},
	{"Club"},
	{"Freight Carriage"},
	{"Trailer 3"},
	{"Andromada"},
	{"Dodo"},
	{"RC Cam"},
	{"Launch"},
	{"Police Car (LSPD)"},
	{"Police Car (SFPD)"},
	{"Police Car (LVPD)"},
	{"Police Ranger"},
	{"Picador"},
	{"S.W.A.T. Van"},
	{"Alpha"},
	{"Phoenix"},
	{"Glendale"},
	{"Sadler"},
	{"Luggage Trailer A"},
	{"Luggage Trailer B"},
	{"Stair Trailer"},
	{"Boxville"},
	{"Farm Plow"},
	{"Utility Trailer"}
};

enum PlayerInfo
{
	Float: Health,
	Float: Armour,
	Float: PosX,
	Float: PosY,
	Float: PosZ,
	Float: Angle,
	Int,
	VW,
	pAdmin,
	pLogin,
	pRegister,
	pData,
	Skin
}
//new
new pInfo[MAX_PLAYERS][PlayerInfo];
new file [128];

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	SetGameModeText("SAMP PROJECT");
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{	
	format(file, sizeof(file), UserFile, GetPlayerNameEx(playerid));
	if(!dini_Exists(file))
	{
		new registerdialog[255]
		format(registerdialog, sizeof(registerdialog), "{FFFFFF}Selamat Datang User Account {B8FF02}%s\n{00BC2E}User Account ini telah terdaftar.{FFFFFF}\nSilahkan masukkan {B8FF02}Password{FFFFFF} untuk Login", pInfo);
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "{6EF83C}Register Your account", registerdialog, "Register", "Keluar");
	}else{
		new logindialog[256];
        format(logindialog, sizeof(logindialog),"{FFFFFF}Selamat Datang User Account {B8FF02}%s\n{00BC2E}User Account ini telah terdaftar.{FFFFFF}\nSilahkan masukkan {B8FF02}Password{FFFFFF} untuk Login", pInfo);
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{6EF83C}Login Panel account", logindialog, "Login", "Keluar");
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	format(File, sizeof(File), UserFile, GetPlayerNameEx(playerid));
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	dini_FloatSet(file, "posX", x);
	dini_FloatSet(file, "posY", y);
	dini_FloatSet(file, "posZ", z);
	dini_IntSet(file, "VirtualWorld", GetPlayerVirtualWorld(playerid));
	dini_IntSet(file, "Interior", GetPlayerInterior(playerid));
	dini_IntSet(file, "AdminLevel", pData[playerid][pAdmin])
	savedatapemain(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(pData[playerid][pRegister] == 1 && pData[playerid][pLogin] == 0)
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(dialogid)
		{
			case DIALOG_REGISTER
			{
				if(!strien(inputtext)) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "{6EF83C}Register Your account", registerdialog, "Register", "Keluar");
				if(!response) return Kick(playerid);
				format(file, sizeof(file), UserFile, GetPlayerNameEx(playerid));
				dini_Create(file);
				dini_set(file, "Password", inputtext);
				pData[playerid][pRegister] = 1;
				SendClientMessage(playerid, COLOR_WHITE, "Your password has been successfully added")
			}
			case DIALOG_LOGIN
			{
				if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{6EF83C}Login Panel account", logindialog, "Login", "Keluar");
				if(!response) return Kick(playerid);
				format(file, sizeof(file), UserFile, GetPlayerNameEx(playerid));
				new password[15];
				format(password, sizeof(password), "%s" dini_Get(file, "Password"));
				if(!strcmp(inputtext, password))
				{
					pData[playerid][pLogin] = 1;
					SendClientMessage(playerid, COLOR_WHITE, "You have successfully Login");
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registering  Your account password wrong, try again", , "Register", "Keluar");
				}
			}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	SetPlayerPos(playerid, Float:fX, Float:fY, Float:fZ);
	return 1;
}

stock GetName(playerid)
{
	new name [ 32 ];
	GetPlayerName(playerid, name, sizeof( name));
	return name;
}

CMD:veh(playerid,tmp[])
{
	new String[200];
	new Float:x, Float:y, Float:z;
	new vehicle = GetVehicleModelIDFromName(tmp);
//	if(!strlen(tmp)) return SendClientMessage(playerid, RED_E, "Anda tidak memberi nama kendaraan");
//	if(vehicle < 400 || vehicle > 611) return SendClientMessage(playerid, RED_E, "Nama kendaraan itu tidak ditemukan");

	new Float:a;
	GetPlayerFacingAngle(playerid, a);
	GetPlayerPos(playerid, x, y, z);

	if(IsPlayerInAnyVehicle(playerid) == 1)
	{
		GetXYInFrontOfPlayer(playerid, x, y, 8);
	}
	else
	{
	    GetXYInFrontOfPlayer(playerid, x, y, 5);
	}

	new PlayersVehicle = CreateVehicle(vehicle, x, y, z, a+90, 1, 1, -1);
	LinkVehicleToInterior(PlayersVehicle, GetPlayerInterior(playerid));

	format(String, sizeof(String), "Kendaraan berhasil di spawn %s", aVehicleNames[vehicle - 400]);
	SendClientMessage(playerid, COLOR_GREEN, String);
	return 1;
}

GetVehicleModelIDFromName(vname[])
{
	for(new i; i < 211; i++)
	{
		if(strfind(aVehicleNames[i], vname, true) != -1)
		return i + 400;
	}
	return -1;
}

stock GetXYInFrontOfPlayer(playerid, &Float:x2, &Float:y2, Float:distance)
{
	new Float:a;

	GetPlayerPos(playerid, x2, y2, a);
	GetPlayerFacingAngle(playerid, a);

	if(GetPlayerVehicleID(playerid))
	{
		GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}

	x2 += (distance * floatsin(-a, degrees));
	y2 += (distance * floatcos(-a, degrees));
}

resertenum(playerid)
{
	pInfo[playerid][Int] = 0;
	pInfo[playerid][VW] = 0;
	pInfo[playerid][Skin] = 0;
}

forward loaddatapemain(playerid);
public loaddatapemain(playerid)
{
	SpawnPlayer(playerid); // buat bug aja nih kampret -_-
	SetCameraBehindPlayer(playerid);

	pInfo[playerid][Health]		=	dini_Float(File, "Darah");
	pInfo[playerid][Armour]		=	dini_Float(File, "Armour");
	pInfo[playerid][PosX]		=	dini_Float(File, "POSX");
	pInfo[playerid][PosY]		=	dini_Float(File, "POSY");
	pInfo[playerid][PosZ]		=	dini_Float(File, "POSZ");
	pInfo[playerid][Angle]		=	dini_Float(File, "ANGLE");

	pInfo[playerid][Int]		=	dini_Int(File, "Interior");	
	pInfo[playerid][VW]			=	dini_Int(File, "VirtualWorld");	
	pInfo[playerid][Skin]		=	dini_Int(File, "Skin");


	SetPlayerHealth(playerid, pInfo[playerid][Health]);
	SetPlayerArmour(playerid, pInfo[playerid][Armour]);
	SetPlayerPos(playerid, pInfo[playerid][PosX] ,pInfo[playerid][PosY], pInfo[playerid][PosZ]);
	SetPlayerFacingAngle(playerid, pInfo[playerid][Angle]);
	SetPlayerInterior(playerid, pInfo[playerid][Int]);
	SetPlayerVirtualWorld(playerid, pInfo[playerid][VW]);
	SetPlayerSkin(playerid, pInfo[playerid][Skin]);
}

forward savedatapemain(playerid);
public savedatapemain(playerid)
{
	format(File, sizeof(File), "UCP/Users/%s.ini", GetName(playerid));
	if(dini_Exists(File))
	{
		GetPlayerPos(playerid, pInfo[playerid][PosX], pInfo[playerid][PosY], pInfo[playerid][PosZ]);
		GetPlayerHealth(playerid, pInfo[playerid][Health]);
		GetPlayerArmour(playerid, pInfo[playerid][Armour]);
		GetPlayerFacingAngle(playerid, pInfo[playerid][Angle]);
		
		pInfo[playerid][Int] 	= GetPlayerInterior(playerid);
		pInfo[playerid][VW] 	= GetPlayerVirtualWorld(playerid);
		pInfo[playerid][Skin]	= GetPlayerSkin(playerid);

		dini_FloatSet(File, "Darah", pInfo[playerid][Health]);
		dini_FloatSet(File, "Armour", pInfo[playerid][Armour]);
		dini_FloatSet(File, "POSX", pInfo[playerid][PosX]);
		dini_FloatSet(File, "POSY", pInfo[playerid][PosY]);
		dini_FloatSet(File, "POSZ", pInfo[playerid][PosZ]);
		dini_FloatSet(File, "ANGLE", pInfo[playerid][Angle]);

		dini_IntSet(File, "Interior", pInfo[playerid][Int]);
		dini_IntSet(File, "VirtualWorld", pInfo[playerid][VW]);
		dini_IntSet(File, "Skin", pInfo[playerid][Skin]);
		SendClientMessage(playerid, -1, "data pemain berhasil di simpan");	

	}
}
cmd: setmoney(playerid, parms[])
{
	if(pData[playerid][pAdmin] < 3)
		return SendClientMessage(playerid, COLOR_GREY, "You not authorized to use this command");

	new otherid, ammount;
	if(sscanf(parms,"ud", otherid, amount))
		return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /setmoney [playerid] [amount]");

	if(amount < 100 || amount > 1000000)
		return SendClientMessage(playerid, COLOR_WHITE, "Amount only between 100 and 10000000");

	ResetPlayerMoney(otherid)
	GivePlayerMoney(otherid, ammount);
	return 1;
}