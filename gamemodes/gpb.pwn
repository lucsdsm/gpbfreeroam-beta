//by Lucas

//Includes:
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

#define MAX_OBJETOS 1000

#define textbox_equipamentos 0
#define textbox_teletransportes 1
#define textbox_equipes 2
#define textbox_animes1 3
#define textbox_acenar 4
#define textbox_apontar 5
#define textbox_beijar 6
#define textbox_comer 7
#define textbox_comemorar 8
#define textbox_conversar 9
#define textbox_cruzar 10
#define textbox_dancar 11
#define textbox_deitarse 12
#define textbox_dormir 13
#define textbox_drogarse 14
#define textbox_masturbarse 15
#define textbox_negociar 16
#define textbox_recarregar 17
#define textbox_sinalizar 18
#define textbox_animes2 19
#define textbox_cintura 20
#define textbox_fermimento 21

#define PreloadAnimLib(%1,%2)	ApplyAnimation(%1,%2,"null",0.0,0,0,0,0,0)

//#define ALLOWED_PICKUPS 350 // Uncomment this if you know that you will never reach 2048 pickups.
 
#if defined ALLOWED_PICKUPS
    new iPickups[ALLOWED_PICKUPS][5];
#else
    new iPickups[MAX_PICKUPS][5];
#endif

main() {
}

