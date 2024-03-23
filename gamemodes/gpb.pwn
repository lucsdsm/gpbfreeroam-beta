//by Lucas

#include <a_samp>

//Definidores:
#define green 0x9ACD32AA
#define red   0xFF6347AA
#define white 0xFFFFFFAA
#define grey  0xAFAFAFAA
#define purple 0xCA9CFFAA
#define orange 0xFFA46BAA
#define indigo 0xD8D6FFAA
#define rose 0xF0C9FFAA
#define lightgreen 0x99FFB1AA
#define blue 0x0000FFAA
#define yellow 0xFFD359AA

//Enumerates:
enum jogadorData {
   pSpawnVehicle,
   pEquipe,
   pFerido,
   pSolicitandoReforco,
   pAlgemado,
   pDerrubado,
   pAnim,
}

enum mortoData {
	Float:morto_X,
	Float:morto_Y,
	Float:morto_Z,
	Float:morto_A,
	morto_int,
	morto_vw,
	bool:morto_dead
};

//Variáveis Globais:
new player[MAX_PLAYERS][jogadorData];
new morto[MAX_PLAYERS][mortoData];
new playerSkin[MAX_PLAYERS];

//Funções personalizadas:
forward JogadorConecta(playerid);
public JogadorConecta(playerid) {
	new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));

    new mensagem[MAX_PLAYER_NAME + 23 + 1];
    format(mensagem, sizeof(mensagem), "%s conectou-se no servidor.", name);
    SendClientMessageToAll(grey, mensagem);
	return 1;
}

forward JogadorDesconecta(playerid, reason);
public JogadorDesconecta(playerid, reason) {
    new
        mensagem[64],
        name[MAX_PLAYER_NAME];

    GetPlayerName(playerid, name, MAX_PLAYER_NAME);

    new szDisconnectReason[3][] = {
        "desconectou-se",
        "saiu do servidor",
        "foi kickado ou banido do servidor"
    };

    format(mensagem, sizeof mensagem, "%s %s.", name, szDisconnectReason[reason]);
    SendClientMessageToAll(grey, mensagem);
    return 1;
}

forward DelayedKick(playerid);
public DelayedKick(playerid) {
    Kick(playerid);
    return 1;
}

forward VerificaNome(playerid);
public VerificaNome(playerid) {
	new playerName[MAX_PLAYER_NAME];
	new gpb[6] = "[GPB]";
 	playerName = GetName(playerid);
  	for (new x = 0; x < 5; x++) { // verifica sem tem o [GPB] no nome
   		if(playerName[x] != gpb[x]) {
     		SendClientMessage(playerid, red, "Para conectar-se você deve utilizar a tag [GPB] antes do nickname.");
       		SetTimerEx("DelayedKick", 1000, false, "i", playerid);
	        }
	}
}

forward HabilidadeArmas(playerid);
public HabilidadeArmas(playerid) {
    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 0);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 0);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 0);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 999);
}

//Funções stocks:
stock SendRangedMessage(sourceid, color, message[], Float:range) {
    new Float:x, Float:y, Float: z;
    GetPlayerPos(sourceid, x, y, z);
    foreach(new ii:Player) {
            if(GetPlayerVirtualWorld(sourceid) == GetPlayerVirtualWorld(ii)) {
                if(IsPlayerInRangeOfPoint(ii, range, x, y, z)) {
                    SendClientMessage(ii, color, message);
                }
            }
        }
    }

stock GetName(playerid) {
   new name[24];
   GetPlayerName(playerid, name, 24);
   return name;
}

stock GetPlayerID(nickname[]) {
    new id[MAX_PLAYER_NAME];
    for(new x; x < MAX_PLAYERS; ++x) {
    	if(IsPlayerConnected(x)) {
            GetPlayerName(x, id, sizeof(id));
            if(!strcmp(id, nickname)) {
                return x;
            }
        }
    }
    return INVALID_PLAYER_ID;
}

main() {
}

//Funções públicas:
public OnGameModeInit() {
	SetGameModeText("GPB:F");
    ManualVehicleEngineAndLights();
	SetNameTagDrawDistance(20.0);
	EnableStuntBonusForAll(0);
	SetWorldTime(20);
	return 1;
}

public OnGameModeExit() {
	return 1;
}

public OnPlayerRequestClass(playerid, classid) {
	player[playerid][pFerido] = 0;
	player[playerid][pEquipe] = 0;
	player[playerid][pAnim] = 0;
	player[playerid][pAlgemado] = 0;
	player[playerid][pDerrubado] = 0;
	TogglePlayerSpectating(playerid, true);
	SpawnPlayer(playerid);
 	SetSpawnInfo(playerid, -1, random(311), 1826, -1372, 14,269.2782,0,0,0,0,0,0);
 	TogglePlayerSpectating(playerid, false);
    return 1;
}

public OnPlayerConnect(playerid) {
	SetPlayerColor(playerid, white);
 	JogadorConecta(playerid);
	SetPlayerVirtualWorld(playerid, 0);
	ShowPlayerMarkers(0);
	HabilidadeArmas(playerid);
	RemovePlayerMapIcon(playerid, -1);
	SendClientMessage(playerid, white, "Digite /comandos para ver os comandos existentes no servidor.");
	SendClientMessage(playerid, white, "Você spawnou como um civil. Digite /equipe para entrar em alguma corporação.");
	return 1;
}

public OnPlayerDisconnect(playerid, reason) {
	JogadorDesconecta(playerid, reason);
	return 1;
}

public OnPlayerSpawn(playerid) {
	if(morto[playerid][morto_X]) {
	    ClearAnimations(playerid);
	    SetPlayerPos(playerid, morto[playerid][morto_X], morto[playerid][morto_Y], morto[playerid][morto_Z]);
	    SetPlayerFacingAngle(playerid, morto[playerid][morto_A]);
	    SetPlayerVirtualWorld(playerid, morto[playerid][morto_vw]);
	    SetPlayerInterior(playerid, morto[playerid][morto_int]);
		SetPlayerSkin(playerid, playerSkin[playerid]);
		ApplyAnimation(playerid, "ped", "KO_shot_front", 4.1, 0, 0, 0, 1, 0, 1);
		new reset[mortoData];
		morto[playerid] = reset;
		morto[playerid][morto_dead] = true;
 	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart) {
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart) {
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason) {
	return 1;
}

public OnVehicleSpawn(vehicleid) {
	return 1;
}

public OnVehicleDeath(vehicleid, killerid) {
	return 1;
}

public OnPlayerText(playerid, text[]) {
}

public OnPlayerCommandText(playerid, cmdtext[]) {
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid) {
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate) {
	return 1;
}

public OnPlayerEnterCheckpoint(playerid) {
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid) {
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid) {
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid) {
	return 1;
}

public OnRconCommand(cmd[]) {
	return 1;
}

public OnPlayerRequestSpawn(playerid) {
	return 1;
}

public OnObjectMoved(objectid) {
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid) {
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid) {
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid) {
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid) {
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2) {
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row) {
	return 1;
}

public OnPlayerExitedMenu(playerid) {
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success) {
	return 1;
}

public OnPlayerUpdate(playerid) {
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid) {
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid) {
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid) {
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid) {
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source) {
	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid) {
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) {
    return 1;
}