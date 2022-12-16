/*                                                                            //
                            Zero_Cool Scripts 2013
                               ZeroHouse V1.0
                                by Zero_Cool

                - Credits to DracoBlue for udb_hash and dini. -
                       - Credits to Y_Less for foreach. -
                   - Credits to CrazyBob for Idea for TdMenu. -
                     - Credits to Incognito for streamer. -
              		      - Credits to Zeex for ZCMD -
*/                                                                            //

#include <a_samp>
#include <TdMenu2> //Credits to CrazyBob for Idea
#include <foreach> 
#include <dini>
#include <streamer>
#include <ZCMD>
#include "../include/gl_common.inc"

#define HDIALOGID   2000
#define HMENUID     1

#define hPath  "ZeroHouses/Houses/%d.ini"
#define iPath  "ZeroHouses/Interiors/%d.ini"
#define uPath  "ZeroHouses/Users/%s.ini"

#define hText "{298ACF}House Name:{FFFFFF}%s\n{298ACF}House Owner:{FFFFFF}%s\n{298ACF}House Price:{FFFFFF}$%d\n{298ACF}House For Sale:{FFFFFF}%s\n{298ACF}House Privacy:{FFFFFF}%s"

#define INVALID_HOUSE_NAME "House For Sale!"

#define MAX_HOUSES      	100
#define MAX_INTERIORS   	10
#define MAX_DIST        	10
#define	MAX_HOUSE_OWNED 	2
#define	MIN_HOUSE_PRICE 	500000
#define	MAX_HOUSE_PRICE 	50000000
#define SPAWN_IN_HOUSE 		true

#define Loop(%0,%1,%2) for(new %0 = %2; %0 < %1; %0++)
#define IsPlayerInHouse(%1,%2) if(!strcmp(HouseInfo[%2][hOwner], pName(%1), true)) if(IsPlayerInHouse[%1][%2] == 1)
#define IsOwner(%1,%2) if(!strcmp(HouseInfo[%2][hOwner], pName(%1), true))

enum hInfo
{
hName[256],
hOwner[256],
hPrice,
vModel,
hInt,
hStorage,
hForSale,
hSalePrice,
hPrivacy,
hPassword,
Float:hCpX,
Float:hCpY,
Float:hCpZ,
Float:hSpawnOutX,
Float:hSpawnOutY,
Float:hSpawnOutZ,
Float:hSpawnOutA,
Float:hVehX,
Float:hVehY,
Float:hVehZ,
Float:hVehA,
Text3D:Text
}

enum iData
{
iIntid,
Float:iCpX,
Float:iCpY,
Float:iCpZ,
Float:iSpawnX,
Float:iSpawnY,
Float:iSpawnZ,
Float:iSpawnA
}

new Interior[MAX_INTERIORS][iData],
HouseInfo[MAX_HOUSES][hInfo],
HouseCar[MAX_HOUSES],HouseIcon[MAX_HOUSES],
hCpOut[MAX_HOUSES],hCpIn[MAX_HOUSES],
CH = 0,CI = 0,FirstSpawn[MAX_PLAYERS],
IsPlayerInHouse[MAX_PLAYERS][MAX_HOUSES],
Iterator:Houses<MAX_HOUSES>;