//Enumerates:
enum jogadorData {
   pVeiculo,
   pEquipe,
   pFerido,
   pAlgemado,
   pDerrubado,
   pAnim,
   pElastomero,
   pRadioPD,
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

enum objetoData {
    objetoCriado,
    Float:sX,
    Float:sY,
    Float:sZ,
    sObject,
};

enum ferimentoData {
	Float:ftronco,
	Float:fpelvis,
	Float:fbracoesq,
	Float:fbracodir,
	Float:fpernaesq,
	Float:fpernadir,
	Float:fcabeca,
	fcausa[64],
}

//Variáveis globais:
new veiculosNomes[212][] =  {
{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},{"Dumper"},
{"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},
{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},{"Washington"},
{"Bobcat"},{"Mr Whoopee"},{"BF Injection"},{"Hunter"},{"Premier"},{"Enforcer"},{"Securicar"},
{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Trailer 1"},{"Previon"},
{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},
{"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Trailer 2"},{"Turismo"},
{"Speeder"},{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},
{"Skimmer"},{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},
{"Sanchez"},{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},
{"Rustler"},{"ZR-350"},{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},
{"Baggage"},{"Dozer"},{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},
{"Jetmax"},{"Hotring"},{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},
{"Mesa"},{"RC Goblin"},{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},
{"Super GT"},{"Elegant"},{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},
{"Tanker"}, {"Roadtrain"},{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},
{"NRG-500"},{"HPV1000"},{"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},
{"Willard"},{"Forklift"},{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},
{"Blade"},{"Freight"},{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},
{"Firetruck LA"},{"Hustler"},{"Intruder"},{"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},
{"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},{"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},
{"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},
{"Bandito"},{"Freight Flat"},{"Streak Carriage"},{"Kart"},{"Mower"},{"Duneride"},{"Sweeper"},
{"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},
{"Tug"},{"Trailer 3"},{"Andromada"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},{"Freight Carriage"},
{"Trailer 3"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},{"Police Car (SFPD)"},
{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},{"Alpha"},{"Phoenix"},{"Glendale"},
{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},{"Boxville"},{"Farm Plow"},
{"Utility Trailer"}};

new const AnimLibs[][] = {
  "AIRPORT",      "ATTRACTORS",   "BAR",          "BASEBALL",     "BD_FIRE",
  "BEACH",        "BENCHPRESS",   "BF_INJECTION", "BIKE_DBZ",     "BIKED",
  "BIKEH",        "BIKELEAP",     "BIKES",        "BIKEV",        "BLOWJOBZ",
  "BMX",          "BOMBER",       "BOX",          "BSKTBALL",     "BUDDY",
  "BUS",          "CAMERA",       "CAR",          "CAR_CHAT",     "CARRY",
  "CASINO",       "CHAINSAW",     "CHOPPA",       "CLOTHES",      "COACH",
  "COLT45",       "COP_AMBIENT",  "COP_DVBYZ",    "CRACK",        "CRIB",
  "DAM_JUMP",     "DANCING",      "DEALER",       "DILDO",        "DODGE",
  "DOZER",        "DRIVEBYS",     "FAT",          "FIGHT_B",      "FIGHT_C",
  "FIGHT_D",      "FIGHT_E",      "FINALE",       "FINALE2",      "FLAME",
  "FLOWERS",      "FOOD",         "FREEWEIGHTS",  "GANGS",        "GFUNK",
  "GHANDS",       "GHETTO_DB",    "GOGGLES",      "GRAFFITI",     "GRAVEYARD",
  "GRENADE",      "GYMNASIUM",    "HAIRCUTS",     "HEIST9",       "INT_HOUSE",
  "INT_OFFICE",   "INT_SHOP",     "JST_BUISNESS", "KART",         "KISSING",
  "KNIFE",        "LAPDAN1",      "LAPDAN2",      "LAPDAN3",      "LOWRIDER",
  "MD_CHASE",     "MD_END",       "MEDIC",        "MISC",         "MTB",
  "MUSCULAR",     "NEVADA",       "ON_LOOKERS",   "OTB",          "PARACHUTE",
  "PARK",         "PAULNMAC",     "PED",          "PLAYER_DVBYS", "PLAYIDLES",
  "POLICE",       "POOL",         "POOR",         "PYTHON",       "QUAD",
  "QUAD_DBZ",     "RAPPING",      "RIFLE",        "RIOT",         "ROB_BANK",
  "ROCKET",       "RUNNINGMAN",   "RUSTLER",      "RYDER",        "SCRATCHING",
  "SEX",          "SHAMAL",       "SHOP",         "SHOTGUN",      "SILENCED",
  "SKATE",        "SMOKING",      "SNIPER",       "SNM",          "SPRAYCAN",
  "STRIP",        "SUNBATHE",     "SWAT",         "SWEET",        "SWIM",
  "SWORD",        "TANK",         "TATTOOS",      "TEC",          "TRAIN",
  "TRUCK",        "UZI",          "VAN",          "VENDING",      "VORTEX",
  "WAYFARER",     "WEAPONS",      "WOP",          "WUZI"
};

new gpbMensagem[512];
new veiculoMotor[MAX_VEHICLES];
new veiculoAvariado[MAX_VEHICLES];
new veiculoPrefixo[MAX_VEHICLES];
new Text3D:veiculoPrefixo3D[MAX_VEHICLES];
new veiculoTrancado[MAX_VEHICLES];
new player[MAX_PLAYERS][jogadorData];
new playerSkin[MAX_PLAYERS];
new PlayerInfo[MAX_PLAYERS][jogadorData];
new ferimento[MAX_PLAYERS][ferimentoData];
new morto[MAX_PLAYERS][mortoData];
new objeto[MAX_OBJETOS][objetoData];

//Returns:
ReturnVehicleId(vName[]) {
	for(new x; x < 211; x++) {
 		if(strfind(veiculosNomes[x], vName, true) != -1) {
	 		return x + 400;
  		}
	}
	return -1;
}

//Funções nativas:
native IsValidVehicle(vehicleid);

//Funções stocks:
stock PreloadAnimLibs(playerid) {
  for(new i = 0; i < sizeof(AnimLibs); i++) {
      ApplyAnimation(playerid, AnimLibs[i], "null", 4.0, 0, 0, 0, 0, 0, 1);
  }
  return 1;
}

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

stock VeiculoComJogador(vehicleid) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
		if(IsPlayerInVehicle(i, vehicleid) && (GetPlayerState(i) == PLAYER_STATE_DRIVER || GetPlayerState(i) == PLAYER_STATE_PASSENGER)) {
			return 1;
		}
	}
    return 0;
    
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
    	if(objeto[i][objetoCriado] == 0) {
            objeto[i][objetoCriado] = 1;
            objeto[i][sX] = x;
            objeto[i][sY] = y;
            objeto[i][sZ] = z-0.7;
            objeto[i][sObject] = CreateDynamicObject(Object, x, y, z-0.9, 0, 0, Angle+90);
            return 1;
		}
	}
	return 0;
}

stock PopPlayerTires(playerid){
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid != 0){
        new panels, doors, lights, tires;
        GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
        UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, 15);
    }
}
 
stock CreateLargeStinger(Float:X, Float:Y, Float:Z, Float:A, virtualworld){
    for(new stingerid = 0; stingerid < sizeof(iPickups); stingerid++){
        if(iPickups[stingerid][0] == -1){
            new Float:dis1 = floatsin(-A, degrees), Float:dis2 = floatcos(-A, degrees);
            iPickups[stingerid][0] = CreateObject(2892, X, Y, Z, 0.0, 0.0, A);
            iPickups[stingerid][1] = CreatePickup(1007, 14, X+(4.0*dis1), Y+(4.0*dis2), Z, virtualworld);
            iPickups[stingerid][2] = CreatePickup(1007, 14, X+(1.25*dis1), Y+(1.25*dis2), Z, virtualworld);
            iPickups[stingerid][3] = CreatePickup(1007, 14, X-(4.0*dis1), Y-(4.0*dis2), Z, virtualworld);
            iPickups[stingerid][4] = CreatePickup(1007, 14, X-(1.25*dis1), Y-(1.25*dis2), Z, virtualworld);
            return stingerid;
        }
    }
    return -1;
}
 
stock CreateSmallStinger(Float:X, Float:Y, Float:Z, Float:A, virtualworld){
    for(new stingerid = 0; stingerid < sizeof(iPickups); stingerid++){
        if(iPickups[stingerid][0] == -1){
            new Float:dis1 = floatsin(-A, degrees), Float:dis2 = floatcos(-A, degrees);
            iPickups[stingerid][0] = CreateObject(2899, X, Y, Z, 0.0, 0.0, A);
            iPickups[stingerid][1] = CreatePickup(1007, 14, X+(1.5*dis1), Y+(1.5*dis2), Z, virtualworld);
            iPickups[stingerid][2] = CreatePickup(1007, 14, X-(1.5*dis1), Y-(1.5*dis2), Z, virtualworld);
            return stingerid;
        }
    }
    return -1;
}

//Funções públicas:
public OnGameModeInit() {
	SetGameModeText("GPB:F v0.5");
    ManualVehicleEngineAndLights();
	SetNameTagDrawDistance(20.0);
	EnableStuntBonusForAll(0);
	SetWorldTime(20);
	for(new i = 0; i < sizeof(iPickups); i++){
        iPickups[i][0] = -1;
        iPickups[i][1] = -1;
        iPickups[i][2] = -1;
        iPickups[i][3] = -1;
        iPickups[i][4] = -1;
    }
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
	player[playerid][pRadioPD] = 0;
	ferimento[playerid][ftronco] = 0;
	ferimento[playerid][fpelvis] = 0;
	ferimento[playerid][fbracoesq] = 0;
	ferimento[playerid][fbracodir] = 0;
	ferimento[playerid][fpernaesq] = 0;
	ferimento[playerid][fpernadir] = 0;
	ferimento[playerid][fcabeca] = 0;
	format(ferimento[playerid][fcausa], 128, "-"); 
	SetPlayerColor(playerid, white);
 	TogglePlayerSpectating(playerid, true);
	SpawnPlayer(playerid);
 	SetSpawnInfo(playerid, -1, random(311), 1836, -1413, 29,269.2782,0,0,0,0,0,0); // SetSpawnInfo(playerid, -1, random(311), 1826, -1372, 14,269.2782,0,0,0,0,0,0);
 	TogglePlayerSpectating(playerid, false);
    return 1;
}

public OnPlayerConnect(playerid) {
	player[playerid][pFerido] = 0;
	player[playerid][pEquipe] = 0;
	player[playerid][pAnim] = 0;
	player[playerid][pAlgemado] = 0;
	player[playerid][pDerrubado] = 0;
	player[playerid][pElastomero] = 0;
	player[playerid][pRadioPD] = 0;
	ferimento[playerid][ftronco] = 0;
	ferimento[playerid][fpelvis] = 0;
	ferimento[playerid][fbracoesq] = 0;
	ferimento[playerid][fbracodir] = 0;
	ferimento[playerid][fpernaesq] = 0;
	ferimento[playerid][fpernadir] = 0;
	ferimento[playerid][fcabeca] = 0;
	format(ferimento[playerid][fcausa], 128, "-");
 	JogadorConecta(playerid);
	SetPlayerVirtualWorld(playerid, 0);
	ShowPlayerMarkers(0);
	RemovePlayerMapIcon(playerid, -1);
	GivePlayerMoney(playerid, 1000);
	SendClientMessage(playerid, white, "Digite /comandos para ver os comandos existentes no servidor.");
	SendClientMessage(playerid, white, "Você spawnou como um civil. Digite /equipe para entrar em alguma corporação.");
	PreloadAnimLibs(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason) {
	JogadorDesconecta(playerid, reason);
	return 1;
}

public OnPlayerSpawn(playerid) {
    if(morto[playerid][morto_X]) { // Faz o jogador spawnar no mesmo local em que morreu
	    ClearAnimations(playerid);
	    SetPlayerPos(playerid, morto[playerid][morto_X], morto[playerid][morto_Y], morto[playerid][morto_Z]);
	    SetPlayerFacingAngle(playerid, morto[playerid][morto_A]);
	    SetPlayerVirtualWorld(playerid, morto[playerid][morto_vw]);
	    SetPlayerInterior(playerid, morto[playerid][morto_int]);
		SetPlayerSkin(playerid, playerSkin[playerid]);
		ApplyAnimation(playerid, "ped", "KO_skid_front", 4.1, 0, 0, 0, 1, 0, 1);
		new reset[mortoData];
		morto[playerid] = reset;
		morto[playerid][morto_dead] = true;
 	}
    HabilidadeArmas(playerid);
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart) {
	new Float:health;
	GetPlayerHealth(playerid,health);
	if (player[playerid][pAnim] == 1) { // Remove as animações ao atirar
		player[playerid][pAnim] = 0;
		ClearAnimations(playerid, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	if ((health < 65) && !IsPlayerInAnyVehicle(playerid) && weaponid != 23 && weaponid != 25 && player[playerid][pFerido] == 0) { // Geral
		player[playerid][pFerido] = 1;
		SetPlayerHealth(playerid, 98303);
		SetPlayerColor(playerid, red);
		ApplyAnimation(playerid, "ped", "KO_skid_front", 4.1, 0, 0, 0, 1, 0, 1);
		SendClientMessage(playerid, grey, "Você está ferido. Para voltar ao controle do personagem use o /reviver.");

	}
	if ((health < 65) && IsPlayerInAnyVehicle(playerid) && weaponid != 23 && weaponid != 25 && player[playerid][pFerido] == 0) { // Vítima em algum veículo
		player[playerid][pFerido] = 1;
		SetPlayerHealth(playerid, 98303);
		SetPlayerColor(playerid, red);
		ApplyAnimation(playerid, "ped", "car_dead_lhs", 4.1, 0, 1, 0, 1, 0, 1);
		SendClientMessage(playerid, grey, "Você está ferido. Para voltar ao controle do personagem use o /reviver.");

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
				ApplyAnimation(playerid, "ped", "KO_skid_front", 4.1, 0, 0, 0, 1, 0, 1);
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
		else if (IsPlayerInAnyVehicle(playerid)) {
			SetPlayerHealth(playerid, 100);
		}
		else {
			new Float:dano = 10;
			new Float:elastomero = random(2);
			GetPlayerHealth(playerid, health);
			SetPlayerHealth(playerid, health-dano);
			
			if (player[playerid][pFerido] == 0 && !IsPlayerInAnyVehicle(playerid)) {
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
			if (elastomero == 1 && player[playerid][pFerido] == 0) {
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
	if (player[playerid][pFerido] == 0) { /* Sistema de ferimento */
		if (weaponid == 54) {
			ferimento[playerid][ftronco] = ferimento[playerid][ftronco] + random(floatround(Float:amount, floatround_round));
			ferimento[playerid][fpelvis] = ferimento[playerid][fpelvis] + random(floatround(Float:amount, floatround_round));
			ferimento[playerid][fbracoesq] = ferimento[playerid][fbracoesq] + random(floatround(Float:amount, floatround_round));
			ferimento[playerid][fbracodir] = ferimento[playerid][fbracodir] + random(floatround(Float:amount, floatround_round));
			ferimento[playerid][fpernaesq] = ferimento[playerid][fpernaesq] + random(floatround(Float:amount, floatround_round));
			ferimento[playerid][fpernadir] = ferimento[playerid][fpernadir] + random(floatround(Float:amount, floatround_round));
			ferimento[playerid][fcabeca] = ferimento[playerid][fcabeca] + random(floatround(Float:amount, floatround_round));
		}
		if (bodypart == 3 && weaponid != 54) {
			ferimento[playerid][ftronco] = ferimento[playerid][ftronco] + amount;
		}
		else if (bodypart == 4) {
			ferimento[playerid][fpelvis] = ferimento[playerid][fpelvis] + amount;
		}
		else if (bodypart == 5) {
			ferimento[playerid][fbracoesq] = ferimento[playerid][fbracoesq] + amount;
		}
		else if (bodypart == 6) {
			ferimento[playerid][fbracodir] = ferimento[playerid][fbracodir] + amount;
		}
		else if (bodypart == 7) {
			ferimento[playerid][fpernaesq] = ferimento[playerid][fpernaesq] + amount;
		}
		else if (bodypart == 8) {
			ferimento[playerid][fpernadir] = ferimento[playerid][fpernadir] + amount;
		}
		else if (bodypart == 9) {
			ferimento[playerid][fcabeca] = ferimento[playerid][fcabeca] + amount;
		}
		if(weaponid == 54) {
			format(ferimento[playerid][fcausa], 128, "queda"); 
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
		ApplyAnimation(playerid, "ped", "KO_skid_front", 4.1, 0, 0, 0, 1, 0, 1);
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
	new Float:chat = random(9);
	if (player[playerid][pFerido] == 0 && player[playerid][pAlgemado] == 0 && player[playerid][pAnim] == 0 && !IsPlayerInAnyVehicle(playerid)) { // Variação na animação de chat.
		if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK) {
			return 1;
		}
		else if (chat == 0) {
			ApplyAnimation(playerid, "MISC", "Idle_Chat_02", 4.1, 0, 0, 0, 0, 0, 1);
		}
		else if (chat == 1) {
			ApplyAnimation(playerid, "ped", "IDLE_chat", 4.1, 0, 0, 0, 0, 0, 1);
		}
		else if (chat == 2) {
			ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.1, 0, 0, 0, 0, 0, 1);
		}
		else if (chat == 3) {
			ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.1, 0, 0, 0, 0, 0, 1);
		}
		else if (chat == 4) {
			ApplyAnimation(playerid, "GANGS", "prtial_gngtlkC", 4.1, 0, 0, 0, 0, 0, 1);
		}
		else if (chat == 5) {
			ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.1, 0, 0, 0, 0, 0, 1);
		}
		else if (chat == 6) {
			ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, 0, 0, 0, 0, 0, 1);
		}
		else if (chat == 7) {
			ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.1, 0, 0, 0, 0, 0, 1);
		}
		else if (chat == 8) {
			ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.1, 0, 0, 0, 0, 0, 1);
		}
		else if (chat == 9) {
			ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.1, 0, 0, 0, 0, 0, 1);
		}
	}
	if(strlen(text) > 65) {
		text[0] = toupper(text[0]);
		new gpbMensagem2[128];
		format(gpbMensagem, sizeof(gpbMensagem), "%s — %.64s [...]", GetName(playerid), text);
		format(gpbMensagem2, sizeof(gpbMensagem2), "[...] %s", text[64]);
		SendRangedMessage(playerid, white, gpbMensagem, 20);
		SendRangedMessage(playerid, white, gpbMensagem2, 20);
		SetPlayerChatBubble(playerid, gpbMensagem, white, 20, 10000);
	}
	else {
		text[0] = toupper(text[0]);
		format(gpbMensagem, 500, "%s — %s", GetName(playerid), text);
		SendRangedMessage(playerid, white, gpbMensagem, 20);
		SetPlayerChatBubble(playerid, gpbMensagem, white, 20, 10000);
	}
	return 0;
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
	if (veiculoTrancado[vehicleid] == 1) {
		new Float:X, Float:Y, Float:Z;
		SendClientMessage(playerid, grey, "Este veículo está trancado.");
		GetPlayerPos(playerid, X, Y, Z);
		SetPlayerPos(playerid, X, Y, Z);
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
	for(new stingerid = 0; stingerid < sizeof(iPickups); stingerid++){
        if(pickupid == iPickups[stingerid][1]){
            new Float:X, Float:Y, Float:Z, Float:A;
            GetObjectPos(iPickups[stingerid][0], X, Y, Z);
            GetObjectRot(iPickups[stingerid][0], A, A, A);
            new Float:dis1 = floatsin(-A, degrees), Float:dis2 = floatcos(-A, degrees);
            PopPlayerTires(playerid);
            DestroyPickup(pickupid);
            if(iPickups[stingerid][3] == -1){ // Small Stinger
                iPickups[stingerid][1] = CreatePickup(1007, 14, X+(1.5*dis1), Y+(1.5*dis2), Z, GetPlayerVirtualWorld(playerid));
            }
            else{ // Large Stinger
                iPickups[stingerid][1] = CreatePickup(1007, 14, X+(4.0*dis1), Y+(4.0*dis2), Z, GetPlayerVirtualWorld(playerid));
            }
            break;
        }
        else if(pickupid == iPickups[stingerid][2]){
            new Float:X, Float:Y, Float:Z, Float:A;
            GetObjectPos(iPickups[stingerid][0], X, Y, Z);
            GetObjectRot(iPickups[stingerid][0], A, A, A);
            new Float:dis1 = floatsin(-A, degrees), Float:dis2 = floatcos(-A, degrees);
            PopPlayerTires(playerid);
            DestroyPickup(pickupid);
            if(iPickups[stingerid][3] == -1){ // Small Stinger
                iPickups[stingerid][2] = CreatePickup(1007, 14, X-(1.5*dis1), Y-(1.5*dis2), Z, GetPlayerVirtualWorld(playerid));
            }
            else{ // Large Stinger
                iPickups[stingerid][2] = CreatePickup(1007, 14, X+(1.25*dis1), Y+(1.25*dis2), Z, GetPlayerVirtualWorld(playerid));
            }
            break;
        }
        else if(pickupid == iPickups[stingerid][3]){
            new Float:X, Float:Y, Float:Z, Float:A;
            GetObjectPos(iPickups[stingerid][0], X, Y, Z);
            GetObjectRot(iPickups[stingerid][0], A, A, A);
            new Float:dis1 = floatsin(-A, degrees), Float:dis2 = floatcos(-A, degrees);
            PopPlayerTires(playerid);
            DestroyPickup(pickupid);
            iPickups[stingerid][3] = CreatePickup(1007, 14, X-(4.0*dis1), Y-(4.0*dis2), Z, GetPlayerVirtualWorld(playerid));
            break;
        }
        else if(pickupid == iPickups[stingerid][4]){
            new Float:X, Float:Y, Float:Z, Float:A;
            GetObjectPos(iPickups[stingerid][0], X, Y, Z);
            GetObjectRot(iPickups[stingerid][0], A, A, A);
            new Float:dis1 = floatsin(-A, degrees), Float:dis2 = floatcos(-A, degrees);
            PopPlayerTires(playerid);
            DestroyPickup(pickupid);
            iPickups[stingerid][4] = CreatePickup(1007, 14, X-(1.25*dis1), Y-(1.25*dis2), Z, GetPlayerVirtualWorld(playerid));
            break;
        }
    }
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
	if (newkeys == KEY_YES) { // Limpar animação com o clique esquerdo
		if (player[playerid][pFerido] == 0 && player[playerid][pAlgemado] == 0 && player[playerid][pDerrubado] == 0 && !IsPlayerInAnyVehicle(playerid)) {
			player[playerid][pAnim] = 0;
			ClearAnimations(playerid, 1);
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
				case 5: GivePlayerWeapon(playerid, 22, 100); // 9mm
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
					GivePlayerWeapon(playerid, 25, 100); // Escopeta
					player[playerid][pElastomero] = 0;
				}
				case 9: {
					if (player[playerid][pEquipe] != 1) {
							SendClientMessage(playerid, grey, "Apenas policiais podem portar a escopeta com munição elastômero.");
						}
					else {
						GivePlayerWeapon(playerid, 25, 100); // Escopeta (Elastômero)
						player[playerid][pElastomero] = 1;
					}
				}
				case 10: GivePlayerWeapon(playerid, 27, 100); // Escopeta de combate
				case 11: GivePlayerWeapon(playerid, 26, 100); // Escopeta de cano serrado
				case 12: GivePlayerWeapon(playerid, 28, 500); // UZI
				case 13: GivePlayerWeapon(playerid, 32, 500); // TEC9
				case 14: GivePlayerWeapon(playerid, 29, 500); // MP5
				case 15: GivePlayerWeapon(playerid, 31, 500); // M4
				case 16: GivePlayerWeapon(playerid, 30, 500); // AK47
				case 17: GivePlayerWeapon(playerid, 34,  50); // Sniper
				case 18: GivePlayerWeapon(playerid, 33, 50); // Rifle de caça
				case 19: GivePlayerWeapon(playerid, 17, 10); // Granada de fumaça
				case 20: GivePlayerWeapon(playerid, 18, 5); // Molotov
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
					else if(player[playerid][pEquipe] == 1) {
						RadioPolicialSai(playerid);
						player[playerid][pEquipe] = 0;
						SendClientMessage(playerid, grey, "Você agora é um civil."); 
						SetPlayerColor(playerid, white);
					}
					else if(player[playerid][pEquipe] == 2) {
						RadioCriminosoSai(playerid);
						player[playerid][pEquipe] = 0;
						SendClientMessage(playerid, grey, "Você agora é um civil."); 
						SetPlayerColor(playerid, white);
					}
					else if(player[playerid][pEquipe] == 3) {
						RadioParamedicoSai(playerid);
						player[playerid][pEquipe] = 0;
						SendClientMessage(playerid, grey, "Você agora é um civil."); 
						SetPlayerColor(playerid, white);
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
					else if(player[playerid][pEquipe] == 2) {
						RadioCriminosoSai(playerid);
						player[playerid][pEquipe] = 1;
						SendClientMessage(playerid, grey, "Agora você é um policial. Use /r caso queira comunicar-se com mais criminosos.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetPlayerColor(playerid, white);
						SetTimerEx("RadioPolicialEntra", 1500, false, "i", playerid);
						if(player[playerid][pRadioPD] == 1) {
							SetTimerEx("RadioPD", 5000, false, "i", playerid);
						}
					}
					else if(player[playerid][pEquipe] == 3) {
						RadioParamedicoSai(playerid);
						player[playerid][pEquipe] = 1;
						SendClientMessage(playerid, grey, "Agora você é um policial.. Use /r caso queira comunicar-se com mais criminosos.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetPlayerColor(playerid, white);
						SetTimerEx("RadioPolicialEntra", 1500, false, "i", playerid);
						if(player[playerid][pRadioPD] == 1) {
							SetTimerEx("RadioPD", 5000, false, "i", playerid);
						}
					}
					else {
						player[playerid][pEquipe] = 1;
						SendClientMessage(playerid, grey, "Agora você é um policial. Use /r para comunicar-se com sua equipe.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetPlayerColor(playerid, white);
						SetTimerEx("RadioPolicialEntra", 1500, false, "i", playerid);
						if(player[playerid][pRadioPD] == 1) {
							SetTimerEx("RadioPD", 5000, false, "i", playerid);
						}
					}
				case 2: // Criminoso
					if(player[playerid][pEquipe] == 2) {
						SendClientMessage(playerid, grey, "Você já é um criminoso.");
					}
					else if(player[playerid][pEquipe] == 1) {
						RadioPolicialSai(playerid);
						player[playerid][pEquipe] = 2;
						SendClientMessage(playerid, grey, "Criminoso. Use /r caso queira comunicar-se com mais criminosos.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetPlayerColor(playerid, white);
						SetTimerEx("RadioCriminosoEntra", 1500, false, "i", playerid);
						if(player[playerid][pRadioPD] == 1) {
							SetTimerEx("RadioPD", 5000, false, "i", playerid);
						}
					}
					else if(player[playerid][pEquipe] == 3) {
						RadioParamedicoSai(playerid);
						player[playerid][pEquipe] = 2;
						SendClientMessage(playerid, grey, "Criminoso. Use /r caso queira comunicar-se com mais criminosos.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetPlayerColor(playerid, white);
						SetTimerEx("RadioCriminosoEntra", 1500, false, "i", playerid);
						if(player[playerid][pRadioPD] == 1) {
							SetTimerEx("RadioPD", 5000, false, "i", playerid);
						}
					}
					else {
						player[playerid][pEquipe] = 2;
						SendClientMessage(playerid, grey, "Paramédico selecionado com sucesso. Use /r caso queira comunicar-se com mais criminosos.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetPlayerColor(playerid, white);
						SetTimerEx("RadioCriminosoEntra", 1500, false, "i", playerid);
						if(player[playerid][pRadioPD] == 1) {
							SetTimerEx("RadioPD", 5000, false, "i", playerid);
						}
					}
				case 3: // Paramédico
					if(player[playerid][pEquipe] == 3) {
						SendClientMessage(playerid, grey, "Você já é um paramédico.");
					}
					else if(player[playerid][pEquipe] == 1) {
						RadioPolicialSai(playerid);
						player[playerid][pEquipe] = 3;
						SendClientMessage(playerid, grey, "Paramédico selecionado com sucesso. Use /r caso queira comunicar-se com mais criminosos.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetPlayerColor(playerid, white);
						SetTimerEx("RadioParamedicoEntra", 1500, false, "i", playerid);
						if(player[playerid][pRadioPD] == 1) {
							SetTimerEx("RadioPD", 5000, false, "i", playerid);
						}
					}
					else if(player[playerid][pEquipe] == 2) {
						RadioCriminosoSai(playerid);
						player[playerid][pEquipe] = 3;
						SendClientMessage(playerid, grey, "Paramédico selecionado com sucesso. Use /r caso queira comunicar-se com mais criminosos.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetPlayerColor(playerid, white);
						SetTimerEx("RadioParamedicoEntra", 1500, false, "i", playerid);
						if(player[playerid][pRadioPD] == 1) {
							SetTimerEx("RadioPD", 5000, false, "i", playerid);
						}
					}
					else {
						player[playerid][pEquipe] = 3;
						SendClientMessage(playerid, grey, "Paramédico selecionado com sucesso. Você ganhou um rádio para comunicar-se com sua equipe.");
						PlayAudioStreamForPlayer(playerid, "https://www.dl.dropboxusercontent.com/s/e5r1ncgz5ghaypn/gpb_noise.mp3");
						SetTimerEx("RadioParamedicoEntra", 1500, false, "i", playerid);
						SetPlayerColor(playerid, white);
						if(player[playerid][pRadioPD] == 1) {
							SetTimerEx("RadioPD", 5000, false, "i", playerid);
						}
					}
			}
		}
	}
	switch(dialogid) {
  		case textbox_animes1: {
			switch(listitem) { 
				case 0: { // Parar animação
					if (IsPlayerInAnyVehicle(playerid)) {
						return 1;
					}
					else {
						ClearAnimations(playerid);
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
						player[playerid][pAnim] = 0;
					}
				}
				case 1: { // Cambalear
					ApplyAnimation(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1, 1);
					player[playerid][pAnim] = 1;
				}
				case 2: { // Cansar
					ApplyAnimation(playerid, "PED", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
					player[playerid][pAnim] = 1;
				}
				case 3: { // Carregar
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
					player[playerid][pAnim] = 1;
				}
				case 4: { // Chorar
					ApplyAnimation(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0, 1);
					player[playerid][pAnim] = 1;
				}
				case 5: { // Braço para fora do veículo
					if (IsPlayerInAnyVehicle(playerid)) {
						new playerseat = GetPlayerVehicleSeat(playerid);
						if(playerseat == 0 || playerseat == 2) {
							ApplyAnimation(playerid, "CAR", "Sit_relaxed", 4.1, 1, 0, 0, 0, 0, 1);
						} 
						else {
							ApplyAnimation(playerid, "PED", "Tap_handP", 4.1, 1, 0, 0, 0, 0, 1);
						}
					}
					else {
						SendClientMessage(playerid, grey, "Você precisa estar em algum veículo.");
					}
				}
				case 6: { // Colocar mãos para cima
					ApplyAnimation(playerid, "SHOP", "SHP_Rob_HandsUp", 4.1, 1, 0, 0, 1, 0, 1);
					player[playerid][pAnim] = 1;
				}
				case 7: { // Fotografar
					ApplyAnimation(playerid, "CAMERA", "camstnd_to_camcrch", 4.1, 0, 0, 0, 1, 0, 1);
					player[playerid][pAnim] = 1;
				}
				case 8: { // Fumar
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
					ApplyAnimation(playerid, "GANGS", "smkcig_prtl", 0.1, 1, 0, 0, 0, 0, 1);
				}
				case 9: { // Meditar
					ApplyAnimation(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0, 1);
				}
				case 10: { // Plantar
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 11: { // Portar
					ApplyAnimation(playerid, "ped", "IDLE_armed", 4.1, 0, 0, 0, 1, 0, 1);
				}
				case 12: { // Revistar
					ApplyAnimation(playerid, "POLICE", "plc_drgbst_02", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 13: { // Urinar
					SetPlayerSpecialAction(playerid, 68);
				}
				case 14: { // Vomitar
					ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1);
				}
				case 15: { // Acenar
					ShowPlayerDialog(playerid, textbox_acenar, DIALOG_STYLE_INPUT, "Acenar", "Digite um número entre 1 e 3:", "Confirmar", "");
				}
				case 16: { // Apontar
					ShowPlayerDialog(playerid, textbox_apontar, DIALOG_STYLE_INPUT, "Apontar", "Digite um número entre 1 e 4:", "Confirmar", "");
				}
				case 17: { // Beijar
					ShowPlayerDialog(playerid, textbox_beijar, DIALOG_STYLE_INPUT, "Beijar", "Digite um número entre 1 e 6:", "Confirmar", "");
				}
				case 18: { // Comer
					ShowPlayerDialog(playerid, textbox_comer, DIALOG_STYLE_INPUT, "Comer", "Digite um número entre 1 e 3:", "Confirmar", "");
				}
				case 19: { // Comemorar
					ShowPlayerDialog(playerid, textbox_comemorar, DIALOG_STYLE_INPUT, "Comemorar", "Digite um número entre 1 e 8:", "Confirmar", "");
				}
				case 20: { // Conversar
					ShowPlayerDialog(playerid, textbox_conversar, DIALOG_STYLE_INPUT, "Conversar", "Digite um número entre 1 e 6:", "Confirmar", "");
				}
				case 21: { // Cruzar
					ShowPlayerDialog(playerid, textbox_cruzar, DIALOG_STYLE_INPUT, "Cruzar", "Digite um número entre 1 e 4:", "Confirmar", "");
				}
				case 22: { // Dançar
					ShowPlayerDialog(playerid, textbox_dancar, DIALOG_STYLE_INPUT, "Dançar", "Digite um número entre 1 e 10:", "Confirmar", "");
				}
				case 23: { // Deitar-se
					ShowPlayerDialog(playerid, textbox_deitarse, DIALOG_STYLE_INPUT, "Deitar-se", "Digite um número entre 1 e 5:", "Confirmar", "");
				}
				case 24: { // Dormir
					ShowPlayerDialog(playerid, textbox_dormir, DIALOG_STYLE_INPUT, "Dormir", "Digite um número entre 1 e 2:", "Confirmar", "");
				}
				case 25: { // Drogar-se
					ShowPlayerDialog(playerid, textbox_drogarse, DIALOG_STYLE_INPUT, "Drogar-se", "Digite um número entre 1 e 6:", "Confirmar", "");
				}
				case 26: { // Masturbar-se
					ShowPlayerDialog(playerid, textbox_masturbarse, DIALOG_STYLE_INPUT, "Masturbar-se", "Digite um número entre 1 e 3:", "Confirmar", "");
				}
				case 27: { // Negociar
					ShowPlayerDialog(playerid, textbox_negociar, DIALOG_STYLE_INPUT, "Negociar", "Digite um número entre 1 e 6:", "Confirmar", "");
				}
				case 28: { // Recarregar
					ShowPlayerDialog(playerid, textbox_recarregar, DIALOG_STYLE_INPUT, "Recarregar", "Digite um número entre 1 e 4:", "Confirmar", "");
				}
				case 29: { // Próxima página
					ShowPlayerDialog(playerid, textbox_animes2, DIALOG_STYLE_TABLIST_HEADERS, "Animações",
					"Descrição\tEscopo\n\
					Agachar\t\n\
					Encostar\t\n\
					Mãos na cintura\t[1-2]\n\
					Sinalizar\t[1-10]\n\
					Voltar página\t<\n",
					"Confirmar", "");
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_acenar: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 3) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 0;
				switch(type) {
					case 1: {
						ApplyAnimation(playerid, "PED", "endchat_03", 4.1, 0, 0, 0, 0, 0, 1);
					}
					case 2: {
						ApplyAnimation(playerid, "KISSING", "gfwave2", 4.1, 0, 0, 0, 0, 0, 1);
					}
					case 3: {
						ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0, 1);
						player[playerid][pAnim] = 1;
					}
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_apontar: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 4) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 1;
				switch(type) {
					case 1: ApplyAnimation(playerid, "PED", "ARRESTgun", 4.1, 0, 0, 0, 1, 0, 1);
					case 2: ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.1, 1, 0, 0, 0, 0, 1);
					case 3: ApplyAnimation(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0, 1);
					case 4: ApplyAnimation(playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 1, 0, 0, 0, 0, 1);
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_beijar: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 6) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 0;
				switch(type) {
					case 1: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
					case 2: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
					case 3: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
					case 4: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
					case 5: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
					case 6: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_comer: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 3) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 0;
				switch(type) {
					case 1: ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
					case 2: ApplyAnimation(playerid, "FOOD", "EAT_Chicken", 4.1, 0, 0, 0, 0, 0, 1);
					case 3: ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_comemorar: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 8) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 0;
				switch(type) {
					case 1: ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.1, 0, 0, 0, 0, 0, 1);
					case 2: ApplyAnimation(playerid, "ON_LOOKERS", "shout_02", 4.1, 0, 0, 0, 0, 0, 1);
					case 3: ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.1, 0, 0, 0, 0, 0, 1);
					case 4: ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
					case 5: ApplyAnimation(playerid, "RIOT", "RIOT_CHANT", 4.1, 0, 0, 0, 0, 0, 1);
					case 6: ApplyAnimation(playerid, "RIOT", "RIOT_shout", 4.1, 0, 0, 0, 0, 0, 1);
					case 7: ApplyAnimation(playerid, "STRIP", "PUN_HOLLER", 4.1, 0, 0, 0, 0, 0, 1);
					case 8: ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_conversar: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 6) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 0;
				switch(type) {
					case 1: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.1, 0, 0, 0, 0, 0, 1);
					case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.1, 0, 0, 0, 0, 0, 1);
					case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, 0, 0, 0, 0, 0, 1);
					case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.1, 0, 0, 0, 0, 0, 1);
					case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.1, 0, 0, 0, 0, 0, 1);
					case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_cruzar: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 4) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 1;
				switch(type) {
					case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 0, 1);
					case 2: ApplyAnimation(playerid, "GRAVEYARD", "prst_loopa", 4.1, 1, 0, 0, 0, 0, 1);
					case 3: ApplyAnimation(playerid, "GRAVEYARD", "mrnM_loop", 4.1, 1, 0, 0, 0, 0, 1);
					case 4: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 0, 1);
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_dancar: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 10) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 1;
				switch(type) {
					case 1: ApplyAnimation(playerid, "DANCING", "dance_loop", 4.1, 1, 0, 0, 0, 0, 1);
					case 2: ApplyAnimation(playerid, "DANCING", "DAN_Left_A", 4.1, 1, 0, 0, 0, 0, 1);
					case 3: ApplyAnimation(playerid, "DANCING", "DAN_Right_A", 4.1, 1, 0, 0, 0, 0, 1);
					case 4: ApplyAnimation(playerid, "DANCING", "DAN_Loop_A", 4.1, 1, 0, 0, 0, 0, 1);
					case 5: ApplyAnimation(playerid, "DANCING", "DAN_Up_A", 4.1, 1, 0, 0, 0, 0, 1);
					case 6: ApplyAnimation(playerid, "DANCING", "DAN_Down_A", 4.1, 1, 0, 0, 0, 0, 1);
					case 7: ApplyAnimation(playerid, "DANCING", "dnce_M_a", 4.1, 1, 0, 0, 0, 0, 1);
					case 8: ApplyAnimation(playerid, "DANCING", "dnce_M_e", 4.1, 1, 0, 0, 0, 0, 1);
					case 9: ApplyAnimation(playerid, "DANCING", "dnce_M_b", 4.1, 1, 0, 0, 0, 0, 1);
					case 10: ApplyAnimation(playerid, "DANCING", "dnce_M_c", 4.1, 1, 0, 0, 0, 0, 1);
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_deitarse: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 5) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 1;
				switch(type) {
					case 1: ApplyAnimation(playerid, "BEACH", "bather", 4.1, 1, 0, 0, 0, 0, 1);
					case 2: ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 0, 0, 0, 0, 1);
					case 3: ApplyAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0, 1);
					case 4: ApplyAnimation(playerid, "BEACH", "ParkSit_W_loop", 4.1, 1, 0, 0, 0, 0, 1);
					case 5: ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.1, 1, 0, 0, 0, 0, 1);
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_dormir: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 2) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 1;
				switch(type) {
					case 1: ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0, 1);
	    			case 2: ApplyAnimation(playerid, "CRACK", "crckidle4", 4.1, 0, 0, 0, 1, 0, 1);
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_drogarse: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 6) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 1;
				switch(type) {
					case 1: ApplyAnimation(playerid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0, 1);
					case 2: ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 0, 0, 1);
					case 3: ApplyAnimation(playerid, "CRACK", "crckdeth3", 4.1, 0, 0, 0, 1, 0, 1);
					case 4: ApplyAnimation(playerid, "CRACK", "crckidle1", 4.1, 0, 0, 0, 1, 0, 1);
					case 5: ApplyAnimation(playerid, "CRACK", "crckidle2", 4.1, 0, 0, 0, 1, 0, 1);
					case 6: ApplyAnimation(playerid, "CRACK", "crckidle3", 4.1, 0, 0, 0, 1, 0, 1);
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_masturbarse: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 4) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 1;
				switch(type) {
					case 1: {
						ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 0, 0, 0, 0, 1);
						player[playerid][pAnim] = 1;
					}
					case 2: {
						ApplyAnimation(playerid, "PAULNMAC", "wank_in", 4.1, 0, 0, 0, 0, 0, 1);
						player[playerid][pAnim] = 0;
					}
					case 3: {
						ApplyAnimation(playerid, "PAULNMAC", "wank_out", 4.1, 0, 0, 0, 0, 0, 1);
					}
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_negociar: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 4) {
				return 1;
			}
			else {
				switch(type) {
					case 1: {
						ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 0, 0, 0, 0, 1);
						player[playerid][pAnim] = 0;
					}
					case 2: {
						ApplyAnimation(playerid, "DEALER", "DRUGS_BUY", 4.1, 0, 0, 0, 0, 0, 1);
						player[playerid][pAnim] = 0;
					}
					case 3: {
						ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0, 1);
						player[playerid][pAnim] = 0;
					}
					case 4: {
						ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 1, 0, 0, 0, 0, 1);
						player[playerid][pAnim] = 0;
					}
					case 5: {
						ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_02", 4.1, 1, 0, 0, 0, 0, 1);
						player[playerid][pAnim] = 1;
					}
					case 6: {
						ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_03", 4.1, 1, 0, 0, 0, 0, 1);
						player[playerid][pAnim] = 1;
					}
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_recarregar: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 4) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 0;
				switch(type) {
					case 1: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 0, 0, 1);
					case 2: ApplyAnimation(playerid, "UZI", "UZI_reload", 4.1, 0, 0, 0, 0, 0, 1);
					case 3: ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.1, 0, 0, 0, 0, 0, 1);
					case 4: ApplyAnimation(playerid, "RIFLE", "rifle_load", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_animes2: {
			switch(listitem) { 
				case 0: { // Agachar
					ApplyAnimation(playerid, "PED", "cower", 4.1, 0, 0, 0, 1, 0, 1);
					player[playerid][pAnim] = 1;
				}
				case 1: { // Encostar
					ApplyAnimation(playerid, "GANGS", "leanIDLE", 4.1, 1, 0, 0, 1, 0, 1);
					player[playerid][pAnim] = 1;
				}
				case 2: { // Mãos na cintura
					ShowPlayerDialog(playerid, textbox_cintura, DIALOG_STYLE_INPUT, "Mãos na cintura", "Digite um número entre 1 e 2:", "Confirmar", "");
				}
				case 3: { // Sinalizar
					ShowPlayerDialog(playerid, textbox_sinalizar, DIALOG_STYLE_INPUT, "Sinalizar", "Digite um número entre 1 e 10:", "Confirmar", "");
				}
				case 4: { // Voltar página
					ShowPlayerDialog(playerid, textbox_animes1, DIALOG_STYLE_TABLIST_HEADERS, "Animações",
					"Descrição\tEscopo\n\
					Parar\tY\n\
					Cambalear\t\n\
					Cansar\t\n\
					Carregar\t\n\
					Chorar\t\n\
					Colocar braço para fora\t\n\
					Colocar mãos acima\t\n\
					Fotografar\t\n\
					Fumar\t\n\
					Meditar\t\n\
					Plantar\t\n\
					Portar\t\n\
					Revistar\t\n\
					Urinar\t\n\
					Vomitar\t\n\
					Acenar\t[1-3]\n\
					Apontar\t[1-4]\n\
					Beijar\t[1-6]\n\
					Comer\t[1-3]\n\
					Comemorar\t[1-8]\n\
					Conversar\t[1-6]\n\
					Cruzar\t[1-4]\n\
					Dançar\t[1-10]\n\
					Deitar-se\t[1-5]\n\
					Dormir\t[1-2]\n\
					Drogar-se\t[1-6]\n\
					Masturbar-se\t[1-3]\n\
					Negociar\t[1-6]\n\
					Recarregar\t[1-4]\n\
					Próxima página\t>\n",
					"Confirmar", "");
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_cintura: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 2) {
				return 1;
			}
			else {
				switch(type) {
					case 1: {
						ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_nod", 4.1, 0, 0, 0, 1, 0, 1);
						player[playerid][pAnim] = 1;
					}
					case 2: {
						ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_shake", 4.1, 0, 0, 0, 1, 0, 1);
						player[playerid][pAnim] = 1;
					}
				}
			}
		}
	}
	switch(dialogid) {
  		case textbox_sinalizar: {
			new type;
			if (sscanf(inputtext, "d", type)) {
				return 1;
			}
			else if (type < 1 || type > 10) {
				return 1;
			}
			else {
				player[playerid][pAnim] = 0;
				switch(type) {
					case 1: ApplyAnimation(playerid, "CAMERA", "camcrch_cmon", 4.1, 0, 0, 0, 0, 0, 1);
					case 2: ApplyAnimation(playerid, "CAMERA", "camstnd_cmon", 4.1, 0, 0, 0, 0, 0, 1);
					case 3: ApplyAnimation(playerid, "MISC", "BMX_comeon", 4.1, 0, 0, 0, 0, 0, 1);
					case 4: ApplyAnimation(playerid, "POLICE", "CopTraf_Away", 4.1, 0, 0, 0, 0, 0, 1);
					case 5: ApplyAnimation(playerid, "POLICE", "CopTraf_Come", 4.1, 0, 0, 0, 0, 0, 1);
					case 6: ApplyAnimation(playerid, "POLICE", "CopTraf_Left", 4.1, 0, 0, 0, 0, 0, 1);
					case 7: ApplyAnimation(playerid, "POLICE", "CopTraf_Stop", 4.1, 0, 0, 0, 0, 0, 1);
					case 8: ApplyAnimation(playerid, "RYDER", "RYD_Beckon_01", 4.1, 0, 0, 0, 0, 0, 1);
					case 9: ApplyAnimation(playerid, "RYDER", "RYD_Beckon_02", 4.1, 0, 0, 0, 0, 0, 1);
					case 10: ApplyAnimation(playerid, "RYDER", "RYD_Beckon_03", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source) {
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success) {
    new string[128];
    format(string, sizeof(string), "Comando inexistente. Digite /comandos para ver os comandos disponíveis.", cmdtext);
    if(!success){
    	SendClientMessage(playerid, grey, string);
    }
    return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid) {
	new Float:health;
	GetVehicleHealth(GetPlayerVehicleID(playerid), health);
	if(health < 550 && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_ENTER_VEHICLE){
		SetVehicleHealth(vehicleid, 400);
		new enginem, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(GetPlayerVehicleID(playerid),enginem, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(GetPlayerVehicleID(playerid),VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
		veiculoAvariado[vehicleid] = 1;
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

//Funções personalizadas:

forward DelayedKick(playerid);
public DelayedKick(playerid) {
    Kick(playerid);
    return 1;
}

forward DelayRadioAudio(i);
public DelayRadioAudio(i) {
	PlayAudioStreamForPlayer(i, "https://www.dl.dropboxusercontent.com/s/p26xc6hpnc606wy/gpb_ptt.mp3");
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

forward RadioPolicialEntra(playerid);
public RadioPolicialEntra(playerid) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 1) {
				format(gpbMensagem, sizeof(gpbMensagem), "[ID: %i - F:%i] entrou na frequência.", playerid, player[playerid][pEquipe]);
				SendClientMessage(i, rose, gpbMensagem);
				PlayAudioStreamForPlayer(i, "https://www.dl.dropboxusercontent.com/s/xkslcjrnxvlngvm/gpb_radioon.mp3");
            }
        }
    }
}

forward RadioPolicialSai(playerid);
public RadioPolicialSai(playerid) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 1) {
				format(gpbMensagem, sizeof(gpbMensagem), "[ID: %i - F:%i] saiu da frequência.", playerid, player[playerid][pEquipe]);
				SendClientMessage(i, rose, gpbMensagem);
            }
        }
    }
}

forward RadioCriminosoEntra(playerid);
public RadioCriminosoEntra(playerid) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 2) {
				format(gpbMensagem, sizeof(gpbMensagem), "[ID: %i - F:%i] entrou na frequência.", playerid, player[playerid][pEquipe]);
				SendClientMessage(i, rose, gpbMensagem);
				PlayAudioStreamForPlayer(i, "https://www.dl.dropboxusercontent.com/s/xkslcjrnxvlngvm/gpb_radioon.mp3");
            }
        }
    }
}

