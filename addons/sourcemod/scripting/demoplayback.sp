#pragma semicolon 1

#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cstrike>
#include <smlib>
#include <eItems>

char g_szMap[128];
bool g_bStartedPlaying[MAXPLAYERS+1];
int g_iCurrentTick[MAXPLAYERS+1], g_iSnapshotTick[MAXPLAYERS+1];
int g_iMaxTick;

char g_szWeapon[65535][64];
char g_szPinPulled[65535][64];
char g_szWeapon_1[65535][64];
char g_szWeapon_2[65535][64];
char g_szWeapon_3[65535][64];
char g_szWeapon_4[65535][64];
char g_szWeapon_5[65535][64];
char g_szWeapon_6[65535][64];
char g_szIsDucked[65535][64];
char g_szIsDucking[65535][64];
char g_szIsWalking[65535][64];

int g_iCurDefIndex[65535];
int g_iHasJumped[65535];
int g_iThrowStrength[65535];

float g_fPosition[65535][3];
float g_fAngles[65535][3];
float g_fVelocity[65535][3];
float g_flNextCommand[MAXPLAYERS+1];

public void OnPluginStart()
{
	HookEventEx("round_start", OnRoundStart);

	RegConsoleCmd("sm_startplayback", Command_StartPlayback);
}

public Action Command_StartPlayback(int client, int iArgs)
{
	g_bStartedPlaying[client] = true;
	Client_RemoveAllWeapons(client);
	ServerCommand("sv_spawn_afk_bomb_drop_time 999");
	
	return Plugin_Handled;
}

public void OnMapStart()
{
	GetCurrentMap(g_szMap, sizeof(g_szMap));
	
	ParseTicks();
}

public void OnClientPostAdminCheck(int client)
{
	g_bStartedPlaying[client] = false;
	g_flNextCommand[client] = 0.0;
}

public void OnRoundStart(Event eEvent, char[] szName, bool bDontBroadcast)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && !IsFakeClient(i) && IsPlayerAlive(i))
		{
			g_bStartedPlaying[i] = false;
			g_iCurrentTick[i] = 0;
			g_iSnapshotTick[i] = 0;
		}
	}
}