public OnFilterScriptInit()
{
	print("\n-----------------Loading-----------------\n");
	print("House System V1.0 by (Emrah Malkic)Zero_Cool\n");
	
	LoadInteriors();
	LoadHouses();
	
	CreateTdMenu(HMENUID,"~g~House Menu",6);
	AddTdMenuItem(HMENUID,1,"Set House Name");
	AddTdMenuItem(HMENUID,2,"House Selling");
	AddTdMenuItem(HMENUID,3,"House Storage");
	AddTdMenuItem(HMENUID,4,"House Password");
	AddTdMenuItem(HMENUID,5,"Toggle House Privacy");
	//AddTdMenuItem(HMENUID,6,"House Security");
	
	CreateTdMenuInPut(HMENUID+1,"~g~Set House Name");
	AddTdMenuInfoRowText(HMENUID+1,2,"Set New House Name:");
	
	CreateTdMenu(HMENUID+2,"~g~House Selling",3);
	AddTdMenuItem(HMENUID+2,1,"Set House For Sale");
	AddTdMenuItem(HMENUID+2,2,"Cancel Active House Sale");
	AddTdMenuItem(HMENUID+2,3,"Sell House");
	
	CreateTdMenu(HMENUID+3,"~g~House Storage",3);
    AddTdMenuItem(HMENUID+3,1,"Withdraw Money");
    AddTdMenuItem(HMENUID+3,2,"Deposit Money");
    AddTdMenuItem(HMENUID+3,3,"Check Balance");
    
    CreateTdMenuInPut(HMENUID+4,"~g~Withdraw Money");
	AddTdMenuInfoRowText(HMENUID+4,2,"Type in the amount you want to withdraw below:");
	
    CreateTdMenuInPut(HMENUID+5,"~g~Deposit Money");
	AddTdMenuInfoRowText(HMENUID+5,2,"Type in the amount you want to deposit below:");
	
	CreateTdMenuInPut(HMENUID+6,"~g~Balance");
	
	
    CreateTdMenu(HMENUID+7,"~g~House Password",2);
    AddTdMenuItem(HMENUID+7,1,"Set House Password");
    AddTdMenuItem(HMENUID+7,2,"Remove House Password");
    
    CreateTdMenuInPut(HMENUID+8,"~g~Set House Password");
    AddTdMenuInfoRowText(HMENUID+8,2,"Type In The New House Password Below:");
    
    CreateTdMenu(HMENUID+9,"~g~House Privacy",2);
    AddTdMenuItem(HMENUID+9,1,"Open House For Visitors");
    AddTdMenuItem(HMENUID+9,2,"Close House For Visitors");
    
    CreateTdMenuInPut(HMENUID+10,"~g~Set House For Sale");
    AddTdMenuInfoRowText(HMENUID+10,1,"Type in how much you want to");
    AddTdMenuInfoRowText(HMENUID+10,2,"sell your house for below:");
    
    CreateTdMenu(HMENUID+11,"~g~House Menu",1);
    AddTdMenuItem(HMENUID+11,1,"Enter House Using Password");
    
    CreateTdMenu(HMENUID+12,"~g~House Menu",2);
    AddTdMenuItem(HMENUID+12,1,"Enter House");
    AddTdMenuItem(HMENUID+12,2,"Enter House Using Password");
    
    CreateTdMenu(HMENUID+13,"~g~House Menu",2);
    AddTdMenuItem(HMENUID+13,1,"Buy House");
    AddTdMenuItem(HMENUID+13,2,"Enter House Using Password");
    
    CreateTdMenu(HMENUID+14,"~g~House Menu",3);
    AddTdMenuItem(HMENUID+14,1,"Buy House");
    AddTdMenuItem(HMENUID+14,2,"Enter House Using Password");
    AddTdMenuItem(HMENUID+14,3,"Enter House");
    
    CreateTdMenu(HMENUID+15,"~g~House Menu",1);
    AddTdMenuItem(HMENUID+15,1,"Buy House");
    
    CreateTdMenu(HMENUID+16,"~g~House Menu",2);
    AddTdMenuItem(HMENUID+16,1,"Buy House");
    AddTdMenuItem(HMENUID+16,2,"Enter House");
    
    CreateTdMenu(HMENUID+17,"~g~House Menu",1);
    AddTdMenuItem(HMENUID+17,1,"Enter House");
    
    CreateTdMenuInPut(HMENUID+18,"~g~House Menu");
    AddTdMenuInfoRowText(HMENUID+18,1,"Enter The Password For");
    AddTdMenuInfoRowText(HMENUID+18,2,"The House Below If You Wish To Enter:");
	print("-----------------Loaded-----------------\n");
	return 1;
}
//
public OnPlayerConnect(playerid)
{
	FirstSpawn[playerid] = 1;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    FirstSpawn[playerid] = 1;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	LoadUserFile(playerid);
 	#if SPAWN_IN_HOUSE == true
		if(FirstSpawn[playerid] == 1)
		{
      		SetTimerEx("SpawnPlayerInHouse",100,0,"d",playerid);
      		FirstSpawn[playerid] = 0;
		}
 	#endif
	return 1;
}
new Index;
CMD:chouse(playerid, params[])
{
    new tmp[256];
	tmp = strtok(params,Index);
	new tmp2[256];
	tmp2 = strtok(params,Index);
	if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid,-1,"Use: /chouse [price] [intid]");
	new id = strval(tmp2);
	new Price = strval(tmp);
	if(Price <= 0)
	return SendClientMessage(playerid,-1,"Invalid house price. The house price must be between $"#MIN_HOUSE_PRICE" and $"#MAX_HOUSE_PRICE"");
	CreateHouse(playerid,GetFreeHouseID(),Price,id);
	SendClientMessage(playerid,-1,"House Created");
    return 1;
}
CMD:addcar(playerid, params[])
{
	new tmp[256];
	tmp = strtok(params,Index);
	new hid = strval(tmp);
	if(IsPlayerInAnyVehicle(playerid))
	{
		new Float:X,Float:Y,Float:Z,Float:Angle;
		GetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);
		GetVehicleZAngle(GetPlayerVehicleID(playerid), Angle);
		new model = GetVehicleModel(GetPlayerVehicleID(playerid));
		dini_IntSet(HouseFile(hid),"vModel",model);
		dini_FloatSet(HouseFile(hid),"vX",X);
		dini_FloatSet(HouseFile(hid),"vY",Y);
		dini_FloatSet(HouseFile(hid),"vZ",Z);
		dini_FloatSet(HouseFile(hid),"vAng",Angle);
		}
		else return SendClientMessage(playerid,-1,"You need to be in a vehicle to add a house car");
    return 1;
}
CMD:removehouse(playerid, params[])
{
	new tmp[256];
	tmp = strtok(params,Index);
	new hid = strval(tmp);
	if(dini_Exists(HouseFile(hid)))
	{
		foreach(Player, i)
	   	{
	   		if(IsPlayerInHouse[i][hid] == 1)
	   		{
				ExitPlayerFromHouse(i,hid);
			}
		}
		Delete3DTextLabel(HouseInfo[hid][Text]);
		DestroyDynamicCP(hCpOut[hid]);
		IsValidDynamicCP(hCpIn[hid]);
		dini_Remove(HouseFile(hid));
	}
    return 1;
}
CMD:houseinfo(playerid, params[])
{
    foreach(Houses, hid)
   	{
		if(IsPlayerInRangeOfPoint(playerid,6.0,HouseInfo[hid][hCpX],HouseInfo[hid][hCpY],HouseInfo[hid][hCpZ]))
		{
		    if(HouseInfo[hid][hForSale] || !strcmp(HouseInfo[hid][hOwner], pName(playerid), true))
		    {
		    	new string[256];
				new hCar;
				if(!HouseInfo[hid][vModel]) hCar = 0;
				else hCar = 1;
			   	format(string,sizeof(string),
				"{298ACF}House Name:{FFFFFF} %s\n{298ACF}House Owner:{FFFFFF} %s\n{298ACF}House Price:{FFFFFF} $%d\n{298ACF}House For Sale:{FFFFFF} %s\n{298ACF}House Privacy:{FFFFFF} %s\n{298ACF}House Car:{FFFFFF} %s",
				HouseInfo[hid][hName],
				HouseInfo[hid][hOwner],
				HouseInfo[hid][hPrice],
				YesOrNo(HouseInfo[hid][hForSale]),
				OpenOrClose(HouseInfo[hid][hPrivacy]),
				YesOrNo(hCar));
				ShowPlayerDialog(playerid,100,DIALOG_STYLE_MSGBOX,"{298ACF}House Info",string,"OK","");
			}
			else SendClientMessage(playerid,-1,"This house is not for sale.");
		}
	}
    return 1;
}
forward SpawnPlayerInHouse(playerid);
public SpawnPlayerInHouse(playerid)
{
    foreach(Houses, hid)
   	{
        IsOwner(playerid,hid)
        {
            SetPVarInt(playerid,"pHouseID",hid);
            IsPlayerInHouse[playerid][hid] = 1;
            hCpIn[hid] = CreateDynamicCP(Interior[HouseInfo[hid][hInt]][iCpX],Interior[HouseInfo[hid][hInt]][iCpY],Interior[HouseInfo[hid][hInt]][iCpZ],1.5,-1,-1,-1,10);
			SetPlayerInInterior(playerid,HouseInfo[hid][hInt]);
        }
   	}
}