forward RadioCriminosoSai(playerid);
public RadioCriminosoSai(playerid) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 2) {
				format(gpbMensagem, sizeof(gpbMensagem), "[ID: %i - F:%i] saiu da frequência.", playerid, player[playerid][pEquipe]);
				SendClientMessage(i, rose, gpbMensagem);
            }
        }
    }
}

forward RadioParamedicoEntra(playerid);
public RadioParamedicoEntra(playerid) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 3) {
				format(gpbMensagem, sizeof(gpbMensagem), "[ID: %i - F:%i] entrou na frequência.", playerid, player[playerid][pEquipe]);
				SendClientMessage(i, rose, gpbMensagem);
				PlayAudioStreamForPlayer(i, "https://www.dl.dropboxusercontent.com/s/xkslcjrnxvlngvm/gpb_radioon.mp3");
            }
        }
    }
}

forward RadioParamedicoSai(playerid);
public RadioParamedicoSai(playerid) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 3) {
				format(gpbMensagem, sizeof(gpbMensagem), "[ID: %i - F:%i] saiu da frequência.", playerid, player[playerid][pEquipe]);
				SendClientMessage(i, rose, gpbMensagem);
            }
        }
    }
}

forward RadioPolicia(string[]);
public RadioPolicia(string[]) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 1) {
                SendClientMessage(i, rose, string);
				PlayAudioStreamForPlayer(i, "https://www.dl.dropboxusercontent.com/s/p26xc6hpnc606wy/gpb_ptt.mp3");
            }
			if(player[i][pRadioPD] == 1) {
				SetTimerEx("RadioPD", 5000, false, "i", i);
			}
        }
    }
}

