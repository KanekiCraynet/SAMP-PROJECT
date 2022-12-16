#include <a_samp>
#include <foreach>
#include <streamer>
#include <sscanf2>
#include <dini>
#include <zcmd>
#include "MODUL\COLOR.pwn"
#include <a_http>
 
#define APIKEY "3E1D7992FDC36C8921ADEF28D1E7A665"
//#define ALWAYS_RESPONSE
#define DIALOG_REGISTER 1
#define DIALOG_LOGIN 	2
#define DIALOG_CONFIRM 	3

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
	Date,
	Skin
}
new pInfo[MAX_PLAYERS][PlayerInfo];
new File [128];

main()
{
	print("\n----------------------------------");
	print(" SAMP PROJECT");
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
	resertenum(playerid);	
	format(File, sizeof(File), "UCP/Users/%s.ini", GetName(playerid));
	if(!dini_Exists(File))
	{
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "Isi", "Masuk", "Keluar");
	}else{
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Isi", "Masuk", "Keluar");
	}
	new IP[30], str[300], pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pName, sizeof(pName));
    GetPlayerIp(playerid, IP, sizeof(IP));
    if(!strcmp(IP, "127.0.0.1"))
    {
        format(str, 230, "%s {FAFAFA}Has joined the server. {1FC7FF}Country: {FAFAFA}localhost", pName);
        SendClientMessageToAll(GetPlayerColor(playerid), str);
    }
    else
    {
        format(str, sizeof(str),"api.ipinfodb.com/v3/ip-country/?key="APIKEY"&ip=%s", IP);
        HTTP(playerid, HTTP_GET, str, "", "GetPlayerCountry");
    }
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	savedatapemain(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_REGISTER)
	{
		if(response)
		{
			if(strlen(inputtext) >= 5 && strlen(inputtext) <= 20)
			{
				format(File, sizeof(File), "UCP/Users/%s.ini", GetName(playerid));
				dini_Create (File);
				dini_Set(File,"Password", inputtext);
				dini_Set(File,"Date", inputtext);
				dini_FloatSet(File, "Darah", 100.0);
				dini_FloatSet(File, "Armour", 0.0);
				dini_FloatSet(File, "POSX", 1682.6084);
				dini_FloatSet(File, "POSY", -2327.8940);
				dini_FloatSet(File, "POSZ", 13.5469);
				dini_FloatSet(File, "ANGLE", 3.4335);

				dini_IntSet(File, "Interior", 0);
				dini_IntSet(File, "VirtualWorld", 0);
				dini_IntSet(File, "Skin", 98);
				SendClientMessage(playerid, -1, "data pemian berhasil di buat");

				// di sini kalian bisa menambah dialog seperti umur, jenis kelamin, dll
				new string[500];
				format(string,sizeof(string),"{2F70D0}______________________________\n{FF0000}Nama: {15FF00}%s\n{FF0000}Password: {15FF00}%s\n{2F70D0}______________________________",GetName(playerid),inputtext);
				ShowPlayerDialog(playerid, DIALOG_CONFIRM, DIALOG_STYLE_MSGBOX, "Stats Akun", string, "Spawn", "Kembali");

			}else
			{
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "harus memenuhi syarat", "Masuk", "Keluar");
			}
		}else{
			Kick(playerid);
		}
	}
	if(dialogid == DIALOG_LOGIN)
	{
		if(response)
		{
			new pass[255];
			format(File, sizeof(File), "UCP/Users/%s.ini", GetName(playerid));
			format(pass, sizeof(pass), "%s", dini_Get(File, "Password"));
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Isi", "Masuk", "Keluar");
			if(strcmp(inputtext, pass) == 0)
			{
				SetTimer("loaddatapemain", 1000, false);

				SendClientMessage(playerid, -1, "data berhasil di load");
			}else{
				 ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Pass Salah", "Masuk", "Keluar");
			}

		}else{
			Kick(playerid);
		}
	}
	if(dialogid == DIALOG_CONFIRM)
	{
		if(response)
		{

			SetTimer("loaddatapemain", 1000, false);
        	/*SpawnPlayer(playerid);

    		SetCameraBehindPlayer(playerid);
			SetPlayerPos(playerid, 1682.6084 ,-2327.8940, 13.5469);
			SetPlayerFacingAngle(playerid, 3.4335);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid,0);
			SetPlayerSkin(playerid, 98);*/
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
	if(!strlen(tmp)) return SendClientMessage(playerid, COLOR_RED, "Anda tidak memberi nama kendaraan");

	new vehicle = GetVehicleModelIDFromName(tmp);

	if(vehicle < 400 || vehicle > 611) return SendClientMessage(playerid, COLOR_RED, "Nama kendaraan itu tidak ditemukan");

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
	pInfo[playerid][Date]		=	dini_Float(File, "Date");
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
		dini_FloatSet(File, "Date", pInfo[playerid][Date]);
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

forward GetPlayerCountry(index, response_code, data[]);
public GetPlayerCountry(index, response_code, data[])
{
    new buffer[358];
    if(response_code == 200)
    {
        new str[230], city[3], country[20], pName[MAX_PLAYER_NAME];
        GetPlayerName(index, pName, sizeof(pName));
        format(buffer, sizeof(buffer), "%s", data);
        strmid(str, buffer, 4, strlen(buffer)); // Cutting the 'OK' response...
        strmid(city, str, strfind(str, ";", true) + 1, strfind(str, ";", true) + 3); // Getting City
        strmid(country, str, strfind(str, ";", true) + 4, strlen(buffer)); // Getting Country
        //printf("city: %s, country: %s", city, country);
        format(str, 230, "%s {FAFAFA}Has joined the server. {1FC7FF}Country: {FAFAFA}%s %s", pName, country, city);
        SendClientMessageToAll(GetPlayerColor(index), str);
    }
    else
    {
        new str[300], pName[MAX_PLAYER_NAME];
        GetPlayerName(index, pName, sizeof(pName));
        #if defined ALWAYS_RESPONSE
        new IP[30];
        GetPlayerIp(index, IP, sizeof(IP));
        format(str, sizeof(str),"api.ipinfodb.com/v3/ip-country/?key="APIKEY"&ip=%s", IP);
        HTTP(index, HTTP_GET, str, "", "GetPlayerCountry");
        #else // Normal message, without country
        format(str, 120, "%s {FAFAFA}Has joined the server.", pName);
        SendClientMessageToAll(GetPlayerColor(index), str);
        #endif
    }
}