stock GetPlayerID(const Name[])
{
	for(new i; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        new p_Name[MAX_PLAYER_NAME];
	        GetPlayerName(i, p_Name, sizeof(p_Name));
	        if(strcmp(Name, p_Name, true)==0)
	        {
	            return i;
	        }
	    }
	}
	return -1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_SUBMISSION)
	{
		foreach(Houses, hid)
    	{
   			IsPlayerInHouse(playerid,hid)
    		{
    			ShowTdMenu(playerid,HMENUID);
			}
		}
	}
	return 1;
}
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		foreach(Houses, hid)
    	{
			if(checkpointid == hCpOut[hid])
			{
			    SetPVarInt(playerid,"pHouseID",hid);
 				IsOwner(playerid,hid)
 				{
					IsPlayerInHouse[playerid][hid] = 1;
					hCpIn[hid] = CreateDynamicCP(Interior[HouseInfo[hid][hInt]][iCpX],Interior[HouseInfo[hid][hInt]][iCpY],Interior[HouseInfo[hid][hInt]][iCpZ],1.5,-1,-1,-1,10);
					SetPlayerInInterior(playerid,HouseInfo[hid][hInt]);
				}
				else
				{
					if(HouseInfo[hid][hPassword] != udb_hash("INVALID_PASSWORD") && HouseInfo[hid][hForSale] == 0)
					{
						switch(HouseInfo[hid][hPrivacy])
						{
							case 0:{ShowTdMenu(playerid,HMENUID+11);}//ShowDialog(playerid,HDIALOGID+10,0,"House Menu","Enter House Using Password");
							case 1:{ShowTdMenu(playerid,HMENUID+12);}//ShowDialog(playerid,HDIALOGID+10,0,"House Menu","Enter House\nEnter House Using Password");}
						}
						return 1;
					}
					if(HouseInfo[hid][hPassword] == udb_hash("INVALID_PASSWORD") && HouseInfo[hid][hForSale] == 0)
					{
						switch(HouseInfo[hid][hPrivacy])
						{
							case 0:{}
							case 1:{ShowTdMenu(playerid,HMENUID+17);}//ShowDialog(playerid,HDIALOGID+10,0,"House Menu","Enter House");}
						}
						return 1;
					}
					if(HouseInfo[hid][hForSale] == 1)
					{
                		if(HouseInfo[hid][hPassword] != udb_hash("INVALID_PASSWORD"))
						{
							switch(HouseInfo[hid][hPrivacy])
							{
								case 0:{ShowTdMenu(playerid,HMENUID+13);}//ShowDialog(playerid,HDIALOGID+13,0,"House Menu","Buy House\nEnter House Using Password");}
								case 1:{ShowTdMenu(playerid,HMENUID+14);}//ShowDialog(playerid,HDIALOGID+13,0,"House Menu","Buy House\nEnter House Using Password\nEnter House");}
							}
                			return 1;
						}
    					if(HouseInfo[hid][hPassword] == udb_hash("INVALID_PASSWORD"))
						{
							switch(HouseInfo[hid][hPrivacy])
							{
								case 0:{ShowTdMenu(playerid,HMENUID+15);}//ShowDialog(playerid,HDIALOGID+14,0,"House Menu","Buy House");}
								case 1:{ShowTdMenu(playerid,HMENUID+16);}//ShowDialog(playerid,HDIALOGID+14,0,"House Menu","Buy House\nEnter House");}
							}
						}
					}
				}
			}
			
			if(checkpointid == hCpIn[GetPVarInt(playerid,"pHouseID")])
			{
				ExitPlayerFromHouse(playerid,GetPVarInt(playerid,"pHouseID"));
			}
		}
	}
	return 1;
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    foreach(Houses, h)
		{
		    if(checkpointid == hCpOut[h])
		    {
				HideCurrentTdMenu(playerid);
		    }
	    }
	}
	return 1;
}

