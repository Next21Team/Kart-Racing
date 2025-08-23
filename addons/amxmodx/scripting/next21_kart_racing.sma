#include <amxmodx>
#include <engine>
#include <fakemeta_util>
#include <hamsandwich>
#include <reapi>
#include <xs>

#include <kart_const>

new const PLUGIN[] = "Kart"
new const VERSION[] = "0.1"
new const AUTHOR[] = "Quake'R"

new const MODEL_KART_PACKS[][] = {
	"models/next21_kart/kart_pack01_a03.mdl",
	"models/next21_kart/kart_pack02_a04.mdl",
	"models/next21_kart/kart_pack03_a04.mdl",
	"models/next21_kart/kart_pack04_a02.mdl",
	"models/next21_kart/kart_pack05_a02.mdl"
}

new const MODEL_CAMERA[] = "models/rpgrocket.mdl"
new const MODEL_ITEMBOX[] = "models/next21_kart/itembox_a01.mdl"
new const MODEL_UI[] = "models/next21_kart/ui_a11.mdl"
new const MODEL_SNOWBALL[] = "models/next21_kart/snowball_a01.mdl"
new const MODEL_BLOWFISH[]	= "models/next21_kart/blowfish_a02.mdl"
new const MODEL_GLOVE[] = "models/next21_kart/glove_a01.mdl"
new const MODEL_TORNADO[] = "models/next21_kart/tornado_a01.mdl"
new const MODEL_UFO[] = "models/next21_kart/ufo_a01.mdl"

new const MODEL_SNOWBALL_GIB[] = "sprites/next21_kart/snowball_gib_a01.spr"
new const MODEL_DIZZY_SPRITE[] = "sprites/next21_kart/dizzy_b02.spr"
new const MODEL_TORNADO_WARN[] = "sprites/next21_kart/tornado_warn.spr"

new const SOUND_STARTING[] = "next21_kart/com_321_go.wav"
new const SOUND_FINAL_LAP[] = "next21_kart/com_final_lap.wav"

new const SOUNDS_FINISH[][] = {
	"next21_kart/com_well_done.wav",
	"next21_kart/com_place_1.wav",
	"next21_kart/com_place_2.wav",
	"next21_kart/com_place_3.wav",
	"next21_kart/com_place_4.wav"
}

new const SOUND_ENGINE[] = "next21_kart/engine_a02.wav"
new const SOUND_JUMP[] = "next21_kart/jump_a01.wav"
new const SOUND_LAND[] = "next21_kart/land_a02.wav"
new const SOUND_ITEMBOX[] = "next21_kart/itembox_a03.wav"
new const SOUND_HORN[] = "next21_kart/horn_a01.wav"

new const SOUNDS_SKIDING[][] = {
	"next21_kart/skid01_a01.wav",
	"next21_kart/skid02_a01.wav",
	"next21_kart/skid03_a01.wav"
}

new const SOUND_COMMON_HIT[] = "next21_kart/common_hit_a01.wav"

new const SOUND_ICICLE_LAUNCH[]	= "next21_efk/icicle_launch.wav"
new const SOUND_SNOWBALL_HIT[] = "next21_kart/snowball_hit_a01.wav"

new const SOUND_BLOWFISH_LAUNCH[] = "next21_kart/blowfish_launch_a02.wav"

new const SOUND_BOOSTER[] = "next21_kart/booster_a02.wav"

new const SOUND_GLOVE_LAUNCH[] = "next21_kart/glove_launch_a01.wav"
new const SOUND_CATCH[] = "next21_kart/catch_b01.wav"

new const SOUND_TORNADO_HIT[] =	"next21_efk/wind_boost_down.wav"
new const SOUND_TORNADO_LAUNCH[] =	"next21_kart/tornado_launch.wav"

new const SOUND_UFO_LAUNCH[] = "next21_kart/ufo_launch_a01.wav"

new const SOUND_ALERT[] = "next21_enjoy/alert.wav"

new const SOUND_SYS_CHANGE[] = "next21_kart/system_change.wav"
new const SOUND_SYS_SELECT[] = "next21_kart/system_select.wav"

new const SKYNAME[] = "drcrash2"

#define CHAR_NUM		40
#define CHAR_PACK_SIZE	8

#define UI_POS_NUM		32
#define UI_LAP_NUM		8

#define UI_SEQ_GIVE_ITEM		1

#define STARTING_TIME		3
#define ENDING_TIME			25

#define WAIT_PLAYERS_TIME	45.0
#define UPDATE_POS_TIME		1.0

#define MAX_POS_LIST_ROWS	8

#define SELECT_CHAR_CAM_DISTANCE	150.0
#define SELECT_CHAR_CAM_HEIGHT		30.0
#define SELECT_CHAR_ASPEED			60.0
#define SELECT_CHAR_COLOR_STEP		5
#define SELECT_CHAR_COLOR_BIG_STEP	15

#define CAR_SIZE				Float:{ -16.0, -16.0, 0.0 }, Float:{ 16.0, 16.0, 32.0 }

#define MAX_FORCE				800.0
#define ACCELERATION			1800.0
#define DRAG					0.3
#define MAX_GRIP				0.4
#define GRAVITY					2000.0

#define POS_PEN_FORCE				15.0
#define MAX_POS_PEN					5

#define TURN_FORCE					1.0
#define TURN_FORCE_BREAK			4.0
#define TURN_MAX_ANGLE				0.2
#define TURN_MAX_ANGLE_BREAK		0.5

#define MIN_VELOCITY_SKIDING_SOUND	300.0

#define TRICK_FORCE				800.0
#define TRICK_MAX_SPEED			500.0

#define JUMP_FORCE				3.0
#define JUMP_VELOCITY			330.0

#define CAMERA_DISTANCE 		120.0
#define CAMERA_MAX_DISTANCE 	280.0
#define CAMERA_HEIGHT 			100.0
#define CAMERA_DAMPING 			0.025
#define CAMERA_ANGULAR_HEIGHT	40.0

#define SPECTATOR_MAXSPEED		800.0

#define ITEMBOX_RESPAWN_TIME	3.0
#define ITEMBOX_SIZES			Float:{ -15.0, -15.0, 0.0 }, Float:{ 15.0, 15.0, 30.0 }

#define SNOWBALL_AMMO			3
#define SNOWBALL_POS_MIN		2
#define SNOWBALL_POS_MAX		0
#define SNOWBALL_SIZES			Float:{ -4.0, -4.0, -4.0 }, Float:{ 4.0, 4.0, 4.0 }
#define SNOWBALL_SPEED			5000.0
#define SNOWBALL_LIFE			2.0
#define CHILL_MAX_FORCE			125.0
#define CHILL_TIME				0.5

#define BOOSTER_AMMO			1
#define BOOSTER_POS_MIN			2
#define BOOSTER_POS_MAX			0
#define BOOSTER_FORCE			3000.0

#define BLOWFISH_AMMO			1
#define BLOWFISH_POS_MIN		0
#define BLOWFISH_POS_MAX		0
#define BLOWFISH_SIZES			Float:{ -20.0, -20.0, 0.0 }, Float:{ 20.0, 20.0, 40.0 }
#define BLOWFISH_LIFE			5.0
#define BLOWFISH_ACCELERATION	0.95
#define BLOWFISH_UNCONTOL_TIME	0.6

#define GLOVE_AMMO				1
#define GLOVE_POS_MIN			0
#define GLOVE_POS_MAX			5
#define GLOVE_LIFE				7.0

#define TORNADO_AMMO			1
#define TORNADO_POS_MIN			5
#define TORNADO_POS_MAX			0
#define TORNADO_SIZES			Float:{ -16.0, -16.0, 0.0 }, Float:{ 16.0, 16.0, 32.0 }
#define TORNADO_SPEED			1350.0
#define TORNADO_LIFE			5.0
#define TORNADO_THINK_DELAY		0.1

#define DIZZY_LIFE				5.0

#define UFO_AMMO				1
#define UFO_POS_MIN				4
#define UFO_POS_MAX				0
#define UFO_SIZES				Float:{ -37.5, -37.5, 0.0 }, Float:{ 37.5, 37.5, 150.0 }
#define UFO_LIFE				16.0
#define UFO_MODE_TIME			1.0
#define UFO_UNCONTOL_TIME		0.6
#define UFO_DEFAULT_NUM			3

#define GRASS_MAX_FORCE			400.0
#define GRASS_TIME				0.1

#define RESET_HOLD_TIME			1.0

#define SKIDING_SOUND_DELAY		0.65

#define BTN_FORWARD				IN_FORWARD
#define BTN_BACK				IN_BACK
#define BTN_LEFT				(IN_LEFT | IN_MOVELEFT)
#define BTN_RIGHT				(IN_RIGHT | IN_MOVERIGHT)
#define BTN_BREAK				IN_JUMP
#define BTN_USE					IN_USE
#define BTN_JUMP				IN_DUCK
#define BTN_BACKCAMERA			IN_ATTACK2
#define BTN_RESET				IN_RELOAD

new const CLASSNAME_CAMERA[] =		"kr_camera"
new const CLASSNAME_CAR[] =			"kr_car"
new const CLASSNAME_UI[] =			"kr_ui"
new const CLASSNAME_ITEMBOX[] =		"kr_itembox"
new const CLASSNAME_SNOWBALL[] =	"kr_snowball"
new const CLASSNAME_BLOWFISH[] =	"kr_blowfish"
new const CLASSNAME_TORNADO[] =		"kr_tornado"
new const CLASSNAME_UFO[] =			"kr_ufo"
new const CLASSNAME_UFOSPAWN[] =	"kr_ufospawn"

#define TASK_STARTING			1000
#define TASK_ENDING				1010
#define TASK_UPDATEPOS			1020
#define TASK_WAITPLAYERS		1030

#define HUD_CHAN_POS			1

#define var_cpnum				var_iuser3
#define var_ui					var_iuser2

#define vat_missile_mode		var_iuser2

#define var_lifetime			var_fuser2
#define var_targetcar			var_iuser3

#define var_ufomark				var_iuser2
#define var_ufospawn			var_iuser2

new const SZ_INFO_TARGET[] = 	"info_target"

enum KartItemType
{
	KIT_NULL = -1,
	KIT_SNOWBALL,
	KIT_BOOSTER,
	KIT_BLOWFISH,
	KIT_GLOVE,
	KIT_TORNADO,
	KIT_UFO,
	KIT_END
}

enum _:DataKartItem
{
	KITEM_AMMO,
	KITEM_POS_MIN,
	KITEM_POS_MAX
}

enum _:DataCPEnts
{
	CPENT_ID,
	CPENT_CP,
	CPENT_RESET,
	CPENT_UFO
}

enum _:DataCPState
{
	CPS_ID,
	Float:CPS_DIST,
	CPS_PASSED
}

enum _:ForwardIndex
{
	FWD_ID_CREATE_CAR,
	FWD_ID_SET_GAME_STATE,
	FWD_ID_PLAYER_GAME_STATE_SET
}

new g_iKartPackModelIndices[sizeof MODEL_KART_PACKS]

new GameState:g_gsGameState
new bool:g_bReverseMap

new Float:g_vPrepareOrigin[3]

new PlayerGameState:g_pgsPlayerGameState[MAX_PLAYERS + 1]
new g_iCarsEnt[MAX_PLAYERS + 1]
new g_iCamerasEnt[MAX_PLAYERS + 1]
new g_iUIEnt[MAX_PLAYERS + 1]
new g_fCarGloveEnt[MAX_PLAYERS + 1]
new g_fCarDizzyEnt[MAX_PLAYERS + 1]
new g_fCarTornadoWarnEnt[MAX_PLAYERS + 1]
new g_iButtons[MAX_PLAYERS + 1]
new g_iSpectatorTarget[MAX_PLAYERS + 1]
new bool:g_bBackwardCamMode[MAX_PLAYERS + 1]
new bool:g_bBackwardCamFixed[MAX_PLAYERS + 1]
new g_iSmoothDizzy[MAX_PLAYERS + 1]
new Float:g_fLastResetPressed[MAX_PLAYERS + 1]

new Float:g_fCarLastThink[MAX_PLAYERS + 1]
new Float:g_vCarVelocity[MAX_PLAYERS + 1][3]
new Float:g_fCarEngineForce[MAX_PLAYERS + 1]
new Float:g_fCarTurnAngle[MAX_PLAYERS + 1]
new Float:g_fCarJumpForce[MAX_PLAYERS + 1]
new Float:g_fCarGear[MAX_PLAYERS + 1]
new Float:g_fCarChillTime[MAX_PLAYERS + 1]
new Float:g_fCarUnControlTime[MAX_PLAYERS + 1]
new Float:g_fCarUnControlRotForce[MAX_PLAYERS + 1]
new Float:g_fCarRecAngle[MAX_PLAYERS + 1]
new Float:g_fCarGloveTime[MAX_PLAYERS + 1]
new Float:g_fCarDizzyTime[MAX_PLAYERS + 1]
new Float:g_fCarGrassTime[MAX_PLAYERS + 1]

new g_iSkidingSound[MAX_PLAYERS + 1]
new Float:g_fSkidingSoundTime[MAX_PLAYERS + 1]

new g_kitemProps[_:KIT_END][DataKartItem]
new KartItemType:g_kitPlayerItem[MAX_PLAYERS + 1]
new g_iPlayerItemAmmo[MAX_PLAYERS + 1]

new Float:g_vSpawnOrigin[MAX_PLAYERS + 1][3]
new Float:g_vSpawnAngles[MAX_PLAYERS + 1][3]
new g_iPlayerPrevCPId[MAX_PLAYERS + 1]
new g_iPlayerNextCP[MAX_PLAYERS + 1]
new g_iPlayerPassedCP[MAX_PLAYERS + 1]
new g_iPlayerCurrLoop[MAX_PLAYERS + 1]
new g_iPlayerCurrSpawn[MAX_PLAYERS + 1]
new g_iPlayerCurrPos[MAX_PLAYERS + 1]

new Array:g_aCPEnts

new Array:g_aPlayerCPState
new g_szPosList[512]
new g_iPosListStart
new g_iFinPlayersNum
new Float:g_fStartTime

new g_iFinishCP

new g_pCvarLapsNum
new g_pCvarReverseAvailable

new g_msgHideWeapon
new g_msgScoreInfo
new g_msgDeathMsg
new g_iOriginalSysTicrate
new g_iCharMenu
new g_iSpectatorAcceptMenu

new g_sprSnowballGib

new g_fwForwards[ForwardIndex]
new g_iDummy


public plugin_natives()
{
	register_native("kart_car_get_char", "_kart_car_get_char")
	register_native("kart_car_get_entity", "_kart_car_get_entity")
	register_native("kart_car_set_char", "_kart_car_set_char")
	register_native("kart_game_state_get", "_kart_game_state_get")
	register_native("kart_player_game_state_get", "_kart_player_game_state_get")
}

