//================================================================================================
// Script Placer Z
// By JR-Imagine
// Visit CoDScript for support: http://codscript.net
//================================================================================================


// Tutorial From Sniperbolt!

// Utilities
#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility; 
#include maps\_zombiemode_zone_manager; 
#include maps\_music;

// DLC3 Utilities
#include maps\dlc3_code;
#include maps\dlc3_teleporter;

main()
{
	level.DLC3 = spawnStruct(); // Leave This Line Or Else It Breaks Everything
	
	// Must Change These To Your Maps
	level.DLC3.createArt = maps\createart\nazi_zombie_building_art::main;
	level.DLC3.createFX = maps\createfx\nazi_zombie_building_fx::main;
	// level.DLC3.myFX = ::preCacheMyFX;
	
	/*--------------------
	 FX
	----------------------*/
	DLC3_FX();
	
	/*--------------------
	 LEVEL VARIABLES
	----------------------*/	
	
	// Variable Containing Helpful Text For Modders -- Don't Remove
	level.modderHelpText = [];
	
	//
	// Change Or Tweak All Of These LEVEL.DLC3 Variables Below For Your Level If You Wish
	//
	
	// Edit The Value In Mod.STR For Your Level Introscreen Place
	level.DLC3.introString = &"nazi zombie tes";
	
	// Weapons. Pointer function automatically loads weapons used in Der Riese.
	level.DLC3.weapons = maps\dlc3_code::include_weapons;
	
	// Power Ups. Pointer function automatically loads power ups used in Der Riese.
	level.DLC3.powerUps =  maps\dlc3_code::include_powerups;
	
	// Adjusts how much melee damage a player with the perk will do, needs only be set once. Stock is 1000.
	level.DLC3.perk_altMeleeDamage = 1000; 
	
	// Adjusts barrier search override. Stock is 400.
	level.DLC3.barrierSearchOverride = 400;
	
	// Adjusts power up drop max per round. Stock is 3.
	level.DLC3.powerUpDropMax = 3;
	
	// _loadout Variables
	level.DLC3.useCoopHeroes = true;
	
	// Bridge Feature
	level.DLC3.useBridge = false;
	
	// Hell Hounds
	level.DLC3.useHellHounds = true;
	
	// Mixed Rounds
	level.DLC3.useMixedRounds = true;
	
	// Magic Boxes -- The Script_Noteworthy Value Names On Purchase Trigger In Radiant
	boxArray = [];
	boxArray[ boxArray.size ] = "start_chest";
	boxArray[ boxArray.size ] = "chest1";
	boxArray[ boxArray.size ] = "chest2";
	boxArray[ boxArray.size ] = "chest3";
	boxArray[ boxArray.size ] = "chest4";
	boxArray[ boxArray.size ] = "chest5";
	level.DLC3.PandoraBoxes = boxArray;
	
	// Initial Zone(s) -- Zone(s) You Want Activated At Map Start
	zones = [];
	zones[ zones.size ] = "start_zone";
	level.DLC3.initialZones = zones;
	
	// Electricity Switch -- If False Map Will Start With Power On
	level.DLC3.useElectricSwitch = true;
	
	// Electric Traps
	level.DLC3.useElectricTraps = true;
	
	// _zombiemode_weapons Variables
	level.random_pandora_box_start = false;
	level.DLC3.usePandoraBoxLight = true;
	level.DLC3.useChestPulls = true;
	level.DLC3.useChestMoves = true;
	level.DLC3.useWeaponSpawn = true;
	level.DLC3.useGiveWeapon = true;
	
	// _zombiemode_spawner Varibles
	level.DLC3.riserZombiesGoToDoorsFirst = true;
	level.DLC3.riserZombiesInActiveZonesOnly = true;
	level.DLC3.assureNodes = true;
	
	// _zombiemode_perks Variables
	level.DLC3.perksNeedPowerOn = true;
	
	// _zombiemode_devgui Variables
	level.DLC3.powerSwitch = true;
	
	/*--------------------
	 FUNCTION CALLS - PRE _Load
	----------------------*/
	level thread DLC3_threadCalls();	
	level thread maps\healing_grenade::main();
	level thread maps\_speed2::main();
	level thread maps\_better_pump::main();
	level thread maps\perk_upgrade_system::main();
	level thread maps\_jug2::main();
	level thread maps\_cannon::main();
	
	/*--------------------
	 ZOMBIE MODE
	----------------------*/
	[[level.DLC3.weapons]]();
	[[level.DLC3.powerUps]]();
	
	maps\_zombiemode::main();
	array_thread(get_players(), ::give_gun_on_spawn_think);
	
	maps\_zombiemode_perks_black_ops::bo_perks_thread();
	thread maps\zom_counter::zom_counter_bc();
	//thread anti_cheat();
	
	/*--------------------
	 FUNCTION CALLS - POST _Load
	----------------------*/
	level.zone_manager_init_func = ::dlc3_zone_init;
	level thread DLC3_threadCalls2();
}

