//----------------------------------------------------------
//
//  GRAND LARCENY  1.0
//  A freeroam gamemode for SA-MP 0.3
//
//----------------------------------------------------------

#include <a_samp>
#include <YSI\y_ini>
#include <core>
#include <float>


//--------------REGISTER------------------------------------
#define DIALOG_REGISTER 1
#define DIALOG_LOGIN 2
#define DIALOG_SUCCESS_1 3
#define DIALOG_SUCCESS_2 4
#define PATH "UCP/Users/%s.ini"
//------------------COLOR------------------------------
#define COLOR_WHITE 		0xFFFFFFFF
#define COLOR_NORMAL_PLAYER 0xFFBB7777
#define COL_WHITE "{FFFFFF}"
#define COL_RED "{F81414}"
#define COL_GREEN "{00FF22}"
#define COL_LIGHTBLUE "{00CED1}"

enum pInfo
{
    pPass,
    pCash,
    pAdmin,
    pKills,
    pDeaths,
    Float: Health,
	Float: Armour,
	Float: PosX,
	Float: PosY,
	Float: PosZ,
	Float: Angle
}
new PlayerInfo[MAX_PLAYERS][pInfo];
new File [128];

//----------------------------------------------------------

main()
{
	print("\n---------------------------------------");
	print("Running Grand Larceny - by the SA-MP team\n");
	print("---------------------------------------\n");
}

//----------------------------------------------------------

public OnPlayerConnect(playerid)
{
	resertenum(playerid);	
	format(File, sizeof(File), "UCP/Users/%s.ini", GetName(playerid));
	if(!dini_Exists(File))
    {
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,""COL_WHITE"Login",""COL_WHITE"Ketik Password Anda untuk Login.","Login","Quit");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,""COL_WHITE"Register",""COL_WHITE"Ketik Password anda untuk Registert.","Register","Quit");
    }
 	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    new INI:File = INI_Open(UserPath(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File,"Cash",GetPlayerMoney(playerid));
    INI_WriteInt(File,"Admin",PlayerInfo[playerid][pAdmin]);
    INI_WriteInt(File,"Kills",PlayerInfo[playerid][pKills]);
    INI_WriteInt(File,"Deaths",PlayerInfo[playerid][pDeaths]);
    INI_Close(File);
   	savedatapemain(playerid);
    return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch( dialogid )
    {
        case DIALOG_REGISTER:
        {
            if (!response) return Kick(playerid);
            if(response)
            {
                if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, ""COL_WHITE"Register",""COL_RED"Anda memasukan Password Yang Salah.\n"COL_WHITE"Ketik Password anda untuk membuat akun.","Register","Quit");
                new INI:File = INI_Open(UserPath(playerid));
                INI_SetTag(File,"data");
                INI_WriteInt(File,"Password",udb_hash(inputtext));
                INI_WriteInt(File,"Cash",0);
                INI_WriteInt(File,"Admin",0);
                INI_WriteInt(File,"Kills",0);
                INI_WriteInt(File,"Deaths",0);
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
                INI_Close(File);

                SetSpawnInfo(playerid, 0, 0, 1958.33, 1343.12, 15.36, 269.15, 0, 0, 0, 0, 0, 0);
                SpawnPlayer(playerid);
                ShowPlayerDialog(playerid, DIALOG_SUCCESS_1, DIALOG_STYLE_MSGBOX,""COL_WHITE"Success!",""COL_GREEN"Relog Untuk Menyimpan Data Anda!","Ok","");
                SendClientMessage(playerid, -1, "data pemian berhasil di buat");
            }
        }

        case DIALOG_LOGIN:
        {
            if ( !response ) return Kick ( playerid );
            if( response )
            {
                if(udb_hash(inputtext) == PlayerInfo[playerid][pPass])
                {
                    INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
                    GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);
                    ShowPlayerDialog(playerid, DIALOG_SUCCESS_2, DIALOG_STYLE_MSGBOX,""COL_WHITE"Success!",""COL_GREEN"Anda Berhasil Login!","Ok","");
                }
                else
                {
                    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT,""COL_WHITE"Login",""COL_RED"Kamu Memasukan Password yang salah.\n"COL_WHITE"Ketik Password Anda Untuk Login.","Login","Quit");
                }
                return 1;
            }
        }
    }
    return 1;
}

//----------------------------------------------------------

public OnPlayerSpawn(playerid)
{
	return 1;
}

//----------------------------------------------------------

public OnPlayerDeath(playerid, killerid, reason)
{
    PlayerInfo[killerid][pKills]++;
    PlayerInfo[playerid][pDeaths]++;
   	return 1;
}

//----------------------------------------------------------

//----------------------------------------------------------
// Used to init textdraws of city names


//----------------------------------------------------------


//----------------------------------------------------------


//----------------------------------------------------------

//----------------------------------------------------------


//----------------------------------------------------------


//----------------------------------------------------------

public OnPlayerRequestClass(playerid, classid)
{
    
	return 0;
}

//----------------------------------------------------------

public OnGameModeInit()
{
	return 1;
}

//----------------------------------------------------------

public OnPlayerUpdate(playerid)
{

	return 1;
}

//------------SISTEM REGISTER-------------------------------------
forward LoadUser_data(playerid,name[],value[]);
public LoadUser_data(playerid,name[],value[])
{
    INI_Int("Password",PlayerInfo[playerid][pPass]);
    INI_Int("Cash",PlayerInfo[playerid][pCash]);
    INI_Int("Admin",PlayerInfo[playerid][pAdmin]);
    INI_Int("Kills",PlayerInfo[playerid][pKills]);
    INI_Int("Deaths",PlayerInfo[playerid][pDeaths]);
    return 1;
}

stock UserPath(playerid)
{
    new string[128],playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),PATH,playername);
    return string;
}

//
stock udb_hash(buf[]) {
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

resertenum(playerid)
{
	pInfo[playerid][Int] = 0;
	pInfo[playerid][VW] = 0;
	pInfo[playerid][Skin] = 0;
}