public plugin_precache()
{
	for (new i; i < sizeof MODEL_KART_PACKS; i++)
		g_iKartPackModelIndices[i] = precache_model(MODEL_KART_PACKS[i])

	precache_model(MODEL_CAMERA)
	precache_model(MODEL_ITEMBOX)
	precache_model(MODEL_UI)

	precache_model(MODEL_SNOWBALL)
	g_sprSnowballGib = precache_model(MODEL_SNOWBALL_GIB)

	precache_model(MODEL_BLOWFISH)

	precache_model(MODEL_GLOVE)

	precache_model(MODEL_TORNADO)
	precache_model(MODEL_DIZZY_SPRITE)
	precache_model(MODEL_TORNADO_WARN)

	precache_model(MODEL_UFO)

	precache_sound(SOUND_STARTING)
	precache_sound(SOUND_FINAL_LAP)

	for (new i; i < sizeof SOUNDS_FINISH; i++)
		precache_sound(SOUNDS_FINISH[i])

	for (new i; i < sizeof SOUNDS_SKIDING; i++)
		precache_sound(SOUNDS_SKIDING[i])

	precache_sound(SOUND_ENGINE)
	precache_sound(SOUND_JUMP)
	precache_sound(SOUND_LAND)
	precache_sound(SOUND_ITEMBOX)
	precache_sound(SOUND_HORN)

	precache_sound(SOUND_COMMON_HIT)

	precache_sound(SOUND_ICICLE_LAUNCH)
	precache_sound(SOUND_SNOWBALL_HIT)

	precache_sound(SOUND_BOOSTER)

	precache_sound(SOUND_GLOVE_LAUNCH)
	precache_sound(SOUND_CATCH)

	precache_sound(SOUND_BLOWFISH_LAUNCH)
	precache_sound(SOUND_UFO_LAUNCH)

	precache_sound(SOUND_TORNADO_HIT)
	precache_sound(SOUND_TORNADO_LAUNCH)

	precache_sound(SOUND_ALERT)

	precache_sound(SOUND_SYS_CHANGE)
	precache_sound(SOUND_SYS_SELECT)

	precache_generic(fmt("gfx/env/%sbk.tga", SKYNAME))
	precache_generic(fmt("gfx/env/%sdn.tga", SKYNAME))
	precache_generic(fmt("gfx/env/%sft.tga", SKYNAME))
	precache_generic(fmt("gfx/env/%slf.tga", SKYNAME))
	precache_generic(fmt("gfx/env/%srt.tga", SKYNAME))
	precache_generic(fmt("gfx/env/%sup.tga", SKYNAME))

	g_fwForwards[FWD_ID_CREATE_CAR] = CreateMultiForward("kart_on_car_create", ET_CONTINUE, FP_CELL, FP_CELL)
	g_fwForwards[FWD_ID_SET_GAME_STATE] = CreateMultiForward("kart_on_game_state_set", ET_CONTINUE, FP_CELL)
	g_fwForwards[FWD_ID_PLAYER_GAME_STATE_SET] = CreateMultiForward("kart_on_player_game_state_set", ET_CONTINUE, FP_CELL, FP_CELL)
}

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)

	g_msgHideWeapon = get_user_msgid("HideWeapon")
	g_msgScoreInfo = get_user_msgid("ScoreInfo")
	g_msgDeathMsg = get_user_msgid("DeathMsg")

	create_char_menu()
	create_spectator_accept_menu()

	new szTargetName[16]

	g_aCPEnts = ArrayCreate(DataCPEnts)

	new iCPEnt = NULLENT, iCPId, eCPEnts[DataCPEnts]
	new Float:vCPOrigin[3], Float:vCPMins[3], Float:vCPMaxs[3]
	while ((iCPEnt = rg_find_ent_by_class(iCPEnt, "trigger_multiple", true)))
	{
		get_entvar(iCPEnt, var_targetname, szTargetName, charsmax(szTargetName))
		if (equal(szTargetName, "checkpoint", 10))
		{
			iCPId = str_to_num(szTargetName[10])

			set_entvar(iCPEnt, var_impulse, IMPULSE_CHECKPOINT)
			set_entvar(iCPEnt, var_cpnum, iCPId)

			get_entvar(iCPEnt, var_mins, vCPMins)
			get_entvar(iCPEnt, var_maxs, vCPMaxs)

			vCPOrigin[0] = (vCPMins[0] + vCPMaxs[0]) / 2.0
			vCPOrigin[1] = (vCPMins[1] + vCPMaxs[1]) / 2.0
			vCPOrigin[2] = (vCPMins[2] + vCPMaxs[2]) / 2.0

			set_entvar(iCPEnt, var_startpos, vCPOrigin)

			eCPEnts[CPENT_ID] = iCPId
			eCPEnts[CPENT_CP] = iCPEnt
			eCPEnts[CPENT_RESET] = engfunc(EngFunc_FindEntityByString, -1, "targetname", fmt("reset%i", iCPId))
			eCPEnts[CPENT_UFO] = engfunc(EngFunc_FindEntityByString, -1, "targetname", fmt("ufo%i", iCPId))
			ArrayPushArray(g_aCPEnts, eCPEnts)
		}
		else if (equal(szTargetName, "reset"))
		{
			set_entvar(iCPEnt, var_impulse, IMPULSE_RESETZONE)
		}
	}

	apply_checkpoints(false)

	new iSpawnEnt = engfunc(EngFunc_FindEntityByString, -1, "targetname", "car_start03")
	if (iSpawnEnt)
	{
		get_entvar(iSpawnEnt, var_origin, g_vPrepareOrigin)
		g_vPrepareOrigin[2] += 60.0
	}

	new iGrassTriggerEnt
	while ((iGrassTriggerEnt = engfunc(EngFunc_FindEntityByString, iGrassTriggerEnt, "targetname", "kart_grass")))
		set_entvar(iGrassTriggerEnt, var_impulse, IMPULSE_GRASS)

	create_itemboxes()
	set_items_props()

	set_game_state(GS_PREPARING)

 	// register_clcmd("start", "start_game")

	register_clcmd("chooseteam", "cmd_chooseteam")
	register_clcmd("jointeam", "blocked")
	register_clcmd("drop", "cmd_drop")

	register_clcmd("radio1", "blocked")
	register_clcmd("radio2", "blocked")
	register_clcmd("radio3", "blocked")

	register_impulse(100, "fwd_PlayerFlashlight")

	RegisterHookChain(RG_CBasePlayer_Spawn, "fwd_PlayerSpawn_Post", true)
	RegisterHookChain(RG_CBasePlayer_PreThink, "fwd_PlayerPreThink_Pre")
	RegisterHam(Ham_Touch, "trigger_multiple", "fwd_TouchMultiple_Pre")
	RegisterHookChain(RH_SV_StartSound, "fwd_StartSound")

	register_forward(FM_ClientKill, "fwd_ClientKill")

	register_event("ResetHUD", "fwd_ResetHUD", "b")
	register_message(g_msgHideWeapon, "fwd_HideWeapon")
	register_message(get_user_msgid("StatusText"), "blocked")

	g_aPlayerCPState = ArrayCreate(DataCPState)

	g_iOriginalSysTicrate = get_cvar_num("sys_ticrate")
	set_cvar_num("sys_ticrate", 100)

	set_cvar_string("sv_skyname", SKYNAME)

	set_cvar_float("mp_roundtime", 0.0)
	set_cvar_num("mp_round_infinite", 1)
	set_cvar_num("mp_forcerespawn", 1)
	set_cvar_num("mp_auto_join_team", 1)
	set_cvar_num("mp_autoteambalance", 0)
	set_cvar_num("sv_maxvelocity", 5000)
	set_cvar_float("sv_maxspeed", SPECTATOR_MAXSPEED)
	set_cvar_string("humans_join_team", "CT")

	bind_pcvar_num(register_cvar("kart_laps_num", "3"), g_pCvarLapsNum)
	bind_pcvar_num(register_cvar("kart_reverse_available", "0"), g_pCvarReverseAvailable)

	register_dictionary("kart_racing.txt")
	register_dictionary("common.txt")
}

public plugin_end()
{
	set_cvar_num("sys_ticrate", g_iOriginalSysTicrate)
}

public client_putinserver(iPlayer)
{
	clear_player_data(iPlayer)
}

public client_disconnected(iPlayer)
{
	clear_player_data(iPlayer)
	set_player_game_state(iPlayer, PGS_DISCONNECTED)
	check_stop_game()
}

clear_player_data(iPlayer)
{
	new iCarEnt = g_iCarsEnt[iPlayer]
	new iCameraEnt = g_iCamerasEnt[iPlayer]
	new iUIEnt = g_iUIEnt[iPlayer]

	if (iCarEnt)
	{
		engfunc(EngFunc_RemoveEntity, iCarEnt)
		g_iCarsEnt[iPlayer] = 0
	}

	if (iCameraEnt)
	{
		engfunc(EngFunc_RemoveEntity, iCameraEnt)
		g_iCamerasEnt[iPlayer] = 0
	}

	if (iUIEnt)
	{
		engfunc(EngFunc_RemoveEntity, iUIEnt)
		g_iUIEnt[iPlayer] = 0
	}

	g_iPlayerCurrSpawn[iPlayer] = 0
	g_iPlayerCurrPos[iPlayer] = 0
	g_iSmoothDizzy[iPlayer] = 0
	g_iSpectatorTarget[iPlayer] = 0

	reset_player_item(iPlayer)
	remove_glove(iPlayer)
	remove_dizzy(iPlayer)
	remove_tornado_warn(iPlayer)
}

public cmd_chooseteam(iPlayer)
{
	if (!is_user_connected(iPlayer))
		return PLUGIN_HANDLED

	if (g_pgsPlayerGameState[iPlayer] == PGS_PREPARING)
	{
		new iMenu = get_player_menu(iPlayer)
		if (iMenu > -1 && iMenu == g_iCharMenu)
			show_menu(iPlayer, 0, "^n", 1)
		else
			show_char_menu(iPlayer)

		return PLUGIN_HANDLED
	}

	if (g_pgsPlayerGameState[iPlayer] == PGS_INGAME)
	{
		if (task_exists(TASK_ENDING))
		{
			prepare_player(iPlayer)
			return PLUGIN_HANDLED
		}

		new iMenu = get_player_menu(iPlayer)
		if (iMenu > -1 && iMenu == g_iSpectatorAcceptMenu)
			show_menu(iPlayer, 0, "^n", 1)
		else
			show_spectator_accept_menu(iPlayer)

		return PLUGIN_HANDLED
	}

	if (is_user_alive(iPlayer))
		prepare_player(iPlayer)
	else
		rg_round_respawn(iPlayer)

	return PLUGIN_HANDLED
}

public cmd_drop(iPlayer)
{
	if (!is_user_connected(iPlayer))
		return PLUGIN_HANDLED

	if (g_pgsPlayerGameState[iPlayer] != PGS_INGAME)
		return PLUGIN_HANDLED

	g_bBackwardCamMode[iPlayer] = !g_bBackwardCamMode[iPlayer]
	g_bBackwardCamFixed[iPlayer] = true

	return PLUGIN_HANDLED
}