forward RadioPoliciaLongo(string[]);
public RadioPoliciaLongo(string[]) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 1) {
                SendClientMessage(i, rose, string);
            }
        }
    }
}

forward RadioCriminoso(string[]);
public RadioCriminoso(string[]) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 2) {
                SendClientMessage(i, rose, string);
				PlayAudioStreamForPlayer(i, "https://www.dl.dropboxusercontent.com/s/p26xc6hpnc606wy/gpb_ptt.mp3");
            }
			if(player[i][pRadioPD] == 1) {
				SetTimerEx("RadioPD", 5000, false, "i", i);
			}
        }
    }
}

forward RadioCriminosoLongo(string[]);
public RadioCriminosoLongo(string[]) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 2) {
                SendClientMessage(i, rose, string);
            }
        }
    }
}

forward RadioParamedico(string[]);
public RadioParamedico(string[]) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 3) {
                SendClientMessage(i, rose, string);
				PlayAudioStreamForPlayer(i, "https://www.dl.dropboxusercontent.com/s/p26xc6hpnc606wy/gpb_ptt.mp3");
            }
			if(player[i][pRadioPD] == 1) {
				SetTimerEx("RadioPD", 5000, false, "i", i);
			}
        }
    }
}

forward RadioParamedicoLongo(string[]);
public RadioParamedicoLongo(string[]) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 3) {
                SendClientMessage(i, rose, string);
            }
        }
    }
}

forward RadioEmergencia(string[]);
public RadioEmergencia(string[]) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 1) {
                SendClientMessage(i, rose, string);
				PlayAudioStreamForPlayer(i, "https://www.dl.dropboxusercontent.com/s/p26xc6hpnc606wy/gpb_ptt.mp3");
            }
			if(player[i][pEquipe] == 3) {
                SendClientMessage(i, rose, string);
				PlayAudioStreamForPlayer(i, "https://www.dl.dropboxusercontent.com/s/p26xc6hpnc606wy/gpb_ptt.mp3");
            }
        }
    }
}

forward RadioEmergenciaLongo(string[]);
public RadioEmergenciaLongo(string[]) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            if(player[i][pEquipe] == 1) {
                SendClientMessage(i, rose, string);
            }
			if(player[i][pEquipe] == 3) {
                SendClientMessage(i, rose, string);
            }
        }
    }
}

forward RadioPD(playerid);
public RadioPD(playerid) {
    PlayAudioStreamForPlayer(playerid,"http://broadcastify.cdnstream1.com/20296");
    return 1;
}

forward DestroyStinger(stingerid);
public DestroyStinger(stingerid){
    DestroyObject(iPickups[stingerid][0]);
    DestroyPickup(iPickups[stingerid][1]);
    DestroyPickup(iPickups[stingerid][2]);
    DestroyPickup(iPickups[stingerid][3]);
    DestroyPickup(iPickups[stingerid][4]);
    iPickups[stingerid][0] = -1;
    iPickups[stingerid][1] = -1;
    iPickups[stingerid][2] = -1;
    iPickups[stingerid][3] = -1;
    iPickups[stingerid][4] = -1;
}

forward Reanima(userid);
public Reanima(userid) {
	ApplyAnimation(userid, "ped", "getup", 4.1, 0, 0, 0, 0, 0, 1);
	SetPlayerColor(userid, white);
	SetPlayerHealth(userid, 100);
	player[userid][pFerido] = 0;
}

//Funções CMD:
CMD:comandos(playerid, params[]) {
	SendClientMessage(playerid, grey, "[Servidor]: /comandos, /equipe, /hora, /clima, /tp, /ir, /tc, /tr, /ob, /remover;");
	SendClientMessage(playerid, grey, "[Chat]: /c, /me, /ame, /do, /sus, /gl, /d, /ooc, /gr, /r, /911, /190, /mp;");
	SendClientMessage(playerid, grey, "[Personagem]: /reviver, /skin, /anim, /equipar, /derrubar, /levantar, /limpar, /morrer;");
	SendClientMessage(playerid, grey, "[Veículo]: /vc, /vd, /chave, /luzes, /pintar, /fix, /travas, /capo, /mala;");
	SendClientMessage(playerid, grey, "[Polícia]: /vcs, /vp, /rp, /mf, /ref, /algemar, /desalgemar.");
   	return 1;
}

CMD:c(playerid, text[]) {
	if(strlen(text) > 65) {
		text[0] = toupper(text[0]);
		new gpbMensagem2[128];
		format(gpbMensagem, sizeof(gpbMensagem), "%s — %.64s [...]", GetName(playerid), text);
		format(gpbMensagem2, sizeof(gpbMensagem2), "[...] %s", text[64]);
		SendRangedMessage(playerid, white, gpbMensagem, 20);
		SendRangedMessage(playerid, white, gpbMensagem2, 20);
		SetPlayerChatBubble(playerid, gpbMensagem, white, 20, 10000);
	}
	else {
		text[0] = toupper(text[0]);
		format(gpbMensagem, 500, "%s — %s", GetName(playerid), text);
		SendRangedMessage(playerid, white, gpbMensagem, 20);
		SetPlayerChatBubble(playerid, gpbMensagem, white, 20, 10000);
	}
	return 1;
}

CMD:me(playerid, text[]) {
	if(isnull(text)) {
		SendClientMessage(playerid, grey, "/me [ação]");
	}
	else if(strlen(text) > 75) {
		new gpbMensagem2[128];
		format(gpbMensagem2, 500, "[...] %s", text[75]);
		strdel(text, 75, 149);
		format(gpbMensagem, 500, "%s %s [...]", GetName(playerid), text);
		SendRangedMessage(playerid, purple, gpbMensagem, 20);
		SendRangedMessage(playerid, purple, gpbMensagem2, 20);
		SetPlayerChatBubble(playerid, gpbMensagem, purple, 20, 10000);
	}
	else {
		format(gpbMensagem, 500, "%s %s", GetName(playerid), text);
		SendRangedMessage(playerid, purple, gpbMensagem, 20);
		format(gpbMensagem, 500, "%s", text);
		SetPlayerChatBubble(playerid, gpbMensagem, purple, 20, 10000);
	}
	return 1;
}

CMD:ame(playerid, text[]) {
	if(isnull(text)) {
		SendClientMessage(playerid, grey, "/me [ação]");
	}
	else if(strlen(text) > 75) {
		new gpbMensagem2[128];
		format(gpbMensagem2, 500, "[...] %s", text[75]);
		strdel(text, 75, 149);
		format(gpbMensagem, 500, "%s %s [...]", GetName(playerid), text);
		SendClientMessage(playerid, purple, gpbMensagem);
		SendClientMessage(playerid, purple, gpbMensagem2);
		SetPlayerChatBubble(playerid, gpbMensagem, purple, 20, 10000);
	}
	else {
		format(gpbMensagem, 500, "%s %s", GetName(playerid), text);
		SendClientMessage(playerid, purple, gpbMensagem);
		format(gpbMensagem, 500, "%s", text);
		SetPlayerChatBubble(playerid, gpbMensagem, purple, 20, 10000);
	}
	return 1;
}

CMD:do(playerid, text[]) {
	if(isnull(text)) {
		SendClientMessage(playerid, grey, "/do [acontecimento]");
	}
	else if(strlen(text) > 75) {
		text[0] = toupper(text[0]);
		new gpbMensagem2[128];
		format(gpbMensagem2, 500, "[...] %s", text[75]);
		strdel(text, 75, 149);
		format(gpbMensagem, 500, "[ID: %i]: %s [...]", playerid, text);
		SendRangedMessage(playerid, green, gpbMensagem, 20);
		SendRangedMessage(playerid, green, gpbMensagem2, 20);
	}
	else {
		text[0] = toupper(text[0]);
		format(gpbMensagem, 500, "[ID: %i]: %s", playerid, text);
    	SendRangedMessage(playerid, green, gpbMensagem, 20);
	}
    return 1;
}

CMD:d(playerid, text[]) {
	if(isnull(text)) {
		SendClientMessage(playerid, grey, "/d [mensagem]");
	}
	else if(strlen(text) > 75) {
		text[0] = toupper(text[0]);
		new gpbMensagem2[128];
		format(gpbMensagem2, 500, "[...] %s", text[75]);
		strdel(text, 75, 149);
		format(gpbMensagem, 500, "[ID: %i]: %s [...]", playerid, text);
		SendClientMessageToAll(red, gpbMensagem);
		SendClientMessageToAll(red, gpbMensagem2);
	}
	else {
		text[0] = toupper(text[0]);
		format(gpbMensagem, 500, "[ID: %i]: %s", playerid, text);
    	SendClientMessageToAll(red, gpbMensagem);
	}
	return 1;
}

CMD:gl(playerid, text[]) {
	if(isnull(text)) {
		SendClientMessage(playerid, grey, "/gl [texto]");
	}
	else if(strlen(text) > 75) {
		text[0] = toupper(text[0]);
		new gpbMensagem2[128];
		format(gpbMensagem2, 500, "[...] %s", text[75]);
		strdel(text, 75, 149);
		format(gpbMensagem, 500, "%s: %s [...]",  GetName(playerid), text);
		SendClientMessageToAll(orange, gpbMensagem);
		SendClientMessageToAll(orange, gpbMensagem2);
	}
	else {
		format(gpbMensagem, 500, "%s: %s", GetName(playerid), text);
 		SendClientMessageToAll(orange, gpbMensagem);
	}
    return 1;
}

CMD:ooc(playerid, text[]) {
	if(isnull(text)) {
		SendClientMessage(playerid, grey, "/ooc [texto]");
	}
	else if(strlen(text) > 75) {
		text[0] = toupper(text[0]);
		new gpbMensagem2[128];
		format(gpbMensagem2, 500, "[...] %s", text[75]);
		strdel(text, 75, 149);
		format(gpbMensagem, 500, "%s [ooc] — %s",  GetName(playerid), text);
		SendClientMessageToAll(indigo, gpbMensagem);
		SendClientMessageToAll(indigo, gpbMensagem2);
	}
	else {
		format(gpbMensagem, 500, "%s [ooc] — %s", GetName(playerid), text);
    	SendRangedMessage(playerid, indigo, gpbMensagem, 20);
	}
    return 1;
}

CMD:gr(playerid, text[]) {
	if(isnull(text)) {
		SendClientMessage(playerid, grey, "/gritar [texto]");
	}
	else {
		new x,y;
		while ((y = text[x])){
			text[x++] = toupper(y);
		}
		if(strlen(text) > 75) {
			new gpbMensagem2[128];
			format(gpbMensagem2, 500, "[...] %s!", text[75]);
			strdel(text, 75, 149);
			format(gpbMensagem, 500, "%s gritou — %s [...]", GetName(playerid), text);
			SendClientMessageToAll(white, gpbMensagem);
			SendClientMessageToAll(white, gpbMensagem2);
		}
		 else {
			format(gpbMensagem, 500, "%s gritou — %s!", GetName(playerid), text);
			SendRangedMessage(playerid, white, gpbMensagem, 50);
			SetPlayerChatBubble(playerid, gpbMensagem, white, 50, 10000);
		}
	}
    return 1;
}

CMD:sus(playerid, text[]) {
	if(isnull(text)) {
		SendClientMessage(playerid, grey, "/sus [texto]");
	}
	else if(strlen(text) > 75) {
		text[0] = toupper(text[0]);
		new gpbMensagem2[128];
		format(gpbMensagem2, 500, "[...] %s", text[75]);
		strdel(text, 75, 149);
		format(gpbMensagem, 500, "%s susurra — %s [...]", GetName(playerid), text);
		SendRangedMessage(playerid, grey, gpbMensagem, 3);
		SendRangedMessage(playerid, grey, gpbMensagem2, 3);
	}
	else {
		text[0] = toupper(text[0]);
		format(gpbMensagem, 500, "%s susurra — %s", GetName(playerid), text);
    	SendRangedMessage(playerid, grey, gpbMensagem, 3);
	}
    return 1;
}

