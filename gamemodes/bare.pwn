#include <a_samp>
#include <core>
#include <float>
#include <dutils>
#include <Dini>
#include <dudb>
#pragma tabsize 0
#pragma unused ret_memcpy

#define Dialog_register 1
#define Dialog_login 	2
#define Dialog_konfrim 	3

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

main()
{
	print("\n----------------------------------");
	print("  Bare Script\n");
	print("----------------------------------\n");
}

public OnPlayerConnect(playerid)
{
	GameTextForPlayer(playerid,"~w~SA-MP: ~r~Bare Script",5000,5);
	resertenum(playerid);	
	format(File, sizeof(File), "Users/%s.ini", GetName(playerid));
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
				format(File, sizeof(File), "Users/%s.ini", GetName(playerid));
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
				//format(string,sizeof(string),"{2F70D0}______________________________\n{FF0000}Nama: {15FF00}%s\n{FF0000}Password: {15FF00}%s\n{2F70D0}______________________________",GetName(playerid),inputtext);
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
			format(File, sizeof(File), "Users/%s.ini", GetName(playerid));
			format(pass, sizeof(pass), "%s", dini_Get(File, "Password"));
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

			SetTimer("loaddatapemain", 1000, true);
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

stock GetName(playerid)
{
	new name [ 32 ];
	GetPlayerName(playerid, name, sizeof( name));
	return name;
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
	format(File, sizeof(File), "Users/%s.ini", GetName(playerid));
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