public Action OnPlayerRunCmd(int client, int &iButtons, int &iImpulse, float fVel[3], float fAngles[3], int &iWeapon, int &iSubtype, int &iCmdNum, int &iTickCount, int &iSeed, int iMouse[2])
{
	if (IsValidClient(client) && IsPlayerAlive(client) && !IsFakeClient(client) && g_bStartedPlaying[client] && g_iCurrentTick[client] <= g_iMaxTick)
	{
		char szUseWeapon[128];
	
		int iNewWeapon;
		int iKnifeSlot = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE);
	
		if(iKnifeSlot == -1)
		{
			GivePlayerItem(client, "weapon_knife");
		}
		
		if(strcmp(g_szWeapon_1[g_iCurrentTick[client]], "NULL") != 0 && !Client_HasWeapon(client, g_szWeapon_1[g_iCurrentTick[client]]))
		{
			iNewWeapon = GivePlayerItem(client, g_szWeapon_1[g_iCurrentTick[client]]);
			if(StrContains(g_szWeapon_1[g_iCurrentTick[client]], "grenade") == -1 
			&& StrContains(g_szWeapon_1[g_iCurrentTick[client]], "flashbang") == -1 
			&& StrContains(g_szWeapon_1[g_iCurrentTick[client]], "decoy") == -1 
			&& StrContains(g_szWeapon_1[g_iCurrentTick[client]], "molotov") == -1)
			{
				EquipPlayerWeapon(client, iNewWeapon);
			}
		}
		
		if(strcmp(g_szWeapon_2[g_iCurrentTick[client]], "NULL") != 0 && !Client_HasWeapon(client, g_szWeapon_2[g_iCurrentTick[client]]))
		{
			iNewWeapon = GivePlayerItem(client, g_szWeapon_2[g_iCurrentTick[client]]);
			if(StrContains(g_szWeapon_2[g_iCurrentTick[client]], "grenade") == -1 
			&& StrContains(g_szWeapon_2[g_iCurrentTick[client]], "flashbang") == -1 
			&& StrContains(g_szWeapon_2[g_iCurrentTick[client]], "decoy") == -1 
			&& StrContains(g_szWeapon_2[g_iCurrentTick[client]], "molotov") == -1)
			{
				EquipPlayerWeapon(client, iNewWeapon);
			}
		}
		
		if(strcmp(g_szWeapon_3[g_iCurrentTick[client]], "NULL") != 0 && !Client_HasWeapon(client, g_szWeapon_3[g_iCurrentTick[client]]))
		{
			iNewWeapon = GivePlayerItem(client, g_szWeapon_3[g_iCurrentTick[client]]);
			if(StrContains(g_szWeapon_3[g_iCurrentTick[client]], "grenade") == -1 
			&& StrContains(g_szWeapon_3[g_iCurrentTick[client]], "flashbang") == -1 
			&& StrContains(g_szWeapon_3[g_iCurrentTick[client]], "decoy") == -1 
			&& StrContains(g_szWeapon_3[g_iCurrentTick[client]], "molotov") == -1)
			{
				EquipPlayerWeapon(client, iNewWeapon);
			}
		}
		
		if(strcmp(g_szWeapon_4[g_iCurrentTick[client]], "NULL") != 0 && !Client_HasWeapon(client, g_szWeapon_4[g_iCurrentTick[client]]))
		{
			iNewWeapon = GivePlayerItem(client, g_szWeapon_4[g_iCurrentTick[client]]);
			if(StrContains(g_szWeapon_4[g_iCurrentTick[client]], "grenade") == -1 
			&& StrContains(g_szWeapon_4[g_iCurrentTick[client]], "flashbang") == -1 
			&& StrContains(g_szWeapon_4[g_iCurrentTick[client]], "decoy") == -1 
			&& StrContains(g_szWeapon_4[g_iCurrentTick[client]], "molotov") == -1)
			{
				EquipPlayerWeapon(client, iNewWeapon);
			}
		}
		
		if(strcmp(g_szWeapon_5[g_iCurrentTick[client]], "NULL") != 0 && !Client_HasWeapon(client, g_szWeapon_5[g_iCurrentTick[client]]))
		{
			iNewWeapon = GivePlayerItem(client, g_szWeapon_5[g_iCurrentTick[client]]);
			if(StrContains(g_szWeapon_5[g_iCurrentTick[client]], "grenade") == -1 
			&& StrContains(g_szWeapon_5[g_iCurrentTick[client]], "flashbang") == -1 
			&& StrContains(g_szWeapon_5[g_iCurrentTick[client]], "decoy") == -1 
			&& StrContains(g_szWeapon_5[g_iCurrentTick[client]], "molotov") == -1)
			{
				EquipPlayerWeapon(client, iNewWeapon);
			}
		}
		
		if(strcmp(g_szWeapon_6[g_iCurrentTick[client]], "NULL") != 0 && !Client_HasWeapon(client, g_szWeapon_6[g_iCurrentTick[client]]))
		{
			iNewWeapon = GivePlayerItem(client, g_szWeapon_6[g_iCurrentTick[client]]);
			if(StrContains(g_szWeapon_6[g_iCurrentTick[client]], "grenade") == -1 
			&& StrContains(g_szWeapon_6[g_iCurrentTick[client]], "flashbang") == -1 
			&& StrContains(g_szWeapon_6[g_iCurrentTick[client]], "decoy") == -1 
			&& StrContains(g_szWeapon_6[g_iCurrentTick[client]], "molotov") == -1)
			{
				EquipPlayerWeapon(client, iNewWeapon);
			}
		}
		
		if(g_iCurrentTick[client] == 0)
		{
			TeleportEntity(client, g_fPosition[g_iCurrentTick[client]], g_fAngles[g_iCurrentTick[client]], g_fVelocity[g_iCurrentTick[client]]);
		}
		
		if(strcmp(g_szPinPulled[g_iCurrentTick[client]], "true") == 0 && g_iThrowStrength[g_iCurrentTick[client]] == 1)
		{
			iButtons |= IN_ATTACK;
			iButtons &= ~IN_ATTACK2;
		}
		else if(strcmp(g_szPinPulled[g_iCurrentTick[client]], "true") == 0 && g_iThrowStrength[g_iCurrentTick[client]] == 0)
		{
			iButtons |= IN_ATTACK2;
			iButtons &= ~IN_ATTACK;
		}
		
		if(strcmp(g_szIsDucked[g_iCurrentTick[client]], "true") == 0 || strcmp(g_szIsDucking[g_iCurrentTick[client]], "true") == 0)
			iButtons |= IN_DUCK;
		else if(strcmp(g_szIsDucked[g_iCurrentTick[client]], "false") == 0)
			iButtons &= ~IN_DUCK;
		
		if(strcmp(g_szIsWalking[g_iCurrentTick[client]], "true") == 0)
			iButtons |= IN_SPEED;
		else
			iButtons &= ~IN_SPEED;
		
		if(g_iHasJumped[g_iCurrentTick[client]] == 1)
		{
			iButtons |= IN_JUMP;
		}
		
		if(g_iSnapshotTick[client] == 64)
		{
			SetEntPropVector(client, Prop_Data, "m_vecAbsOrigin", g_fPosition[g_iCurrentTick[client]]);
			Array_Copy(g_fAngles[g_iCurrentTick[client]], fAngles, 2);
			g_iSnapshotTick[client] = 0;
		}
		else
		{
			Array_Copy(g_fAngles[g_iCurrentTick[client]], fAngles, 2);
			
			float fLength = GetVectorLength(g_fVelocity[g_iCurrentTick[client]]);
			if(fLength > 5.0)
			{
				TF2_MoveTo(client, g_fPosition[g_iCurrentTick[client]], fVel, fAngles);
			}
			
			SetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", g_fVelocity[g_iCurrentTick[client]]);
		}
		
		if(g_iCurDefIndex[g_iCurrentTick[client]] != 49)
		{
			eItems_GetWeaponClassNameByDefIndex(g_iCurDefIndex[g_iCurrentTick[client]], szUseWeapon, sizeof(szUseWeapon));
			
			if(StrContains(szUseWeapon, "weapon_knife") != -1)
			{
				Client_SetActiveWeapon(client, GetPlayerWeaponSlot(client, CS_SLOT_KNIFE));
			}
			else
			{
				Client_SetActiveWeapon(client, eItems_FindWeaponByClassName(client, szUseWeapon));
			}
		}
		
		g_iCurrentTick[client]++;
		g_iSnapshotTick[client]++;
		
		return Plugin_Changed;
	}
	
	return Plugin_Changed;
}