CMD:mp(playerid, params[]) {
	new destinatario, text[128];
	if(sscanf(params, "us[128]", destinatario, text)) {
		SendClientMessage(playerid, grey, "/mp [id] [mensagem]");
	}
	else if(destinatario == playerid) {
		SendClientMessage(playerid, grey, "Você não pode enviar mensagens privadas para si mesmo.");
	}
	else if(destinatario == INVALID_PLAYER_ID) {
		SendClientMessage(playerid, grey, "Jogador não conectado.");
	}
	else if(strlen(text) > 75) {
		text[0] = toupper(text[0]);
		new gpbMensagem2[128];
		format(gpbMensagem2, 500, "[...] %s", text[75]);
		strdel(text, 75, 149);
		format(gpbMensagem, 500, "%s para %s: %s [...]", GetName(playerid), GetName(destinatario), text);
		SendClientMessage(playerid, yellow, gpbMensagem);
		SendClientMessage(destinatario, yellow, gpbMensagem);
		SendClientMessage(playerid, yellow, gpbMensagem2);
		SendClientMessage(destinatario, yellow, gpbMensagem2);
	}
	else {
		format(gpbMensagem, sizeof(gpbMensagem), "%s para %s: %s", GetName(playerid), GetName(destinatario), text);
		SendClientMessage(playerid, yellow, gpbMensagem);
		SendClientMessage(destinatario, yellow, gpbMensagem);
	}
	return 1;
}

CMD:r(playerid, text[]) {
	if(player[playerid][pEquipe] == 0) {
		SendClientMessage(playerid, grey, "Você não possui um rádio.");
	}
	else if(isnull(text)) {
		SendClientMessage(playerid, grey, "/r [mensagem]");
	}
    else if (player[playerid][pFerido] == 1) {
        SendClientMessage(playerid, grey, "Você está ferido. Primeiro use o /reviver.");
    }
	else {
		if (!IsPlayerInAnyVehicle(playerid) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK) {
			ApplyAnimation(playerid, "ped", "phone_out", 2.0, 0, 0, 0, 0, 0, 1);
		}
		else if (IsPlayerInAnyVehicle(playerid)) {
			ApplyAnimation(playerid, "ped", "CAR_tune_radio", 2.0, 0, 0, 0, 0, 0, 1);
		}
		if(strlen(text) > 75) {
			text[0] = toupper(text[0]);
			new gpbMensagem2[67];
			format(gpbMensagem, sizeof(gpbMensagem), "[ID: %i - F:%i]: %.64s [...]", playerid, player[playerid][pEquipe], text[0]);
			format(gpbMensagem2, sizeof(gpbMensagem2), "[...] %s", text[64]);
			if (player[playerid][pEquipe] == 1) {
				RadioPolicia(gpbMensagem);
				RadioPoliciaLongo(gpbMensagem2);
			}
			else if (player[playerid][pEquipe] == 2) {
				RadioCriminoso(gpbMensagem);
				RadioCriminosoLongo(gpbMensagem2);
			}
			else if (player[playerid][pEquipe] == 3) {
				RadioParamedico(gpbMensagem);
				RadioParamedicoLongo(gpbMensagem2);
			}
		} 
		else {
			text[0] = toupper(text[0]);
			format(gpbMensagem, sizeof(gpbMensagem), "[ID: %i - F:%i]: %s", playerid, player[playerid][pEquipe], text[0]);
			if (player[playerid][pEquipe] == 1) {
				RadioPolicia(gpbMensagem);
			}
			else if (player[playerid][pEquipe] == 2) {
				RadioCriminoso(gpbMensagem);
			}
			else if (player[playerid][pEquipe] == 3) {
				RadioParamedico(gpbMensagem);
			}
		}
	}
	return 1;
}

CMD:mf(playerid, text[]) {
	if (player[playerid][pEquipe] != 1) {
		SendClientMessage(playerid, grey, "Você não pode utilizar o megafone se não for um policial.");
		return 1;
	}
    else if (player[playerid][pFerido] == 1) {
        SendClientMessage(playerid, grey, "Você está ferido. Primeiro use o /reviver.");

    }
	else if (!IsPlayerInAnyVehicle(playerid)){
		SendClientMessage(playerid, grey, "Você não está em um veiculo.");
		return 1;
	}
	else if(isnull(text)) {
		SendClientMessage(playerid, grey, "/mf [texto]");
		return 1;
	}
	else {
		ApplyAnimation(playerid, "ped", "phone_talk", 2.0, 0, 0, 0, 0, 0, 1);
		new x,y;
		while ((y = text[x])){
			text[x++] = toupper(y);
		}
		if(strlen(text) > 75) {
			new gpbMensagem2[128];
			format(gpbMensagem2, 500, "[...] %s", text[75]);
			strdel(text, 75, 149);
			format(gpbMensagem, 500, "[ID: %i] pelo megafone — %s [...]", playerid, text);
			SendRangedMessage(playerid, yellow, gpbMensagem, 75);
    		SendRangedMessage(playerid, yellow, gpbMensagem2, 75);
		}
		else {
			format(gpbMensagem, 500, "[ID: %i] pelo megafone — %s", playerid, text);
    		SendRangedMessage(playerid, yellow, gpbMensagem, 75);
		}
	}
	return 1;
}

CMD:911(playerid, text[]) {
	if(isnull(text)) {
		SendClientMessage(playerid, grey, "/911 [mensagem]");
	}
	else {
		if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK && player[playerid][pDerrubado] == 0  && player[playerid][pFerido] == 0 && player[playerid][pAnim] == 0) {
			ApplyAnimation(playerid, "ped", "phone_talk", 2.0, 0, 0, 0, 0, 0, 1);
		}
		if(strlen(text) > 75) {
			new mensagem[128];
			new gpbMensagem2[128];
			new zone[MAX_ZONE_NAME];
			text[0] = toupper(text[0]);
			format(gpbMensagem2, 500, "[...] %s", text[75]);
			SendClientMessage(playerid, grey, "Seu chamado foi encaminhado para as unidades de emergência.");
			format(mensagem, sizeof(mensagem), "[Central] Relato recebido próximo a(o) %s: %s", zone, text[0]);
			RadioEmergencia(mensagem);
			RadioEmergenciaLongo(gpbMensagem2);
		}
		else {
			text[0] = toupper(text[0]);
			new mensagem[128];
			new zone[MAX_ZONE_NAME];
			GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
			SendClientMessage(playerid, grey, "Seu chamado foi encaminhado para as unidades de emergência.");
			format(mensagem, sizeof(mensagem), "[Central] Relato recebido próximo a(o) %s: %s", zone, text[0]);
			RadioEmergencia(mensagem);
		}
	}
	return 1;
}

CMD:190(playerid, text[]) {
	if(isnull(text)) {
		SendClientMessage(playerid, grey, "/190 [mensagem]");
	}
	else {
		if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK && player[playerid][pDerrubado] == 0  && player[playerid][pFerido] == 0 && player[playerid][pAnim] == 0) {
			ApplyAnimation(playerid, "ped", "phone_talk", 2.0, 0, 0, 0, 0, 0, 1);
		}
		if(strlen(text) > 75) {
			new mensagem[128];
			new gpbMensagem2[128];
			new zone[MAX_ZONE_NAME];
			text[0] = toupper(text[0]);
			format(gpbMensagem2, 500, "[...] %s", text[75]);
			format(mensagem, sizeof(mensagem), "[Central] Relato recebido próximo a(o) %s: %s", zone, text[0]);
			RadioEmergencia(mensagem);
			RadioEmergenciaLongo(gpbMensagem2);
			SendClientMessage(playerid, grey, "Seu chamado foi encaminhado para as unidades de emergência.");
			strdel(text, 75, 149);
		}
		else {
			text[0] = toupper(text[0]);
			new mensagem[128];
			new zone[MAX_ZONE_NAME];
			GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
			format(mensagem, sizeof(mensagem), "[Central] Relato recebido próximo a(o) %s: %s", zone, text[0]);
			RadioEmergencia(mensagem);
			SendClientMessage(playerid, grey, "Seu chamado foi encaminhado para as unidades de emergência.");
		}
	}
	return 1;
}

CMD:equipe(playerid, params[]) {
    if (player[playerid][pFerido] == 1) {
        SendClientMessage(playerid, grey, "Você está ferido. Primeiro use o /reviver.");

    }
    else {
        ShowPlayerDialog(playerid, textbox_equipes, DIALOG_STYLE_LIST, "Equipes",
        "Civil\nPolicial\nCriminoso\nParamédico",
        "Aceitar", "");
    }
	return 1;
}

CMD:ref(playerid) {
	new zone[MAX_ZONE_NAME];
	GetPlayer2DZone(playerid, zone, MAX_ZONE_NAME);
	if (player[playerid][pFerido] == 1) {
        SendClientMessage(playerid, grey, "Você está ferido. Primeiro use o /reviver.");

    }
	else if (player[playerid][pEquipe] == 0) {
		SendClientMessage(playerid, grey, "Você não pode utilizar esse comando.");
	}
	else {
		if (!IsPlayerInAnyVehicle(playerid)) {
			ApplyAnimation(playerid, "ped", "phone_out", 2.0, 0, 0, 0, 0, 0, 1);
		}
		if (player[playerid][pEquipe] == 1){
			new mensagem[128];
			format(mensagem, sizeof(mensagem), "[ID: %i - F:%i]: Solicita apoio de unidades nas localidades de a(o) %s.", playerid, player[playerid][pEquipe], zone);
			RadioPolicia(mensagem);
		}
		else if (player[playerid][pEquipe] == 2){
			SetPlayerColor(playerid, orange);
			new mensagem[128];
			format(mensagem, sizeof(mensagem), "[ID: %i - F:%i]: Tô precisando de ajuda aqui perto de a(o) %s.", playerid, player[playerid][pEquipe], zone);
			RadioCriminoso(mensagem);
		}
		else if (player[playerid][pEquipe] == 3){
			SetPlayerColor(playerid, lightgreen);
			new mensagem[128];
			format(mensagem, sizeof(mensagem), "[ID: %i - F:%i]: Requisitando ambulância próximo a(a) %s.", playerid, player[playerid][pEquipe], zone);
			RadioParamedico(mensagem);
		}
	}
	return 1;
}

CMD:tc(playerid, params[]) {
	if(IsPlayerInAnyVehicle(playerid)){
            SendClientMessage(playerid, grey, "Você não pode criar um tapete de pregos de dentro do veículo.");
        }
        else if (player[playerid][pFerido] == 1 || player[playerid][pDerrubado] == 1 || player[playerid][pAlgemado] == 1) {
            SendClientMessage(playerid, grey, "Você não pode fazer isso. ");
        }
        else {
            new Float:X, Float:Y, Float:Z, Float:A;
            GetPlayerPos(playerid, X, Y, Z);
            GetPlayerFacingAngle(playerid, A);
            CreateSmallStinger(X+(floatsin(-A, degrees)), Y+(floatcos(-A, degrees)), Z-0.825, A+90, GetPlayerVirtualWorld(playerid));
            ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0, 1);
            SendClientMessage(playerid, grey, "Tapete de pregos criado com sucesso.");
        }
        /* else {
            new vehicleid = GetPlayerVehicleID(playerid);
            new Float:X, Float:Y, Float:Z, Float:A;
            GetVehiclePos(vehicleid, X, Y, Z);
            GetVehicleZAngle(vehicleid, A);
            CreateLargeStinger(X-(floatsin(-A, degrees)), Y-(floatcos(-A, degrees)), Z-0.325, A+90, GetPlayerVirtualWorld(playerid));
        } */
	return 1;
}

CMD:tr(playerid, params[]) {
	new Float:X, Float:Y, Float:Z;
	if (player[playerid][pFerido] == 1 || player[playerid][pDerrubado] == 1 || player[playerid][pAlgemado] == 1) {
        SendClientMessage(playerid, grey, "Você não pode fazer isso. ");
    }
    else {
		for(new stingerid = 0; stingerid < sizeof(iPickups); stingerid++) {
			if(iPickups[stingerid][0] == -1)
				continue;
			
			GetObjectPos(iPickups[stingerid][0], X, Y, Z);
			if(IsPlayerInRangeOfPoint(playerid, 2.0, X, Y, Z)){
				DestroyStinger(stingerid);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
				SendClientMessage(playerid, grey, "Tapete de pregos removido.");
				break;
        	}
    	}
	}
	return 1;
}

CMD:radiopd(playerid, params[]) {
	if (player[playerid][pRadioPD] == 0) {
		RadioPD(playerid);
		player[playerid][pRadioPD] = 1;
		SendClientMessage(playerid, grey, "Rádio sincronizado com sucesso.");
	}
	else {
		SendClientMessage(playerid, grey, "Rádio definido para transmitir apenas texto.");
		StopAudioStreamForPlayer(playerid);
		player[playerid][pRadioPD] = 0;
	}
    return 1;
}