public OnPlayerTdMenuUsed(playerid,menuid,row)
{
	new hid = GetPVarInt(playerid,"pHouseID");
	if(menuid == HMENUID+16)
	{
		if(row == 1)
		{
			if(IsPlayerInDynamicCP(playerid,hCpOut[hid]))
			{
				if(HouseInfo[hid][hForSale] == 1  && HouseInfo[hid][hSalePrice] == 0)
				{
					new str[256]; format(str,sizeof(str),"You already own %d house%s.",MAX_HOUSE_OWNED,AddS(MAX_HOUSE_OWNED));
				    if(GetOwnedHouses(playerid) > MAX_HOUSE_OWNED) return SendClientMessage(playerid,-1,str);
					if(GetPlayerMoney(playerid) < HouseInfo[hid][hPrice]) return SendClientMessage(playerid,-1,"You can not afford to buy this house.");
					format(HouseInfo[hid][hName], sizeof(str), "%s's House", pName(playerid));
					dini_Set(HouseFile(hid),"HouseName",HouseInfo[hid][hName]);
					format(HouseInfo[hid][hOwner], MAX_PLAYER_NAME, "%s", pName(playerid));
					dini_Set(HouseFile(hid),"Owner",HouseInfo[hid][hOwner]);
					dini_IntSet(HouseFile(hid),"HouseForSale",0);
					HouseInfo[hid][hForSale] = 0;
					GivePlayerMoney(playerid, -HouseInfo[hid][hPrice]);
					format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hPrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
					Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
					DestroyDynamicMapIcon(HouseIcon[hid]);
					HideCurrentTdMenu(playerid);
					HouseIcon[hid] = CreateDynamicMapIcon(HouseInfo[hid][hCpX],HouseInfo[hid][hCpY],HouseInfo[hid][hCpZ],32,-1);
				}
				else if(HouseInfo[hid][hForSale] == 1  && HouseInfo[hid][hSalePrice] > 0)
				{
				    new str[256]; format(str,sizeof(str),"You already own %d house%s.",MAX_HOUSE_OWNED,AddS(MAX_HOUSE_OWNED));
				    if(GetOwnedHouses(playerid) > MAX_HOUSE_OWNED) return SendClientMessage(playerid,-1,str);
				    if(GetPlayerMoney(playerid) < HouseInfo[hid][hSalePrice]) return SendClientMessage(playerid,-1,"You can not afford to buy this house.");
					new ID = GetPlayerID(HouseInfo[hid][hOwner]);
					if(IsPlayerConnected(ID))
					{
						GivePlayerMoney(ID, HouseInfo[hid][hSalePrice]);
					}
					else
					{
						new file[128];
						format(file, sizeof(file), uPath, HouseInfo[hid][hOwner]);
						if(!dini_Exists(file))
						{
							dini_Create(file);
						}
						dini_Set(file,"HouseName",HouseInfo[hid][hName]);
						dini_Set(file,"Buyer",pName(playerid));
						dini_IntSet(file,"MoneyToPlayer",HouseInfo[hid][hSalePrice]);
						dini_IntSet(file,"MoneyToHouse",HouseInfo[hid][hStorage]);
					}
					format(HouseInfo[hid][hName], sizeof(str), "%s's House", pName(playerid));
					dini_Set(HouseFile(hid),"HouseName",HouseInfo[hid][hName]);
					format(HouseInfo[hid][hOwner], MAX_PLAYER_NAME, "%s", pName(playerid));
					dini_Set(HouseFile(hid),"Owner",HouseInfo[hid][hOwner]);
					dini_IntSet(HouseFile(hid),"HouseForSale",0);
					HouseInfo[hid][hStorage] = 0;
					dini_IntSet(HouseFile(hid),"HouseStorage",0);
					HouseInfo[hid][hPassword] = udb_hash("INVALID_PASSWORD");
					dini_IntSet(HouseFile(hid),"HousePassword",HouseInfo[hid][hPassword]);
					HouseInfo[hid][hForSale] = 0;
					GivePlayerMoney(playerid, -HouseInfo[hid][hSalePrice]);
					format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hPrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
					Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
					DestroyDynamicMapIcon(HouseIcon[hid]);
					HideCurrentTdMenu(playerid);
					HouseIcon[hid] = CreateDynamicMapIcon(HouseInfo[hid][hCpX],HouseInfo[hid][hCpY],HouseInfo[hid][hCpZ],32,-1);
				}
			}
		}
		if(row == 2)
		{
			IsPlayerInHouse[playerid][hid] = 1;
			hCpIn[hid] = CreateDynamicCP(Interior[HouseInfo[hid][hInt]][iCpX],Interior[HouseInfo[hid][hInt]][iCpY],Interior[HouseInfo[hid][hInt]][iCpZ],1.5,-1,-1,-1,10);
			SetPlayerInInterior(playerid,HouseInfo[hid][hInt]);
			HideTdMenu(playerid,HMENUID+16);
		}
	}
	if(menuid == HMENUID+15)
	{
		if(row == 1)
		{
			if(IsPlayerInDynamicCP(playerid,hCpOut[hid]))
			{
				if(HouseInfo[hid][hForSale] == 1  && HouseInfo[hid][hSalePrice] == 0)
				{
				    new str[256]; format(str,sizeof(str),"You already own %d house%s.",MAX_HOUSE_OWNED,AddS(MAX_HOUSE_OWNED));
				    if(GetOwnedHouses(playerid) > MAX_HOUSE_OWNED) return SendClientMessage(playerid,-1,str);
					if(GetPlayerMoney(playerid) < HouseInfo[hid][hPrice]) return SendClientMessage(playerid,-1,"You can not afford to buy this house.");
					format(HouseInfo[hid][hName], sizeof(str), "%s's House", pName(playerid));
					dini_Set(HouseFile(hid),"HouseName",HouseInfo[hid][hName]);
					format(HouseInfo[hid][hOwner], MAX_PLAYER_NAME, "%s", pName(playerid));
					dini_Set(HouseFile(hid),"Owner",HouseInfo[hid][hOwner]);
					dini_IntSet(HouseFile(hid),"HouseForSale",0);
					HouseInfo[hid][hForSale] = 0;
					GivePlayerMoney(playerid, -HouseInfo[hid][hPrice]);
					format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hPrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
					Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
					DestroyDynamicMapIcon(HouseIcon[hid]);
					HideCurrentTdMenu(playerid);
					HouseIcon[hid] = CreateDynamicMapIcon(HouseInfo[hid][hCpX],HouseInfo[hid][hCpY],HouseInfo[hid][hCpZ],32,-1);
				}
				else if(HouseInfo[hid][hForSale] == 1  && HouseInfo[hid][hSalePrice] > 0)
				{
				    new str[256]; format(str,sizeof(str),"You already own %d house%s.",MAX_HOUSE_OWNED,AddS(MAX_HOUSE_OWNED));
				    if(GetOwnedHouses(playerid) > MAX_HOUSE_OWNED) return SendClientMessage(playerid,-1,str);
				    if(GetPlayerMoney(playerid) < HouseInfo[hid][hSalePrice]) return SendClientMessage(playerid,-1,"You can not afford to buy this house.");
					new ID = GetPlayerID(HouseInfo[hid][hOwner]);
					if(IsPlayerConnected(ID))
					{
						GivePlayerMoney(ID, HouseInfo[hid][hSalePrice]);
					}
					else
					{
						new file[128];
						format(file, sizeof(file), uPath, HouseInfo[hid][hOwner]);
						if(!dini_Exists(file))
						{
							dini_Create(file);
						}
						dini_Set(file,"HouseName",HouseInfo[hid][hName]);
						dini_Set(file,"Buyer",pName(playerid));
						dini_IntSet(file,"MoneyToPlayer",HouseInfo[hid][hSalePrice]);
						dini_IntSet(file,"MoneyToHouse",HouseInfo[hid][hStorage]);
					}
					format(HouseInfo[hid][hName], sizeof(str), "%s's House", pName(playerid));
					dini_Set(HouseFile(hid),"HouseName",HouseInfo[hid][hName]);
					format(HouseInfo[hid][hOwner], MAX_PLAYER_NAME, "%s", pName(playerid));
					dini_Set(HouseFile(hid),"Owner",HouseInfo[hid][hOwner]);
					dini_IntSet(HouseFile(hid),"HouseForSale",0);
					HouseInfo[hid][hStorage] = 0;
					dini_IntSet(HouseFile(hid),"HouseStorage",0);
					HouseInfo[hid][hPassword] = udb_hash("INVALID_PASSWORD");
					dini_IntSet(HouseFile(hid),"HousePassword",HouseInfo[hid][hPassword]);
					HouseInfo[hid][hForSale] = 0;
					GivePlayerMoney(playerid, -HouseInfo[hid][hSalePrice]);
					format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hPrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
					Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
					DestroyDynamicMapIcon(HouseIcon[hid]);
					HideCurrentTdMenu(playerid);
					HouseIcon[hid] = CreateDynamicMapIcon(HouseInfo[hid][hCpX],HouseInfo[hid][hCpY],HouseInfo[hid][hCpZ],32,-1);
				}
			}
		}
	}
	if(menuid == HMENUID+14)
	{
		if(row == 1)
		{
			if(IsPlayerInDynamicCP(playerid,hCpOut[hid]))
			{
				if(HouseInfo[hid][hForSale] == 1  && HouseInfo[hid][hSalePrice] == 0)
				{
				    new str[256]; format(str,sizeof(str),"You already own %d house%s.",MAX_HOUSE_OWNED,AddS(MAX_HOUSE_OWNED));
				    if(GetOwnedHouses(playerid) > MAX_HOUSE_OWNED) return SendClientMessage(playerid,-1,str);
					if(GetPlayerMoney(playerid) < HouseInfo[hid][hPrice]) return SendClientMessage(playerid,-1,"You can not afford to buy this house.");
					format(HouseInfo[hid][hName], sizeof(str), "%s's House", pName(playerid));
					dini_Set(HouseFile(hid),"HouseName",HouseInfo[hid][hName]);
					format(HouseInfo[hid][hOwner], MAX_PLAYER_NAME, "%s", pName(playerid));
					dini_Set(HouseFile(hid),"Owner",HouseInfo[hid][hOwner]);
					dini_IntSet(HouseFile(hid),"HouseForSale",0);
					HouseInfo[hid][hForSale] = 0;
					GivePlayerMoney(playerid, -HouseInfo[hid][hPrice]);
					format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hPrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
					Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
					DestroyDynamicMapIcon(HouseIcon[hid]);
					HideCurrentTdMenu(playerid);
					HouseIcon[hid] = CreateDynamicMapIcon(HouseInfo[hid][hCpX],HouseInfo[hid][hCpY],HouseInfo[hid][hCpZ],32,-1);
				}
				else if(HouseInfo[hid][hForSale] == 1  && HouseInfo[hid][hSalePrice] > 0)
				{
				    new str[256]; format(str,sizeof(str),"You already own %d house%s.",MAX_HOUSE_OWNED,AddS(MAX_HOUSE_OWNED));
				    if(GetOwnedHouses(playerid) > MAX_HOUSE_OWNED) return SendClientMessage(playerid,-1,str);
				    if(GetPlayerMoney(playerid) < HouseInfo[hid][hSalePrice]) return SendClientMessage(playerid,-1,"You can not afford to buy this house.");
					new ID = GetPlayerID(HouseInfo[hid][hOwner]);
					if(IsPlayerConnected(ID))
					{
						GivePlayerMoney(ID, HouseInfo[hid][hSalePrice]);
					}
					else
					{
						new file[128];
						format(file, sizeof(file), uPath, HouseInfo[hid][hOwner]);
						if(!dini_Exists(file))
						{
							dini_Create(file);
						}
						dini_Set(file,"HouseName",HouseInfo[hid][hName]);
						dini_Set(file,"Buyer",pName(playerid));
						dini_IntSet(file,"MoneyToPlayer",HouseInfo[hid][hSalePrice]);
						dini_IntSet(file,"MoneyToHouse",HouseInfo[hid][hStorage]);
					}
					format(HouseInfo[hid][hName], sizeof(str), "%s's House", pName(playerid));
					dini_Set(HouseFile(hid),"HouseName",HouseInfo[hid][hName]);
					format(HouseInfo[hid][hOwner], MAX_PLAYER_NAME, "%s", pName(playerid));
					dini_Set(HouseFile(hid),"Owner",HouseInfo[hid][hOwner]);
					dini_IntSet(HouseFile(hid),"HouseForSale",0);
					HouseInfo[hid][hStorage] = 0;
					dini_IntSet(HouseFile(hid),"HouseStorage",0);
					HouseInfo[hid][hPassword] = udb_hash("INVALID_PASSWORD");
					dini_IntSet(HouseFile(hid),"HousePassword",HouseInfo[hid][hPassword]);
					HouseInfo[hid][hForSale] = 0;
					GivePlayerMoney(playerid, -HouseInfo[hid][hSalePrice]);
					format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hPrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
					Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
					DestroyDynamicMapIcon(HouseIcon[hid]);
					HideCurrentTdMenu(playerid);
					HouseIcon[hid] = CreateDynamicMapIcon(HouseInfo[hid][hCpX],HouseInfo[hid][hCpY],HouseInfo[hid][hCpZ],32,-1);
				}
			}
		}
		if(row == 2)
		{
			ShowTdMenu(playerid,HMENUID+18);
		}
		if(row == 3)
		{
			IsPlayerInHouse[playerid][hid] = 1;
			hCpIn[hid] = CreateDynamicCP(Interior[HouseInfo[hid][hInt]][iCpX],Interior[HouseInfo[hid][hInt]][iCpY],Interior[HouseInfo[hid][hInt]][iCpZ],1.5,-1,-1,-1,10);
			SetPlayerInInterior(playerid,HouseInfo[hid][hInt]);
			HideTdMenu(playerid,HMENUID+14);
		}
	}
	if(menuid == HMENUID+13)
	{
		if(row == 1)
		{
			if(IsPlayerInDynamicCP(playerid,hCpOut[hid]))
			{
				if(HouseInfo[hid][hForSale] == 1  && HouseInfo[hid][hSalePrice] == 0)
				{
				    new str[256]; format(str,sizeof(str),"You already own %d house%s.",MAX_HOUSE_OWNED,AddS(MAX_HOUSE_OWNED));
				    if(GetOwnedHouses(playerid) > MAX_HOUSE_OWNED) return SendClientMessage(playerid,-1,str);
					if(GetPlayerMoney(playerid) < HouseInfo[hid][hPrice]) return SendClientMessage(playerid,-1,"You can not afford to buy this house.");
					format(HouseInfo[hid][hName], sizeof(str), "%s's House", pName(playerid));
					dini_Set(HouseFile(hid),"HouseName",HouseInfo[hid][hName]);
					format(HouseInfo[hid][hOwner], MAX_PLAYER_NAME, "%s", pName(playerid));
					dini_Set(HouseFile(hid),"Owner",HouseInfo[hid][hOwner]);
					dini_IntSet(HouseFile(hid),"HouseForSale",0);
					HouseInfo[hid][hForSale] = 0;
					GivePlayerMoney(playerid, -HouseInfo[hid][hPrice]);
					format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hPrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
					Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
					DestroyDynamicMapIcon(HouseIcon[hid]);
					HideCurrentTdMenu(playerid);
					HouseIcon[hid] = CreateDynamicMapIcon(HouseInfo[hid][hCpX],HouseInfo[hid][hCpY],HouseInfo[hid][hCpZ],32,-1);
				}
				else if(HouseInfo[hid][hForSale] == 1  && HouseInfo[hid][hSalePrice] > 0)
				{
				    new str[256]; format(str,sizeof(str),"You already own %d house%s.",MAX_HOUSE_OWNED,AddS(MAX_HOUSE_OWNED));
				    if(GetOwnedHouses(playerid) > MAX_HOUSE_OWNED) return SendClientMessage(playerid,-1,str);
				    if(GetPlayerMoney(playerid) < HouseInfo[hid][hSalePrice]) return SendClientMessage(playerid,-1,"You can not afford to buy this house.");
					new ID = GetPlayerID(HouseInfo[hid][hOwner]);
					if(IsPlayerConnected(ID))
					{
						GivePlayerMoney(ID, HouseInfo[hid][hSalePrice]);
					}
					else
					{
						new file[128];
						format(file, sizeof(file), uPath, HouseInfo[hid][hOwner]);
						if(!dini_Exists(file))
						{
							dini_Create(file);
						}
						dini_Set(file,"HouseName",HouseInfo[hid][hName]);
						dini_Set(file,"Buyer",pName(playerid));
						dini_IntSet(file,"MoneyToPlayer",HouseInfo[hid][hSalePrice]);
						dini_IntSet(file,"MoneyToHouse",HouseInfo[hid][hStorage]);
					}
					format(HouseInfo[hid][hName], sizeof(str), "%s's House", pName(playerid));
					dini_Set(HouseFile(hid),"HouseName",HouseInfo[hid][hName]);
					format(HouseInfo[hid][hOwner], MAX_PLAYER_NAME, "%s", pName(playerid));
					dini_Set(HouseFile(hid),"Owner",HouseInfo[hid][hOwner]);
					dini_IntSet(HouseFile(hid),"HouseForSale",0);
					HouseInfo[hid][hStorage] = 0;
					dini_IntSet(HouseFile(hid),"HouseStorage",0);
					HouseInfo[hid][hPassword] = udb_hash("INVALID_PASSWORD");
					dini_IntSet(HouseFile(hid),"HousePassword",HouseInfo[hid][hPassword]);
					HouseInfo[hid][hForSale] = 0;
					GivePlayerMoney(playerid, -HouseInfo[hid][hSalePrice]);
					format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hPrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
					Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
					DestroyDynamicMapIcon(HouseIcon[hid]);
					HideCurrentTdMenu(playerid);
					HouseIcon[hid] = CreateDynamicMapIcon(HouseInfo[hid][hCpX],HouseInfo[hid][hCpY],HouseInfo[hid][hCpZ],32,-1);
				}
			}
		}
		if(row == 2)
		{
			ShowTdMenu(playerid,HMENUID+18);
		}
	}
	if(menuid == HMENUID+11)
	{
		if(row == 1)
		{
			ShowTdMenu(playerid,HMENUID+18);
		}
	}
	if(menuid == HMENUID+17)
	{
		if(row == 1)
		{
			IsPlayerInHouse[playerid][hid] = 1;
			hCpIn[hid] = CreateDynamicCP(Interior[HouseInfo[hid][hInt]][iCpX],Interior[HouseInfo[hid][hInt]][iCpY],Interior[HouseInfo[hid][hInt]][iCpZ],1.5,-1,-1,-1,10);
			SetPlayerInInterior(playerid,HouseInfo[hid][hInt]);
			HideTdMenu(playerid,HMENUID+17);
		}
	}
	if(menuid == HMENUID+12)
	{
		if(row == 1)
		{
			IsPlayerInHouse[playerid][hid] = 1;
			hCpIn[hid] = CreateDynamicCP(Interior[HouseInfo[hid][hInt]][iCpX],Interior[HouseInfo[hid][hInt]][iCpY],Interior[HouseInfo[hid][hInt]][iCpZ],1.5,-1,-1,-1,10);
			SetPlayerInInterior(playerid,HouseInfo[hid][hInt]);
			HideTdMenu(playerid,HMENUID+12);
		}
		if(row == 2)
		{
			ShowTdMenu(playerid,HMENUID+18);
		}
	}
	if(menuid == HMENUID)
	{
		if(row == 1)
		{
			ShowTdMenu(playerid,HMENUID+1);
		}
		if(row == 2)
		{
			ShowTdMenu(playerid,HMENUID+2);
		}
		if(row == 3)
		{
			ShowTdMenu(playerid,HMENUID+3);
		}
		if(row == 4)
		{
			ShowTdMenu(playerid,HMENUID+7);
		}
		if(row == 5)
		{
			ShowTdMenu(playerid,HMENUID+9);
		}
	}
	if(menuid == HMENUID+2)
	{
		if(row == 1)
		{
	    	ShowTdMenu(playerid,HMENUID+10);
		}
		if(row == 2)
		{
			new str[256];
			HouseInfo[hid][hForSale] = 0;
			HouseInfo[hid][hSalePrice] = 0;
			dini_IntSet(HouseFile(hid),"HouseForSale",0);
			dini_IntSet(HouseFile(hid),"HouseSalePrice",0);
			format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hPrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
			Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
		}
		if(row == 3)
		{
			new str[256];
			new money = (HouseInfo[hid][hPrice] - (HouseInfo[hid][hPrice] / 4));
			GivePlayerMoney(playerid,money);
			format(HouseInfo[hid][hName], sizeof(str), "House For Sale!");
			format(HouseInfo[hid][hOwner], sizeof(str), "No Owner");
			dini_Set(HouseFile(hid),"HouseName","House For Sale!");
			dini_Set(HouseFile(hid),"Owner","No Owner");
			dini_IntSet(HouseFile(hid),"HouseForSale",1);
			HouseInfo[hid][hForSale] = 1;
			format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hPrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
			Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
			ExitPlayerFromHouse(playerid,hid);
			SendClientMessage(playerid,-1,"You sell your house.");
			DestroyDynamicMapIcon(HouseIcon[hid]);
			HouseIcon[hid] = CreateDynamicMapIcon(HouseInfo[hid][hCpX],HouseInfo[hid][hCpY],HouseInfo[hid][hCpZ],31,-1);
		}
	}
	if(menuid == HMENUID+3)
	{
		if(row == 1)
		{
			ShowTdMenu(playerid,HMENUID+4);
		}
		if(row == 2)
		{
			ShowTdMenu(playerid,HMENUID+5);
		}
		if(row == 3)
		{
			new string[256];
			ShowTdMenu(playerid,HMENUID+6);
			format(string, sizeof(string), "You have $%d in your house storage.", HouseInfo[hid][hStorage]);
			AddTdMenuInfoRowText(HMENUID+6,2,string);
		}
	}
	if(menuid == HMENUID+7)
	{
		if(row == 1)
		{
			ShowTdMenu(playerid,HMENUID+8);
		}
		if(row == 2)
		{
			HouseInfo[hid][hPassword] = udb_hash("INVALID_PASSWORD");
			dini_IntSet(HouseFile(hid),"HousePassword",HouseInfo[hid][hPassword]);
			SendClientMessage(playerid,-1,"Successfully Removed");
		}
	}
	if(menuid == HMENUID+9)
	{
		if(row == 1)
		{
			HouseInfo[hid][hPrivacy] = 1;
			dini_IntSet(HouseFile(hid),"HousePrivacy",1);
			new str[256];
			format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hSalePrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
			Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
		}
		if(row == 2)
		{
			HouseInfo[hid][hPrivacy] = 0;
			dini_IntSet(HouseFile(hid),"HousePrivacy",0);
			new str[256];
			format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hSalePrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
			Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
		}
	}
	return 1;
}

