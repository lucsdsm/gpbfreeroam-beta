//by Lucas

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <foreach>
#include <streamer>
#include <callbacks>
#include <a_zones>
#include <sound>

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
   pElastomero,
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
new gpbMensagem[128];

new player[MAX_PLAYERS][jogadorData];
new morto[MAX_PLAYERS][mortoData];
new playerSkin[MAX_PLAYERS];

new veiculoMotor[MAX_VEHICLES];
new veiculoAvariado[MAX_VEHICLES];

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

forward LigarMotor(playerid);
public LigarMotor(playerid) {
 	new vehicleid = GetPlayerVehicleID(playerid);
	new enginem, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(GetPlayerVehicleID(playerid),enginem, lights, alarm, doors, bonnet, boot, objective);

	SetVehicleParamsEx(GetPlayerVehicleID(playerid),VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
    format(gpbMensagem, 500, "%s gira a chave e liga o motor do seu veículo.", GetName(playerid));
    SendRangedMessage(playerid, purple, gpbMensagem, 10);
	veiculoMotor[vehicleid] = 1;
}

forward DesligarMotor(playerid);
public DesligarMotor(playerid) {
	new vehicleid = GetPlayerVehicleID(playerid);
	new enginem, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(GetPlayerVehicleID(playerid),enginem, lights, alarm, doors, bonnet, boot, objective);

	if (veiculoMotor[vehicleid] == 0) {
		SetVehicleParamsEx(GetPlayerVehicleID(playerid),VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
		format(gpbMensagem, 500, "%s gira a chave e liga o motor do seu veículo.", GetName(playerid));
		SendRangedMessage(playerid, purple, gpbMensagem, 10);
		veiculoMotor[vehicleid] = 1;
	}
	else {
		SetVehicleParamsEx(GetPlayerVehicleID(playerid),VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
		format(gpbMensagem, 500, "%s gira a chave e desliga o motor do seu veículo.", GetName(playerid));
		SendRangedMessage(playerid, purple, gpbMensagem, 10);
		veiculoMotor[vehicleid] = 0;
	}
}

//Funções nativas:
native IsValidVehicle(vehicleid);

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

stock GetLightStatus(vehicleid) {
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (lights != 1)
		return 0;

	return 1;
}

stock SetLightStatus(vehicleid, status) {
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, status, alarm, doors, bonnet, boot, objective);
}

stock ControlaLuzes(vehicleid) {
	switch (GetLightStatus(vehicleid)) {
	    case false: {
	        SetLightStatus(vehicleid, true);
		}
		case true: {
		    SetLightStatus(vehicleid, false);
		}
	}
	return 1;
}

stock ControlaMotor(playerid, vehicleid) {
	if (GetPlayerVehicleSeat(playerid) == 0) {
		if(veiculoMotor[vehicleid] == 0) {
  			new Float:hp;
		  	GetVehicleHealth(vehicleid, hp);
	  	  	if(hp > 400) {
				SetTimerEx("LigarMotor", 300, false, "d", playerid);
			}
			else {
				SendClientMessage(playerid, grey, "O motor está quebrado. Digite /fix para consertá-lo.");
			}
		}
		else {
			SetTimerEx("DesligarMotor", 300, false, "d", playerid);
		}
	}
	return 1;
}

stock HasNoEngine(vehicleid) {
    switch (GetVehicleModel(vehicleid)) {
        case 509, 510, 481, 606, 607, 610, 584, 611, 608, 435, 591, 590, 569, 570, 449, 450, 537, 538: return 1;
    }
    return 0;
}

stock VeiculoRaio(Float:radi, playerid, vehicleid) {
    if(IsPlayerConnected(playerid)) {
        new Float:PX,Float:PY,Float:PZ,Float:X,Float:Y,Float:Z;GetPlayerPos(playerid,PX,PY,PZ);GetVehiclePos(vehicleid, X,Y,Z);new Float:Distance = (X-PX)*(X-PX)+(Y-PY)*(Y-PY)+(Z-PZ)*(Z-PZ);
		if(Distance <= radi*radi) {
            return true;
        }
    }
    return 0;
}

stock VehicleAsDriver(vehicleid) {
    new stats = 0;
    for(new i; i < MAX_PLAYERS; i++){
        if(IsPlayerInVehicle(i, vehicleid) && GetPlayerState(i) == PLAYER_STATE_DRIVER) {
            stats = 1;
            break;
        }
    }
    return stats;
}

stock IsPlayerNearPlayer(playerid, targetid, Float:radius) {
    static
        Float:fX,
        Float:fY,
        Float:fZ;

    GetPlayerPos(targetid, fX, fY, fZ);

    return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

stock CriaObjeto(Object, Float:x, Float:y, Float:z, Float:Angle) {
    for(new i = 0; i < sizeof(objeto); i++) {
    	if(objeto[i][sCreated] == 0) {
            objeto[i][sCreated] = 1;
            objeto[i][sX] = x;
            objeto[i][sY] = y;
            objeto[i][sZ] = z-0.7;
            objeto[i][sObject] = CreateDynamicObject(Object, x, y, z-0.9, 0, 0, Angle+90);
            return 1;
		}
	}
	return 0;
}

main() {
}

//Funções públicas:
public OnGameModeInit() {
	SetGameModeText("GPB:F v0.1");
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
	player[playerid][pElastomero] = 0;
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
	new Float:health;
	GetPlayerHealth(playerid,health);
	if (player[playerid][pAnim] == 1) {
		player[playerid][pAnim] = 0;
	}
	if ((health < 65 || bodypart == 9) && weaponid != 23 && weaponid != 25 && player[playerid][pFerido] == 0) { // Geral
		player[playerid][pFerido] = 1;
		SetPlayerHealth(playerid, 98303);
		SetPlayerColor(playerid, red);
		if (IsPlayerInAnyVehicle(playerid)) { // Animação dentro de algum veículo
			TogglePlayerControllable(playerid, false);
			ApplyAnimation(playerid, "ped", "car_dead_lhs", 4.1, 0, 1, 0, 1, 0, 1);
			SendClientMessage(playerid, grey, "Você está ferido. Para voltar ao controle do personagem use o /reviver.");
		}
		else { // Animação fora de algum veículo
			ApplyAnimation(playerid, "ped", "KO_shot_front", 4.1, 0, 0, 0, 1, 0, 1);
			SendClientMessage(playerid, grey, "Você está ferido. Para voltar ao controle do personagem use o /reviver.");
		}
	}
	if ((health < 65)) { // Impedir mensagens duplicadas
		if (weaponid == 37 || weaponid == 9) {
			return 1;
		}
	}
	if (health > 100) {
		SetPlayerHealth(playerid, 98303); // Ficar com a vida "infinta" se estiver ferido
	}
	if (weaponid == 23) { // Taser
		if (IsPlayerNearPlayer(playerid, issuerid, 7.6)) {
			if (player[playerid][pFerido] == 1 || player[playerid][pDerrubado] == 1) {
			SendClientMessage(issuerid, grey, "Este jogador já está no chão.");
			}
			else if (IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(issuerid, grey, "O jogador está dentro de um veículo, portanto é imune ao taser.");
			}
			else {
				player[playerid][pDerrubado] = 1;
				SetPlayerHealth(playerid, 98303);
				SetPlayerColor(playerid, yellow);
				ApplyAnimation(playerid, "ped", "KO_shot_front", 4.1, 0, 0, 0, 1, 0, 1);
				format(gpbMensagem, 500, "Você atingiu %s com um taser. Para o jogador voltar ao controle, levante-o utilizando o /levantar.", GetName(playerid));
				SendClientMessage(playerid, grey, "Você foi atingido por um taser. Espere algum policial te levantar para voltar ao controle do personagem.");
				SendClientMessage(issuerid, grey, gpbMensagem);
			}
		}
		else {
			SetPlayerHealth(playerid, health+amount);
		}
	}
	if (weaponid == 25 && player[issuerid][pElastomero]) { // Escopeta com elastômero
		if (player[playerid][pFerido] == 1 || player[playerid][pDerrubado] == 1) {
			return 0;
		}
		else {
			new Float:dano = 10;
			new Float:chance = random(2);
			GetPlayerHealth(playerid, health);
			SetPlayerHealth(playerid, health-dano);
			
			if (bodypart == 9 && player[playerid][pFerido] == 0) {
				player[playerid][pFerido] = 1;
				SetPlayerHealth(playerid, 98303);
				SetPlayerColor(playerid, red);
				SendClientMessage(playerid, grey, "Você foi atingido por uma escopeta com elastômero. Para voltar ao controle do personagem use o /reviver.");
				if (IsPlayerInAnyVehicle(playerid)) {
					ApplyAnimation(playerid, "ped", "car_dead_lhs", 4.1, 0, 1, 0, 1, 0, 1);
				}
				else {
					ApplyAnimation(playerid, "sweet", "Sweet_injuredloop", 4.1, 0, 0, 0, 1, 0, 1);
				}
				return 1;
			}
			if (chance == 1 && player[playerid][pFerido] == 0) {
				player[playerid][pFerido] = 1;
				SetPlayerHealth(playerid, 98303);
				SetPlayerColor(playerid, red);
				SendClientMessage(playerid, grey, "Você foi atingido por uma escopeta com elastômero. Para voltar ao controle do personagem use o /reviver.");
				ApplyAnimation(playerid, "sweet", "Sweet_injuredloop", 4.1, 0, 0, 0, 1, 0, 1);
				return 1;
			}

			if (health <= 65 && player[playerid][pFerido] == 0) {
				player[playerid][pFerido] = 1;
				SetPlayerHealth(playerid, 98303);
				SetPlayerColor(playerid, red);
				SendClientMessage(playerid, grey, "Você foi atingido por uma escopeta com elastômero. Para voltar ao controle do personagem use o /reviver.");
				ApplyAnimation(playerid, "sweet", "Sweet_injuredloop", 4.1, 0, 0, 0, 1, 0, 1);
				return 1;
			}
		}
	}
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart) {
	new Float:health;
	GetPlayerHealth(damagedid, health);
	if(IsPlayerPaused(damagedid)) {
    	if(health < 100) {
   			SetPlayerHealth(playerid, 100);
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason) {
	/* Caso morra, spawnar no mesmo local */
    GetPlayerPos(playerid, morto[playerid][morto_X], morto[playerid][morto_Y], morto[playerid][morto_Z]);
	GetPlayerFacingAngle(playerid, morto[playerid][morto_A]);
	morto[playerid][morto_vw] = GetPlayerVirtualWorld(playerid);
	morto[playerid][morto_int] = GetPlayerInterior(playerid);
	playerSkin[playerid] = GetPlayerSkin(playerid);
	new Float:health;
	GetPlayerHealth(playerid, health);
	if (reason == 54) { // Morte por queda
		TogglePlayerSpectating(playerid, true); // Faz desaparecer a tela de morte
		TogglePlayerSpectating(playerid, false);
		player[playerid][pFerido] = 1;
		SetPlayerHealth(playerid, 98303);
		SetPlayerColor(playerid, red);
		ApplyAnimation(playerid, "ped", "KO_shot_front", 4.1, 0, 0, 0, 1, 0, 1);
		SendClientMessage(playerid, grey, "Você está ferido. Para voltar ao controle do personagem use o /reviver.");
		return 1;
	}
	return 1;
}

public OnVehicleSpawn(vehicleid) {
	if (veiculoMotor[vehicleid] == 1) {
		veiculoMotor[vehicleid] = 0;
	}
	else if (veiculoMotor[vehicleid] == 0) {
	    DestroyVehicle(vehicleid);
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid) {
	veiculoMotor[vehicleid] = 0;
	return 1;
}

public OnPlayerText(playerid, text[]) {
	if (player[playerid][pFerido] == 0 && player[playerid][pAlgemado] == 0 && player[playerid][pAnim] == 0 && !IsPlayerInAnyVehicle(playerid)) {
		ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.1, 0, 0, 0, 0, 0, 1);
	}
	text[0] = toupper(text[0]);
	format(gpbMensagem, 500, "%s — %s", GetName(playerid), text);
	SendRangedMessage(playerid, white, gpbMensagem, 20);
	format(gpbMensagem, 500, "— %s", text);
	SetPlayerChatBubble(playerid, gpbMensagem, white, 20, 10000);
}

public OnPlayerCommandText(playerid, cmdtext[]) {
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
	if (HasNoEngine(vehicleid) == 1) {
		new enginem, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, enginem, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
		veiculoMotor[vehicleid] = 1;
	}
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
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0) {
        if(newkeys == KEY_ANALOG_UP) {
            if (player[playerid][pFerido] == 1 || player[playerid][pAlgemado]) {
	        	return 1;
			}
			else if (HasNoEngine(vehicleid) == 1) {
				return 1;
			}
            else {
				ControlaLuzes(vehicleid);
			}
		}
        else if(newkeys == KEY_FIRE) {
            if (player[playerid][pFerido] == 1 || player[playerid][pAlgemado]) {
	        	return 1;
			}
			else if (HasNoEngine(vehicleid) == 1) {
				return 1;
			}
            else {
				ControlaMotor(playerid, vehicleid);
			}
  		}
	}
	else if(newkeys == KEY_SECONDARY_ATTACK) {
		if (player[playerid][pAnim] == 1) {
			player[playerid][pAnim] = 0;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
	}
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
	switch(dialogid) {
		case textbox_equipamentos: {
			switch(listitem) {
				case 0: SetPlayerHealth(playerid, 100); // Vida
				case 1: SetPlayerArmour(playerid, 100); // Colete
				case 2: GivePlayerWeapon(playerid, 41 , 0x7FFFFFFF); // Spray
				case 3: GivePlayerWeapon(playerid, 3, 1); // Cacetete
				case 4: GivePlayerWeapon(playerid, 4, 1); //  Faca
				case 5: GivePlayerWeapon(playerid, 22, 500); // 9mm
				case 6: {
					if (player[playerid][pEquipe] != 1) {
						SendClientMessage(playerid, grey, "Apenas policiais podem portar o taser.");
					}
					else {
						GivePlayerWeapon(playerid, 23, 500); // Pistola Silenciada (Taser)
					}
				}
				case 7: GivePlayerWeapon(playerid, 24, 500); // Desert Eagle
				case 8: {
					GivePlayerWeapon(playerid, 25, 500); // Escopeta
					player[playerid][pElastomero] = 0;
				}
				case 9: {
					if (player[playerid][pEquipe] != 1) {
							SendClientMessage(playerid, grey, "Apenas policiais podem portar a escopeta com munição elastômaro.");
						}
					else {
						GivePlayerWeapon(playerid, 25, 500); // Escopeta (Elastômaro)
						player[playerid][pElastomero] = 1;
					}
				}
				case 10: GivePlayerWeapon(playerid, 27, 500); // Escopeta de combate
				case 11: GivePlayerWeapon(playerid, 26, 500); // Escopeta de cano serrado
				case 12: GivePlayerWeapon(playerid, 28, 500); // UZI
				case 13: GivePlayerWeapon(playerid, 32, 500); // TEC9
				case 14: GivePlayerWeapon(playerid, 29, 500); // MP5
				case 15: GivePlayerWeapon(playerid, 31, 500); // M4
				case 16: GivePlayerWeapon(playerid, 30, 500); // AK47
				case 17: GivePlayerWeapon(playerid, 34,  10); // Sniper
				case 18: GivePlayerWeapon(playerid, 33, 20); // Rifle de caça
				case 19: GivePlayerWeapon(playerid, 17, 10); // Granada de fumaça
				case 20: GivePlayerWeapon(playerid, 18, 10); // Molotov
				case 21: GivePlayerWeapon(playerid, 40, 1); // Detonador
				case 22: GivePlayerWeapon(playerid, 43, 0x7FFFFFFF); // Câmera
				case 23: GivePlayerWeapon(playerid, 46, 1); // Paraquedas
				case 24: GivePlayerWeapon(playerid, 2, 1); //  Golf
				case 25: GivePlayerWeapon(playerid, 5, 1); //  Baseball
				case 26: GivePlayerWeapon(playerid, 7, 1); // Sinuca
				case 27: GivePlayerWeapon(playerid, 8, 1); //  Katana
				case 28: GivePlayerWeapon(playerid, 6, 1); //  Pá
				case 29: GivePlayerWeapon(playerid, 9, 1); //  Serra
				case 30: GivePlayerWeapon(playerid, 42, 0x7FFFFFFF); // Mangueira
				case 31: GivePlayerWeapon(playerid, 39, 1) && GivePlayerWeapon(playerid, 40, 1) ; // Bomba remota
				case 32: GivePlayerWeapon(playerid, 10, 1); // Dildo
				case 33: GivePlayerWeapon(playerid, 12, 1); // Vibrador
				case 34: GivePlayerWeapon(playerid, 14, 1); // Buquê
				case 35: GivePlayerWeapon(playerid, 15, 1); // Bengala
			}
  		}
	}
    switch(dialogid) {
  		case textbox_teletransportes: {
			switch(listitem) {
				case 0: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), 1826, -1372, 14);
					}
					else {
						SetPlayerPos(playerid, 1826, -1372, 14); // Los Santos
					}
				}
				case 1: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), 1521, -1676, 13);
					}
					else {
						SetPlayerPos(playerid, 1521, -1676, 13); // Los Santos Police Department
					}
				}
				case 2: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), 326, -1795, 4);
					}
					else {
						SetPlayerPos(playerid, 326, -1795, 4); // Santa Maria Beach
					}
				}
				case 3: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), 2489, -1682, 13);
					}
					else {
						SetPlayerPos(playerid, 2489, -1682, 13); // Groove Street
					}
				}
				case 4: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), -1638, 1179, 8);
					}
					else {
						SetPlayerPos(playerid, -1638, 1179, 8); // San Fierro
					}
				}
				case 5: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), -1609, 725, 12);
					}
					else {
						SetPlayerPos(playerid, -1609, 725, 12); // San Fierro Police Department
					}
				}
				case 6: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), 2004, 1709, 10);
					}
					else {
						SetPlayerPos(playerid, 2004, 1709, 10); // Las Venturas
					}
				}
				case 7: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), 2298, 2409, 10);
					}
					else {
						SetPlayerPos(playerid, 2298, 2409, 10); // Las Venturas Police Department
					}
				}
				case 8: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), 2337, -32, 26);
					}
					else {
						SetPlayerPos(playerid, 2321, -32, 26); // Palomino Creek
					}
				}
				case 9: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), 1274, 177, 19);
					}
					else {
						SetPlayerPos(playerid, 1274, 177, 19); // Montgomery
					}
				}
				case 10: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), 624, -596, 17);
					}
					else {
						SetPlayerPos(playerid, 624, -596, 17); // Dillimore
					}
				}
				case 11: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), 213, -147, 1);
					}
					else {
						SetPlayerPos(playerid, 213, -147, 1); // Blueberry
					}
				}
				case 12: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), -2209, -2378, 32);
					}
					else {
						SetPlayerPos(playerid, -2209, -2378, 32); // Angel Pine
					}
				}
    			case 13: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), -1408, 2645, 55);
					}
					else {
						SetPlayerPos(playerid, -1408, 2645, 55); // El Quebrados
					}
				}
				case 14: {
					if(IsPlayerInAnyVehicle(playerid)) {
						SetVehiclePos(GetPlayerVehicleID(playerid), -220, 995, 19);
					}
					else {
						SetPlayerPos(playerid, -220, 995, 19); // Fort Carson
					}
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_equipes: {
			switch(listitem) {
				case 0: // Civil
					if(player[playerid][pEquipe] == 0) {
						SendClientMessage(playerid, grey, "Você já é um civil.");
					}
					else {
						player[playerid][pEquipe] = 0;
						SendClientMessage(playerid, grey, "Você agora é um civil."); 
						SetPlayerColor(playerid, white);
					}
				case 1: // Policial
					if(player[playerid][pEquipe] == 1) {
						SendClientMessage(playerid, grey, "Você já é um policial.");
					}
					else {
						player[playerid][pEquipe] = 1;
						SendClientMessage(playerid, grey, "Agora você é um policial. Use /r para comunicar-se com sua equipe.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetPlayerColor(playerid, white);
					}
				case 2: // Criminoso
					if(player[playerid][pEquipe] == 2) {
						SendClientMessage(playerid, grey, "Você já é um criminoso.");
					}
					else {
						player[playerid][pEquipe] = 2;
						SendClientMessage(playerid, grey, "Criminoso. Use /r caso queira comunicar-se com mais criminosos.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetPlayerColor(playerid, white);
					}
				case 3: // Paramédico
					if(player[playerid][pEquipe] == 3) {
						SendClientMessage(playerid, grey, "Você já é um paramédico.");
					}
					else {
						player[playerid][pEquipe] = 3;
						SendClientMessage(playerid, grey, "Paramédico selecionado com sucesso. Você ganhou um rádio para comunicar-se com sua equipe.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetPlayerColor(playerid, white);
					}
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source) {
	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid) {
	new Float:health;
	GetVehicleHealth(GetPlayerVehicleID(playerid), health);
	if(health < 550){
		SetVehicleHealth(vehicleid, 400);
		new enginem, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(GetPlayerVehicleID(playerid),enginem, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(GetPlayerVehicleID(playerid),VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
		veiculoAvariado[vehicleid] = 1;
	}
	if (health == 400) {
		SendClientMessage(playerid, grey, "Seu veículo avariou. Use o comando /fix para usá-lo novamente.");
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) {
	if(hittype == BULLET_HIT_TYPE_VEHICLE) {
        new Float:health;
		GetVehicleHealth(hitid, health);
        new Float:dano = 15;
        SetVehicleHealth(hitid, health-dano);
		if (health < 550) {
			new enginem, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(hitid,enginem, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(hitid,VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
			veiculoAvariado[hitid] = 1;
        	SetVehicleHealth(hitid, 450);
		}
    }
    return 1;
}