CMD:vc(playerid, params[]) { 
	if(player[playerid][pFerido] == 1 || player[playerid][pAlgemado] == 1 || player[playerid][pDerrubado] == 1) {
  		SendClientMessage(playerid, grey, "Você não pode fazer isso agora.");
		return 1;
	}
	new playerseat = GetPlayerVehicleSeat(playerid);
	if(playerseat == 1 || playerseat == 2 || playerseat == 3 ) {
    	SendClientMessage(playerid, grey, "Saia do veículo de outro jogador primeiro.");
		return 1;
	} 
	else {
	    new modelo[32], id;
		if(sscanf(params,"s[32]", modelo)){
    		SendClientMessage(playerid, grey, "/vc [modelo]");
    		return 1;
		}

		new modeloid = ReturnVehicleId(modelo);
		id = ReturnVehicleId(modelo);
		
	 	if(modeloid >= 400 && modeloid <= 611) { // Cria veículos pelo nome.
	 	    if (modeloid == 441 || modeloid == 464 || modeloid == 594 || modeloid == 501 || modeloid == 465 || modeloid == 564 || modeloid == 590 || modeloid == 538 || modeloid == 570 || modeloid == 569 || modeloid == 537 || modeloid == 449 || modeloid == 539 || modeloid == 592 || modeloid == 577) {
	 	        SendClientMessage(playerid, grey, "Você não pode utilizar esse veículo no servidor.");
	 	    }
	 	    else {
				new Float:pos[4];
				new vehicleid = GetPlayerVehicleID(playerid);
			    DestroyVehicle(vehicleid);
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetPlayerFacingAngle(playerid, pos[3]);
				new modeloId = CreateVehicle(modeloid, pos[0], pos[1], pos[2], pos[3], -1, -1, -1, 0);
				SetVehicleVirtualWorld(modeloId,GetPlayerVirtualWorld(playerid));
				LinkVehicleToInterior(modeloId,GetPlayerInterior(playerid));
				PutPlayerInVehicle(playerid, modeloId, 0);
				player[playerid][pAnim] = 0;
				veiculoTrancado[modeloId] = 0;
				if (HasNoEngine(modeloId) == 1) {
					new enginem, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(modeloId, enginem, lights, alarm, doors, bonnet, boot, objective);
					SetVehicleParamsEx(modeloId, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
					veiculoMotor[modeloId] = 1;
				}
				else {
					veiculoMotor[modeloId] = 0;
				}
				return 1;
			}
		}

	 	else if(id >= 400 || id <= 611) { // Cria veículos pelo id.
			id = strval(modelo);
			if (id < 400 || id > 611 ) {
				SendClientMessage(playerid, grey, "Modelo inválido.");
			}
			else if (id == 441 || id == 464 || id == 594 || id == 501 || id == 465 || id == 564 || id == 590 || id == 538 || id == 570 || id == 569 || id == 537 || id == 449 || id == 539 || id == 592 || id == 577) {
			    SendClientMessage(playerid, grey, "Você não pode utilizar esse veículo no servidor.");
			}
   			else {
			 	new Float:pos[4];
			 	new vehicleid = GetPlayerVehicleID(playerid);
			 	DestroyVehicle(vehicleid);
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetPlayerFacingAngle(playerid, pos[3]);
	   			PlayerInfo[playerid][pVeiculo] = CreateVehicle(id, pos[0], pos[1], pos[2], pos[3], -1, -1, -1, 0);
				LinkVehicleToInterior(PlayerInfo[playerid][pVeiculo], GetPlayerInterior(playerid));
				PutPlayerInVehicle(playerid, PlayerInfo[playerid][pVeiculo], 0);
				player[playerid][pAnim] = 0;
				veiculoTrancado[pVeiculo] = 0;
				if (HasNoEngine(PlayerInfo[playerid][pVeiculo]) == 1) {
					new enginem, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(PlayerInfo[playerid][pVeiculo], enginem, lights, alarm, doors, bonnet, boot, objective);
					SetVehicleParamsEx(PlayerInfo[playerid][pVeiculo], VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
					veiculoMotor[PlayerInfo[playerid][pVeiculo]] = 1;
				}
				else {
					veiculoMotor[vehicleid] = 0;
				}
				return 1;
			}
        }

  		else {
		    SendClientMessage(playerid, grey, "Modelo inválido.");
		}
	}
	return 1;
}

CMD:vcs(playerid, params[]) { 
	if(player[playerid][pFerido] == 1 || player[playerid][pAlgemado] == 1 || player[playerid][pDerrubado] == 1) {
  		SendClientMessage(playerid, grey, "Você não pode fazer isso agora.");
		return 1;
	}
	new playerseat = GetPlayerVehicleSeat(playerid);
	if(playerseat == 1 || playerseat == 2 || playerseat == 3 ) {
    	SendClientMessage(playerid, grey, "Você não pode spawnar um veículo se estiver de passageiro.");
		return 1;
	}
	else {
	    new modelo[32], id;
		if(sscanf(params,"s[32]", modelo)){
    		SendClientMessage(playerid, grey, "/vc [modelo]");
    		return 1;
		}

		new modeloid = ReturnVehicleId(modelo);
		id = ReturnVehicleId(modelo);
		
	 	if(modeloid >= 400 && modeloid <= 611) { // Cria veículos pelo nome.
	 	    if (modeloid == 441 || modeloid == 464 || modeloid == 594 || modeloid == 501 || modeloid == 465 || modeloid == 564 || modeloid == 590 || modeloid == 538 || modeloid == 570 || modeloid == 569 || modeloid == 537 || modeloid == 449 || modeloid == 539 || modeloid == 592 || modeloid == 577) {
	 	        SendClientMessage(playerid, grey, "Você não pode utilizar esse veículo no servidor.");
	 	    }
	 	    else {
				new Float:pos[4];
				new vehicleid = GetPlayerVehicleID(playerid);
			    DestroyVehicle(vehicleid);
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetPlayerFacingAngle(playerid, pos[3]);
				new modeloId = CreateVehicle(modeloid, pos[0], pos[1], pos[2], pos[3], -1, -1, -1, 1);
				SetVehicleVirtualWorld(modeloId,GetPlayerVirtualWorld(playerid));
				LinkVehicleToInterior(modeloId,GetPlayerInterior(playerid));
				PutPlayerInVehicle(playerid, modeloId, 0);
				player[playerid][pAnim] = 0;
				veiculoTrancado[modeloId] = 0;
				if (HasNoEngine(modeloId) == 1) {
					new enginem, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(modeloId, enginem, lights, alarm, doors, bonnet, boot, objective);
					SetVehicleParamsEx(modeloId, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
					veiculoMotor[modeloId] = 1;
				}
				else {
					veiculoMotor[modeloId] = 0;
				}
				return 1;
			}
		}

	 	else if(id >= 400 || id <= 611) { // Cria veículos pelo id.
			id = strval(modelo);
			if (id < 400 || id > 611 ) {
				SendClientMessage(playerid, grey, "Modelo inválido.");
			}
			else if (id == 441 || id == 464 || id == 594 || id == 501 || id == 465 || id == 564 || id == 590 || id == 538 || id == 570 || id == 569 || id == 537 || id == 449 || id == 539 || id == 592 || id == 577) {
			    SendClientMessage(playerid, grey, "Você não pode utilizar esse veículo no servidor.");
			}
   			else {
			 	new Float:pos[4];
			 	new vehicleid = GetPlayerVehicleID(playerid);
			 	DestroyVehicle(vehicleid);
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetPlayerFacingAngle(playerid, pos[3]);
	   			PlayerInfo[playerid][pVeiculo] = CreateVehicle(id, pos[0], pos[1], pos[2], pos[3], -1, -1, -1, 1);
				LinkVehicleToInterior(PlayerInfo[playerid][pVeiculo], GetPlayerInterior(playerid));
				PutPlayerInVehicle(playerid, PlayerInfo[playerid][pVeiculo], 0);
				player[playerid][pAnim] = 0;
				veiculoTrancado[pVeiculo] = 0;
				if (HasNoEngine(PlayerInfo[playerid][pVeiculo]) == 1) {
					new enginem, lights, alarm, doors, bonnet, boot, objective;
					GetVehicleParamsEx(PlayerInfo[playerid][pVeiculo], enginem, lights, alarm, doors, bonnet, boot, objective);
					SetVehicleParamsEx(PlayerInfo[playerid][pVeiculo], VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
					veiculoMotor[PlayerInfo[playerid][pVeiculo]] = 1;
				}
				else {
					veiculoMotor[vehicleid] = 0;
				}
				return 1;
			}
        }

  		else {
		    SendClientMessage(playerid, grey, "Modelo inválido.");
		}
	}
	return 1;
}

CMD:vd(playerid, params[]) {
	if(player[playerid][pFerido] == 1 || player[playerid][pAlgemado] == 1 || player[playerid][pDerrubado] == 1) {
  		SendClientMessage(playerid, grey, "Você não pode fazer isso agora.");
	}
	else if(IsPlayerInAnyVehicle(playerid) == 1) {
		new vehicleid = GetPlayerVehicleID(playerid);
		DestroyVehicle(vehicleid);
	}
	else {
		new counter = 0;
		new result;
		for(new i; i != MAX_VEHICLES; i++) {
			new dist = VeiculoRaio(5, playerid, i);
			if(dist) {
				result = i;
				counter++;
			}
		}
		switch(counter) {
			case 0: {
				SendClientMessage(playerid, grey, "Não há nenhum veículo próximo o bastante.");
			}
			case 1: {
				if(VeiculoComJogador(result)) {
					SendClientMessage(playerid, grey, "Não é possível excluir um veículo com um jogador dentro.");
				}
				else {
					DestroyVehicle(result);
				}
			}
			default: {
				if(VeiculoComJogador(result)) {
					SendClientMessage(playerid, grey, "Não é possível excluir um veículo com um jogador dentro.");
				}
				else {
					DestroyVehicle(result);
				}
			}
		}
	}
	return 1;
}

CMD:chave(playerid, params[]) {
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsValidVehicle(vehicleid)) {
		SendClientMessage(playerid, grey, "Você não está em um veículo.");
	}
	else if(GetPlayerVehicleSeat(playerid) != 0) {
		SendClientMessage(playerid, grey, "Você não pode ligar ou desligar o veículo se estiver como passageiro.");
	}
	else if(player[playerid][pFerido] == 1){
	    SendClientMessage(playerid, grey, "Você está ferido. Primeiro utilize o /reviver.");
	}
	else if (HasNoEngine(vehicleid) == 1) {
		SendClientMessage(playerid, grey, "Este veículo não possui nenhuma chave.");
	}
	else {
		ControlaMotor(playerid, vehicleid);
	}
	return 1;
}

CMD:luzes(playerid) {
	new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsValidVehicle(vehicleid)) {
		SendClientMessage(playerid, grey, "Você não está em um veículo.");
	}
	else if(GetPlayerVehicleSeat(playerid) != 0) {
		SendClientMessage(playerid, grey, "Você não pode ligar ou desligar as luzes do veículo se estiver como passageiro.");
	}
	else if(player[playerid][pFerido] == 1){
	    SendClientMessage(playerid, grey, "Você está ferido. Primeiro utilize o /reviver.");
	}
	else {
		ControlaLuzes(vehicleid);
	}
	return 1;
}

CMD:travas(playerid) {
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) {
		SendClientMessage(playerid, grey, "Você precisa estar como motorista de um veículo.");
	}
    else {
		new vehicleid = GetPlayerVehicleID(playerid);
		if (veiculoTrancado[vehicleid] == 0) {
			veiculoTrancado[vehicleid] = 1;
			SendClientMessage(playerid, grey, "Veículo trancado.");
			for(new i=0; i < MAX_PLAYERS; i++) {
				if(i == playerid) {
					SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 1);
				}
			}
		}
		else if (veiculoTrancado[vehicleid] == 1) {
			veiculoTrancado[vehicleid] = 0;
			SendClientMessage(playerid, grey, "Veículo destrancado.");
			for(new i=0; i < MAX_PLAYERS; i++) {
				if(i == playerid) {
					SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid), i, 0, 0);
				}
			}
		}
	}    
	return 1;
}

CMD:capo(playerid, params[]) {
	if(player[playerid][pFerido] == 1 || player[playerid][pAlgemado] == 1 || player[playerid][pDerrubado] == 1) {
  		SendClientMessage(playerid, grey, "Você não pode fazer isso agora.");
	}
	else {
		new counter = 0;
		new result;
		for(new i; i != MAX_VEHICLES; i++) {
			new dist = VeiculoRaio(4, playerid, i);
			if(dist) {
				result = i;
				counter++;
			}
		}
		switch(counter) {
			case 0: {
				SendClientMessage(playerid, grey, "Não há nenhum veículo próximo o bastante.");
			}
			case 1: {
				new enginem, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(result, enginem, lights, alarm, doors, bonnet, boot, objective);
				if (bonnet != VEHICLE_PARAMS_ON) {
					if (IsPlayerInAnyVehicle(playerid) == 1) {
						SendClientMessage(playerid, grey, "Saia do veículo para abrir o capô.");
					}
					else {
						ApplyAnimation(playerid, "ped", "Walk_DoorPartial", 4.1, 0, 0, 0, 0, 0, 1);
						SetVehicleParamsEx(result, enginem, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);
						format(gpbMensagem, 500, "%s abre o capô do veículo.", GetName(playerid));
						SendRangedMessage(playerid, purple, gpbMensagem, 15);
						format(gpbMensagem, 500, "Abre o capô do veículo.");
						SetPlayerChatBubble(playerid, gpbMensagem, purple, 15, 10000);
					}
				}
				else if (bonnet == VEHICLE_PARAMS_ON) {
					if (IsPlayerInAnyVehicle(playerid) == 1) {
						SendClientMessage(playerid, grey, "Saia do veículo para fechar o capô.");
					}
					else {
						ApplyAnimation(playerid, "INT_SHOP", "shop_in", 1.00, 0, 0, 0, 0, 0, 1);
						SetVehicleParamsEx(result, enginem, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);
						format(gpbMensagem, 500, "%s fecha o capô do veículo.", GetName(playerid));
						SendRangedMessage(playerid, purple, gpbMensagem, 15);
						format(gpbMensagem, 500, "Fecha o capô do veículo.");
						SetPlayerChatBubble(playerid, gpbMensagem, purple, 15, 10000);
					}
				}
				
			}
			default: {
				new enginem, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(result, enginem, lights, alarm, doors, bonnet, boot, objective);
				if (bonnet != VEHICLE_PARAMS_ON) {
					if (IsPlayerInAnyVehicle(playerid) == 1) {
						SendClientMessage(playerid, grey, "Saia do veículo para abrir o capô.");
					}
					else {
						ApplyAnimation(playerid, "ped", "Walk_DoorPartial", 4.1, 0, 0, 0, 0, 0, 1);
						SetVehicleParamsEx(result, enginem, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);
						format(gpbMensagem, 500, "%s abre o capô do veículo.", GetName(playerid));
						SendRangedMessage(playerid, purple, gpbMensagem, 15);
						format(gpbMensagem, 500, "Abre o capô do veículo.");
						SetPlayerChatBubble(playerid, gpbMensagem, purple, 15, 10000);
					}
				}
				else if (bonnet == VEHICLE_PARAMS_ON) {
					if (IsPlayerInAnyVehicle(playerid) == 1) {
						SendClientMessage(playerid, grey, "Saia do veículo para fechar o capô.");
					}
					else {
						ApplyAnimation(playerid, "INT_SHOP", "shop_in", 1.00, 0, 0, 0, 0, 0, 1);
						SetVehicleParamsEx(result, enginem, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);
						format(gpbMensagem, 500, "%s fecha o capô do veículo.", GetName(playerid));
						SendRangedMessage(playerid, purple, gpbMensagem, 15);
						format(gpbMensagem, 500, "Fecha o capô do veículo.");
						SetPlayerChatBubble(playerid, gpbMensagem, purple, 15, 10000);
					}
				}
			}
		}
	}
	return 1;
}

CMD:mala(playerid, params[]) {
	if(player[playerid][pFerido] == 1 || player[playerid][pAlgemado] == 1 || player[playerid][pDerrubado] == 1) {
  		SendClientMessage(playerid, grey, "Você não pode fazer isso agora.");
	}
	else {
		new counter = 0;
		new result;
		for(new i; i != MAX_VEHICLES; i++) {
			new dist = VeiculoRaio(4, playerid, i);
			if(dist) {
				result = i;
				counter++;
			}
		}
		switch(counter) {
			case 0: {
				SendClientMessage(playerid, grey, "Não há nenhum veículo próximo o bastante.");
			}
			case 1: {
				new enginem, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(result, enginem, lights, alarm, doors, bonnet, boot, objective);
				if (boot != VEHICLE_PARAMS_ON) {
					veiculoTrancado[result] = 0;
					SetVehicleParamsForPlayer(result, playerid, 0, 0);
					ApplyAnimation(playerid, "ped", "Walk_DoorPartial", 4.1, 0, 0, 0, 0, 0, 1);
					SetVehicleParamsEx(result, enginem, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
					format(gpbMensagem, 500, "%s abre a mala do veículo.", GetName(playerid));
					SendRangedMessage(playerid, purple, gpbMensagem, 15);
					format(gpbMensagem, 500, "Abre a mala do veículo.");
					SetPlayerChatBubble(playerid, gpbMensagem, purple, 15, 10000);
				}
				else if (boot == VEHICLE_PARAMS_ON) {
					ApplyAnimation(playerid, "INT_SHOP", "shop_in", 1.00, 0, 0, 0, 0, 0, 1);
					SetVehicleParamsEx(result, enginem, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);
					format(gpbMensagem, 500, "%s fecha a mala do veículo.", GetName(playerid));
					SendRangedMessage(playerid, purple, gpbMensagem, 15);
					format(gpbMensagem, 500, "Fecha a mala do veículo.");
					SetPlayerChatBubble(playerid, gpbMensagem, purple, 15, 10000);
				}
				
			}
			default: {
				new enginem, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(result, enginem, lights, alarm, doors, bonnet, boot, objective);
				if (boot != VEHICLE_PARAMS_ON) {
					ApplyAnimation(playerid, "ped", "Walk_DoorPartial", 4.1, 0, 0, 0, 0, 0, 1);
					SetVehicleParamsEx(result, enginem, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
					format(gpbMensagem, 500, "%s abre a mala do veículo.", GetName(playerid));
					SendRangedMessage(playerid, purple, gpbMensagem, 15);
					format(gpbMensagem, 500, "Abre a mala do veículo.");
					SetPlayerChatBubble(playerid, gpbMensagem, purple, 15, 10000);
				}
				else if (bonnet == VEHICLE_PARAMS_ON) {
					ApplyAnimation(playerid, "INT_SHOP", "shop_in", 1.00, 0, 0, 0, 0, 0, 1);
					SetVehicleParamsEx(result, enginem, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);
					format(gpbMensagem, 500, "%s fecha a mala do veículo.", GetName(playerid));
					SendRangedMessage(playerid, purple, gpbMensagem, 15);
					format(gpbMensagem, 500, "Fecha a mala do veículo.");
					SetPlayerChatBubble(playerid, gpbMensagem, purple, 15, 10000);
				}
			}
		}
	}
	return 1;
}

CMD:pintar(playerid, params[]) {
	new cor1, cor2, vehicleid = GetPlayerVehicleID(playerid);
	if (!(IsPlayerInAnyVehicle(playerid))) {
		SendClientMessage(playerid, grey, "Você tem que estar em um veículo.");
	}
	else if(sscanf(params, "dd[5]", cor1, cor2))
		SendClientMessage(playerid, grey, "/pintar [cor1] [cor2]");
	
	else if(player[playerid][pFerido] == 1){
	    SendClientMessage(playerid, grey, "Você está ferido. Primeiro utilize o /reviver.");
	}
	else {
		ChangeVehicleColor(vehicleid, cor1, cor2);
	}
    return 1;
}

CMD:fix(playerid) {
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!IsValidVehicle(vehicleid)) {
		SendClientMessage(playerid, grey, "Você não está em um veículo.");
	}
    else if (player[playerid][pFerido] == 1) {
        SendClientMessage(playerid, grey, "Você está ferido. Primeiro use o /reviver.");

    }
	else {
	 	SetVehicleHealth(vehicleid, 1000.0);
	 	RepairVehicle(GetPlayerVehicleID(playerid));
		format(gpbMensagem, 500, "%s reparou o seu veículo.", GetName(playerid));
    	SendRangedMessage(playerid, green, gpbMensagem, 50);
	}
 	return 1;
}

CMD:vp(playerid, params[]) {
    new vehicleid = GetPlayerVehicleID(playerid);
	if(!(IsPlayerInAnyVehicle(playerid))) {
		SendClientMessage(playerid, grey, "Você tem que estar em um veículo para definir um prefixo.");
	}
	else if(isnull(params)) {
 		SendClientMessage(playerid, grey, "/vp [prefixo].");
	}
    else if (veiculoPrefixo[vehicleid]) {
        Delete3DTextLabel(veiculoPrefixo3D[vehicleid]);
        veiculoPrefixo[vehicleid] = 0;
    }
    else {
        veiculoPrefixo3D[vehicleid] = Create3DTextLabel(params, -1, 0.0, 0.0, 0.0, 50.0, 0, 1);
	    Attach3DTextLabelToVehicle(veiculoPrefixo3D[vehicleid], vehicleid, -0.8, -2.8, -0.3);
	    veiculoPrefixo[vehicleid] = 1;
    }
	return 1;
}

CMD:rp(playerid, params[]) {
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!(IsPlayerInAnyVehicle(playerid))) {
		SendClientMessage(playerid, grey, "Você tem que estar em um veículo para remover seu prefixo.");
 	}
    else if (player[playerid][pFerido] == 1) {
        SendClientMessage(playerid, grey, "Você está ferido. Primeiro use o /reviver.");

    }
	else if (!(veiculoPrefixo[vehicleid])) {
	    SendClientMessage(playerid, grey, "O veículo não possui um prefixo pré-definido.");
	}
    else {
        Delete3DTextLabel(veiculoPrefixo3D[vehicleid]);
        veiculoPrefixo[vehicleid] = 0;
    }
    return 1;
}