public Menu(mid,playerid,value[])
{
	new hid = GetPVarInt(playerid,"pHouseID");
	if(mid == HMENUID+18)
	{
		if(strlen(value))
		{
			if(HouseInfo[hid][hPassword] == udb_hash(value))
			{
				IsPlayerInHouse[playerid][hid] = 1;
				hCpIn[hid] = CreateDynamicCP(Interior[HouseInfo[hid][hInt]][iCpX],Interior[HouseInfo[hid][hInt]][iCpY],Interior[HouseInfo[hid][hInt]][iCpZ],1.5,-1,-1,-1,10);
				SetPlayerInInterior(playerid,HouseInfo[hid][hInt]);
				HideTdMenu(playerid,HMENUID+18);
			}
			else
			{
				SendClientMessage(playerid,-1,"Wrong Password");
			}
		}
	}
	if(mid == HMENUID+1)
	{
		new str[256];
		format(HouseInfo[hid][hName], 256,"%s", value);
		dini_Set(HouseFile(hid),"HouseName",HouseInfo[hid][hName]);
		format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hSalePrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
		Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
		SendClientMessage(playerid,-1,"Successfully Changed");
		ShowTdMenu(playerid,HMENUID);
	}
	if(mid == HMENUID+10)
	{
		new value2 = strval(value);
		HouseInfo[hid][hForSale] = 1;
		HouseInfo[hid][hSalePrice] = value2;
		dini_IntSet(HouseFile(hid),"HouseForSale",1);
		dini_IntSet(HouseFile(hid),"HouseSalePrice",value2);
		new str[256];
		format(str,sizeof(str),hText,HouseInfo[hid][hName],HouseInfo[hid][hOwner],HouseInfo[hid][hSalePrice],YesOrNo(HouseInfo[hid][hForSale]),OpenOrClose(HouseInfo[hid][hPrivacy]));
		Update3DTextLabelText(HouseInfo[hid][Text],-1,str);
		SendClientMessage(playerid,-1,"Successfully Seted");
		ShowTdMenu(playerid,HMENUID+2);
	}
	if(mid == HMENUID+4)
	{
		new value2 = strval(value);
		HouseInfo[hid][hStorage] = (HouseInfo[hid][hStorage] - value2);
		dini_IntSet(HouseFile(hid),"HouseStorage",HouseInfo[hid][hStorage]);
		GivePlayerMoney(playerid, value2);
		SendClientMessage(playerid,-1,"Successfully Withdraw");
		ShowTdMenu(playerid,HMENUID+3);
	}
	if(mid == HMENUID+5)
	{
		new value2 = strval(value);
		HouseInfo[hid][hStorage] = (HouseInfo[hid][hStorage] + value2);
		dini_IntSet(HouseFile(hid),"HouseStorage",HouseInfo[hid][hStorage]);
		GivePlayerMoney(playerid, -value2);
		SendClientMessage(playerid,-1,"Successfully Deposit");
		ShowTdMenu(playerid,HMENUID+3);
	}
	if(mid == HMENUID+8)
	{
		HouseInfo[hid][hPassword] = udb_hash(value);
		dini_IntSet(HouseFile(hid),"HousePassword",HouseInfo[hid][hPassword]);
		SendClientMessage(playerid,-1,"Successfully Seted");
		ShowTdMenu(playerid,HMENUID+7);
	}
}
stock SetPlayerInInterior(playerid,Interiorid)
{
	SetPlayerInterior(playerid,Interior[Interiorid][iIntid]);
	SetPlayerPos(playerid,Interior[Interiorid][iSpawnX],Interior[Interiorid][iSpawnY],Interior[Interiorid][iSpawnZ]);
	SetPlayerFacingAngle(playerid,Interior[Interiorid][iSpawnA]);
	SetCameraBehindPlayer(playerid);
}
stock SetPlayerPosEx(playerid,intrtiorid,Float:x,Float:y,Float:z,Float:ang)
{
	SetPlayerInterior(playerid,intrtiorid);
	SetPlayerPos(playerid,x,y,z);
	SetPlayerFacingAngle(playerid,ang);
	SetCameraBehindPlayer(playerid);
}
stock ExitPlayerFromHouse(playerid,houseid)
{
	if(IsPlayerInHouse[playerid][houseid] == 1)
	{
		DestroyDynamicCP(hCpIn[houseid]);
		SetPlayerPosEx(playerid,0,HouseInfo[houseid][hSpawnOutX],HouseInfo[houseid][hSpawnOutY],HouseInfo[houseid][hSpawnOutZ],HouseInfo[houseid][hSpawnOutA]);
		IsPlayerInHouse[playerid][houseid] = 0;
		DeletePVar(playerid,"pHouseID");
	}
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		foreach(Houses, hid)
		{
			if(GetPlayerVehicleID(playerid) == HouseCar[hid])
			{
				IsOwner(playerid,hid)
				{
					SendClientMessage(playerid,-1,"Welcome Sir");
				}
				else
				{
					RemovePlayerFromVehicle(playerid);
				}
			}
		}
 	}
	return 1;
}