dlc3_zone_init()
{

	add_adjacent_zone( "start_zone", "zone1", "enter_zone1" );
	add_adjacent_zone( "zone1", "zone2", "enter_zone2" );
	/*
	=============
	///ScriptDocBegin
	"Name: add_adjacent_zone( <zone_1>, <zone_2>, <flag>, <one_way> )"
	"Summary: Sets up adjacent zones."
	"MandatoryArg: <zone_1>: Name of first Info_Volume"
	"MandatoryArg: <zone_2>: Name of second Info_Volume"
	"MandatoryArg: <flag>: Flag to be set to initiate zones"
	"OptionalArg: <one_way>: Make <zone_1> adjacent to <zone_2>. Defaults to false."
	"Example: add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );"
	///ScriptDocEnd
	=============
	*/

	// Outside East Door
	//add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );
}

anti_cheat()
{
	setdvar ("god", "Not Allowed");
	setdvar ("ufo", "Not Allowed");
	setdvar ("noclip", "Not Allowed");
	setdvar ("give", "Not Allowed");
	setdvar ("demigod", "Not Allowed");
	setdvar ("notarget", "Not Allowed");
	setdvar ("jumptonode", "Not Allowed");
	setdvar ("thereisacow", "Not Allowed");
	setdvar ("player_sprintunlimited", "Not Allowed");
	setdvar ("sf_use_ignoreammo", "Not Allowed");
	

	// floating
	meleedamage = getdvar ("player_meleedamagemultiplier");
	res_range = getdvar ("player_revivetriggerRadius");  
	bleed_out = getdvar ("player_laststandbleedouttime"); 
	melee_range = getdvar ("player_meleerange");
	clip_size = getdvar ("player_clipsizemultiplier");
	speed = getdvar ("g_speed"); 
	gravity = getdvar ("g_gravity"); 
	death_delay = getdvar ("g_deathdelay"); 
	perk_1 = getdvar ("perk_overheatreduction"); 
	arcade = getdvar ("arcademode_score_revive"); 
	ammo = getdvar ("player_sustainammo");
while(1)
	{
	if( GetDvarInt( "player_meleedamagemultiplier" ) != meleedamage ||
		GetDvarInt( "player_revivetriggerRadius" ) != res_range ||
		GetDvarInt( "player_laststandbleedouttime" ) != bleed_out || 
		GetDvarInt( "player_meleerange" ) != melee_range ||
		GetDvarInt( "player_clipsizemultiplier" ) != clip_size ||
		GetDvarInt( "g_speed" ) != speed ||
		GetDvarInt( "g_gravity" ) != gravity ||
		GetDvarInt( "g_deathdelay" ) != death_delay ||
		GetDvarInt( "perk_overheatreduction" ) != perk_1 ||
		GetDvarInt( "arcademode_score_revive" ) != arcade ||
		GetDvarInt( "player_sustainammo" ) != ammo)
		{
			setsaveddvar ("player_meleedamagemultiplier", "0.4");
			setsaveddvar ("player_revivetriggerRadius", "64");
			setsaveddvar ("player_laststandbleedouttime", "30");
			setsaveddvar ("player_meleerange", "64");
			setsaveddvar ("player_clipsizemultiplier", "1");
			setsaveddvar ("g_speed", "190");
			setsaveddvar ("g_gravity", "800");
			setsaveddvar ("g_deathdelay", "4000");
			setsaveddvar ("perk_overheatreduction", "0.7");
			setsaveddvar ("arcademode_score_revive", "100");
			setsaveddvar ("player_sustainammo", "0");
		}
	wait 1;
	}
}

// Attempts to fix the "no gun on respawn" error
give_gun_on_spawn_think()
{
    self endon("disconnect");
    flag_wait("all_players_spawned");
    //iPrintLn("Running loop on player " + self GetEntityNumber());
    while(true)
    {
        self waittill("spawned_player");
        wait_network_frame();
        wait(0.05);
        //iPrintLn("Giving a weapon to respawned player " + self GetEntityNumber());
        self GiveWeapon("zombie_tac45");
        self SwitchToWeapon("zombie_tac45");
    }
}