CMD:skin(playerid, params[]) {
	new skin = strval(params);
	if(player[playerid][pFerido] == 1 || player[playerid][pAlgemado] == 1 || player[playerid][pDerrubado] == 1) {
  		SendClientMessage(playerid, grey, "Você não pode fazer isso agora.");
	}
	else if (IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid, grey, "Não é possível mudar o personagem dentro de um veículo.");
	}
	else if(isnull(params)) {
 		SendClientMessage(playerid, grey, "/skin [id]");
	}
	else if(skin >= 0 && skin <= 311 && skin != 74) {
		player[playerid][pAnim] = 0;
		SetPlayerSkin(playerid, skin);
		new mensagem[120];
        format(mensagem, sizeof(mensagem), "Você mudou para a skin ID %d com sucesso.", skin);
		SendClientMessage(playerid, grey, mensagem);
	}
	else {
 		SendClientMessage(playerid, grey, "/skin [id]");
	}
	return 1;
}

CMD:morrer(playerid) {
    if(IsPlayerInAnyVehicle(playerid)) {
        TogglePlayerControllable(playerid, 0);
		player[playerid][pFerido] = 1;
	    SetPlayerHealth(playerid, 98303);
	    SetPlayerColor(playerid, red);
	    ApplyAnimation(playerid, "ped", "car_dead_lhs", 4.1, 0, 1, 0, 1, 0, 1);
	    SendClientMessage(playerid, grey, "Você está ferido. Para voltar ao controle do personagem use o /levantar.");
	}
	else {
	    player[playerid][pFerido] = 1;
	    SetPlayerHealth(playerid, 98303);
	    SetPlayerColor(playerid, red);
	    ApplyAnimation(playerid, "ped", "KO_skid_front", 4.1, 0, 0, 0, 1, 0, 1);
	    SendClientMessage(playerid, grey, "Você está ferido. Para voltar ao controle do personagem use o /levantar.");
	}
	return 1;
}

CMD:reviver(playerid) {
    new Float:health;
    GetPlayerHealth(playerid,health);

	if (player[playerid][pFerido] == 0) {
		SendClientMessage(playerid, grey, "Você não está ferido.");
	}
    else if(IsPlayerInAnyVehicle(playerid)) {
        TogglePlayerControllable(playerid, 1);
        ApplyAnimation(playerid, "ped", "car_sit", 4.1, 0, 0, 0, 0, 0, 1);
        SetPlayerHealth(playerid, 100.0);
	    SetPlayerColor(playerid, white);
	    player[playerid][pFerido] = 0;
		ferimento[playerid][ftronco] = 0;
		ferimento[playerid][fpelvis] = 0;
		ferimento[playerid][fbracoesq] = 0;
		ferimento[playerid][fbracodir] = 0;
		ferimento[playerid][fpernaesq] = 0;
		ferimento[playerid][fpernadir] = 0;
		ferimento[playerid][fcabeca] = 0;
	}
	else {
	    ApplyAnimation(playerid, "ped", "getup", 1.1, 0, 0, 0, 0, 0, 1);
	    SetPlayerHealth(playerid, 100.0);
	    SetPlayerColor(playerid, white);
	    player[playerid][pFerido] = 0;
		ferimento[playerid][ftronco] = 0;
		ferimento[playerid][fpelvis] = 0;
		ferimento[playerid][fbracoesq] = 0;
		ferimento[playerid][fbracodir] = 0;
		ferimento[playerid][fpernaesq] = 0;
		ferimento[playerid][fpernadir] = 0;
		ferimento[playerid][fcabeca] = 0;
	}
    return 1;
}

CMD:equipar(playerid, params[]) {
    if(player[playerid][pFerido] == 1 || player[playerid][pAlgemado] == 1 || player[playerid][pDerrubado] == 1) {
  		SendClientMessage(playerid, grey, "Você não pode fazer isso agora.");
	}
	else {
 		ShowPlayerDialog(playerid, textbox_equipamentos, DIALOG_STYLE_LIST, "Equipamentos",
        "Vida\nColete\nSpray\nCacetete\nFaca\n9mm\nTaser\nDesert Eagle\nEscopeta\nEscopeta com elastômero\nEscopeta de combate\nEscopeta de cano serrado\nMicro-UZI\nTEC9\nMP5\nM4\nAK-47\nRifle de precisão\nRifle de caçador\nGranada de fumaça\nCoquetel molotov\nDetonador\nCâmera\nParaquedas\nTaco de golf\nTaco de baseball\nTaco de sinuca\nKatana\nPá\nSerra elétrica\nExtintor\nExplosivo\nDildo\nVibrador\nBuquê\nBengala",
        "Aceitar", "Cancelar");
	}
	return 1;
}

CMD:limpar(playerid, params[]) {
	ResetPlayerWeapons(playerid);
	return 1;
}

CMD:hora(playerid, params[]) {
    new hora = strval(params);
    if(isnull(params)) {
		return SendClientMessage(playerid, grey, "/hora [0-24]");
 	}
	if(hora >= 0 && hora <= 24) {
		SetPlayerTime(playerid, hora, 0);
	}
	else return SendClientMessage(playerid, grey, "/hora [0-24]");
	return 1;
}

CMD:hour(playerid, params[]) { // Hora global (admin)
	if (IsPlayerAdmin(playerid)) {
		new hora = strval(params);
		if(isnull(params)) {
			return SendClientMessage(playerid, grey, "/hora [0-24]");
		}
		if(hora >= 0 && hora <= 24) {
			SetWorldTime(hora);
			format(gpbMensagem, sizeof(gpbMensagem), "Horário local definido para às %d:00 em Los Santos.", hora);
			SendClientMessageToAll(red, gpbMensagem);
		}
		else { 
			SendClientMessage(playerid, grey, "/hora [0-24]");
		}
	}
	else {
		SendClientMessage(playerid, grey, "Você não tem permissão.");
	}
	return 1;
}

CMD:clima(playerid, params[]) {
	new clima = strval(params);
	if(isnull(params)) {
		SendClientMessage(playerid, grey, "/clima [0-45]");
	}
	if(clima >= 0 && clima <= 45) {

		SetPlayerWeather(playerid, clima);
	}
	else {
		SendClientMessage(playerid, grey, "/clima [0-45]");
	}
	return 1;
}

CMD:tp(playerid, params[]) {
    if(player[playerid][pFerido] == 1 || player[playerid][pAlgemado] == 1 || player[playerid][pDerrubado] == 1) {
  		SendClientMessage(playerid, grey, "Você não pode fazer isso agora.");
	}
	else {
   		ShowPlayerDialog(playerid, textbox_teletransportes, DIALOG_STYLE_LIST, "Lugares",
        "Los Santos\nLos Santos Police Department\nSanta Maria Beach\nGroove Street\nSan Fierro\nSan Fierro Police Department\nLas Venturas\nLas Venturas Police Department\nPalomino Creek\nMontgomery\nDillimore\nBlueberry\nAngel Pine\nEl Quebrados\nFort Carson",
        "Aceitar", "Cancelar");
	}
	return 1;
}

CMD:ir(playerid, params[]) {
	new objetivo = strval(params);
	new Float:pos[3];
	if(player[playerid][pFerido] == 1 || player[playerid][pAlgemado] == 1 || player[playerid][pDerrubado] == 1) {
  		SendClientMessage(playerid, grey, "Você não pode fazer isso agora.");
	}
	else if (isnull(params)) {
		SendClientMessage(playerid, grey, "/ir [id]");
	}
	else if (playerid == objetivo) {
		SendClientMessage(playerid, grey, "Você não pode ir até si mesmo.");
	}
	else if(isnull(params)) {
		SendClientMessage(playerid, grey, "/ir [id]");
	}
	else if(!IsPlayerConnected(objetivo)) {
		SendClientMessage(playerid, grey, "O jogador não está conectado.");
	} 
	else if (IsPlayerInAnyVehicle(playerid)) {
		GetPlayerPos(objetivo, pos[0], pos[1], pos[2]);
		SetVehiclePos(GetPlayerVehicleID(playerid), pos[0]+1, pos[1]+1, pos[2]);
	}
	else {
		if(IsPlayerInAnyVehicle(playerid)) {
			GetPlayerPos(objetivo, pos[0], pos[1], pos[2]);
			SetVehiclePos(GetPlayerVehicleID(playerid), pos[0]+1, pos[1]+1, pos[2]);
			format(gpbMensagem, sizeof(gpbMensagem), "Voce foi até %s.", GetName(objetivo));
			SendClientMessage(playerid, grey, gpbMensagem);
			format(gpbMensagem, sizeof(gpbMensagem), "%s veio até sua localização.", GetName(playerid));
			SendClientMessage(objetivo, grey, gpbMensagem);
		}
		else {
			GetPlayerPos(objetivo, pos[0], pos[1], pos[2]);
			SetPlayerPos(playerid, pos[0]+1, pos[1]+1, pos[2]);
			format(gpbMensagem, sizeof(gpbMensagem), "Voce foi até %s.", GetName(objetivo));
			SendClientMessage(playerid, grey, gpbMensagem);
			format(gpbMensagem, sizeof(gpbMensagem), "%s veio até sua localização.", GetName(playerid));
			SendClientMessage(objetivo, grey, gpbMensagem);
		}
	}	
	return 1;
}

CMD:algemar(playerid, params[]) {
    new userid;
	if (player[playerid][pEquipe] != 1) {
		SendClientMessage(playerid, grey, "Você não possui algemas.");
	}
    else if (sscanf(params, "u", userid)) {
		SendClientMessage(playerid, grey, "/algemar [id]");
	}
	else if(IsPlayerInAnyVehicle(userid)) {
		SendClientMessage(playerid, grey, "Você não pode algemar um jogador que esteja de dentro de um veículo.");
	}
	else if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid, grey, "Você não pode algemar alguém dentro de um veículo.");
	}
    else if (userid == INVALID_PLAYER_ID) {
		SendClientMessage(playerid, grey, "Jogador não conectado.");
	}
    else if (userid == playerid) {
		SendClientMessage(playerid, grey, "Você não pode algemar a si mesmo.");
	}
	else if (player[userid][pAlgemado] == 1) {
		SendClientMessage(playerid, grey, "O jogador já está algemado");
	}
	else if (player[playerid][pFerido] == 1 || player[playerid][pAlgemado] == 1) {
  		SendClientMessage(playerid, grey, "Você não pode fazer isso agora.");
	}
    else if (!IsPlayerNearPlayer(playerid, userid, 2.0)) {
		SendClientMessage(playerid, grey, "Você deve estar bem próximo ao jogador.");
	} 
	else {
		player[userid][pAlgemado] = 1;
		ApplyAnimation(playerid, "GANGS", "shake_cara", 1.1, 0, 0, 0, 0, 0, 1);
		SetPlayerSpecialAction(userid, SPECIAL_ACTION_CUFFED);
		format(gpbMensagem, sizeof(gpbMensagem), "Voce foi algemado por %s.", GetName(playerid));
		SendClientMessage(userid, grey, gpbMensagem);
		format(gpbMensagem, sizeof(gpbMensagem), "%s retira um par de algemas e coloca nos pulsos de %s.", GetName(playerid), GetName(userid));
    	SendRangedMessage(playerid, purple, gpbMensagem, 15);
	}
    return 1;
}

CMD:desalgemar(playerid, params[]) {
	new userid;
	if (player[playerid][pEquipe] != 1) {
		SendClientMessage(playerid, grey, "Você não pode desalgemar ninguém.");
	}
    else if(player[playerid][pFerido] == 1){
	    SendClientMessage(playerid, grey, "Você está ferido. Primeiro utilize o /reviver.");
	}
	else if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid, grey, "Você não pode desalgemar alguém de dentro de um veículo.");
	}
	else if (sscanf(params, "u", userid)) {
		SendClientMessage(playerid, grey, "/desalgemar [id]");
	}
	else if (userid == INVALID_PLAYER_ID) {
		SendClientMessage(playerid, grey, "Jogador não conectado.");
	}
	else if (userid == playerid) {
		SendClientMessage(playerid, grey, "Você não pode desalgemar a si mesmo.");
	}
	else if (player[userid][pAlgemado] == 0) {
		SendClientMessage(playerid, grey, "O jogador não está está algemado");
	}
	else if (!IsPlayerNearPlayer(playerid, userid, 2.0)) {
		SendClientMessage(playerid, grey, "Você deve estar bem próximo ao jogador.");
	}
	else {
		player[userid][pAlgemado] = 0;
		ApplyAnimation(playerid, "GANGS", "shake_cara", 1.1, 0, 0, 0, 0, 0, 1);
		SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);
		format(gpbMensagem, sizeof(gpbMensagem), "Voce foi desalgemado por %s.", GetName(playerid));
		SendClientMessage(userid, grey, gpbMensagem);
		format(gpbMensagem, sizeof(gpbMensagem), "%s retira o par de algemas de %s.", GetName(playerid), GetName(userid));
    	SendRangedMessage(playerid, purple, gpbMensagem, 15);
	}
    return 1;
}

CMD:derrubar(playerid, params[]) {
    new userid;
    if(player[playerid][pFerido] == 1){
	    SendClientMessage(playerid, grey, "Você está ferido. Primeiro utilize o /reviver.");
	}
	else if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid, grey, "Você não pode derrubar alguém de dentro de um veículo.");
	}
	else if (sscanf(params, "u", userid)) {
		SendClientMessage(playerid, grey, "/derrubar [id]");
	}
	else if (userid == INVALID_PLAYER_ID) {
		SendClientMessage(playerid, grey, "Jogador não conectado.");
	}
	else if (userid == playerid) {
		SendClientMessage(playerid, grey, "Você não pode derrubar a si mesmo.");
	}
	else if (!IsPlayerNearPlayer(playerid, userid, 2.0)) {
		SendClientMessage(playerid, grey, "Você deve estar bem próximo ao jogador.");
	}
	else if (player[userid][pDerrubado] == 1 || (player[userid][pAlgemado] == 1) && player[userid][pFerido] == 1) {
		SendClientMessage(playerid, grey, "O jogador já está no chão.");
	}
	else {
		format(gpbMensagem, sizeof(gpbMensagem), "%s coloca %s ao chão.", GetName(playerid), GetName(userid));
    	SendRangedMessage(playerid, purple, gpbMensagem, 15);
		ApplyAnimation(playerid, "BASEBALL", "Bat_4", 1.1, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "ped", "KO_skid_front", 4.1, 0, 0, 0, 1, 0, 1);
		player[userid][pDerrubado] = 1;
	}
	return 1;
}