stock Float:GetPosInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	switch(IsPlayerInAnyVehicle(playerid))
	{
	    case 0: GetPlayerFacingAngle(playerid, a);
	    case 1: GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
	return a;
}
stock CreateHouse(playerid,Houseid,Price,Interiorid)
{
    new str[256];
	new Float:X,Float:Y,Float:Z,Float:Angle;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, Angle);
	HouseInfo[Houseid][hInt] = Interiorid;
	HouseInfo[Houseid][hPrice] = Price;
	HouseInfo[Houseid][hCpX] = X;
	HouseInfo[Houseid][hCpY] = Y;
	HouseInfo[Houseid][hCpZ] = Z;
	HouseInfo[Houseid][hForSale] = 1;
	HouseInfo[Houseid][hSalePrice] = Price;
	HouseInfo[Houseid][hPrivacy] = 0;
	HouseInfo[Houseid][hPassword] = udb_hash("INVALID_PASSWORD");
	HouseInfo[Houseid][hStorage] = 0;
	dini_Create(HouseFile(Houseid));
	dini_Set(HouseFile(Houseid),"HouseName","House For Sale!");
	dini_Set(HouseFile(Houseid),"Owner","No Owner");
	dini_IntSet(HouseFile(Houseid),"HouseStorage",0);
	dini_IntSet(HouseFile(Houseid),"HouseSalePrice",Price);
	dini_IntSet(HouseFile(Houseid),"HouseInterior",Interiorid);
	dini_IntSet(HouseFile(Houseid),"HouseForSale",1);
	dini_IntSet(HouseFile(Houseid),"Price",Price);
	dini_IntSet(HouseFile(Houseid),"HousePrivacy",0);
	dini_IntSet(HouseFile(Houseid),"HousePassword",udb_hash("INVALID_PASSWORD"));
	dini_FloatSet(HouseFile(Houseid),"CpX",X);
	dini_FloatSet(HouseFile(Houseid),"CpY",Y);
	dini_FloatSet(HouseFile(Houseid),"CpZ",Z);
	format(HouseInfo[Houseid][hName],35,"House For Sale!");
	format(HouseInfo[Houseid][hOwner],256,"No Owner");
	format(str,sizeof(str),hText,HouseInfo[Houseid][hName],HouseInfo[Houseid][hOwner],Price,YesOrNo(HouseInfo[Houseid][hForSale]),OpenOrClose(HouseInfo[Houseid][hPrivacy]));
	HouseInfo[Houseid][Text] = Create3DTextLabel(str,-1,X, Y, Z+0.7,20,0);
	GetPosInFrontOfPlayer(playerid, X, Y, -2.5);
	dini_FloatSet(HouseFile(Houseid),"SpawnOutX",X);
	dini_FloatSet(HouseFile(Houseid),"SpawnOutY",Y);
	dini_FloatSet(HouseFile(Houseid),"SpawnOutZ",Z);
	dini_FloatSet(HouseFile(Houseid),"SpawnOutAngle", (180.0 + Angle));
	HouseInfo[Houseid][hSpawnOutX] = X;
	HouseInfo[Houseid][hSpawnOutY] = Y;
	HouseInfo[Houseid][hSpawnOutZ] = Z;
	HouseInfo[Houseid][hSpawnOutA] = (180.0 + Angle);
	hCpOut[Houseid] = CreateDynamicCP(HouseInfo[Houseid][hCpX],HouseInfo[Houseid][hCpY],HouseInfo[Houseid][hCpZ],1.5,-1,-1,-1,MAX_DIST);
	hCpIn[Houseid] = CreateDynamicCP(Interior[HouseInfo[Houseid][hInt]][iCpX],Interior[HouseInfo[Houseid][hInt]][iCpY],Interior[HouseInfo[Houseid][hInt]][iCpZ],1.5,-1,-1,-1,MAX_DIST);
	Iter_Add(Houses, Houseid);
}

