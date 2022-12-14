#include <a_samp>
#include <core>
#include <float>
#include <dutils>
#include <Dini>
#include <dudb>
#pragma tabsize 0
#pragma unused ret_memcpy

#define COLOR_WHITE 0xFFFFFFAA
#define Dialog_register 1
#define Dialog_login 	2
#define Dialog_konfrim 	3
#define Welcome_Server 4

//Enum and New Var
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
	Skin
}
new pInfo[MAX_PLAYERS][PlayerInfo];
new File [128];

//Forward
forward ShowCharacter(playerid);
forward ini_GetKey( line[] );

main()
{
	print("\n----------------------------------");
	print("  Bare Script\n");
	print("----------------------------------\n");
}

public OnPlayerConnect(playerid)
{
	resertenum(playerid);	
	format(File, sizeof(File), "UCP/Users/%s.ini", GetName(playerid));
	if(!dini_Exists(File))
	{
		ShowPlayerDialog(playerid, Dialog_register, DIALOG_STYLE_PASSWORD, "Register", "Isi", "Masuk", "Keluar");
	}else{
		ShowPlayerDialog(playerid, Dialog_login, DIALOG_STYLE_PASSWORD, "Login", "Isi", "Masuk", "Keluar");
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
	if(dialogid == Dialog_register)
	{
		if(response)
		{
			if(strlen(inputtext) >= 5 && strlen(inputtext) <= 20)
			{
				format(File, sizeof(File), "UCP/Users/%s.ini", GetName(playerid));
				dini_Create (File);
				dini_Set(File,"Password", inputtext);
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
				ShowPlayerDialog(playerid, Dialog_konfrim, DIALOG_STYLE_MSGBOX, "Stats Akun", string, "Spawn", "Kembali");

			}else
			{
				ShowPlayerDialog(playerid, Dialog_register, DIALOG_STYLE_PASSWORD, "Register", "harus memenuhi syarat", "Masuk", "Keluar");
			}
		}else{
			Kick(playerid);
		}
	}
	if(dialogid == Dialog_login)
	{
		if(response)
		{
			new pass[255];
			format(File, sizeof(File), "UCP/Users/%s.ini", GetName(playerid));
			format(pass, sizeof(pass), "%s", dini_Get(File, "Password"));
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, Dialog_login, DIALOG_STYLE_PASSWORD, "Login", "Isi", "Masuk", "Keluar");
			if(strcmp(inputtext, pass) == 0)
			{
				SetTimer("loaddatapemain", 1000, false);

				SendClientMessage(playerid, -1, "data berhasil di load");
			}else{
				 ShowPlayerDialog(playerid, Dialog_login, DIALOG_STYLE_PASSWORD, "Login", "Pass Salah", "Masuk", "Keluar");
			}

		}else{
			Kick(playerid);
		}
	}
	if(dialogid == Dialog_konfrim)
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

public OnPlayerCommandText(playerid, cmdtext[])
{
	new idx;
	new cmd[256];
	
	cmd = strtok(cmdtext, idx);

	if(strcmp(cmd, "/yadayada", true) == 0) {
    	return 1;
	}

	return 0;
}

public OnPlayerDeath(playerid, killerid, reason)
{
   	return 1;
}

SetupPlayerForClassSelection(playerid)
{
 	SetPlayerInterior(playerid,14);
	SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
	SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Bare Script");
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	AllowAdminTeleport(1);

	AddPlayerClass(265,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);

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
	new vehicle = GetVehicleModelIDFromName(tmp);
	new Float:x, Float:y, Float:z;
	if(!strlen(tmp)) return SendClientMessage(playerid, l_red, "Anda tidak memberi nama kendaraan");

	if(vehicle < 400 || vehicle > 611) return SendClientMessage(playerid, l_red, "Nama kendaraan itu tidak ditemukan");

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
	SendClientMessage(playerid, l_green, String);
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

public ShowCharacter(playerid)
{
	if(IsPlayerConnected(playerid))
	{
        new string[256];
		new Account1[64];
		new Account2[64];
		new Account3[64];
		format(string, sizeof(string), "UCP/Users/%s.ini", playerid);
        new File: UserFile = fopen(string, io_read);
		if ( UserFile )
        {
            new key[ 256 ] , val[ 256 ];
			new Data[ 256 ];
			while ( fread( UserFile , Data , sizeof( Data ) ) )
			{
				key = ini_GetKey( Data );
				if( strcmp( key , "Account1" , true ) == 0 ) { val = ini_GetValue( Data ); strmid(Account1, val, 0, strlen(val)-1, 255); }
				if( strcmp( key , "Account2" , true ) == 0 ) { val = ini_GetValue( Data ); strmid(Account2, val, 0, strlen(val)-1, 255); }
				if( strcmp( key , "Account3" , true ) == 0 ) { val = ini_GetValue( Data ); strmid(Account3, val, 0, strlen(val)-1, 255); }
			}
			fclose(UserFile);
        }
        format(string, sizeof(string), "%s\n%s\n%s\n{00BC2E}Create New Character\n{F81414}Delete Character\n",Account1,Account2,Account3);
	    ShowPlayerDialog(playerid, 699, DIALOG_STYLE_LIST, "Character Select", string, "Select", "Quit" );
	}
}

stock ini_GetKey( line[] )
{
	new keyRes[256];
	keyRes[0] = 0;
    if( strfind( line , "=" , true ) == -1 ) return keyRes;
    strmid( keyRes , line , 0 , strfind( line , "=" , true ) , sizeof( keyRes) );
    return keyRes;
}

stock ini_GetValue( line[] )
{
	new valRes[256];
	valRes[0]=0;
	if( strfind( line , "=" , true ) == -1 ) return valRes;
	strmid( valRes , line , strfind( line , "=" , true )+1 , strlen( line ) , sizeof( valRes ) );
	return valRes;
}