CMD:levantar(playerid, params[]) {
    new userid;
    if(player[playerid][pFerido] == 1){
	    SendClientMessage(playerid, grey, "Você está ferido. Primeiro utilize o /reviver.");
	}
	else if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid, grey, "Você não pode levantar alguém de dentro de um veículo.");
	}
	else if (sscanf(params, "u", userid)) {
		SendClientMessage(playerid, grey, "/levantar [id]");
	}
	else if (userid == INVALID_PLAYER_ID) {
		SendClientMessage(playerid, grey, "Jogador não conectado.");
	}
	else if (userid == playerid) {
		SendClientMessage(playerid, grey, "Você não pode usar esse comando em si mesmo.");
	}
	else if (!IsPlayerNearPlayer(playerid, userid, 2.0)) {
		SendClientMessage(playerid, grey, "Você deve estar bem próximo ao jogador.");
	}
	else if (player[userid][pDerrubado] == 0) {
		SendClientMessage(playerid, grey, "O jogador não está no chão.");
	}
	else {
		format(gpbMensagem, sizeof(gpbMensagem), "%s pega %s pelo braço e levanta-o.", GetName(playerid), GetName(userid));
    	SendRangedMessage(playerid, purple, gpbMensagem, 15);
		ApplyAnimation(playerid, "CARRY", "liftup05", 4.1, 0, 0, 0, 0, 0, 1);
		ApplyAnimation(userid, "ped", "getup", 1.1, 0, 0, 0, 0, 0, 1);
		SetPlayerColor(userid, white);
		SetPlayerHealth(userid, 100);
		player[userid][pDerrubado] = 0;
	}
	return 1;
}

CMD:reanimar(playerid, params[]) {
    new userid;
	if(player[playerid][pFerido] == 1){
	    SendClientMessage(playerid, grey, "Você está ferido. Primeiro utilize o /reviver.");
	}
	else if(player[playerid][pEquipe] != 3) {
		SendClientMessage(playerid, grey, "Você precisa ser um paramédico para reanimar um jogador.");
	}
	else if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessage(playerid, grey, "Você não pode reanimar alguém de dentro de um veículo.");
	}
	else if (sscanf(params, "u", userid)) {
		SendClientMessage(playerid, grey, "/reanimar [id]");
	}
	else if (userid == INVALID_PLAYER_ID) {
		SendClientMessage(playerid, grey, "Jogador não conectado.");
	}
	else if (userid == playerid) {
		SendClientMessage(playerid, grey, "Você não pode usar esse comando em si mesmo.");
	}
	else if (!IsPlayerNearPlayer(playerid, userid, 2.0)) {
		SendClientMessage(playerid, grey, "Você deve estar bem próximo ao jogador.");
	}
	else if (player[userid][pFerido] == 0) {
		SendClientMessage(playerid, grey, "O jogador não está ferido.");
	}
	else {
		format(gpbMensagem, sizeof(gpbMensagem), "%s ajoelha-se e tenta reanimar %s.", GetName(playerid), GetName(userid));
    	SendRangedMessage(playerid, purple, gpbMensagem, 15);
		ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);
		SetTimerEx("Reanima", 5000, false, "d", userid);
	}
	return 1;
}

CMD:ferimento(playerid, params[]) {
	new scabeca[32], stronco[32], sbracoesq[32], sbracodir[32], spelvis[32], spernaesq[32], spernadir[32];
	// Categoriza o ferimento
	if (ferimento[playerid][fcabeca] == 0) {
		scabeca = "{FFFFFF}Sem lesões";
	}
	else if (20 >= ferimento[playerid][fcabeca] > 0) {
		scabeca = "{00adef}Não urgente";
	}
	else if (40 >= ferimento[playerid][fcabeca] > 20) {
		scabeca = "{027e3f}Pouco urgente";
	}
	else if (60 >= ferimento[playerid][fcabeca] > 40) {
		scabeca = "{f4c900}Urgente";
	}
	else if (80 >= ferimento[playerid][fcabeca] > 60) {
		scabeca = "{f58122}Muito urgente";
	}
	else if (ferimento[playerid][fcabeca] > 80) {
		scabeca = "{c5161d}Emergência";
	}
	//
	if (ferimento[playerid][ftronco] == 0) {
		stronco = "{FFFFFF}Sem lesões";
	}
	else if (20 >= ferimento[playerid][ftronco] > 0) {
		stronco = "{00adef}Não urgente";
	}
	else if (40 >= ferimento[playerid][ftronco] > 20) {
		stronco = "{027e3f}Pouco urgente";
	}
	else if (60 >= ferimento[playerid][ftronco] > 40) {
		stronco = "{f4c900}Urgente";
	}
	else if (80 >= ferimento[playerid][ftronco] > 60) {
		stronco = "{f58122}Muito urgente";
	}
	else if (ferimento[playerid][ftronco] > 80) {
		stronco = "{c5161d}Emergência";
	}
	//
	if (ferimento[playerid][fbracoesq] == 0) {
		sbracoesq = "{FFFFFF}Sem lesões";
	}
	else if (20 >= ferimento[playerid][fbracoesq] > 0) {
		sbracoesq = "{00adef}Não urgente";
	}
	else if (40 >= ferimento[playerid][fbracoesq] > 20) {
		sbracoesq = "{027e3f}Pouco urgente";
	}
	else if (60 >= ferimento[playerid][fbracoesq] > 40) {
		sbracoesq = "{f4c900}Urgente";
	}
	else if (80 >= ferimento[playerid][fbracoesq] > 60) {
		sbracoesq = "{f58122}Muito urgente";
	}
	else if (ferimento[playerid][fbracoesq] > 80) {
		sbracoesq = "{c5161d}Emergência";
	}
	//
	if (ferimento[playerid][fbracodir] == 0) {
		sbracodir = "{FFFFFF}Sem lesões";
	}
	else if (20 >= ferimento[playerid][fbracodir] > 0) {
		sbracodir = "{00adef}Não urgente";
	}
	else if (40 >= ferimento[playerid][fbracodir] > 20) {
		sbracodir = "{027e3f}Pouco urgente";
	}
	else if (60 >= ferimento[playerid][fbracodir] > 40) {
		sbracodir = "{f4c900}Urgente";
	}
	else if (80 >= ferimento[playerid][fbracodir] > 60) {
		sbracodir = "{f58122}Muito urgente";
	}
	else if (ferimento[playerid][fbracodir] > 80) {
		sbracodir = "{c5161d}Emergência";
	}
	//
	if (ferimento[playerid][fpelvis] == 0) {
		spelvis = "{FFFFFF}Sem lesões";
	}
	else if (20 >= ferimento[playerid][fpelvis] > 0) {
		spelvis = "{00adef}Não urgente";
	}
	else if (40 >= ferimento[playerid][fpelvis] > 20) {
		spelvis = "{027e3f}Pouco urgente";
	}
	else if (60 >= ferimento[playerid][fpelvis] > 40) {
		spelvis = "{f4c900}Urgente";
	}
	else if (80 >= ferimento[playerid][fpelvis] > 60) {
		spelvis = "{f58122}Muito urgente";
	}
	else if (ferimento[playerid][fpelvis] > 80) {
		spelvis = "{c5161d}Emergência";
	}
	//
	if (ferimento[playerid][fpernaesq] == 0) {
		spernaesq = "{FFFFFF}Sem lesões";
	}
	else if (20 >= ferimento[playerid][fpernaesq] > 0) {
		spernaesq = "{00adef}Não urgente";
	}
	else if (40 >= ferimento[playerid][fpernaesq] > 20) {
		spernaesq = "{027e3f}Pouco urgente";
	}
	else if (60 >= ferimento[playerid][fpernaesq] > 40) {
		spernaesq = "{f4c900}Urgente";
	}
	else if (80 >= ferimento[playerid][fpernaesq] > 60) {
		spernaesq = "{f58122}Muito urgente";
	}
	else if (ferimento[playerid][fpernaesq] > 80) {
		spernaesq = "{c5161d}Emergência";
	}
	//
	if (ferimento[playerid][fpernadir] == 0) {
		spernadir = "{FFFFFF}Sem lesões";
	}
	else if (20 >= ferimento[playerid][fpernadir] > 0) {
		spernadir = "{00adef}Não urgente";
	}
	else if (40 >= ferimento[playerid][fpernadir] > 20) {
		spernadir = "{027e3f}Pouco urgente";
	}
	else if (60 >= ferimento[playerid][fpernadir] > 40) {
		spernadir = "{f4c900}Urgente";
	}
	else if (80 >= ferimento[playerid][fpernadir] > 60) {
		spernadir = "{f58122}Muito urgente";
	}
	else if (ferimento[playerid][fpernadir] > 80) {
		spernadir = "{c5161d}Emergência";
	}
	//
	format(gpbMensagem, sizeof(gpbMensagem), "{FFFFFF}Segmento corpóreo\tGrau de lesão\nCabeça\t\t\t%s\n{FFFFFF}Tronco\t\t\t%s\n{FFFFFF}Braço esquerdo\t\t%s\n{FFFFFF}Braço direito\t\t%s\n{FFFFFF}Pélvis\t\t\t%s\n{FFFFFF}Perna esquerda\t\t%s\n{FFFFFF}Perna direita\t\t%s\n\n{FFFFFF}Ferimentos causados possivelmente por %s.", scabeca, stronco, sbracoesq, sbracodir, spelvis, spernaesq, spernadir, ferimento[playerid][fcausa]);
	ShowPlayerDialog(playerid, textbox_fermimento, DIALOG_STYLE_MSGBOX, "Fermimentos", gpbMensagem, "Voltar", "");
	return 1;
}

CMD:anim(playerid, params[]) {
	if (player[playerid][pFerido] == 1 || player[playerid][pAlgemado] == 1 || player[playerid][pDerrubado] == 1) {
		SendClientMessage(playerid, grey, "Você não pode realizar animações no momento.");
	}
	else {
		ShowPlayerDialog(playerid, textbox_animes1, DIALOG_STYLE_TABLIST_HEADERS, "Animações",
		"Descrição\tEscopo\n\
		Parar\tY\n\
		Cambalear\t\n\
		Cansar\t\n\
		Carregar\t\n\
		Chorar\t\n\
		Colocar braço para fora\t\n\
		Colocar mãos acima\t\n\
		Fotografar\t\n\
		Fumar\t\n\
		Meditar\t\n\
		Plantar\t\n\
		Portar\t\n\
		Revistar\t\n\
		Urinar\t\n\
		Vomitar\t\n\
		Acenar\t[1-3]\n\
		Apontar\t[1-4]\n\
		Beijar\t[1-6]\n\
		Comer\t[1-3]\n\
		Comemorar\t[1-8]\n\
		Conversar\t[1-6]\n\
		Cruzar\t[1-4]\n\
		Dançar\t[1-10]\n\
		Deitar-se\t[1-5]\n\
		Dormir\t[1-2]\n\
		Drogar-se\t[1-6]\n\
		Masturbar-se\t[1-3]\n\
		Negociar\t[1-6]\n\
		Recarregar\t[1-4]\n\
		Próxima página\t>\n",
		"Confirmar", "");
	}
	return 1;
}

//Objetos
CMD:ob(playerid, params[]) {
	new obj = strval(params);
	new Float:objx, Float:objy, Float:objz, Float:obja;
	GetPlayerPos(playerid, objx, objy, objz);
	GetPlayerFacingAngle(playerid, obja);
    if(player[playerid][pFerido] == 1){
	    SendClientMessage(playerid, grey, "Você está ferido. Primeiro utilize o /reviver.");
	}
    else if(player[playerid][pAlgemado] == 1){
	    SendClientMessage(playerid, grey, "Você está algemado.");
	}
    else {
        if(obj == 1) {
		CriaObjeto(1238, objx, objy, objz+0.2, obja);
		SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 2) {
            CriaObjeto(1228, objx, objy, objz+0.2, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 3) {
            CriaObjeto(1237, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 4) {
            CriaObjeto(1422, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 5) {
            CriaObjeto(1425, objx, objy, objz+0.2, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 6) {
            CriaObjeto(1427, objx, objy, objz+0.2, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 7) {
            CriaObjeto(19972, objx, objy, objz-0.1, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 8) {
            CriaObjeto(3091, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 9) {
            CriaObjeto(1423, objx, objy, objz+0.6, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 10) {
            CriaObjeto(1459, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 11) {
            CriaObjeto(1424, objx, objy, objz+0.5, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 12) {
            CriaObjeto(1432, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 13) {
            CriaObjeto(1810, objx, objy, objz-0.1, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 14) {
            CriaObjeto(2370, objx, objy, objz-0.1, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 15) {
            CriaObjeto(19997, objx, objy, objz-0.1, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 16) {
            CriaObjeto(1340, objx, objy, objz+1, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 17) {
            CriaObjeto(1466, objx, objy, objz+1, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 18) {
            CriaObjeto(19121, objx, objy, objz+0.2, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 19) {
            CriaObjeto(2905, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 20) {
            CriaObjeto(2906, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 21) {
            CriaObjeto(2907, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 22) {
            CriaObjeto(2908, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 23) {
            CriaObjeto(1440, objx, objy, objz+0.3, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 24) {
            CriaObjeto(1334, objx, objy, objz+0.8, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 25) {
            CriaObjeto(851, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 26) {
            CriaObjeto(1265, objx, objy, objz+0.3, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 27) {
            CriaObjeto(2968, objx, objy, objz+0.2, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 28) {
            CriaObjeto(3092, objx, objy, objz+0.8, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 29) {
            CriaObjeto(1212, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 30) {
            CriaObjeto(11738, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 31) {
            CriaObjeto(19632, objx, objy, objz-0.1, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 32) {
            CriaObjeto(19893, objx, objy, objz-0.1, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 33) {
            CriaObjeto(1550, objx, objy, objz+0.3, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 34) {
            CriaObjeto(1442, objx, objy, objz+0.5, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 35) {
            CriaObjeto(1349, objx, objy, objz+0.45, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 36) {
            CriaObjeto(19339, objx, objy, objz+0.3, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 37) {
            CriaObjeto(1428, objx, objy, objz+1.4, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 38) {
            CriaObjeto(1411, objx, objy, objz+1.5, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 39) {
            CriaObjeto(1412, objx, objy, objz+1.2, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 40) {
            CriaObjeto(1417, objx, objy, objz+0.2, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 41) {
            CriaObjeto(3632, objx, objy, objz+0.4, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 42) {
            CriaObjeto(2359, objx, objy, objz+0.1, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 43) {
            CriaObjeto(964, objx, objy, objz-0.1, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 44) {
            CriaObjeto(1518, objx, objy, objz+0.2, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 45) {
            CriaObjeto(1481, objx, objy, objz+0.6, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 46) {
            CriaObjeto(19831, objx, objy, objz-0.1, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 47) {
            CriaObjeto(1829, objx, objy, objz+0.4, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 48) {
            CriaObjeto(2146, objx, objy, objz+0.4, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 49) {
            CriaObjeto(638, objx, objy, objz, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else if(obj == 50) {
            CriaObjeto(1360, objx, objy, objz+0.7, obja);
            SendClientMessage(playerid, grey, "Objeto adicionado. Use /remover para retirá-lo.");
        }
        else {
            SendClientMessage(playerid, grey, "/objeto [1-50]");
        }
    }
	return 1;
}

CMD:remover(playerid, params[]) {
    if (player[playerid][pFerido] == 1) {
		SendClientMessage(playerid, grey, "Você está ferido. Primeiro use o /reviver.");
	}
    else if (player[playerid][pAlgemado] == 1) {
		SendClientMessage(playerid, grey, "Você está algemado.");
	}
    else {
        for(new i = 0; i < sizeof(objeto); i++) {
    	if(IsPlayerInRangeOfPoint(playerid, 2.0, objeto[i][sX], objeto[i][sY], objeto[i][sZ])) {
        	if(objeto[i][objetoCriado] == 1) {
                objeto[i][objetoCriado] = 0;
                objeto[i][sX] = 0.0;
                objeto[i][sY] = 0.0;
                objeto[i][sZ] = 0.0;
                DestroyDynamicObject(objeto[i][sObject]);
				SendClientMessage(playerid, grey, "Objeto removido.");
                return 1;
            }
		}
	}
}
    return 1;
}