stock SpawnHouse(Houseid)
{
	hCpOut[Houseid] = CreateDynamicCP(HouseInfo[Houseid][hCpX],HouseInfo[Houseid][hCpY],HouseInfo[Houseid][hCpZ],1.5,-1,-1,-1,MAX_DIST);
	new str[256];
	if(HouseInfo[Houseid][hForSale] == 1)
	{
		format(str,sizeof(str),hText,HouseInfo[Houseid][hName],HouseInfo[Houseid][hOwner],HouseInfo[Houseid][hSalePrice],YesOrNo(HouseInfo[Houseid][hForSale]),OpenOrClose(HouseInfo[Houseid][hPrivacy]));
	}
	else
	{
		format(str,sizeof(str),hText,HouseInfo[Houseid][hName],HouseInfo[Houseid][hOwner],HouseInfo[Houseid][hPrice],YesOrNo(HouseInfo[Houseid][hForSale]),OpenOrClose(HouseInfo[Houseid][hPrivacy]));
	}
	HouseInfo[Houseid][Text] = Create3DTextLabel(str,-1,HouseInfo[Houseid][hCpX],HouseInfo[Houseid][hCpY],HouseInfo[Houseid][hCpZ]+0.7,20,0);
	HouseCar[Houseid] = CreateVehicle(HouseInfo[Houseid][vModel],HouseInfo[Houseid][hVehX],HouseInfo[Houseid][hVehY],HouseInfo[Houseid][hVehZ],HouseInfo[Houseid][hVehA],0,0,9999);
	if(!strcmp(HouseInfo[Houseid][hOwner], "No Owner", true))
	{
		HouseIcon[Houseid] = CreateDynamicMapIcon(HouseInfo[Houseid][hCpX],HouseInfo[Houseid][hCpY],HouseInfo[Houseid][hCpZ],31,-1);
	}
	else
	{
		HouseIcon[Houseid] = CreateDynamicMapIcon(HouseInfo[Houseid][hCpX],HouseInfo[Houseid][hCpY],HouseInfo[Houseid][hCpZ],32,-1);
	}
}