stock void TF2_MoveTo(int client, float flGoal[3], float fVel[3], float fAng[3])
{
    float flPos[3];
    GetClientAbsOrigin(client, flPos);

    float newmove[3];
    SubtractVectors(flGoal, flPos, newmove);
    
    newmove[1] = -newmove[1];
    
    float sin = Sine(fAng[1] * FLOAT_PI / 180.0);
    float cos = Cosine(fAng[1] * FLOAT_PI / 180.0);                        
    
    fVel[0] = cos * newmove[0] - sin * newmove[1];
    fVel[1] = sin * newmove[0] + cos * newmove[1];
    
    NormalizeVector(fVel, fVel);
    ScaleVector(fVel, 450.0);
}

stock bool FakeClientCommandThrottled(int client, const char[] command)
{
	if(g_flNextCommand[client] > GetGameTime())
		return false;
	
	FakeClientCommand(client, command);
	
	g_flNextCommand[client] = GetGameTime() + 0.4;
	
	return true;
}

void ParseTicks()
{
	char szPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, szPath, sizeof(szPath), "configs/bot_demos.txt");
	
	if (!FileExists(szPath))
	{
		PrintToServer("Configuration file %s is not found.", szPath);
		return;
	}
	
	KeyValues kv = new KeyValues("Nades");
	
	if (!kv.ImportFromFile(szPath))
	{
		delete kv;
		PrintToServer("Unable to parse Key Values file %s.", szPath);
		return;
	}
	
	if (!kv.JumpToKey(g_szMap))
	{
		delete kv;
		PrintToServer("Unable to find %s section in file %s.", g_szMap, szPath);
		return;
	}
	
	if (!kv.GotoFirstSubKey())
	{
		delete kv;
		PrintToServer("Unable to find %s section in file %s.", g_szMap, szPath);
		return;
	}
	
	char szTick[64];
	do {

		kv.GetSectionName(szTick, sizeof(szTick));
		
		kv.GetVector("position", g_fPosition[StringToInt(szTick)]);
		kv.GetVector("angles", g_fAngles[StringToInt(szTick)]);
		kv.GetVector("velocity", g_fVelocity[StringToInt(szTick)]);
		kv.GetString("cur_name", g_szWeapon[StringToInt(szTick)], 64);
		g_iCurDefIndex[StringToInt(szTick)] = kv.GetNum("cur_itemindex");
		kv.GetString("pinpulled", g_szPinPulled[StringToInt(szTick)], 64);
		g_iThrowStrength[StringToInt(szTick)] = kv.GetNum("throwStrength");
		kv.GetString("weapon_1", g_szWeapon_1[StringToInt(szTick)], 64);
		kv.GetString("weapon_2", g_szWeapon_2[StringToInt(szTick)], 64);
		kv.GetString("weapon_3", g_szWeapon_3[StringToInt(szTick)], 64);
		kv.GetString("weapon_4", g_szWeapon_4[StringToInt(szTick)], 64);
		kv.GetString("weapon_5", g_szWeapon_5[StringToInt(szTick)], 64);
		kv.GetString("weapon_6", g_szWeapon_6[StringToInt(szTick)], 64);
		kv.GetString("isducked", g_szIsDucked[StringToInt(szTick)], 64);
		kv.GetString("iswalking", g_szIsWalking[StringToInt(szTick)], 64);
		g_iHasJumped[StringToInt(szTick)] = kv.GetNum("hasJumped");
	} while (kv.GotoNextKey());
	
	g_iMaxTick = StringToInt(szTick);
	
	delete kv;
}

stock bool IsValidClient(int client)
{
	return client > 0 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && !IsClientSourceTV(client);
}