public fwd_PlayerFlashlight(iPlayer)
{
	if (g_gsGameState == GS_PLAYING && g_pgsPlayerGameState[iPlayer] == PGS_INGAME)
	{
		if (g_iCarsEnt[iPlayer])
			emit_sound(g_iCarsEnt[iPlayer], CHAN_ITEM, SOUND_HORN, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	}
	return PLUGIN_HANDLED
}

public start_game()
{
	for (new iPlayer = 1; iPlayer <= MAX_PLAYERS; iPlayer++)
		start_player(iPlayer)

	set_game_state(GS_STARTING)
	new iParams[1]
	iParams[0] = STARTING_TIME + 1
	remove_task(TASK_STARTING)
	set_task(1.0, "task_starting", TASK_STARTING, iParams, 1)

	g_szPosList[0] = 0
	g_iPosListStart = 0
	g_iFinPlayersNum = 0

	new iBlowFishEnt
	while ((iBlowFishEnt = rg_find_ent_by_class(iBlowFishEnt, CLASSNAME_BLOWFISH)))
		set_entvar(iBlowFishEnt, var_flags, FL_KILLME)

	new iUFOEnt
	while ((iUFOEnt = rg_find_ent_by_class(iUFOEnt, CLASSNAME_UFO)))
		set_entvar(iUFOEnt, var_flags, FL_KILLME)

	new iUFOSpawnEnt
	while ((iUFOSpawnEnt = rg_find_ent_by_class(iUFOSpawnEnt, CLASSNAME_UFOSPAWN)))
		set_entvar(iUFOSpawnEnt, var_flags, FL_KILLME)
}

set_game_state(GameState:gameState)
{
	ExecuteForward(g_fwForwards[FWD_ID_SET_GAME_STATE], g_iDummy, gameState)

	remove_task(TASK_UPDATEPOS)
	remove_task(TASK_WAITPLAYERS)
	g_gsGameState = gameState

	switch (gameState)
	{
		case GS_PREPARING: set_task(WAIT_PLAYERS_TIME, "check_ready_players", TASK_WAITPLAYERS, .flags="b")
		case GS_PLAYING: set_task(UPDATE_POS_TIME, "update_pos_list", TASK_UPDATEPOS, .flags="b")
	}
}

set_player_game_state(iPlayer, PlayerGameState:playerGameState)
{
	ExecuteForward(g_fwForwards[FWD_ID_PLAYER_GAME_STATE_SET], g_iDummy, iPlayer, playerGameState)

	g_pgsPlayerGameState[iPlayer] = playerGameState
}

apply_checkpoints(bool:bReverse)
{
	g_iFinishCP = -1

	new iCheckPointsNum = ArraySize(g_aCPEnts)
	if (!iCheckPointsNum)
		return

	new eCPEnts[DataCPEnts]

	if (bReverse)
	{
		ArraySortEx(g_aCPEnts, "sort_checkpoints_reverse")
		ArrayGetArray(g_aCPEnts, iCheckPointsNum - 1, eCPEnts)
		ArrayDeleteItem(g_aCPEnts, iCheckPointsNum - 1)
		ArrayInsertArrayBefore(g_aCPEnts, 0, eCPEnts)
	}
	else
	{
		ArraySortEx(g_aCPEnts, "sort_checkpoints")
	}

	ArrayGetArray(g_aCPEnts, 0, eCPEnts)
	g_iFinishCP = eCPEnts[CPENT_CP]

	if (g_bReverseMap != bReverse)
	{
		new Float:vFinishOrigin[3]
		get_entvar(g_iFinishCP, var_startpos, vFinishOrigin)

		for (new i = 1, iSpawnEnt; i <= MAX_PLAYERS; i++)
		{
			iSpawnEnt = engfunc(EngFunc_FindEntityByString, -1, "targetname", fmt("car_start%02d", i))
			if (iSpawnEnt > 0)
				reverse_ent(iSpawnEnt, vFinishOrigin)
		}

		for (new i, iResetEnt, iUFOMarkEnt, Float:vPivot[3]; i < iCheckPointsNum; i++)
		{
			ArrayGetArray(g_aCPEnts, i, eCPEnts)

			iResetEnt = eCPEnts[CPENT_RESET]
			if (iResetEnt > 0)
			{
				get_entvar(eCPEnts[CPENT_CP], var_startpos, vPivot)
				reverse_ent(iResetEnt, vPivot)
			}

			iUFOMarkEnt = eCPEnts[CPENT_UFO]
			if (iUFOMarkEnt > 0)
			{
				if (i == 0)
					get_entvar(eCPEnts[CPENT_CP], var_startpos, vPivot)
				else
					get_entvar(iUFOMarkEnt, var_origin, vPivot)
				reverse_ent(iUFOMarkEnt, vPivot)
			}
		}
	}

	g_bReverseMap = bReverse
}

public task_starting(iParams[], iTaskId)
{
	new iSeconds = iParams[0] - 1

	if (iSeconds <= 0)
	{
		client_print(0, print_center, "GO")
		set_game_state(GS_PLAYING)
		g_fStartTime = get_gametime()

		for (new iPlayer = 1; iPlayer <= MAX_PLAYERS; iPlayer++)
		{
			if (g_pgsPlayerGameState[iPlayer] == PGS_INGAME)
			{
				g_iPlayerPrevCPId[iPlayer] = -1
				g_iPlayerNextCP[iPlayer] = g_iFinishCP
				g_iPlayerCurrLoop[iPlayer] = -1
				g_iPlayerPassedCP[iPlayer] = 0
				rh_emit_sound2(g_iCarsEnt[iPlayer], iPlayer, CHAN_VOICE, SOUND_ENGINE, .vol=0.65, .pitch=80)

				if (g_iUIEnt[iPlayer])
					set_entvar(g_iUIEnt[iPlayer], var_effects, (1 << 12))
			}
		}

		update_pos_list()
		return
	}

	if (iSeconds == 3)
		client_cmd(0, "spk ^"%s^"", SOUND_STARTING)

	client_print(0, print_center, "%i", iSeconds)

	new iParams[1]
	iParams[0] = iSeconds
	remove_task(TASK_STARTING)
	set_task(1.0, "task_starting", TASK_STARTING, iParams, 1)
}

public task_ending(iParams[], iTaskId)
{
	new iSeconds = iParams[0] - 1

	if (iSeconds <= 0)
	{
		if (g_pCvarReverseAvailable)
			apply_checkpoints(!g_bReverseMap)

		new iReadyPlayersNum
		for (new iPlayer = 1; iPlayer <= MAX_PLAYERS; iPlayer++)
		{
			if (g_pgsPlayerGameState[iPlayer] == PGS_INGAME
				|| g_pgsPlayerGameState[iPlayer] == PGS_READY)
			{
				ready_player(iPlayer)
				iReadyPlayersNum++
			}
		}

		if (iReadyPlayersNum > 1)
			start_game()
		else
			set_game_state(GS_PREPARING)

		return
	}

	client_print(0, print_center, "%L", LANG_PLAYER, "KART_ENDING", iSeconds)

	new iParams[1]
	iParams[0] = iSeconds
	remove_task(TASK_ENDING)
	set_task(1.0, "task_ending", TASK_ENDING, iParams, 1)
}

public sort_checkpoints(Array:a, v1[], v2[])
{
	if (v1[CPENT_ID] > v2[CPENT_ID])
		return 1
	if (v1[CPENT_ID] < v2[CPENT_ID])
		return -1
	return 0
}

public sort_checkpoints_reverse(Array:a, v1[], v2[])
{
	if (v1[CPENT_ID] > v2[CPENT_ID])
		return -1
	if (v1[CPENT_ID] < v2[CPENT_ID])
		return 1
	return 0
}

check_stop_game()
{
	if (g_gsGameState != GS_PREPARING)
	{
		new iReadyPlayersNum
		for (new iPlayer = 1; iPlayer <= MAX_PLAYERS; iPlayer++)
			if (g_pgsPlayerGameState[iPlayer] == PGS_INGAME)
				iReadyPlayersNum++

		if (!iReadyPlayersNum)
			set_game_state(GS_PREPARING)
	}
}

prepare_player(iPlayer)
{
	clear_player_data(iPlayer)

	set_entvar(iPlayer, var_effects, EF_NODRAW)
	fm_strip_user_weapons(iPlayer)
	fm_set_user_godmode(iPlayer, 1)
	set_entvar(iPlayer, var_movetype, MOVETYPE_NOCLIP)

	engfunc(EngFunc_SetClientMaxspeed, iPlayer, 0.000001)
	set_entvar(iPlayer, var_maxspeed, 0.000001)

	new Float:vOrigin[3], Float:vAngles[3]
	xs_vec_copy(g_vPrepareOrigin, vOrigin)

	new iCarEnt = create_car(iPlayer)
	g_iCarsEnt[iPlayer] = iCarEnt

	new iCameraEnt = create_camera(iPlayer)
	g_iCamerasEnt[iPlayer] = iCameraEnt

	if (!iCarEnt || !iCameraEnt)
	{
		move_player_spectator(iPlayer)
		return
	}

	g_iUIEnt[iPlayer] = create_ui(iPlayer, iCameraEnt)

	set_player_game_state(iPlayer, PGS_PREPARING)
	g_iPlayerCurrSpawn[iPlayer] = 0
	g_iPlayerCurrPos[iPlayer] = 0

	set_car_preparing(iCarEnt)
	set_entvar(iCarEnt, var_origin, vOrigin)
	set_entvar(iCarEnt, var_angles, vAngles)

	vOrigin[0] -= SELECT_CHAR_CAM_DISTANCE
	vOrigin[2] += SELECT_CHAR_CAM_HEIGHT

	set_entvar(iCameraEnt, var_origin, vOrigin)
	set_entvar(iCameraEnt, var_angles, vAngles)

	set_entvar(iPlayer, var_origin, vOrigin)
	set_entvar(iPlayer, var_angles, vAngles)
	set_entvar(iPlayer, var_v_angle, vAngles)
	set_entvar(iPlayer, var_fixangle, 1)

	show_char_menu(iPlayer)
}

ready_player(iPlayer)
{
	new iFilledSpawn[MAX_PLAYERS + 1]
	for (new i = 1; i <= MAX_PLAYERS; i++)
	{
		if (iPlayer != i && g_iPlayerCurrSpawn[i])
			iFilledSpawn[g_iPlayerCurrSpawn[i]] = 1
	}
	for (new i = 1; i <= MAX_PLAYERS; i++)
	{
		if (!iFilledSpawn[i])
		{
			g_iPlayerCurrSpawn[iPlayer] = i
			break
		}
	}

	new iSpawnEnt = engfunc(EngFunc_FindEntityByString, -1, "targetname",
		fmt("car_start%02d", g_iPlayerCurrSpawn[iPlayer]))

	if (!iSpawnEnt)
		return

	set_player_game_state(iPlayer, PGS_READY)
	g_bBackwardCamMode[iPlayer] = false
	g_bBackwardCamFixed[iPlayer] = false

	new Float:vSpawnOrigin[3], Float:vSpawnAngles[3]
	get_entvar(iSpawnEnt, var_origin, vSpawnOrigin)
	get_entvar(iSpawnEnt, var_angles, vSpawnAngles)

	xs_vec_copy(vSpawnOrigin, g_vSpawnOrigin[iPlayer])
	xs_vec_copy(vSpawnAngles, g_vSpawnAngles[iPlayer])

	new iCarEnt = g_iCarsEnt[iPlayer]

	set_entvar(iCarEnt, var_origin, vSpawnOrigin)
	set_entvar(iCarEnt, var_angles, vSpawnAngles)
	set_car_ready(iCarEnt)
	reset_player_car_vars(iPlayer)
	reset_player_car_chill(iPlayer, iCarEnt)

	set_car_waiting(iCarEnt)

	new iUIEnt = g_iUIEnt[iPlayer]
	if (iUIEnt)
	{
		set_entvar(iUIEnt, var_effects, EF_NODRAW)
		set_entvar(iUIEnt, var_body, 0)
		set_entvar(iUIEnt, var_skin, 0)
	}

	if (task_exists(TASK_WAITPLAYERS))
	{
		new iReadyPlayersNum
		for (new iPlayer = 1; iPlayer <= MAX_PLAYERS; iPlayer++)
			if (g_pgsPlayerGameState[iPlayer] == PGS_INGAME)
				iReadyPlayersNum++

		if (iReadyPlayersNum == 1)
			change_task(TASK_WAITPLAYERS, WAIT_PLAYERS_TIME)
	}

	g_iPlayerPassedCP[iPlayer] = -1
}

start_player(iPlayer)
{
	if (g_pgsPlayerGameState[iPlayer] != PGS_READY)
		return

	set_player_game_state(iPlayer, PGS_INGAME)

	new iCarEnt = g_iCarsEnt[iPlayer]

	set_entvar(iCarEnt, var_origin, g_vSpawnOrigin[iPlayer])
	set_entvar(iCarEnt, var_angles, g_vSpawnAngles[iPlayer])
	set_car_ready(iCarEnt)

	reset_player_car_vars(iPlayer)
	reset_player_item(iPlayer)

	g_iPlayerCurrSpawn[iPlayer] = 0
	g_fLastResetPressed[iPlayer] = -1.0
	g_iPlayerCurrPos[iPlayer] = 0
}

create_char_menu()
{
	g_iCharMenu = menu_create("", "handler_char_menu")
	menu_additem(g_iCharMenu, "")
	menu_additem(g_iCharMenu, "")
	menu_additem(g_iCharMenu, "")
	menu_additem(g_iCharMenu, "")
	menu_additem(g_iCharMenu, "")
	menu_additem(g_iCharMenu, "")
	menu_additem(g_iCharMenu, "")
}

show_char_menu(iPlayer)
{
	static szBuffer[64]

	formatex(szBuffer, charsmax(szBuffer), "%L", iPlayer, "KART_CHAR_MENU_TITLE")
	menu_setprop(g_iCharMenu, MPROP_TITLE, szBuffer)

	formatex(szBuffer, charsmax(szBuffer), "%L", iPlayer, "KART_CHAR_MENU_NEXT")
	menu_item_setname(g_iCharMenu, 0, szBuffer)

	formatex(szBuffer, charsmax(szBuffer), "%L^n", iPlayer, "KART_CHAR_MENU_PREV")
	menu_item_setname(g_iCharMenu, 1, szBuffer)

	formatex(szBuffer, charsmax(szBuffer), "%L", iPlayer, "KART_CHAR_MENU_COLOR")
	menu_item_setname(g_iCharMenu, 2, szBuffer)

	formatex(szBuffer, charsmax(szBuffer), "%L", iPlayer, "KART_CHAR_MENU_COLOR2")
	menu_item_setname(g_iCharMenu, 3, szBuffer)

	formatex(szBuffer, charsmax(szBuffer), "%L^n", iPlayer, "KART_CHAR_MENU_COLOR3")
	menu_item_setname(g_iCharMenu, 4, szBuffer)

	formatex(szBuffer, charsmax(szBuffer), "%L", iPlayer, "KART_CHAR_MENU_RANDOM")
	menu_item_setname(g_iCharMenu, 5, szBuffer)

	formatex(szBuffer, charsmax(szBuffer), "%L", iPlayer, "KART_CHAR_MENU_START")
	menu_item_setname(g_iCharMenu, 6, szBuffer)

	formatex(szBuffer, charsmax(szBuffer), "%L", iPlayer, "EXIT")
	menu_setprop(g_iCharMenu, MPROP_EXITNAME, szBuffer)

	menu_display(iPlayer, g_iCharMenu)
}

public handler_char_menu(iPlayer, iMenu, iItem)
{
	if (iItem == MENU_EXIT)
	{
		if (is_user_connected(iPlayer))
			move_player_spectator(iPlayer)
		return PLUGIN_HANDLED
	}

	new iCarEnt = g_iCarsEnt[iPlayer]
	if (!iCarEnt)
		return PLUGIN_HANDLED

	switch (iItem)
	{
		case 0:
		{
			client_cmd(iPlayer, "spk ^"%s^"", SOUND_SYS_CHANGE)
			set_car_char(iCarEnt, (get_car_char(iCarEnt) + 1) % CHAR_NUM)
			show_char_menu(iPlayer)
		}
		case 1:
		{
			client_cmd(iPlayer, "spk ^"%s^"", SOUND_SYS_CHANGE)
			set_car_char(iCarEnt, (get_car_char(iCarEnt) - 1) % CHAR_NUM)
			show_char_menu(iPlayer)
		}
		case 2:
		{
			set_entvar(iCarEnt, var_colormap,
				(get_entvar(iCarEnt, var_colormap) + SELECT_CHAR_COLOR_BIG_STEP) % 256)
			show_char_menu(iPlayer)
		}
		case 3:
		{
			set_entvar(iCarEnt, var_colormap,
				(get_entvar(iCarEnt, var_colormap) + SELECT_CHAR_COLOR_STEP) % 256)
			show_char_menu(iPlayer)
		}
		case 4:
		{
			set_entvar(iCarEnt, var_colormap,
				(get_entvar(iCarEnt, var_colormap) - SELECT_CHAR_COLOR_STEP) % 256)
			show_char_menu(iPlayer)
		}
		case 5:
		{
			client_cmd(iPlayer, "spk ^"%s^"", SOUND_SYS_CHANGE)
			set_car_char(iCarEnt, random(CHAR_NUM))
			set_entvar(iCarEnt, var_colormap, SELECT_CHAR_COLOR_STEP * random(256 / SELECT_CHAR_COLOR_STEP))
			show_char_menu(iPlayer)
		}
		case 6:
		{
			client_cmd(iPlayer, "spk ^"%s^"", SOUND_SYS_SELECT)
			ready_player(iPlayer)
		}
	}

	return PLUGIN_HANDLED
}

create_spectator_accept_menu()
{
	g_iSpectatorAcceptMenu = menu_create("", "handler_spectator_accept_menu")
	menu_additem(g_iSpectatorAcceptMenu, "")
	menu_additem(g_iSpectatorAcceptMenu, "")
	menu_setprop(g_iSpectatorAcceptMenu, MPROP_EXIT, MEXIT_NEVER)
}

show_spectator_accept_menu(iPlayer)
{
	static szBuffer[64]

	formatex(szBuffer, charsmax(szBuffer), "%L", iPlayer, "KART_SA_MENU_TITLE")
	menu_setprop(g_iSpectatorAcceptMenu, MPROP_TITLE, szBuffer)

	formatex(szBuffer, charsmax(szBuffer), "%L", iPlayer, "YES")
	menu_item_setname(g_iSpectatorAcceptMenu, 0, szBuffer)

	formatex(szBuffer, charsmax(szBuffer), "%L", iPlayer, "NO")
	menu_item_setname(g_iSpectatorAcceptMenu, 1, szBuffer)

	menu_display(iPlayer, g_iSpectatorAcceptMenu)
}

public handler_spectator_accept_menu(iPlayer, iMenu, iItem)
{
	if (!iItem)
		move_player_spectator(iPlayer)

	return PLUGIN_HANDLED
}

public fwd_PlayerPreThink_Pre(iPlayer)
{
	static iButtons, PlayerGameState:pgsPlayerGameState
	iButtons = get_entvar(iPlayer, var_button)
	pgsPlayerGameState = g_pgsPlayerGameState[iPlayer]

	if (pgsPlayerGameState != PGS_INGAME)
	{
		g_iButtons[iPlayer] = iButtons
		if (pgsPlayerGameState == PGS_SPECTATOR)
		{
			show_hud_pos(iPlayer)
			show_hud_spectator(iPlayer)
			spectator_think(iPlayer)
		}
		return HC_CONTINUE
	}

	show_hud_pos(iPlayer)

	if (g_fCarDizzyEnt[iPlayer])
	{
		if (!(iButtons & BTN_LEFT) && (iButtons & BTN_RIGHT))
			iButtons = (iButtons & ~BTN_RIGHT) | BTN_LEFT
		else if ((iButtons & BTN_LEFT) && !(iButtons & BTN_RIGHT))
			iButtons = (iButtons & ~BTN_LEFT) | BTN_RIGHT
	}
	else if (g_iSmoothDizzy[iPlayer])
	{
		if (iButtons & g_iSmoothDizzy[iPlayer])
		{
			if (!(iButtons & BTN_LEFT) && (iButtons & BTN_RIGHT))
				iButtons = (iButtons & ~BTN_RIGHT) | BTN_LEFT
			else if ((iButtons & BTN_LEFT) && !(iButtons & BTN_RIGHT))
				iButtons = (iButtons & ~BTN_LEFT) | BTN_RIGHT
		}
		else
			g_iSmoothDizzy[iPlayer] = 0
	}

	g_iButtons[iPlayer] = iButtons

	if (iButtons & BTN_BACKCAMERA)
	{
		g_bBackwardCamFixed[iPlayer] = false
		g_bBackwardCamMode[iPlayer] = true
	}
	else if (!g_bBackwardCamFixed[iPlayer])
		g_bBackwardCamMode[iPlayer] = false

	return HC_CONTINUE
}

public fwd_CarThink(iCarEnt)
{
	static iPlayer
	iPlayer = get_entvar(iCarEnt, var_owner)
	if (!iPlayer)
		return

	static Float:fGameTime, Float:fDeltaTime
	fGameTime = get_gametime()
	fDeltaTime = fGameTime - g_fCarLastThink[iPlayer]
	g_fCarLastThink[iPlayer] = fGameTime

	if (g_gsGameState != GS_PLAYING)
	{
		if (g_iCamerasEnt[iPlayer])
			camera_think(g_iCamerasEnt[iPlayer], iCarEnt, iPlayer)
		set_entvar(iCarEnt, var_nextthink, fGameTime)
		try_skiding_sound(iPlayer, iCarEnt, 0)
		return
	}

	static Float:vOrigin[3], Float:vAngles[3], Float:vVelocity[3], Float:vAVelocity[3],
		Float:fMaxForce, Float:fEngineForce, Float:fTurnAngle, Float:fBrakeForce, Float:fJumpForce,
		Float:fMaxGrip, Float:fSpeed, Float:fAngle, Float:fDir,
		Float:fGrip, Float:fVAngle, Float:vAccel[3], Float:fTireGrip, iShouldJump,
		iButtons, iFlags, iOldButtons[MAX_PLAYERS + 1], iCarUnControling, iCarSkiding

	get_entvar(iCarEnt, var_origin, vOrigin)
	get_entvar(iCarEnt, var_angles, vAngles)
	get_entvar(iCarEnt, var_velocity, vVelocity)
	get_entvar(iCarEnt, var_avelocity, vAVelocity)

	// That stupid collision box gets stuck behind every little bump, so force it to keep moving
	vVelocity[0] = g_vCarVelocity[iPlayer][0] * 0.8 + vVelocity[0] * 0.2
	vVelocity[1] = g_vCarVelocity[iPlayer][1] * 0.8 + vVelocity[1] * 0.2

	iCarUnControling = g_fCarUnControlTime[iPlayer] >= fGameTime
	iButtons = iCarUnControling ? 0 : g_iButtons[iPlayer]
	iFlags = get_entvar(iCarEnt, var_flags)

	fEngineForce = g_fCarEngineForce[iPlayer]
	fTurnAngle = g_fCarTurnAngle[iPlayer]
	fBrakeForce = 0.0
	fJumpForce = g_fCarJumpForce[iPlayer]
	iCarSkiding = 0
	fMaxForce = MAX_FORCE - max(0, MAX_POS_PEN - (g_iPlayerCurrPos[iPlayer] - 1)) * POS_PEN_FORCE

	if (iButtons & BTN_FORWARD)
	{
		fEngineForce += ACCELERATION * fDeltaTime

		if (iButtons & BTN_BREAK)
		{
			fMaxGrip = 0.1
			fBrakeForce = 0.1

			if (floatabs(fTurnAngle) > TURN_MAX_ANGLE_BREAK - 0.1
				&& xs_vec_len(vVelocity) > MIN_VELOCITY_SKIDING_SOUND)
			{
				iCarSkiding = 1
			}
		}
		else
			fMaxGrip = MAX_GRIP

		if (fEngineForce > fMaxForce)
			fEngineForce = fMaxForce
	}
	else if (iButtons & BTN_BACK)
	{
		fEngineForce -= ACCELERATION * fDeltaTime
		if (fEngineForce < -fMaxForce)
			fEngineForce = -fMaxForce
		fMaxGrip = MAX_GRIP
	}
	else
	{
		fEngineForce = 0.0
		fMaxGrip = MAX_GRIP
	}

	if (iButtons & BTN_LEFT)
	{
		if ((iButtons & BTN_BREAK) && (iButtons & BTN_FORWARD))
		{
			fTurnAngle += TURN_FORCE_BREAK * fDeltaTime
			if (fTurnAngle > TURN_MAX_ANGLE_BREAK)
				fTurnAngle = TURN_MAX_ANGLE_BREAK
		}
		else
		{
			fTurnAngle += TURN_FORCE * fDeltaTime
			if (fTurnAngle > TURN_MAX_ANGLE)
				fTurnAngle = TURN_MAX_ANGLE
		}
	}
	else if (iButtons & BTN_RIGHT)
	{
		if ((iButtons & BTN_BREAK) && (iButtons & BTN_FORWARD))
		{
			fTurnAngle -= TURN_FORCE_BREAK * fDeltaTime
			if (fTurnAngle < -TURN_MAX_ANGLE_BREAK)
				fTurnAngle = -TURN_MAX_ANGLE_BREAK
		}
		else
		{
			fTurnAngle -= TURN_FORCE * fDeltaTime
			if (fTurnAngle < -TURN_MAX_ANGLE)
				fTurnAngle = -TURN_MAX_ANGLE
		}
	}
	else
	{
		if (floatabs(fTurnAngle) < 0.2)
			fTurnAngle = 0.0
		else if (fTurnAngle > 0.0)
			fTurnAngle -= 2.0 * fDeltaTime
		else if (fTurnAngle < 0.0)
			fTurnAngle += 2.0 * fDeltaTime
	}

	try_skiding_sound(iPlayer, iCarEnt, iCarSkiding)

	// TODO: clamp
	if (g_fCarChillTime[iPlayer] > fGameTime)
	{
		if (fEngineForce > CHILL_MAX_FORCE)
			fEngineForce = CHILL_MAX_FORCE
		else if (fEngineForce < -CHILL_MAX_FORCE)
			fEngineForce = -CHILL_MAX_FORCE
	}
	else
		reset_player_car_chill(iPlayer, iCarEnt)

	if (g_fCarGrassTime[iPlayer] > fGameTime)
	{
		if (fEngineForce > GRASS_MAX_FORCE)
			fEngineForce = GRASS_MAX_FORCE
		else if (fEngineForce < -GRASS_MAX_FORCE)
			fEngineForce = -GRASS_MAX_FORCE
	}

	fAngle = vAngles[1] / 180.0 * M_PI
	fVAngle = floatatan2(vVelocity[1], vVelocity[0], radian)
	fGrip = 0.0
	fDir = floatcos(fAngle - fVAngle) > 0.0 ? 1.0 : -1.0

	vAccel[0] = -DRAG * vVelocity[0]
	vAccel[1] = -DRAG * vVelocity[1]

	if (!iFlags)	// Flying
	{
		fSpeed = xs_vec_len_2d(vVelocity)

		// Set angle startpoint for stunts calculations
		if (fJumpForce > 0.0 && !(iButtons & BTN_JUMP))
		{
			set_entvar(iCarEnt, var_startpos, vAngles)
			fJumpForce = 0.0
		}

		set_entvar(iCarEnt, var_endpos, vAngles)

		if (iButtons & BTN_FORWARD)
			vAVelocity[0] += TRICK_FORCE * fDeltaTime
		else if (iButtons & BTN_BACK)
			vAVelocity[0] -= TRICK_FORCE * fDeltaTime
		else
		{
			if (floatabs(vAVelocity[0]) < TRICK_FORCE * 0.1)
				vAVelocity[0] = 0.0
			else if (vAVelocity[0] > 0.0)
				vAVelocity[0] -= TRICK_FORCE * fDeltaTime
			else if (vAVelocity[0] < 0.0)
				vAVelocity[0] += TRICK_FORCE * fDeltaTime
		}

		if (iButtons & BTN_LEFT)
			vAVelocity[1] += TRICK_FORCE * fDeltaTime * fDir
		else if (iButtons & BTN_RIGHT)
			vAVelocity[1] -= TRICK_FORCE * fDeltaTime * fDir
		else
		{
			if (floatabs(vAVelocity[1]) < TRICK_FORCE * 0.1)
				vAVelocity[1] = 0.0
			else if (vAVelocity[1] > 0.0)
				vAVelocity[1] -= TRICK_FORCE * fDeltaTime
			else if (vAVelocity[1] < 0.0)
				vAVelocity[1] += TRICK_FORCE * fDeltaTime
		}

		vAVelocity[0] = floatclamp(vAVelocity[0], -TRICK_MAX_SPEED, TRICK_MAX_SPEED)
		vAVelocity[1] = floatclamp(vAVelocity[1], -TRICK_MAX_SPEED, TRICK_MAX_SPEED)
	}
	else if ((iFlags & FL_INWATER) && (PointContents(vOrigin) == CONTENTS_SKY))
	{
		fSpeed = xs_vec_len_2d(vVelocity)

		vOrigin[0] -= vVelocity[0] * fDeltaTime
		vOrigin[1] -= vVelocity[1] * fDeltaTime
		vOrigin[2] -= vVelocity[2] * fDeltaTime
		set_entvar(iCarEnt, var_origin, vOrigin)

		vVelocity[0] *= -0.5
		vVelocity[1] *= -0.5
		vVelocity[2] *= -0.5
		set_entvar(iCarEnt, var_velocity, vVelocity)
	}
	else
	{
		fSpeed = xs_vec_len(vVelocity)

		// Upside down in the ground, so crashed
		if (floatcos(vAngles[0], degrees) < -0.1) // Very cheap for now, but it's acceptable
		{
			emit_sound(iCarEnt, CHAN_AUTO, SOUND_LAND, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			vAngles[0] = 0.0
		}

		// Just landed, check stunts
		if (fJumpForce < 0.0)
			fJumpForce = 0.0

		if (fSpeed > 0.1)
			fGrip = floatsin(fAngle - fVAngle)

		fTireGrip = floatclamp(fGrip, -fMaxGrip, fMaxGrip)

		// 3-speed gearbox
		if (fSpeed > fMaxForce * 1.1)
		{
			if (g_fCarGear[iPlayer] < 1.5)
				fEngineForce *= 0.5
			g_fCarGear[iPlayer] = 1.6
			fTireGrip *= 0.6
		}
		else if (fSpeed > fMaxForce * 0.7 && fSpeed < fMaxForce * 0.9)
		{
			if (g_fCarGear[iPlayer] < 1.2 || g_fCarGear[iPlayer] > 1.4)
				fEngineForce *= 0.5
			g_fCarGear[iPlayer] = 1.3
			fTireGrip *= 0.8
		}
		else if (fSpeed < fMaxForce * 0.5)
			g_fCarGear[iPlayer] = 1.0

		// Acceleration
		vAccel[0] += floatcos(fAngle) * fEngineForce * g_fCarGear[iPlayer]
		vAccel[1] += floatsin(fAngle) * fEngineForce * g_fCarGear[iPlayer]

		// Braking
		vAccel[0] -= floatcos(fAngle) * fBrakeForce * fSpeed * fDir
		vAccel[1] -= floatsin(fAngle) * fBrakeForce * fSpeed * fDir

		// Sideways friction (drifting)
		vAccel[0] -= floatcos(fAngle - M_PI * 0.5) * fTireGrip * fSpeed * 10.0	// Cheap but working tracktion
		vAccel[1] -= floatsin(fAngle - M_PI * 0.5) * fTireGrip * fSpeed * 10.0

		if (xs_vec_len_2d(vVelocity) > 0.05)
		{
			static Float:vDirAngle[3]
			vector_to_angle(vVelocity, vDirAngle)
			vAngles[0] = vDirAngle[0] * fDir
		}
		else
			vAngles[0] = 0.0

		vVelocity[0] += vAccel[0] * fDeltaTime //* floatcos(vAngles[1], degrees)
		vVelocity[1] += vAccel[1] * fDeltaTime //* floatcos(vAngles[1], degrees)

		// Rotational force doesn't excists, but i got it right here :)
		vAVelocity[0] = 0.0
		vAVelocity[1] = fSpeed * floatsin(fTurnAngle) * (1.0 - floatabs(fGrip)) * fDir
		vAVelocity[2] = 0.0

		iShouldJump = 0
		if (iButtons & BTN_JUMP)
		{
			fJumpForce += JUMP_FORCE * fDeltaTime
			if (fJumpForce > 1.0)
				fJumpForce = 1.0
		}
		else
		{
			if (fJumpForce > 0.3)
				iShouldJump = 1
			else
				fJumpForce = 0.0
		}

		if (iShouldJump)
		{
			vVelocity[2] = floatmax(0.0, vVelocity[2]) + fJumpForce * JUMP_VELOCITY
			emit_sound(iCarEnt, CHAN_AUTO, SOUND_JUMP, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			fJumpForce = 0.0
		}
		else
		{
			if (vAngles[0] <= 0.0 || vAngles[0] >= 180.0)
				vVelocity[2] -= GRAVITY * fDeltaTime // To stop him from riding up the wall, almost
			else
				vVelocity[2] -= GRAVITY * fDeltaTime * 3.0
		}

		set_entvar(iCarEnt, var_velocity, vVelocity)
	}

	// client_print(iPlayer, print_center, "%f", fSpeed)

	set_entvar(iCarEnt, var_framerate, fSpeed / 250.0)

	static Float:fBlend
	fBlend = ((pev(iCarEnt, pev_blending_0) % 256) - 127.5) / 127.5
	fBlend += (-floatclamp(fTurnAngle, -TURN_MAX_ANGLE, TURN_MAX_ANGLE) / TURN_MAX_ANGLE - fBlend) * 0.1
	set_pev(iCarEnt, pev_blending_0, floatround(((fBlend + 1.0) * 127.5)))

	if (iCarUnControling)
	{
		vAngles[0] = 0.0
		vAngles[1] += g_fCarUnControlRotForce[iPlayer] * fDeltaTime
		vAngles[2] = 0.0
	}
	else if (g_fCarUnControlTime[iPlayer] > 0.0)
	{
		g_fCarUnControlTime[iPlayer] = 0.0
		vAngles[1] = g_fCarRecAngle[iPlayer]
	}
	else
	{
		vAngles[0] += vAVelocity[0] * fDeltaTime
		vAngles[1] += vAVelocity[1] * fDeltaTime
		vAngles[2] += vAVelocity[2] * fDeltaTime
	}

	set_entvar(iCarEnt, var_angles, vAngles)
	set_entvar(iCarEnt, var_avelocity, vAVelocity)

	g_fCarEngineForce[iPlayer] = fEngineForce
	g_fCarTurnAngle[iPlayer] = fTurnAngle
	g_vCarVelocity[iPlayer][0] = vVelocity[0]
	g_vCarVelocity[iPlayer][1] = vVelocity[1]
	g_vCarVelocity[iPlayer][2] = vVelocity[2]
	g_fCarJumpForce[iPlayer] = fJumpForce

	static Float:eNextPitchTime[MAX_PLAYERS + 1], iPitch
	iPitch = 80 + floatround((floatabs(fEngineForce / MAX_FORCE) + fSpeed / 1000.0) * 50)
	if (iPitch > 255)
		iPitch = 255

	if ((eNextPitchTime[iPlayer] < fGameTime))
	{
		rh_emit_sound2(iCarEnt, iPlayer, CHAN_VOICE, SOUND_ENGINE, .flags=SND_CHANGE_PITCH, .pitch=iPitch)
		eNextPitchTime[iPlayer] = fGameTime + 0.1
	}

	set_entvar(iCarEnt, var_nextthink, fGameTime)
	set_entvar(iPlayer, var_origin, vOrigin)

	if (g_iCamerasEnt[iPlayer])
		camera_think(g_iCamerasEnt[iPlayer], iCarEnt, iPlayer)

	if ((iButtons & BTN_USE) && !(iOldButtons[iPlayer] & BTN_USE))
		use_player_item(iPlayer, iCarEnt)

	if (iButtons & BTN_RESET)
	{
		if (g_fLastResetPressed[iPlayer] < 0.0)
			g_fLastResetPressed[iPlayer] = fGameTime
		else if (g_fLastResetPressed[iPlayer] > 0.0 && fGameTime - g_fLastResetPressed[iPlayer] >= RESET_HOLD_TIME)
			reset_car(iCarEnt, iPlayer)
	}
	else
		g_fLastResetPressed[iPlayer] = -1.0

	if (g_fCarGloveEnt[iPlayer] && g_fCarGloveTime[iPlayer] < fGameTime)
		remove_glove(iPlayer)

	if (g_fCarDizzyEnt[iPlayer] && g_fCarDizzyTime[iPlayer] < fGameTime)
		remove_dizzy(iPlayer)

	iOldButtons[iPlayer] = iButtons
}

Float:math_clamp01(Float:fValue)
{
	if (fValue < 0.0)
		return 0.0
	if (fValue > 1.0)
 		return 1.0
	return fValue
}

math_lerp(Float:a[3], Float:b[3], Float:t, Float:vOut[3])
{
	t = math_clamp01(t)
	vOut[0] = a[0] + (b[0] - a[0]) * t
	vOut[1] = a[1] + (b[1] - a[1]) * t
	vOut[2] = a[2] + (b[2] - a[2]) * t
}

camera_think(iCameraEnt, iCarEnt, iPlayer)
{
	static Float:vTargetOrigin[3], Float:vCameraOrigin[3], Float:vResOrigin[3]
	static Float:vTargetAngles[3], Float:vCameraAngles[3], Float:vResAngles[3]
	static Float:vDir[3]

	get_entvar(iCameraEnt, var_origin, vCameraOrigin)
	get_entvar(iCameraEnt, var_angles, vCameraAngles)
	get_entvar(iCarEnt, var_origin, vTargetOrigin)

	if (g_fCarUnControlTime[iPlayer] < get_gametime())
		get_entvar(iCarEnt, var_angles, vTargetAngles)

	xs_vec_sub(vCameraOrigin, vTargetOrigin, vDir)
	if (xs_vec_len(vDir) > CAMERA_MAX_DISTANCE)
	{
		xs_vec_normalize(vDir, vDir)
		xs_vec_mul_scalar(vDir, CAMERA_MAX_DISTANCE, vDir)
		xs_vec_add(vTargetOrigin, vDir, vCameraOrigin)
	}

	angle_vector(vTargetAngles, ANGLEVECTOR_FORWARD, vDir)
	vDir[2] = 0.0
	xs_vec_normalize(vDir, vDir)
	xs_vec_mul_scalar(vDir, -CAMERA_DISTANCE, vDir)
	vDir[2] = CAMERA_HEIGHT

	if (!g_bBackwardCamMode[iPlayer])
	{
		xs_vec_add(vTargetOrigin, vDir, vResOrigin)

		engfunc(EngFunc_TraceLine, vTargetOrigin, vResOrigin, IGNORE_MONSTERS, iCarEnt, 0)
		static Float:fFraction, Float:vEndOrigin[3]
		get_tr2(0, TR_flFraction, fFraction)
		if (fFraction != 1.0)
		{
			get_tr2(0, TR_vecEndPos, vEndOrigin)
			vResOrigin[0] = vEndOrigin[0]
			vResOrigin[1] = vEndOrigin[1]
			vResOrigin[2] = vTargetOrigin[2] + vDir[2] * (2.0 - fFraction)
		}

		math_lerp(vCameraOrigin, vResOrigin, CAMERA_DAMPING, vResOrigin)
	}
	else
	{
		vDir[2] = -vDir[2]
		xs_vec_sub(vTargetOrigin, vDir, vResOrigin)
	}

	/*xs_vec_sub(vResOrigin, vTargetOrigin, vDir)
	if (xs_vec_len(vDir) > 280.0)
	{
		xs_vec_normalize(vDir, vDir)
		xs_vec_mul_scalar(vDir, 280.0, vDir)
		xs_vec_add(vTargetOrigin, vDir, vResOrigin)
	}*/

	vTargetOrigin[2] += CAMERA_ANGULAR_HEIGHT
	xs_vec_sub(vTargetOrigin, vCameraOrigin, vDir)
	vDir[2] = -vDir[2]
	xs_vec_normalize(vDir, vDir)
	vector_to_angle(vDir, vResAngles)

	//math_lerp(vCameraAngles, vResAngles, 0.1, vResAngles) // CAMERA_ANGULAR_DAMPING

	//euler2quat(vCameraAngles, qCameraAngles)
	//euler2quat(vTargetAngles, qTargetAngles)
	//math_quat_lerp(qCameraAngles, qTargetAngles, 0.1, qTargetAngles) // CAMERA_ANGULAR_DAMPING
	//quat2euler(qTargetAngles, vResAngles)

	set_entvar(iCameraEnt, var_origin, vResOrigin)
	set_entvar(iCameraEnt, var_angles, vResAngles)

	static iUIEnt
	iUIEnt = get_entvar(iCameraEnt, var_ui)

	if (iUIEnt)
	{
		vResAngles[0] = -vResAngles[0]
		set_entvar(iUIEnt, var_origin, vResOrigin)
		set_entvar(iUIEnt, var_angles, vResAngles)
	}
}

move_player_spectator(iPlayer)
{
	clear_player_data(iPlayer)
	set_player_game_state(iPlayer, PGS_SPECTATOR)
	reset_spectator_target(iPlayer)
	check_stop_game()
}

reset_spectator_target(iPlayer)
{
	engfunc(EngFunc_SetClientMaxspeed, iPlayer, SPECTATOR_MAXSPEED)
	set_entvar(iPlayer, var_maxspeed, SPECTATOR_MAXSPEED)
	engfunc(EngFunc_SetView, iPlayer, iPlayer)

	g_iSpectatorTarget[iPlayer] = 0
}

set_spectator_target(iPlayer, iTarget)
{
	engfunc(EngFunc_SetClientMaxspeed, iPlayer, 0.000001)
	set_entvar(iPlayer, var_maxspeed, 0.000001)

	new iCameraEnt = g_iCamerasEnt[iTarget]
	if (!is_nullent(iCameraEnt))
		engfunc(EngFunc_SetView, iPlayer, iCameraEnt)

	g_iSpectatorTarget[iPlayer] = iTarget
}

find_spectator_target(iPlayer, bool:bReverse=false)
{
	new Float:fGameTime = get_gametime()
	new Float:fNextFollowTime = Float:get_member(iPlayer, m_flNextFollowTime)
	new iLastTarget = g_iSpectatorTarget[iPlayer]

	if (fNextFollowTime && fNextFollowTime > fGameTime)
		return iLastTarget

	set_member(iPlayer, m_flNextFollowTime, fGameTime + 0.25)

	new iStart = iLastTarget ? iLastTarget : iPlayer
	new iCurrent = iStart
	new iDir = bReverse ? -1 : 1

	do
	{
		iCurrent += iDir
		if (iCurrent > MaxClients)
			iCurrent = 1
		else if (iCurrent < 1)
			iCurrent = MaxClients

		if (g_pgsPlayerGameState[iCurrent] == PGS_INGAME || g_pgsPlayerGameState[iCurrent] == PGS_READY)
			return iCurrent
	}
	while (iCurrent != iStart)

	return 0
}

spectator_think(iPlayer)
{
	new iButtons = g_iButtons[iPlayer]
	new iOldButtons = get_entvar(iPlayer, var_oldbuttons)
	new iLastTarget = g_iSpectatorTarget[iPlayer]
	new iTarget

	if ((iButtons & IN_ATTACK) && !(iOldButtons & IN_ATTACK))
		iTarget = find_spectator_target(iPlayer)
	else if ((iButtons & IN_ATTACK2) && !(iOldButtons & IN_ATTACK2))
		iTarget = find_spectator_target(iPlayer, true)
	else
		iTarget = iLastTarget

	if (!iTarget)
	{
		if (iLastTarget)
			reset_spectator_target(iPlayer)
		return
	}

	if ((g_pgsPlayerGameState[iTarget] != PGS_INGAME && g_pgsPlayerGameState[iTarget] != PGS_READY)
		|| (iButtons & IN_JUMP))
	{
		reset_spectator_target(iPlayer)
		return
	}

	if (iTarget != iLastTarget)
		set_spectator_target(iPlayer, iTarget)
}

public fwd_SnowballThink(iSnowballEnt)
{
	set_entvar(iSnowballEnt, var_flags, FL_KILLME)
}

public fwd_BlowfishThink(iBlowfishEnt)
{
	if (get_entvar(iBlowfishEnt, vat_missile_mode) == 1)
	{
		set_entvar(iBlowfishEnt, var_flags, FL_KILLME)
		return
	}

	static Float:vVelocity[3]
	get_entvar(iBlowfishEnt, var_velocity, vVelocity)

	if (xs_vec_len_2d(vVelocity) < 1.0)
	{
		set_entvar(iBlowfishEnt, vat_missile_mode, 1)
		set_entvar(iBlowfishEnt, var_nextthink, get_gametime() + BLOWFISH_LIFE)
	}
	else
	{
		vVelocity[0] *= BLOWFISH_ACCELERATION
		vVelocity[1] *= BLOWFISH_ACCELERATION
		set_entvar(iBlowfishEnt, var_velocity, vVelocity)
		set_entvar(iBlowfishEnt, var_nextthink, get_gametime())
	}
}

public fwd_GloveThink(iGloveEnt)
{
	static iCarEnt, Float:vOrigin[3], Float:vAngles[3], Float:vDir[3],
		Float:fBlend, Float:fGameTime

	fGameTime = get_gametime()

	iCarEnt = get_entvar(iGloveEnt, var_owner)
	if (is_nullent(iCarEnt))
		return

	get_entvar(iCarEnt, var_origin, vOrigin)
	get_entvar(iCarEnt, var_velocity, vDir)

	if (xs_vec_len(vDir) > 150.0)
		vector_to_angle(vDir, vAngles)
	else
		get_entvar(iCarEnt, var_angles, vAngles)

	fBlend = (floatsin(fGameTime * 2.5) + 1.0) * 127.5

	engfunc(EngFunc_SetOrigin, iGloveEnt, vOrigin)

	set_entvar(iGloveEnt, var_origin, vOrigin)
	set_entvar(iGloveEnt, var_angles, vAngles)

	set_pev(iGloveEnt, pev_blending_0, floatround(fBlend))

	set_entvar(iGloveEnt, var_nextthink, fGameTime)
}

public fwd_UFOSpawnThink(iUFOSpawnEnt)
{
	new iUFOEnt
	while ((iUFOEnt = rg_find_ent_by_class(iUFOEnt, CLASSNAME_UFO)))
		if (get_entvar(iUFOEnt, var_ufospawn) == iUFOSpawnEnt)
			set_entvar(iUFOEnt, var_flags, FL_KILLME)
	set_entvar(iUFOSpawnEnt, var_flags, FL_KILLME)
}

public fwd_UFOThink(iUFOEnt)
{
	new iMode = get_entvar(iUFOEnt, var_skin)
	if (iMode)
	{
		set_entvar(iUFOEnt, var_skin, 0)
		set_entvar(iUFOEnt, var_solid, SOLID_TRIGGER)
		set_entvar(iUFOEnt, var_nextthink, get_gametime() + UFO_MODE_TIME * 2.0)
	}
	else
	{
		set_entvar(iUFOEnt, var_skin, 1)
		set_entvar(iUFOEnt, var_solid, SOLID_NOT)
		set_entvar(iUFOEnt, var_nextthink, get_gametime() + UFO_MODE_TIME)
	}
}

public fwd_UFOTouch(iUFOEnt, iToucher)
{
	if (!iToucher || get_entvar(iToucher, var_impulse) != IMPULSE_CAR)
		return HC_CONTINUE

	new iOwnerCar = get_entvar(iUFOEnt, var_owner)

	if (iToucher == iOwnerCar)
		return HC_CONTINUE

	new iPlayer = get_entvar(iToucher, var_owner)
	if (!iPlayer)
		return HC_CONTINUE

	emit_sound(iToucher, CHAN_AUTO, SOUND_UFO_LAUNCH, 0.8, ATTN_NORM, 0, PITCH_NORM)
	hit_player_car(iPlayer, iToucher, UFO_UNCONTOL_TIME, 720.0 / UFO_UNCONTOL_TIME)

	new iAttacker
	if (iOwnerCar)
		iAttacker = get_entvar(iOwnerCar, var_owner)
	show_hit_message(iAttacker, iPlayer, CLASSNAME_UFO)

	new iUFOSpawnEnt = get_entvar(iUFOEnt, var_ufospawn)
	set_entvar(iUFOSpawnEnt, var_nextthink, get_gametime())

	return HC_CONTINUE
}

create_car(iOwner)
{
	new iCarEnt = rg_create_entity(SZ_INFO_TARGET, true)
	if (is_nullent(iCarEnt))
		return 0

	new iChar = random(CHAR_NUM)
	new iColor = SELECT_CHAR_COLOR_STEP * random(256 / SELECT_CHAR_COLOR_STEP)

	set_car_char(iCarEnt, iChar)
	set_entvar(iCarEnt, var_colormap, iColor)

	// TODO: use hitbox
	engfunc(EngFunc_SetSize, iCarEnt, CAR_SIZE)
	//set_entvar(iEnt, var_takedamage, DAMAGE_NO)
	set_entvar(iCarEnt, var_health, 0.0)

	set_entvar(iCarEnt, var_owner, iOwner)
	set_entvar(iCarEnt, var_classname, CLASSNAME_CAR)
	set_entvar(iCarEnt, var_impulse, IMPULSE_CAR)

	set_entvar(iCarEnt, var_animtime, 0.0)
	set_entvar(iCarEnt, var_sequence, 0)

	set_entvar(iCarEnt, var_friction, 0.0000001)

	SetThink(iCarEnt, "fwd_CarThink")

	// set_entvar(iCarEnt, var_gravity, GRAVITY)

	ExecuteForward(g_fwForwards[FWD_ID_CREATE_CAR], g_iDummy, iOwner, iCarEnt)

	return iCarEnt
}

set_car_char(iCarEnt, iChar)
{
	set_entvar(iCarEnt, var_modelindex, g_iKartPackModelIndices[iChar / CHAR_PACK_SIZE])
	set_entvar(iCarEnt, var_body, iChar % CHAR_PACK_SIZE)
}

get_car_char(iCarEnt)
{
	new iChar = (get_entvar(iCarEnt, var_modelindex) - g_iKartPackModelIndices[0]) * CHAR_PACK_SIZE
	return iChar + get_entvar(iCarEnt, var_body)
}

set_car_preparing(iCarEnt)
{
	set_pev(iCarEnt, pev_blending_0, 127)
	set_entvar(iCarEnt, var_frame, 0)
	set_entvar(iCarEnt, var_framerate, 0.0)
	set_entvar(iCarEnt, var_solid, SOLID_NOT)
	set_entvar(iCarEnt, var_movetype, MOVETYPE_NOCLIP)
	set_entvar(iCarEnt, var_velocity, NULL_VECTOR)
	set_entvar(iCarEnt, var_avelocity, Float:{0.0, SELECT_CHAR_ASPEED, 0.0})
	fm_set_rendering(iCarEnt, kRenderFxNone, 255, 255, 255, kRenderNormal, 255)
	set_entvar(iCarEnt, var_effects, get_entvar(iCarEnt, var_effects) | (1 << 12))
	set_entvar(iCarEnt, var_nextthink, -1.0)
}

set_car_ready(iCarEnt)
{
	drop_to_floor(iCarEnt)
	set_pev(iCarEnt, pev_blending_0, 127)
	set_entvar(iCarEnt, var_frame, 0)
	set_entvar(iCarEnt, var_framerate, 0.0)
	set_entvar(iCarEnt, var_solid, SOLID_TRIGGER)
	set_entvar(iCarEnt, var_movetype, MOVETYPE_PUSHSTEP)
	set_entvar(iCarEnt, var_velocity, NULL_VECTOR)
	set_entvar(iCarEnt, var_avelocity, NULL_VECTOR)
	fm_set_rendering(iCarEnt, kRenderFxNone, 255, 255, 255, kRenderNormal, 255)
	set_entvar(iCarEnt, var_effects, get_entvar(iCarEnt, var_effects) & ~(1 << 12))
	set_entvar(iCarEnt, var_nextthink, get_gametime())
	rh_emit_sound2(iCarEnt, get_entvar(iCarEnt, var_owner), CHAN_VOICE, SOUND_ENGINE, .flags=SND_STOP, .pitch=80)
}

set_car_waiting(iCarEnt)
{
	reset_player_car_chill(get_entvar(iCarEnt, var_owner), iCarEnt)
	set_entvar(iCarEnt, var_solid, SOLID_NOT)
	fm_set_rendering(iCarEnt, kRenderFxNone, 255, 255, 255, kRenderTransAdd, 120)
}

reset_car(iCarEnt, iPlayer)
{
	set_entvar(iCarEnt, var_origin, g_vSpawnOrigin[iPlayer])
	set_entvar(iCarEnt, var_angles, g_vSpawnAngles[iPlayer])

	// fm_drop_to_floor(iCarEnt)
	set_entvar(iCarEnt, var_velocity, NULL_VECTOR)
	reset_player_car_vars(iPlayer)
	g_fLastResetPressed[iPlayer] = -1.0

	try_skiding_sound(iPlayer, iCarEnt, 0)
	reset_player_car_chill(iPlayer, iCarEnt)

	new iTornadoEnt = NULLENT
	while ((iTornadoEnt = rg_find_ent_by_class(iTornadoEnt, CLASSNAME_TORNADO)))
		if (get_entvar(iTornadoEnt, var_targetcar) == iCarEnt)
			set_entvar(iTornadoEnt, var_flags, FL_KILLME)
}

hit_player_car(iPlayer, iCarEnt, Float:fUnControlTime, Float:fRotForce=720.0)
{
	set_entvar(iCarEnt, var_velocity, NULL_VECTOR)
	g_vCarVelocity[iPlayer][0] = 0.0
	g_vCarVelocity[iPlayer][1] = 0.0
	g_vCarVelocity[iPlayer][2] = 0.0
	g_fCarEngineForce[iPlayer] = 0.0
	g_fCarUnControlTime[iPlayer] = get_gametime() + fUnControlTime
	g_fCarUnControlRotForce[iPlayer] = fRotForce

	new Float:vAngles[3]
	get_entvar(iCarEnt, var_angles, vAngles)
	g_fCarRecAngle[iPlayer] = vAngles[1]
}

reset_player_car_chill(iPlayer, iCarEnt)
{
	if (g_fCarChillTime[iPlayer] > 0.0)
	{
		fm_set_rendering(iCarEnt, kRenderFxNone, 255, 255, 255, kRenderNormal, 255)
		g_fCarChillTime[iPlayer] = 0.0
	}
}

reset_player_car_vars(iPlayer)
{
	g_fCarLastThink[iPlayer] = get_gametime()
	g_vCarVelocity[iPlayer][0] = 0.0
	g_vCarVelocity[iPlayer][1] = 0.0
	g_vCarVelocity[iPlayer][2] = 0.0
	g_fCarEngineForce[iPlayer] = 0.0
	g_fCarTurnAngle[iPlayer] = 0.0
	g_fCarJumpForce[iPlayer] = 0.0
	g_fCarGear[iPlayer] = 0.0
	g_fCarUnControlTime[iPlayer] = 0.0
	g_iSmoothDizzy[iPlayer] = 0
	remove_glove(iPlayer)
	remove_dizzy(iPlayer)
	remove_tornado_warn(iPlayer)
}

try_skiding_sound(iPlayer, iCarEnt, iPlay=1)
{
	static Float:fGameTime
	fGameTime = get_gametime()

	if (g_fSkidingSoundTime[iPlayer] > fGameTime)
		return

	if (iPlay)
	{
		if (play_skiding_sound(iPlayer, iCarEnt))
			g_fSkidingSoundTime[iPlayer] = fGameTime + SKIDING_SOUND_DELAY
	}
	else
	{
		if (stop_skiding_sound(iPlayer, iCarEnt))
			g_fSkidingSoundTime[iPlayer] = fGameTime + SKIDING_SOUND_DELAY
	}
}

bool:play_skiding_sound(iPlayer, iCarEnt)
{
	if (g_iSkidingSound[iPlayer])
		return false

	new iCarSkiding = random(sizeof SOUNDS_SKIDING) + 1
	emit_sound(iCarEnt, CHAN_AUTO, SOUNDS_SKIDING[iCarSkiding - 1], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	g_iSkidingSound[iPlayer] = iCarSkiding
	return true
}

bool:stop_skiding_sound(iPlayer, iCarEnt)
{
	if (!g_iSkidingSound[iPlayer])
		return false

	emit_sound(iCarEnt, CHAN_AUTO, SOUNDS_SKIDING[g_iSkidingSound[iPlayer] - 1], VOL_NORM, ATTN_NORM, SND_STOP, PITCH_NORM)
	g_iSkidingSound[iPlayer] = 0
	return true
}

create_camera(iOwner)
{
	new iCameraEnt = rg_create_entity(SZ_INFO_TARGET, true)
	if (is_nullent(iCameraEnt))
		return 0

	engfunc(EngFunc_SetModel, iCameraEnt, MODEL_CAMERA)

	set_entvar(iCameraEnt, var_owner, iOwner)
	set_entvar(iCameraEnt, var_classname, CLASSNAME_CAMERA)
	set_entvar(iCameraEnt, var_solid, SOLID_NOT)
	set_entvar(iCameraEnt, var_movetype, MOVETYPE_NOCLIP)
	set_entvar(iCameraEnt, var_rendermode, kRenderTransTexture)

	engfunc(EngFunc_SetView, iOwner, iCameraEnt)

	return iCameraEnt
}

create_ui(iOwner, iCameraEnt)
{
	new iUIEnt = rg_create_entity(SZ_INFO_TARGET, true)
	if (is_nullent(iUIEnt))
		return 0

	engfunc(EngFunc_SetModel, iUIEnt, MODEL_UI)

	set_entvar(iUIEnt, var_owner, iOwner)
	set_entvar(iUIEnt, var_classname, CLASSNAME_UI)
	set_entvar(iUIEnt, var_solid, SOLID_NOT)
	set_entvar(iUIEnt, var_movetype, MOVETYPE_NOCLIP)
	set_entvar(iUIEnt, var_effects, EF_NODRAW)
	set_entvar(iUIEnt, var_framerate, 0.0)

	set_entvar(iCameraEnt, var_ui, iUIEnt)

	engfunc(EngFunc_SetSize, iUIEnt, Float:{-16.0, -16.0, -16.0}, Float:{16.0, 16.0, 16.0} )
	fm_set_rendering(iUIEnt, kRenderFxNone, 255, 255, 255, kRenderTransAdd, 255)

	return iUIEnt
}

public update_pos_list()
{
	new eCPState[DataCPState], iListSize
	static iPlayerPosList[MAX_PLAYERS]

	ArrayClear(g_aPlayerCPState)

	new iNextCP, Float:vCarOrigin[3], Float:vCPOrigin[3]
	for (new iPlayer = 1; iPlayer <= MAX_PLAYERS; iPlayer++)
	{
		if (g_pgsPlayerGameState[iPlayer] != PGS_INGAME)
			continue

		iNextCP = g_iPlayerNextCP[iPlayer]
		if (iNextCP <= 0)
			continue

		get_entvar(g_iCarsEnt[iPlayer], var_origin, vCarOrigin)
		get_entvar(iNextCP, var_startpos, vCPOrigin)

		eCPState[CPS_ID] = iPlayer
		eCPState[CPS_DIST] = get_distance_f(vCarOrigin, vCPOrigin)
		eCPState[CPS_PASSED] = g_iPlayerPassedCP[iPlayer]
		ArrayPushArray(g_aPlayerCPState, eCPState)

		iListSize++
	}

	ArraySortEx(g_aPlayerCPState, "sort_cps")

	for (new i, iPlayer, iPos; i < iListSize; i++)
	{
		ArrayGetArray(g_aPlayerCPState, i, eCPState)
		iPlayer = eCPState[CPS_ID]
		iPos = i + g_iFinPlayersNum + 1
		iPlayerPosList[i] = iPlayer
		set_ui_pos(iPlayer, iPos)
		g_iPlayerCurrPos[iPlayer] = iPos
	}

	if (!iListSize || g_iFinPlayersNum >= MAX_POS_LIST_ROWS)
		return

	g_szPosList[g_iPosListStart] = 0
	iListSize = min(iListSize, MAX_POS_LIST_ROWS - g_iFinPlayersNum)

	for (new i, iLen = g_iPosListStart; i < iListSize; i++)
	{
		iLen += formatex(g_szPosList[iLen], charsmax(g_szPosList),
			"%i: %n^n", i + g_iFinPlayersNum + 1, iPlayerPosList[i])
	}
}

show_hud_pos(iPlayer)
{
	static Float:fGameTime, Float:fLastHUDUpdate[MAX_PLAYERS + 1]
	fGameTime = get_gametime()

	if (fLastHUDUpdate[iPlayer] > fGameTime)
		return
	fLastHUDUpdate[iPlayer] = fGameTime + 0.5

	if (g_szPosList[0])
	{
		set_hudmessage(255, 255, 255, -0.05, 0.3, 0, 0.0, 0.6, 0.0, 0.0, HUD_CHAN_POS)
		show_hudmessage(iPlayer, g_szPosList)
	}
}

show_hud_spectator(iPlayer)
{
	static Float:fGameTime, Float:fLastHUDUpdate[MAX_PLAYERS + 1]
	fGameTime = get_gametime()

	if (fLastHUDUpdate[iPlayer] > fGameTime)
		return
	fLastHUDUpdate[iPlayer] = fGameTime + 0.5

	set_dhudmessage(255, 255, 255, -1.0, -0.05, 0, 0.0, 0.6, 0.0, 0.0)

	new iTarget = g_iSpectatorTarget[iPlayer]

	if (iTarget)
		show_dhudmessage(iPlayer, "%L", iPlayer, "KART_SPECTATOR_TARGET", g_iPlayerCurrPos[iTarget], iTarget)
	else
		show_dhudmessage(iPlayer, "%L", iPlayer, "KART_SPECTATOR_FREE")
}

public check_ready_players()
{
	new iReadyPlayersNum
	for (new iPlayer = 1; iPlayer <= MAX_PLAYERS; iPlayer++)
		if (g_pgsPlayerGameState[iPlayer] == PGS_READY)
			iReadyPlayersNum++

	if (iReadyPlayersNum > 1)
		start_game()
	else
		client_print(0, print_center, "%L", LANG_PLAYER, "KART_WAITING")
}

public sort_cps(Array:a, v1[], v2[])
{
	if (v1[CPS_PASSED] > v2[CPS_PASSED])
		return -1
	if (v1[CPS_PASSED] < v2[CPS_PASSED])
		return 1
	if (Float:v1[CPS_DIST] > Float:v2[CPS_DIST])
		return 1
	return -1
}

create_itemboxes()
{
	new iItemBox = -1
	while ((iItemBox = engfunc(EngFunc_FindEntityByString, iItemBox, "targetname", "bonus")))
	{
		engfunc(EngFunc_SetModel, iItemBox, MODEL_ITEMBOX)
		engfunc(EngFunc_SetSize, iItemBox, ITEMBOX_SIZES)

		set_entvar(iItemBox, var_solid, SOLID_TRIGGER)
		set_entvar(iItemBox, var_movetype, MOVETYPE_NOCLIP)

		set_entvar(iItemBox, var_impulse, IMPULSE_ITEMBOX)
		set_entvar(iItemBox, var_classname, CLASSNAME_ITEMBOX)

		set_entvar(iItemBox, var_animtime, 0.0)
		set_entvar(iItemBox, var_sequence, 0)
		set_entvar(iItemBox, var_framerate, 1.0)

		set_entvar(iItemBox, var_nextthink, -1.0)

		SetThink(iItemBox, "fwd_ItemboxThink")
		SetTouch(iItemBox, "fwd_ItemboxTouch")
	}
}

set_items_props()
{
	g_kitemProps[_:KIT_SNOWBALL][KITEM_AMMO] = SNOWBALL_AMMO
	g_kitemProps[_:KIT_SNOWBALL][KITEM_POS_MIN] = SNOWBALL_POS_MIN
	g_kitemProps[_:KIT_SNOWBALL][KITEM_POS_MAX] = SNOWBALL_POS_MAX

	g_kitemProps[_:KIT_BOOSTER][KITEM_AMMO] = BOOSTER_AMMO
	g_kitemProps[_:KIT_BOOSTER][KITEM_POS_MIN] = BOOSTER_POS_MIN
	g_kitemProps[_:KIT_BOOSTER][KITEM_POS_MAX] = BOOSTER_POS_MAX

	g_kitemProps[_:KIT_BLOWFISH][KITEM_AMMO] = BLOWFISH_AMMO
	g_kitemProps[_:KIT_BLOWFISH][KITEM_POS_MIN] = BLOWFISH_POS_MIN
	g_kitemProps[_:KIT_BLOWFISH][KITEM_POS_MAX] = BLOWFISH_POS_MAX

	g_kitemProps[_:KIT_GLOVE][KITEM_AMMO] = GLOVE_AMMO
	g_kitemProps[_:KIT_GLOVE][KITEM_POS_MIN] = GLOVE_POS_MIN
	g_kitemProps[_:KIT_GLOVE][KITEM_POS_MAX] = GLOVE_POS_MAX

	g_kitemProps[_:KIT_TORNADO][KITEM_AMMO] = TORNADO_AMMO
	g_kitemProps[_:KIT_TORNADO][KITEM_POS_MIN] = TORNADO_POS_MIN
	g_kitemProps[_:KIT_TORNADO][KITEM_POS_MAX] = TORNADO_POS_MAX

	g_kitemProps[_:KIT_UFO][KITEM_AMMO] = UFO_AMMO
	g_kitemProps[_:KIT_UFO][KITEM_POS_MIN] = UFO_POS_MIN
	g_kitemProps[_:KIT_UFO][KITEM_POS_MAX] = UFO_POS_MAX
}

set_player_item(iPlayer, KartItemType:iKartItem, iAmmo=0)
{
	if (iAmmo <= 0)
		iAmmo = g_kitemProps[_:iKartItem][KITEM_AMMO]

	g_kitPlayerItem[iPlayer] = iKartItem
	g_iPlayerItemAmmo[iPlayer] = iAmmo
	set_ui_item(iPlayer, iKartItem, iAmmo)

	new iUIEnt = g_iUIEnt[iPlayer]
	if (iUIEnt)
	{
		set_entvar(iUIEnt, var_sequence, UI_SEQ_GIVE_ITEM)
		set_entvar(iUIEnt, var_frame, 0)
	}
}

reset_player_item(iPlayer)
{
	g_kitPlayerItem[iPlayer] = KIT_NULL
	g_iPlayerItemAmmo[iPlayer] = 0
	// set_ui_item(iPlayer, KIT_NULL, 0)

	new iUIEnt = g_iUIEnt[iPlayer]
	if (iUIEnt)
	{
		set_entvar(iUIEnt, var_sequence, 0)
		set_entvar(iUIEnt, var_frame, 0)
	}
}

use_player_item(iPlayer, iCarEnt)
{
	static KartItemType:iKartItem, iRetRes
	iKartItem = g_kitPlayerItem[iPlayer]

	switch (iKartItem)
	{
		case KIT_SNOWBALL: iRetRes = use_snowball(iPlayer, iCarEnt)
		case KIT_BOOSTER: iRetRes = use_booster(iPlayer, iCarEnt)
		case KIT_BLOWFISH: iRetRes = use_blowfish(iPlayer, iCarEnt)
		case KIT_GLOVE: iRetRes = use_glove(iPlayer, iCarEnt)
		case KIT_TORNADO: iRetRes = use_tornado(iPlayer, iCarEnt)
		case KIT_UFO:
		{
			use_ufo(iPlayer, iCarEnt)
			iRetRes = 1
		}
		default: return
	}

	if (iRetRes)
	{
		new iAmmo = g_iPlayerItemAmmo[iPlayer] - 1
		if (iAmmo > 0)
		{
			g_iPlayerItemAmmo[iPlayer] = iAmmo
			if (g_iUIEnt[iPlayer])
				set_entvar(g_iUIEnt[iPlayer], var_skin, iAmmo - 1)
		}
		else
			reset_player_item(iPlayer)
	}
}

use_snowball(iPlayer, iCarEnt)
{
	new iSnowballEnt = rg_create_entity(SZ_INFO_TARGET, true)
	if (is_nullent(iSnowballEnt))
		return 0

	new Float:vOrigin[3], Float:vAngles[3]
	new Float:vVelocity[3], Float:vDirection[3]

	get_entvar(iCarEnt, var_origin, vOrigin)
	get_entvar(iCarEnt, var_angles, vAngles)
	vAngles[0] = -vAngles[0]

	angle_vector(vAngles, ANGLEVECTOR_UP, vDirection)
	xs_vec_mul_scalar(vDirection, 16.0, vDirection)
	xs_vec_add(vOrigin, vDirection, vOrigin)

	angle_vector(vAngles, ANGLEVECTOR_FORWARD, vDirection)
	if (g_bBackwardCamMode[iPlayer])
		xs_vec_neg(vDirection, vDirection)

	xs_vec_mul_scalar(vDirection, SNOWBALL_SPEED, vVelocity)

	engfunc(EngFunc_SetModel, iSnowballEnt, MODEL_SNOWBALL)
	engfunc(EngFunc_SetOrigin, iSnowballEnt, vOrigin)
	engfunc(EngFunc_SetSize, iSnowballEnt, SNOWBALL_SIZES)

	set_entvar(iSnowballEnt, var_origin, vOrigin)
	set_entvar(iSnowballEnt, var_angles, vAngles)
	set_entvar(iSnowballEnt, var_velocity, vVelocity)

	set_entvar(iSnowballEnt, var_solid, SOLID_TRIGGER)
	set_entvar(iSnowballEnt, var_movetype, MOVETYPE_BOUNCE)
	set_entvar(iSnowballEnt, var_classname, CLASSNAME_SNOWBALL)
	set_entvar(iSnowballEnt, var_impulse, IMPULSE_SNOWBALL)
	set_entvar(iSnowballEnt, var_owner, iCarEnt)
	set_entvar(iSnowballEnt, var_gravity, 0.0)

	fm_set_rendering(iSnowballEnt, kRenderFxGlowShell, 255, 255, 255, kRenderNormal, 10)
	set_entvar(iSnowballEnt, var_rendermode, kRenderNormal)
	set_entvar(iSnowballEnt, var_nextthink, get_gametime() + SNOWBALL_LIFE)

	SetThink(iSnowballEnt, "fwd_SnowballThink")
	SetTouch(iSnowballEnt, "fwd_SnowballTouch")

	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_BEAMFOLLOW)
	write_short(iSnowballEnt)
	write_short(g_sprSnowballGib)
	write_byte(4)
	write_byte(8)
	write_byte(255)
	write_byte(255)
	write_byte(255)
	write_byte(100)
	message_end()

	emit_sound(iCarEnt, CHAN_AUTO, SOUND_ICICLE_LAUNCH, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

	return iSnowballEnt
}

use_booster(iPlayer, iCarEnt)
{
	// if (get_entvar(iCarEnt, var_flags) & FL_ONGROUND)
	if (get_entvar(iCarEnt, var_flags))
	{
		new Float:vAngles[3], Float:vVelocity[3]
		get_entvar(iCarEnt, var_angles, vAngles)
		angle_vector(vAngles, ANGLEVECTOR_FORWARD, vVelocity)
		xs_vec_mul_scalar(vVelocity, BOOSTER_FORCE, vVelocity)

		g_vCarVelocity[iPlayer][0] = vVelocity[0]
		g_vCarVelocity[iPlayer][1] = vVelocity[1]
	}

	emit_sound(iCarEnt, CHAN_AUTO, SOUND_BOOSTER, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

	g_fCarEngineForce[iPlayer] = MAX_FORCE

	return 1
}

use_blowfish(iPlayer, iCarEnt)
{
	#pragma unused iPlayer

	new iBlowfishEnt = rg_create_entity(SZ_INFO_TARGET, true)
	if (is_nullent(iBlowfishEnt))
		return 0

	new Float:vOrigin[3], Float:vAngles[3], Float:vVelocity[3]
	new Float:fGameTime = get_gametime()

	get_entvar(iCarEnt, var_origin, vOrigin)

	get_entvar(iCarEnt, var_velocity, vVelocity)
	xs_vec_mul_scalar(vVelocity, -0.5, vVelocity)
	vVelocity[2] = -10.0

	get_entvar(iCarEnt, var_angles, vAngles)
	vAngles[0] = vAngles[2] = 0.0
	vAngles[1] = -vAngles[1]

	engfunc(EngFunc_SetModel, iBlowfishEnt, MODEL_BLOWFISH)
	engfunc(EngFunc_SetOrigin, iBlowfishEnt, vOrigin)
	engfunc(EngFunc_SetSize, iBlowfishEnt, BLOWFISH_SIZES)

	set_entvar(iBlowfishEnt, var_origin, vOrigin)
	set_entvar(iBlowfishEnt, var_angles, vAngles)
	set_entvar(iBlowfishEnt, var_velocity, vVelocity)

	set_entvar(iBlowfishEnt, var_solid, SOLID_TRIGGER)
	set_entvar(iBlowfishEnt, var_movetype, MOVETYPE_TOSS)
	set_entvar(iBlowfishEnt, var_classname, CLASSNAME_BLOWFISH)
	set_entvar(iBlowfishEnt, var_impulse, IMPULSE_BLOWFISH)
	set_entvar(iBlowfishEnt, var_owner, iCarEnt)
	set_entvar(iBlowfishEnt, var_gravity, 0.05)

	set_entvar(iBlowfishEnt, var_animtime, 0.0)
	set_entvar(iBlowfishEnt, var_sequence, 0)
	set_entvar(iBlowfishEnt, var_framerate, 1.0)

	set_entvar(iBlowfishEnt, vat_missile_mode, 0)

	set_entvar(iBlowfishEnt, var_nextthink, fGameTime)

	SetThink(iBlowfishEnt, "fwd_BlowfishThink")
	SetTouch(iBlowfishEnt, "fwd_BlowfishTouch")

	emit_sound(iCarEnt, CHAN_AUTO, SOUND_BLOWFISH_LAUNCH, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

	return iBlowfishEnt
}

public use_glove(iPlayer, iCarEnt)
{
	new iGloveEnt = rg_create_entity(SZ_INFO_TARGET, true)
	if (is_nullent(iGloveEnt))
		return 0

	new Float:vOrigin[3], Float:vAngles[3], Float:vDir[3], Float:fBlend
	new Float:fGameTime = get_gametime()

	get_entvar(iCarEnt, var_origin, vOrigin)
	get_entvar(iCarEnt, var_velocity, vDir)
	if (xs_vec_len(vDir) > 150.0)
		vector_to_angle(vDir, vAngles)

	fBlend = (floatsin(fGameTime * 2.5) + 1.0) * 127.5

	engfunc(EngFunc_SetModel, iGloveEnt, MODEL_GLOVE)
	engfunc(EngFunc_SetOrigin, iGloveEnt, vOrigin)
	// engfunc(EngFunc_SetSize, iGloveEnt, GLOVE_SIZES)

	set_entvar(iGloveEnt, var_origin, vOrigin)
	set_entvar(iGloveEnt, var_angles, vAngles)

	set_entvar(iGloveEnt, var_solid, SOLID_NOT)
	set_entvar(iGloveEnt, var_movetype, MOVETYPE_NOCLIP)
	// set_entvar(iGloveEnt, var_classname, CLASSNAME_GLOVE)
	// set_entvar(iGloveEnt, var_impulse, IMPULSE_GLOVE)
	set_entvar(iGloveEnt, var_owner, iCarEnt)

	set_entvar(iGloveEnt, var_sequence, 0)
	set_pev(iGloveEnt, pev_blending_0, floatround(fBlend))

	set_entvar(iGloveEnt, var_nextthink, fGameTime)

	SetThink(iGloveEnt, "fwd_GloveThink")

	remove_glove(iPlayer)
	g_fCarGloveEnt[iPlayer] = iGloveEnt
	g_fCarGloveTime[iPlayer] = fGameTime + GLOVE_LIFE

	emit_sound(iCarEnt, CHAN_AUTO, SOUND_GLOVE_LAUNCH, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

	return iGloveEnt
}

remove_glove(iPlayer)
{
	if (g_fCarGloveEnt[iPlayer])
	{
		set_entvar(g_fCarGloveEnt[iPlayer], var_flags, FL_KILLME)
		g_fCarGloveEnt[iPlayer] = 0
	}
	g_fCarGloveTime[iPlayer] = 0.0
}

use_tornado(iPlayer, iCarEnt)
{
	new iTargetPlayer = -1
	new iMinPos = MAX_PLAYERS + 1

	for (new i = 1, iPos; i <= MAX_PLAYERS; i++)
	{
		if (iPlayer == i)
			continue

		if (g_pgsPlayerGameState[i] != PGS_INGAME)
			continue

		if (g_fCarDizzyEnt[i])
			continue

		iPos = g_iPlayerCurrPos[i]
		if (iPos <= g_iFinPlayersNum)
			continue

		if (iPos < iMinPos)
		{
			iMinPos = iPos
			iTargetPlayer = i
		}
	}

	if (iTargetPlayer < 0)
		return 0

	new iTargetCar = g_iCarsEnt[iTargetPlayer]

	new iTornadoEnt = rg_create_entity(SZ_INFO_TARGET, true)
	if (is_nullent(iTornadoEnt))
		return 0

	set_tornado_warn(iTargetPlayer, iTargetCar)

	new Float:fGameTime = get_gametime()
	new Float:vOrigin[3]

	get_entvar(iCarEnt, var_origin, vOrigin)

	engfunc(EngFunc_SetOrigin, iTornadoEnt, vOrigin)
	engfunc(EngFunc_SetModel, iTornadoEnt, MODEL_TORNADO)
	engfunc(EngFunc_SetSize, iTornadoEnt, TORNADO_SIZES)

	set_entvar(iTornadoEnt, var_origin, vOrigin)
	set_entvar(iTornadoEnt, var_solid, SOLID_TRIGGER)
	set_entvar(iTornadoEnt, var_movetype, MOVETYPE_NOCLIP)
	set_entvar(iTornadoEnt, var_classname, CLASSNAME_TORNADO)
	set_entvar(iTornadoEnt, var_impulse, IMPULSE_TORNADO)
	set_entvar(iTornadoEnt, var_owner, iCarEnt)
	set_entvar(iTornadoEnt, var_gravity, 0.0)
	set_entvar(iTornadoEnt, var_lifetime, fGameTime + TORNADO_LIFE)
	set_entvar(iTornadoEnt, var_nextthink, fGameTime + TORNADO_THINK_DELAY)

	set_entvar(iTornadoEnt, var_animtime, 0.0)
	set_entvar(iTornadoEnt, var_sequence, 0)
	set_entvar(iTornadoEnt, var_targetcar, iTargetCar)

	SetThink(iTornadoEnt, "fwd_TornadoThink")
	SetTouch(iTornadoEnt, "fwd_TornadoTouch")

	emit_sound(iCarEnt, CHAN_AUTO, SOUND_TORNADO_LAUNCH, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

	fwd_TornadoThink(iTornadoEnt)

	return iTornadoEnt
}

set_tornado_warn(iPlayer, iCarEnt)
{
	new iTornadoWarnEnt = rg_create_entity(SZ_INFO_TARGET, true)
	if (is_nullent(iTornadoWarnEnt))
		return 0

	engfunc(EngFunc_SetModel, iTornadoWarnEnt, MODEL_TORNADO_WARN)

	set_entvar(iTornadoWarnEnt, var_solid, SOLID_NOT)
	set_entvar(iTornadoWarnEnt, var_movetype, MOVETYPE_FOLLOW)
	set_entvar(iTornadoWarnEnt, var_aiment, iCarEnt)
	set_entvar(iTornadoWarnEnt, var_scale, 0.25)
	set_entvar(iTornadoWarnEnt, var_owner, iCarEnt)

	client_cmd(iPlayer, "spk ^"%s^"", SOUND_ALERT)

	remove_tornado_warn(iPlayer)
	g_fCarTornadoWarnEnt[iPlayer] = iTornadoWarnEnt
	return iTornadoWarnEnt
}

remove_tornado_warn(iPlayer)
{
	if (g_fCarTornadoWarnEnt[iPlayer])
	{
		set_entvar(g_fCarTornadoWarnEnt[iPlayer], var_flags, FL_KILLME)
		g_fCarTornadoWarnEnt[iPlayer] = 0
	}
}

set_dizzy(iPlayer, iCarEnt)
{
	new iDizzyEnt = rg_create_entity(SZ_INFO_TARGET, true)
	if (is_nullent(iDizzyEnt))
		return 0

	new Float:fGameTime = get_gametime()

	engfunc(EngFunc_SetModel, iDizzyEnt, MODEL_DIZZY_SPRITE)

	set_entvar(iDizzyEnt, var_solid, SOLID_NOT)
	set_entvar(iDizzyEnt, var_movetype, MOVETYPE_FOLLOW)
	set_entvar(iDizzyEnt, var_aiment, iCarEnt)
	set_entvar(iDizzyEnt, var_scale, 0.25)
	set_entvar(iDizzyEnt, var_owner, iCarEnt)
	set_entvar(iDizzyEnt, var_lifetime, fGameTime + DIZZY_LIFE)
	set_entvar(iDizzyEnt, var_nextthink, fGameTime + 1.0)
	set_entvar(iDizzyEnt, var_frame, DIZZY_LIFE - 1.0)

	SetThink(iDizzyEnt, "fwd_DizzyThink")

	remove_dizzy(iPlayer)
	g_fCarDizzyEnt[iPlayer] = iDizzyEnt
	g_fCarDizzyTime[iPlayer] = fGameTime + DIZZY_LIFE
	return iDizzyEnt
}

remove_dizzy(iPlayer)
{
	if (g_fCarDizzyEnt[iPlayer])
	{
		set_entvar(g_fCarDizzyEnt[iPlayer], var_flags, FL_KILLME)
		g_fCarDizzyEnt[iPlayer] = 0

		new iButtons = g_iButtons[iPlayer]
		if ((iButtons & BTN_LEFT) && !(iButtons & BTN_RIGHT))
			g_iSmoothDizzy[iPlayer] = BTN_RIGHT
		else if (!(iButtons & BTN_LEFT) || (iButtons & BTN_RIGHT))
			g_iSmoothDizzy[iPlayer] = BTN_LEFT
		else
			g_iSmoothDizzy[iPlayer] = 0
	}
	g_fCarDizzyTime[iPlayer] = 0.0
}

public use_ufo(iPlayer, iCarEnt)
{
	new iUFOMarkEnt = find_ufo_mark()
	if (is_nullent(iUFOMarkEnt))
		return 0

	new Float:fGameTime = get_gametime()

	new Float:vUFOMarkOrigin[3], Float:vUFOMarkAngles[3], iUFOMarkShift, iUFOsNum
	get_entvar(iUFOMarkEnt, var_origin, vUFOMarkOrigin)
	get_entvar(iUFOMarkEnt, var_angles, vUFOMarkAngles)
	iUFOMarkShift = get_entvar(iUFOMarkEnt, var_skin)
	iUFOsNum = get_entvar(iUFOMarkEnt, var_body)

	if (iUFOsNum <= 0)
		iUFOsNum = UFO_DEFAULT_NUM

	new iUFOSpawnEnt = rg_create_entity(SZ_INFO_TARGET, true)
	if (is_nullent(iUFOSpawnEnt))
		return 0

	engfunc(EngFunc_SetOrigin, iUFOSpawnEnt, vUFOMarkOrigin)
	engfunc(EngFunc_SetSize, iUFOSpawnEnt,
		Float:{ -8.0, -8.0, 0.0 }, Float:{ 8.0, 8.0, 16.0 })

	set_entvar(iUFOSpawnEnt, var_origin, vUFOMarkOrigin)
	set_entvar(iUFOSpawnEnt, var_solid, SOLID_NOT)
	set_entvar(iUFOSpawnEnt, var_movetype, MOVETYPE_NONE)
	set_entvar(iUFOSpawnEnt, var_classname, CLASSNAME_UFOSPAWN)
	set_entvar(iUFOSpawnEnt, var_impulse, IMPULSE_UFOSPAWN)
	set_entvar(iUFOSpawnEnt, var_nextthink, fGameTime + UFO_LIFE)
	set_entvar(iUFOSpawnEnt, var_ufomark, iUFOMarkEnt)

	SetThink(iUFOSpawnEnt, "fwd_UFOSpawnThink")

	new Float:vDir[3]
	angle_vector(vUFOMarkAngles, ANGLEVECTOR_RIGHT, vDir)

	new Float:fOffset = iUFOMarkShift * ((iUFOsNum - 1) / 2.0)
	new Float:vUFOOrigin[3]
	xs_vec_copy(vUFOMarkOrigin, vUFOOrigin)
	vUFOOrigin[0] -= vDir[0] * fOffset
	vUFOOrigin[1] -= vDir[1] * fOffset

	new iUFOEnt
	for (new i, j; i < iUFOsNum; i++)
	{
		iUFOEnt = rg_create_entity(SZ_INFO_TARGET, true)
		if (is_nullent(iUFOEnt))
			continue

		engfunc(EngFunc_SetModel, iUFOEnt, MODEL_UFO)
		engfunc(EngFunc_SetOrigin, iUFOEnt, vUFOOrigin)
		engfunc(EngFunc_SetSize, iUFOEnt, UFO_SIZES)

		set_entvar(iUFOEnt, var_origin, vUFOOrigin)
		set_entvar(iUFOEnt, var_angles, NULL_VECTOR)
		set_entvar(iUFOEnt, var_velocity, NULL_VECTOR)

		set_entvar(iUFOEnt, var_movetype, MOVETYPE_FLY)
		set_entvar(iUFOEnt, var_classname, CLASSNAME_UFO)
		set_entvar(iUFOEnt, var_impulse, IMPULSE_UFO)
		set_entvar(iUFOEnt, var_owner, iCarEnt)
		set_entvar(iUFOEnt, var_gravity, 0.0)
		set_entvar(iUFOEnt, var_ufospawn, iUFOSpawnEnt)

		set_entvar(iUFOEnt, var_animtime, 0.0)
		set_entvar(iUFOEnt, var_sequence, 1)
		set_entvar(iUFOEnt, var_framerate, 1.0)
		// set_entvar(iUFOEnt, var_effects, EF_DIMLIGHT)

		set_entvar(iUFOEnt, var_body, 1)

		j = i % 3
		if (j == 0)
		{
			set_entvar(iUFOEnt, var_skin, 1)
			set_entvar(iUFOEnt, var_solid, SOLID_NOT)
			set_entvar(iUFOEnt, var_nextthink, fGameTime + UFO_MODE_TIME)
		}
		else
		{
			set_entvar(iUFOEnt, var_skin, 0)
			set_entvar(iUFOEnt, var_solid, SOLID_TRIGGER)
			set_entvar(iUFOEnt, var_nextthink, fGameTime + UFO_MODE_TIME * j)
		}

		SetThink(iUFOEnt, "fwd_UFOThink")
		SetTouch(iUFOEnt, "fwd_UFOTouch")

		vUFOOrigin[0] += vDir[0] * iUFOMarkShift
		vUFOOrigin[1] += vDir[1] * iUFOMarkShift
	}

	emit_sound(iCarEnt, CHAN_AUTO, SOUND_UFO_LAUNCH, 0.8, ATTN_NORM, 0, PITCH_NORM)

	return iUFOEnt
}

find_ufo_mark()
{
	new iCheckPointsNum = ArraySize(g_aCPEnts)

	new iMaxPassedCP = -1, iMaxCPId = -1
	for (new iPlayer = 1, iPos, iCPId; iPlayer <= MAX_PLAYERS; iPlayer++)
	{
		if (g_pgsPlayerGameState[iPlayer] != PGS_INGAME)
			continue

		if (iMaxPassedCP >= g_iPlayerPassedCP[iPlayer])
			continue

		iPos = g_iPlayerCurrLoop[iPlayer]
		if (iPos >= g_pCvarLapsNum)
			continue

		iCPId = g_iPlayerPrevCPId[iPlayer]
		if (iCPId < 0)
			continue

		if (g_iPlayerNextCP[iPlayer] == g_iFinishCP && iPos + 1 >= g_pCvarLapsNum)
			iCPId = 0
		else
			iCPId = (iCPId + 2) % iCheckPointsNum

		iMaxCPId = iCPId
		iMaxPassedCP = g_iPlayerPassedCP[iPlayer]
	}

	if (iMaxCPId < 0)
		return 0

	new eCPEnts[DataCPEnts]
	ArrayGetArray(g_aCPEnts, iMaxCPId, eCPEnts)

	new iUFOMarkEnt = eCPEnts[CPENT_UFO]
	if (iUFOMarkEnt <= 0)
		return 0

	new iUFOSpawnEnt
	while ((iUFOSpawnEnt = rg_find_ent_by_class(iUFOSpawnEnt, CLASSNAME_UFOSPAWN)))
	{
		if (get_entvar(iUFOSpawnEnt, var_ufomark) == iUFOMarkEnt)
			return 0
	}

	return iUFOMarkEnt
}

public fwd_ItemboxThink(iItemBox)
{
	set_entvar(iItemBox, var_solid, SOLID_TRIGGER)
	set_entvar(iItemBox, var_effects, 0)
	set_entvar(iItemBox, var_nextthink, -1.0)
}

public fwd_PlayerSpawn_Post(iPlayer)
{
	if (!is_user_alive(iPlayer))
		return HAM_IGNORED

	prepare_player(iPlayer)

	return HAM_IGNORED
}

public fwd_TouchMultiple_Pre(iEnt, iToucher)
{
	if (!iToucher || get_entvar(iToucher, var_impulse) != IMPULSE_CAR)
		return HAM_IGNORED

	static iImpulse
	iImpulse = get_entvar(iEnt, var_impulse)

	switch (iImpulse)
	{
		case IMPULSE_CHECKPOINT: return touch_checkpoint(iEnt, iToucher)
		case IMPULSE_RESETZONE: return touch_reset_zone(iEnt, iToucher)
		case IMPULSE_GRASS: return touch_grass_zone(iEnt, iToucher)
	}

	return HAM_IGNORED
}

touch_checkpoint(iEnt, iToucher)
{
	new iPlayer = get_entvar(iToucher, var_owner)
	if (!iPlayer || g_pgsPlayerGameState[iPlayer] != PGS_INGAME)
		return HAM_IGNORED

	new iNextCP = g_iPlayerNextCP[iPlayer]

	if (iNextCP != iEnt)
		return HAM_IGNORED

	new iCheckPointsNum = ArraySize(g_aCPEnts)
	new iCPId = (g_iPlayerPrevCPId[iPlayer] + 1) % iCheckPointsNum
	new eCPEnts[DataCPEnts]

	ArrayGetArray(g_aCPEnts, iCPId, eCPEnts)
	new iResetEnt = eCPEnts[CPENT_RESET]
	if (iResetEnt > 0)
	{
		get_entvar(iResetEnt, var_origin, g_vSpawnOrigin[iPlayer])
		get_entvar(iResetEnt, var_angles, g_vSpawnAngles[iPlayer])
	}

	ArrayGetArray(g_aCPEnts, (iCPId + 1) % iCheckPointsNum, eCPEnts)
	iNextCP = eCPEnts[CPENT_CP]

	if (iEnt == g_iFinishCP)
	{
		new iCurrLoop = g_iPlayerCurrLoop[iPlayer] + 1
		g_iPlayerCurrLoop[iPlayer] = iCurrLoop

		if (iCurrLoop >= g_pCvarLapsNum)
		{
			iNextCP = -1

			new iSoundFinishId
			if (g_iFinPlayersNum < 4)
				iSoundFinishId = g_iFinPlayersNum + 1
			client_cmd(iPlayer, "spk ^"%s^"", SOUNDS_FINISH[iSoundFinishId])

			new Float:fPlayerFrags
			fPlayerFrags = get_entvar(iPlayer, var_frags)
			fPlayerFrags += MAX_PLAYERS - g_iFinPlayersNum
			set_entvar(iPlayer, var_frags, fPlayerFrags)

			message_begin(MSG_ALL, g_msgScoreInfo)
			write_byte(iPlayer)
			write_short(floatround(fPlayerFrags))
			write_short(0)
			write_short(0)
			write_short(get_member(iPlayer, m_iTeam))
			message_end()

			client_print(iPlayer, print_center, "%L", iPlayer, "KART_FINISH")
			set_car_waiting(iToucher)

			if (!task_exists(TASK_ENDING))
			{
				new iParams[1]
				iParams[0] = ENDING_TIME
				set_task(1.0, "task_ending", TASK_ENDING, iParams, 1)
			}

			if (++g_iFinPlayersNum <= MAX_POS_LIST_ROWS)
			{
				new iMins, iSeconds, iMSecond
				iMSecond = floatround((get_gametime() - g_fStartTime) * 10.0, floatround_floor)
				iSeconds = iMSecond / 10 % 60
				iMins = iMSecond / 10 / 60
				iMSecond %= 10

				new iLen = g_iPosListStart
				iLen += formatex(g_szPosList[iLen], charsmax(g_szPosList),
					"%i: %i:%02i:%02i %n^n", g_iFinPlayersNum, iMins, iSeconds, iMSecond, iPlayer)
				g_iPosListStart = iLen
			}

			set_ui_pos(iPlayer, g_iFinPlayersNum)
			g_iPlayerCurrPos[iPlayer] = g_iFinPlayersNum

			reset_player_item(iPlayer)
		}
		else
		{
			set_ui_lap(iPlayer, iCurrLoop + 1)
			if (iCurrLoop == g_pCvarLapsNum - 1)
			{
				client_cmd(iPlayer, "spk ^"%s^"", SOUND_FINAL_LAP)
				client_print(iPlayer, print_center, "%L", iPlayer, "KART_FINAL_LAP")
			}
			else
			{
				client_print(iPlayer, print_center, "%L", iPlayer, "KART_LAP", iCurrLoop + 1)
			}
		}
	}

	g_iPlayerPrevCPId[iPlayer] = iCPId
	g_iPlayerNextCP[iPlayer] = iNextCP
	g_iPlayerPassedCP[iPlayer]++
	update_pos_list()

	return HAM_IGNORED
}

touch_reset_zone(iEnt, iToucher)
{
	#pragma unused iEnt

	new iPlayer = get_entvar(iToucher, var_owner)
	if (!iPlayer)
		return HAM_IGNORED

	reset_car(iToucher, iPlayer)
	return HAM_IGNORED
}

touch_grass_zone(iEnt, iToucher)
{
	#pragma unused iEnt

	new iPlayer = get_entvar(iToucher, var_owner)
	if (!iPlayer)
		return HAM_IGNORED

	g_fCarGrassTime[iPlayer] = get_gametime() + GRASS_TIME
	return HAM_IGNORED
}

public fwd_ItemboxTouch(iItemboxEnt, iToucher)
{
	if (!iToucher || get_entvar(iToucher, var_impulse) != IMPULSE_CAR)
		return HC_CONTINUE

	new iPlayer = get_entvar(iToucher, var_owner)
	if (!iPlayer || g_kitPlayerItem[iPlayer] > KIT_NULL)
		return HC_CONTINUE

	set_entvar(iItemboxEnt, var_solid, SOLID_NOT)
	set_entvar(iItemboxEnt, var_effects, EF_NODRAW)
	set_entvar(iItemboxEnt, var_nextthink, get_gametime() + ITEMBOX_RESPAWN_TIME)

	new iPlayerPos = g_iPlayerCurrPos[iPlayer]

	new iItems[_:KIT_END], iItemsNum
	for (new i, iPosMin, iPosMax; i < _:KIT_END; i++)
	{
		iPosMin = g_kitemProps[i][KITEM_POS_MIN]
		iPosMax = g_kitemProps[i][KITEM_POS_MIN]

		if (iPosMin && iPlayerPos < iPosMin)
			continue

		if (iPosMax && iPlayerPos > iPosMax)
			continue

		if (i == _:KIT_UFO && !find_ufo_mark())
			continue

		iItems[iItemsNum++] = i
	}

	set_player_item(iPlayer, KartItemType:iItems[random(iItemsNum)])
	client_cmd(iPlayer, "spk %s", SOUND_ITEMBOX)

	return HC_CONTINUE
}

public fwd_SnowballTouch(iSnowballEnt, iToucher)
{
	if (!iToucher)
		return HC_CONTINUE

	new iOwnerCar = get_entvar(iSnowballEnt, var_owner)

	if (iToucher == iOwnerCar)
		return HC_CONTINUE

	new iImpulse = get_entvar(iToucher, var_impulse)

	switch (iImpulse)
	{
		case IMPULSE_CAR:
		{
			new iPlayer = get_entvar(iToucher, var_owner)
			if (!iPlayer)
				return HC_CONTINUE

			if (g_fCarGloveEnt[iPlayer])
			{
				if (g_kitPlayerItem[iPlayer] == KIT_NULL)
					set_player_item(iPlayer, KIT_SNOWBALL, 1)
				remove_glove(iPlayer)
				set_entvar(iSnowballEnt, var_flags, FL_KILLME)
				emit_sound(iToucher, CHAN_AUTO, SOUND_CATCH, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
				return HC_CONTINUE
			}

			new Float:fGameTime = get_gametime()

			if (g_fCarChillTime[iPlayer] < fGameTime)
			{
				g_fCarChillTime[iPlayer] = fGameTime + CHILL_TIME
			}
			else
			{
				g_fCarChillTime[iPlayer] += CHILL_TIME
			}

			new Float:vVelocity[3]
			vVelocity[0] = g_vCarVelocity[iPlayer][0]
			vVelocity[1] = g_vCarVelocity[iPlayer][1]

			if (xs_vec_len_2d(vVelocity) > CHILL_MAX_FORCE)
			{
				xs_vec_normalize(vVelocity, vVelocity)
				xs_vec_mul_scalar(vVelocity, CHILL_MAX_FORCE, vVelocity)
				g_vCarVelocity[iPlayer][0] = vVelocity[0]
				g_vCarVelocity[iPlayer][1] = vVelocity[1]
			}

			g_fCarEngineForce[iPlayer] = floatclamp(g_fCarEngineForce[iPlayer], -CHILL_MAX_FORCE, CHILL_MAX_FORCE)

			new Float:vOrigin[3]
			get_entvar(iSnowballEnt, var_origin, vOrigin)

			engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, vOrigin, 0)
			write_byte(TE_SPRITETRAIL)
			engfunc(EngFunc_WriteCoord, vOrigin[0])
			engfunc(EngFunc_WriteCoord, vOrigin[1])
			engfunc(EngFunc_WriteCoord, vOrigin[2])
			engfunc(EngFunc_WriteCoord, vOrigin[0])
			engfunc(EngFunc_WriteCoord, vOrigin[1])
			engfunc(EngFunc_WriteCoord, vOrigin[2] + 20.0)
			write_short(g_sprSnowballGib)
			write_byte(12)
			write_byte(1)
			write_byte(4)
			write_byte(30)
			write_byte(10)
			message_end()

			new iAttacker
			if (iOwnerCar)
				iAttacker = get_entvar(iOwnerCar, var_owner)
			show_hit_message(iAttacker, iPlayer, CLASSNAME_SNOWBALL)

			emit_sound(iToucher, CHAN_AUTO, SOUND_SNOWBALL_HIT, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			fm_set_rendering(iToucher, kRenderFxGlowShell, 84, 231, 247, kRenderNormal, 16)

			set_entvar(iSnowballEnt, var_flags, FL_KILLME)
		}
		case IMPULSE_BLOWFISH:
		{
			set_entvar(iSnowballEnt, var_flags, FL_KILLME)
			set_entvar(iToucher, var_flags, FL_KILLME)
		}
	}

	return HC_CONTINUE
}

public fwd_BlowfishTouch(iBlowfishEnt, iToucher)
{
	if (!iToucher || get_entvar(iToucher, var_impulse) != IMPULSE_CAR)
		return HC_CONTINUE

	new iOwnerCar = get_entvar(iBlowfishEnt, var_owner)

	if (iToucher == iOwnerCar)
		return HC_CONTINUE

	new iPlayer = get_entvar(iToucher, var_owner)
	if (!iPlayer)
		return HC_CONTINUE

	if (g_fCarGloveEnt[iPlayer])
	{
		if (g_kitPlayerItem[iPlayer] == KIT_NULL)
			set_player_item(iPlayer, KIT_BLOWFISH, 1)
		remove_glove(iPlayer)
		set_entvar(iBlowfishEnt, var_flags, FL_KILLME)
		emit_sound(iToucher, CHAN_AUTO, SOUND_CATCH, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		return HC_CONTINUE
	}

	emit_sound(iToucher, CHAN_AUTO, SOUND_COMMON_HIT, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	hit_player_car(iPlayer, iToucher, BLOWFISH_UNCONTOL_TIME, 720.0 / BLOWFISH_UNCONTOL_TIME)

	new iAttacker
	if (iOwnerCar)
		iAttacker = get_entvar(iOwnerCar, var_owner)
	show_hit_message(iAttacker, iPlayer, CLASSNAME_BLOWFISH)

	set_entvar(iBlowfishEnt, var_flags, FL_KILLME)

	return HC_CONTINUE
}

public fwd_TornadoThink(iTornadoEnt)
{
	new Float:fGameTime = get_gametime()
	new Float:fLifeTime = get_entvar(iTornadoEnt, var_lifetime)
	new iTagetCar = get_entvar(iTornadoEnt, var_targetcar)

	if (fLifeTime <= fGameTime)
	{
		if (iTagetCar)
		{
			new iTargetPlayer = get_entvar(iTagetCar, var_owner)
			remove_tornado_warn(iTargetPlayer)
		}
		set_entvar(iTornadoEnt, var_flags, FL_KILLME)
		return HC_CONTINUE
	}

	if (iTagetCar)
	{
		new Float:vOrigin[3], Float:vTargetOrigin[3], Float:vVelocity[3]
		get_entvar(iTornadoEnt, var_origin, vOrigin)
		get_entvar(iTagetCar, var_origin, vTargetOrigin)
		xs_vec_sub(vTargetOrigin, vOrigin, vVelocity)
		xs_vec_normalize(vVelocity, vVelocity)
		xs_vec_mul_scalar(vVelocity, TORNADO_SPEED, vVelocity)
		set_entvar(iTornadoEnt, var_velocity, vVelocity)
	}

	set_entvar(iTornadoEnt, var_nextthink, fGameTime + TORNADO_THINK_DELAY)
	return HC_CONTINUE
}

public fwd_TornadoTouch(iTornadoEnt, iToucher)
{
	if (!iToucher || get_entvar(iToucher, var_impulse) != IMPULSE_CAR)
		return HC_CONTINUE

	new iOwnerCar = get_entvar(iTornadoEnt, var_owner)

	if (iToucher == iOwnerCar)
		return HC_CONTINUE

	new iPlayer = get_entvar(iToucher, var_owner)
	if (!iPlayer)
		return HC_CONTINUE

	new iTagetCar = get_entvar(iTornadoEnt, var_targetcar)
	if (iTagetCar)
	{
		new iTargetPlayer = get_entvar(iTagetCar, var_owner)
		remove_tornado_warn(iTargetPlayer)
	}

	if (g_fCarGloveEnt[iPlayer])
	{
		if (g_kitPlayerItem[iPlayer] == KIT_NULL)
			set_player_item(iPlayer, KIT_TORNADO, 1)
		remove_glove(iPlayer)
		set_entvar(iTornadoEnt, var_flags, FL_KILLME)
		emit_sound(iToucher, CHAN_AUTO, SOUND_CATCH, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		return HC_CONTINUE
	}

	emit_sound(iToucher, CHAN_AUTO, SOUND_TORNADO_HIT, 1.0, ATTN_NORM, 0, PITCH_NORM)

	new iAttacker
	if (iOwnerCar)
		iAttacker = get_entvar(iOwnerCar, var_owner)
	show_hit_message(iAttacker, iPlayer, CLASSNAME_TORNADO)

	set_entvar(iTornadoEnt, var_flags, FL_KILLME)

	if (g_fCarDizzyEnt[iPlayer])
		remove_dizzy(iPlayer)
	else
		set_dizzy(iPlayer, iToucher)

	return HC_CONTINUE
}

public fwd_DizzyThink(iDizzyEnt)
{
	new Float:fGameTime = get_gametime()
	new Float:fLifeTime = get_entvar(iDizzyEnt, var_lifetime)
	new Float:fFrame = floatmin(5.0, fLifeTime - fGameTime) - 1.0

	set_entvar(iDizzyEnt, var_frame, fFrame)
	set_entvar(iDizzyEnt, var_nextthink, fGameTime + 1.0)
	return HC_CONTINUE
}

update_ui(iUIEnt, iPosBody, iLapBody, iItemBody)
{
	set_entvar(iUIEnt, var_body,
		iItemBody * UI_LAP_NUM * UI_POS_NUM
		+ iLapBody * UI_POS_NUM + iPosBody)
}

set_ui_pos(iPlayer, iPos)
{
	new iUIEnt = g_iUIEnt[iPlayer]
	if (!iUIEnt)
		return

	new iBody = get_entvar(iUIEnt, var_body)
	new iPosBody = iPos - 1,
		iLapBody = (iBody % (UI_LAP_NUM * UI_POS_NUM)) / UI_POS_NUM,
		iItemBody = iBody / (UI_LAP_NUM * UI_POS_NUM)

	update_ui(iUIEnt, iPosBody, iLapBody, iItemBody)
}

set_ui_lap(iPlayer, iLap)
{
	new iUIEnt = g_iUIEnt[iPlayer]
	if (!iUIEnt)
		return

	new iBody = get_entvar(iUIEnt, var_body)
	new iPosBody = iBody % UI_POS_NUM,
		iLapBody = iLap - 1,
		iItemBody = iBody / (UI_LAP_NUM * UI_POS_NUM)

	update_ui(iUIEnt, iPosBody, iLapBody, iItemBody)
}

set_ui_item(iPlayer, KartItemType:kitItem, iAmmo)
{
	new iUIEnt = g_iUIEnt[iPlayer]
	if (!iUIEnt)
		return

	new iBody = get_entvar(iUIEnt, var_body)
	new iPosBody = iBody % UI_POS_NUM,
		iLapBody = (iBody % (UI_LAP_NUM * UI_POS_NUM)) / UI_POS_NUM,
		iItemBody = _:kitItem

	update_ui(iUIEnt, iPosBody, iLapBody, iItemBody)

	if (--iAmmo < 0)
		iAmmo = 0
	set_entvar(iUIEnt, var_skin, iAmmo)
}

public fwd_StartSound(iRecipients, iEnt, iChannel, const szSample[], iVolume, Float:fAttn, iFlags, iPitch)
{
	if (iEnt > 0 && iEnt <= MAX_PLAYERS)
		return HC_SUPERCEDE

	return HC_CONTINUE
}

public fwd_ClientKill(iPlayer)
{
	return FMRES_SUPERCEDE
}

public fwd_HideWeapon()
{
	set_msg_arg_int(1, ARG_BYTE, get_msg_arg_int(1) | 59)
}

public fwd_ResetHUD(iPlayer)
{
	message_begin(MSG_ONE, g_msgHideWeapon, _, iPlayer)
	write_byte(57 | (1<<1))
	message_end()
}

public blocked(iPlayer)
{
	return PLUGIN_HANDLED
}

show_hit_message(iAttacker, iVictim, const szItemClassname[])
{
	emessage_begin(MSG_ALL, g_msgDeathMsg)
	ewrite_byte(iAttacker)
	ewrite_byte(iVictim)
	ewrite_byte(0)
	ewrite_string(szItemClassname)
	emessage_end()
}

get_player_menu(iPlayer)
{
	new iOldMenu, iMenu
	player_menu_info(iPlayer, iOldMenu, iMenu)
	return iMenu
}

reverse_ent(iEnt, Float:vPivot[3])
{
	new Float:vOrigin[3], Float:vAngles[3]

	get_entvar(iEnt, var_origin, vOrigin)
	get_entvar(iEnt, var_angles, vAngles)

	vOrigin[0] = vPivot[0] - (vOrigin[0] - vPivot[0])
	vOrigin[1] = vPivot[1] - (vOrigin[1] - vPivot[1])

	vAngles[1] += 180.0
	if (vAngles[1] >= 360.0)
		vAngles[1] -= 360.0

	set_entvar(iEnt, var_origin, vOrigin)
	set_entvar(iEnt, var_angles, vAngles)
}

public _kart_car_get_char(plugin, num_params)
{
	new iCarEnt = get_param(1)
	return get_car_char(iCarEnt)
}

public _kart_car_get_entity(plugin, num_params)
{
	new iPlayer = get_param(1)
	return g_iCarsEnt[iPlayer]
}

public GameState:_kart_game_state_get(plugin, num_params)
{
	return g_gsGameState
}

public _kart_car_set_char(plugin, num_params)
{
	enum
	{
		ARG_CAR_ENT = 1,
		ARG_CHAR
	}

	new iCarEnt = get_param(ARG_CAR_ENT)
	new iChar = get_param(ARG_CHAR)
	set_car_char(iCarEnt, iChar)
}

public PlayerGameState:_kart_player_game_state_get(plugin, num_params)
{
	new iPlayer = get_param(1)
	return g_pgsPlayerGameState[iPlayer]
}