stock LoadHouses()
{
	Loop(Houseid,MAX_HOUSES,0)
	{
		if(fexist(HouseFile(Houseid)))
		{
			format(HouseInfo[Houseid][hName],35,"%s",dini_Get(HouseFile(Houseid),"HouseName"));
			format(HouseInfo[Houseid][hOwner],35,"%s",dini_Get(HouseFile(Houseid),"Owner"));
			HouseInfo[Houseid][hPassword] = dini_Int(HouseFile(Houseid),"HousePassword");
			HouseInfo[Houseid][hInt] = dini_Int(HouseFile(Houseid),"HouseInterior");
			HouseInfo[Houseid][hForSale] = dini_Int(HouseFile(Houseid),"HouseForSale");
			HouseInfo[Houseid][hSalePrice] = dini_Int(HouseFile(Houseid),"HouseSalePrice");
			HouseInfo[Houseid][hPrice] = dini_Int(HouseFile(Houseid),"Price");
			HouseInfo[Houseid][hStorage] = dini_Int(HouseFile(Houseid),"HouseStorage");
			HouseInfo[Houseid][hPrivacy] = dini_Int(HouseFile(Houseid),"HousePrivacy");
			HouseInfo[Houseid][hSpawnOutX] = dini_Float(HouseFile(Houseid),"SpawnOutX");
			HouseInfo[Houseid][hSpawnOutY] = dini_Float(HouseFile(Houseid),"SpawnOutY");
			HouseInfo[Houseid][hSpawnOutZ] = dini_Float(HouseFile(Houseid),"SpawnOutZ");
			HouseInfo[Houseid][hSpawnOutA] = dini_Float(HouseFile(Houseid),"SpawnOutAngle");
			HouseInfo[Houseid][hCpX] = dini_Float(HouseFile(Houseid),"CpX");
			HouseInfo[Houseid][hCpY] = dini_Float(HouseFile(Houseid),"CpY");
			HouseInfo[Houseid][hCpZ] = dini_Float(HouseFile(Houseid),"CpZ");
			HouseInfo[Houseid][vModel] = dini_Int(HouseFile(Houseid),"vModel");
			HouseInfo[Houseid][hVehX] = dini_Float(HouseFile(Houseid),"vX");
			HouseInfo[Houseid][hVehY] = dini_Float(HouseFile(Houseid),"vY");
			HouseInfo[Houseid][hVehZ] = dini_Float(HouseFile(Houseid),"vZ");
			HouseInfo[Houseid][hVehA] = dini_Float(HouseFile(Houseid),"vAng");
			SpawnHouse(Houseid);
			CH ++;
			Iter_Add(Houses, Houseid);
		}
	}
	return printf("Created Houses:%d\n",CH);
}
stock LoadInteriors()
{
	Loop(Intid,MAX_INTERIORS,0)
	{
		if(fexist(InteriorFile(Intid)))
		{
			Interior[Intid][iIntid] = dini_Int(InteriorFile(Intid),"Interior");
			Interior[Intid][iCpX] = dini_Float(InteriorFile(Intid),"CPX");
			Interior[Intid][iCpY] = dini_Float(InteriorFile(Intid),"CPY");
			Interior[Intid][iCpZ] = dini_Float(InteriorFile(Intid),"CPZ");
			Interior[Intid][iSpawnX] = dini_Float(InteriorFile(Intid),"SpawnX");
			Interior[Intid][iSpawnY] = dini_Float(InteriorFile(Intid),"SpawnY");
			Interior[Intid][iSpawnZ] = dini_Float(InteriorFile(Intid),"SpawnZ");
			CI ++;
		}
	}
	return printf("Houses Interiors Created:%d\n",CI);
}

public OnFilterScriptExit()
{
    Iter_Clear(Houses);
	return 1;
}

stock GetFreeHouseID()
{
    Loop(Houseid,MAX_HOUSES,0)
    {
        if(!fexist(HouseFile(Houseid)))
        {
            return Houseid;
		}
	}
    return -1;
}

stock GetOwnedHouses(playerid)
{
	new count;
	foreach(Houses, h)
	{
	    IsOwner(playerid,h)
	    {
     		count++;
		}
	}
	return count;
}

stock LoadUserFile(playerid)
{
	new file[128];
	format(file, sizeof(file), uPath, pName(playerid));
	if(dini_Exists(file))
	{
		new value = (dini_Int(file,"MoneyToPlayer") + dini_Int(file,"MoneyToHouse"));
		GivePlayerMoney(playerid,(dini_Int(file,"MoneyToPlayer") + dini_Int(file,"MoneyToHouse")));
		new str[1000];
		format(str,sizeof(str),"Your house %s has been sold to %s while you were offline.",dini_Get(file,"HouseName"),dini_Get(file,"Buyer"));
		SendClientMessage(playerid,-1,str);
		format(str,sizeof(str),"You receive: $%d House Storage: $%d House Price: $%d",value,dini_Int(file,"MoneyToHouse"),dini_Int(file,"MoneyToPlayer"));
		SendClientMessage(playerid,-1,str);
		dini_Remove(file);
	}
}

stock YesOrNo(i)
{
	new yon[128];
	if(i == 0){format(yon,sizeof(yon),"No");}
	if(i == 1){format(yon,sizeof(yon),"Yes");}
	return yon;
}

stock OpenOrClose(i)
{
	new ooc[128];
	if(i == 0){format(ooc,sizeof(ooc),"Closed");}
	if(i == 1){format(ooc,sizeof(ooc),"Open");}
	return ooc;
}

stock AddS(amount) // By [03]Garsino.
{
	new returnstring[2];
	format(returnstring, 2, "");
	if(amount != 1 && amount != -1)
	{
	    format(returnstring, 2, "s");
	}
	return returnstring;
}

stock pName(playerid)
{
	new Nick[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Nick, MAX_PLAYER_NAME);
 	return Nick;
}
stock HouseFile(houseid)
{
    new filename[128];
	format(filename, sizeof(filename), hPath, houseid);
	return filename;
}
stock InteriorFile(Interiorid)
{
    new filename[128];
	format(filename, sizeof(filename), iPath, Interiorid);
	return filename;
}
stock UserFile(playerid)
{
    new filename[128];
	format(filename, sizeof(filename), uPath, pName(playerid));
	return filename;
}

stock udb_hash(buf[]) // By DracoBlue
{
	new length = strlen(buf), s1 = 1, s2;
	Loop(n, length, 0)
    {
       s1 = (s1 + buf[n]) % 65521, s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}
