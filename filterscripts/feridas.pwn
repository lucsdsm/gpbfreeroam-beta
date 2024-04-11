#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <foreach>
#include <streamer>
#include <callbacks>
#include <a_zones>
#include <sound>

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

#define textbox_fermimento 21

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

new ferimento[MAX_PLAYERS][ferimentoData];
new gpbMensagem[512];

public OnPlayerRequestClass(playerid, classid) {
	ferimento[playerid][ftronco] = 0;
	ferimento[playerid][fpelvis] = 0;
	ferimento[playerid][fbracoesq] = 0;
	ferimento[playerid][fbracodir] = 0;
	ferimento[playerid][fpernaesq] = 0;
	ferimento[playerid][fpernadir] = 0;
	ferimento[playerid][fcabeca] = 0;
    return 1;
}

public OnPlayerConnect(playerid) {
	ferimento[playerid][ftronco] = 0;
	ferimento[playerid][fpelvis] = 0;
	ferimento[playerid][fbracoesq] = 0;
	ferimento[playerid][fbracodir] = 0;
	ferimento[playerid][fpernaesq] = 0;
	ferimento[playerid][fpernadir] = 0;
	ferimento[playerid][fcabeca] = 0;
	format(ferimento[playerid][fcausa], 128, "-");
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart) {
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
    return 1;
}

CMD:feridas(playerid, params[]) {
	new scabeca[32], stronco[32], sbracoesq[32], sbracodir[32], spelvis[32], spernaesq[32], spernadir[32];
    new Float:health;
    GetPlayerHealth(playerid,health);
    if (health == 100) {
		ferimento[playerid][ftronco] = 0;
		ferimento[playerid][fpelvis] = 0;
		ferimento[playerid][fbracoesq] = 0;
		ferimento[playerid][fbracodir] = 0;
		ferimento[playerid][fpernaesq] = 0;
		ferimento[playerid][fpernadir] = 0;
		ferimento[playerid][fcabeca] = 0;
		format(ferimento[playerid][fcausa], 128, "-");
    }
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