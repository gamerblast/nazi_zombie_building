#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_zombiemode_utility;

init()
{
	vending_triggers = GetEntArray( "zombie_vending_black_ops", "targetname" );
	
	
	if ( vending_triggers.size < 1 )
	{
		return;
	}


	// this map uses atleast 1 perk machine
	PrecacheItem( "zombie_perk_bottle_doubletap" );
	PrecacheItem( "zombie_perk_bottle_jugg" );
	PrecacheItem( "zombie_perk_bottle_revive" );
	PrecacheItem( "zombie_perk_bottle_sleight" );

	PrecacheShader( "vending_phd_shader" );       
	PrecacheShader( "vending_staminup_shader" );
	PrecacheShader( "vending_mule_kick_shader" );       
	PrecacheShader( "vending_deadshot_shader" );
	
	level._effect["sleight_light"] = loadfx("misc/fx_zombie_cola_on");
	level._effect["doubletap_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
	level._effect["jugger_light"] = loadfx("misc/fx_zombie_cola_jugg_on");
	level._effect["revive_light"] = loadfx("misc/fx_zombie_cola_revive_on");
	level._effect["packapunch_fx"] = loadfx("maps/zombie/fx_zombie_packapunch");




	//level._effect["sleight_light"] = loadfx("misc/fx_zombie_cola_on");


	set_zombie_var( "zombie_perk_cost",					2000 );
	set_zombie_var( "zombie_perk_juggernaut_health",	320 );

	// this map uses atleast 1 perk machine
	
	
	
	array_thread( vending_triggers, ::vending_trigger_think );
	//array_thread( vending_triggers, :: electric_perks_dialog);

	
	level thread turn_phd_flopper_on();
	level thread turn_mule_kick_on();
	level thread turn_staminup_on();
	level thread turn_deadshot_on();


}

turn_phd_flopper_on()
{
	machine = getentarray("vending_phd_flopper", "targetname");
	
	flag_wait("electricity_on");
	
	for( i = 0; i < machine.size; i++ )
	{
		machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
		machine[i] playsound("perks_power_on");
		machine[i] thread perk_fx("jugger_light");
	}
	level notify( "specialty_detectexplosive_on" );
}

turn_deadshot_on()
{
	

	machine = getentarray("vending_deadshot", "targetname");
	
	flag_wait("electricity_on");
	
	for( i = 0; i < machine.size; i++ )
	{
		machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
		machine[i] playsound("perks_power_on");
		machine[i] thread perk_fx( "doubletap_light" );
	}
	level notify( "specialty_bulletaccuracy_on" );
}

turn_staminup_on()
{

	machine = getentarray("vending_staminup", "targetname");
	
	flag_wait("electricity_on");
	
	for( i = 0; i < machine.size; i++ )
	{
		machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
		machine[i] playsound("perks_power_on");
		machine[i] thread perk_fx( "doubletap_light" );
	}
	level notify( "specialty_longersprint_on" );
}

turn_mule_kick_on()
{
	machine = getentarray("vending_mule_kick", "targetname");
	
	flag_wait("electricity_on");
	
	for( i = 0; i < machine.size; i++ )
	{
		machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
		machine[i] playsound("perks_power_on");
		machine[i] thread perk_fx( "sleight_light" );
	}
	level notify( "specialty_extraammo_on" );
}



perk_fx( fx )
{
	wait(3);
	//playfxontag( level._effect[ fx ], self, "tag_origin" );

    self.fx_playing = spawn("script_model",self.origin + (0,0,20));
    self.fx_playing setmodel("tag_origin");
    self.fx_playing.angles = (0, self.angles[1] + 90, 0 );
    playfxontag( level._effect[ fx ], self.fx_playing, "tag_origin" );
}






vending_trigger_think()
{

	//self thread turn_cola_off();
	
	perk = self.script_noteworthy;

	self SetHintString( &"ZOMBIE_FLAMES_UNAVAILABLE" );

	self SetCursorHint( "HINT_NOICON" );
	self UseTriggerRequireLookAt();

	notify_name = perk + "_power_on";
	flag_wait("electricity_on");
	//level waittill( notify_name );
	
	perk_hum = spawn("script_origin", self.origin);
	perk_hum playloopsound("perks_machine_loop");

	self thread check_player_has_perk(perk);
	
	self vending_set_hintstring(perk);
	
	for( ;; )
	{
		self waittill( "trigger", player );
		index = maps\_zombiemode_weapons::get_player_index(player);
		
		cost = level.zombie_vars["zombie_perk_cost"];
		switch( perk )
		{
		case "specialty_detectexplosive": //phd flopper
			cost = 2000;
			break;
		
		case "specialty_longersprint": //staminup
			cost = 2000;
			break;	
			
		case "specialty_extraammo": //mule kick
			cost = 4000;
			break;	
			
		case "specialty_bulletaccuracy": //deadshot
			cost = 1000;
			break;
		}

		if (player maps\_laststand::player_is_in_laststand() )
		{
			continue;
		}

		if(player in_revive_trigger())
		{
			continue;
		}
		
		if( player isThrowingGrenade() )
		{
			wait( 0.1 );
			continue;
		}
		
		if( player isSwitchingWeapons() )
		{
			wait(0.1);
			continue;
		}

		/*if ( player HasPerk( perk ) )
		{
			cheat = false;

			/#
			if ( GetDVarInt( "zombie_cheat" ) >= 5 )
			{
				cheat = true;
			}
			#/

			if ( cheat != true )
			{
				//player iprintln( "Already using Perk: " + perk );
				self playsound("deny");
				player thread play_no_money_perk_dialog();

				
				continue;
			}
		}*/
			
		if ( player HasPerk( perk ) )
		{
			cheat = false;

			/#
			if ( GetDVarInt( "zombie_cheat" ) >= 5 )
			{
				cheat = true;
			}
			#/

			if ( cheat != true )
			{
				//player iprintln( "Already using Perk: " + perk );
				self playsound("deny");
				player thread play_no_money_perk_dialog();
					
				continue;
			}
		}
		// END PERK LIMIT //

		if ( player.score < cost )
		{
			//player iprintln( "Not enough points to buy Perk: " + perk );
			self playsound("deny");
			player thread play_no_money_perk_dialog();
			continue;
		}

		sound = "bottle_dispense3d";
		player achievement_notify( "perk_used" );
		playsoundatposition(sound, self.origin);
		player maps\_zombiemode_score::minus_to_player_score( cost ); 
		///bottle_dispense
		switch( perk )
		{
		case "specialty_detectexplosive":
			sound = "mx_jugger_sting";
			break;



		default:
			sound = "mx_jugger_sting";
			break;
		}

		//self thread play_vendor_stings(sound);
	
		//self waittill("sound_done");


		// do the drink animation
		gun = player perk_give_bottle_begin(perk);
		player.is_drinking = 1;
		player waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );

		// restore player controls and movement
		player perk_give_bottle_end( gun, perk);
		player.is_drinking = undefined;
		// TODO: race condition?
		if ( player maps\_laststand::player_is_in_laststand() )
		{
			continue;
		}

		player SetPerk( perk );
		//player thread perk_vo("specialty_armorvest");
		player setblur( 4, 0.1 );
		wait(0.1);
		player setblur(0, 0.1);
		//earthquake (0.4, 0.2, self.origin, 100);
		if(perk == "specialty_armorvest")
		{
			player.maxhealth = level.zombie_vars["zombie_perk_juggernaut_health"];
			player.health = level.zombie_vars["zombie_perk_juggernaut_health"];
			player.health = 320;
		}

		
		player perk_hud_create( perk );

		//stat tracking
		player.stats["perks"]++;

		//player iprintln( "Bought Perk: " + perk );
		bbPrint( "zombie_uses: playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type perk",
			player.playername, player.score, level.round_number, cost, perk, self.origin );

		player thread perk_think( perk );

	}
}



vending_set_hintstring( perk )
{
	switch( perk )
	{

	case "specialty_detectexplosive":
		self SetHintString( "Press & hold &&1 to buy PHD-Flopper [Cost: 2000]" );
		break;
		
	case "specialty_longersprint":
		self SetHintString( "Press & hold &&1 to buy Stamin-up [Cost: 2000]" );
		break;	
		
	case "specialty_extraammo":
		self SetHintString( "Press & hold &&1 to buy Mule Kick [Cost: 4000]" );
		break;	
		
	case "specialty_bulletaccuracy":
		self SetHintString( "Press & hold &&1 to buy DeadShot Daquiri [Cost: 1000]" );
		break;	
		
	default:
		self SetHintString( perk + " Cost: " + level.zombie_vars["zombie_perk_cost"] );
		break;

	}
}


perk_think( perk )
{
		self waittill_any( "fake_death", "death", "player_downed" );

		self UnsetPerk( "specialty_detectexplosive" );
		self UnsetPerk( "specialty_longersprint" );
		self UnsetPerk( "specialty_extraammo" );
		self UnsetPerk( "specialty_bulletaccuracy" );
		self.maxhealth = 100;
		self perk_hud_destroy( perk );
		//self iprintln( "Perk Lost: " + perk );
}


perk_hud_create( perk )
{
	if ( !IsDefined( self.perk_hud ) )
	{
		self.perk_hud = [];
	}

		shader = "";

		switch( perk )
		{
		case "specialty_detectexplosive":
			shader = "vending_phd_shader";
			break;
			
		case "specialty_longersprint":
			shader = "vending_staminup_shader";
			break;	
			
		case "specialty_extraammo":
			shader = "vending_mule_kick_shader";
			break;	

		case "specialty_bulletaccuracy":
			shader = "vending_deadshot_shader";
			break;				
			
		case "specialty_armorvest":
			shader = "specialty_juggernaut_zombies";
			break;

		case "specialty_quickrevive":
			shader = "specialty_quickrevive_zombies";
			break;

		case "specialty_fastreload":
			shader = "specialty_fastreload_zombies";
			break;

		case "specialty_rof":
			shader = "specialty_doubletap_zombies";
			break;

		default:
			shader = "";
			break;
		}

		t_y = -30;
		hud = create_simple_hud( self );
		hud.foreground = true; 
		hud.sort = 1; 
		hud.hidewheninmenu = false; 
		hud.alignX = "left"; 
		hud.alignY = "bottom";
		hud.horzAlign = "left"; 
		hud.vertAlign = "bottom";
		
		if(!level.tom_use_timmer)
		{
			hud.x = self.perk_hud.size * 30; 
			hud.y = hud.y - 70; 
			hud.alpha = 1;
			hud SetShader( shader, 24, 24 );
		}
		else if(level.tom_use_timmer)
		{
			hud.x = 5; 
			hud.y = t_y - (self.perk_hud.size * 30); 
			hud.alpha = 1;
			hud SetShader( shader, 24, 24 );
		}

		self.perk_hud[ perk ] = hud;
}


perk_hud_destroy( perk )
{
	self.perk_hud[ perk ] destroy_hud();
	self.perk_hud[ perk ] = undefined;
}



perk_give_bottle_end( gun, perk )
{
	assert( gun != "zombie_perk_bottle_doubletap" );
	assert( gun != "zombie_perk_bottle_revive" );
	assert( gun != "zombie_perk_bottle_jugg" );
	assert( gun != "zombie_perk_bottle_sleight" );
	assert( gun != "syrette" );

	self EnableOffhandWeapons();
	self EnableWeaponCycling();

	self AllowLean( true );
	self AllowAds( true );
	self AllowSprint( true );
	self AllowProne( true );		
	self AllowMelee( true );
	weapon = "";
	switch( perk )
	{
	case "specialty_detectexplosive":
		weapon = "zombie_perk_bottle_revive";
		break;

	case "specialty_longersprint":
		weapon = "zombie_perk_bottle_doubletap";
		break;

	case "specialty_extraammo":
		weapon = "zombie_perk_bottle_sleight";
		break;

	case "specialty_bulletaccuracy":
		weapon = "zombie_perk_bottle_doubletap";
		break;
	}

	// TODO: race condition?
	if ( self maps\_laststand::player_is_in_laststand() )
	{
		self TakeWeapon(weapon);
		return;
	}

	if ( gun != "none" && gun != "mine_bouncing_betty" )
	{
		self SwitchToWeapon( gun );
	}
	else 
	{
		// try to switch to first primary weapon
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}

	self TakeWeapon(weapon);
}

perk_vo(type)
{
	self endon("death");
	self endon("disconnect");

	index = maps\_zombiemode_weapons::get_player_index(self);
	sound = undefined;

	if(!isdefined (level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	player_index = "plr_" + index + "_";
	//wait(randomfloatrange(1,2));

//TUEY We need to eventually store the dialog in an array so you can add multiple variants...but we only have 1 now anyway.
	switch(type)
	{
	case "specialty_armorvest":
		sound_to_play = "vox_perk_jugga_0";
		break;
	case "specialty_fastreload":
		sound_to_play = "vox_perk_speed_0";
		break;
	case "specialty_quickrevive":
		sound_to_play = "vox_perk_revive_0";
		break;
	case "specialty_rof":
		sound_to_play = "vox_perk_doubletap_0";
		break; 	
	default:	
		sound_to_play = "vox_perk_jugga_0";
		break;
	}
	
	wait(1.0);
	self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, 0.25);
}
machine_watcher()
{
	//PI ESM - support for two level switches for Factory
	if (isDefined(level.DLC3.perksNeedPowerOn) && level.DLC3.perksNeedPowerOn)
	{
		level thread machine_watcher_factory("juggernog_on");
		level thread machine_watcher_factory("sleight_on");
		level thread machine_watcher_factory("doubletap_on");
		level thread machine_watcher_factory("revive_on");
		level thread machine_watcher_factory("Pack_A_Punch_on");
	}
	else
	{		
		level waittill("master_switch_activated");
		//array_thread(getentarray( "zombie_vending", "targetname" ), ::perks_a_cola_jingle);	
				
	}		
	
}

//PI ESM - added for support for two switches in factory
machine_watcher_factory(vending_name)
{
	level waittill(vending_name);
	switch(vending_name)
	{
		case "juggernog_on":
			temp_script_sound = "mx_jugger_jingle";			
			break;
			
		case "sleight_on":
			temp_script_sound = "mx_speed_jingle";
			break;
			
		case "doubletap_on":
			temp_script_sound = "mx_doubletap_jingle";
			break;
		
		case "revive_on":
			temp_script_sound = "mx_revive_jingle";
			break;
			
		case "Pack_A_Punch_on":
			temp_script_sound = "mx_packa_jingle";
			break;		
		
		default:
			temp_script_sound = "mx_jugger_jingle";
			break;
	}


	temp_machines = getstructarray("perksacola", "targetname");
	for (x = 0; x < temp_machines.size; x++)
	{
		if (temp_machines[x].script_sound == temp_script_sound)
			temp_machines[x] thread perks_a_cola_jingle();
	}

}

play_vendor_stings(sound)
{	
	if(!IsDefined (level.speed_jingle))
	{
		level.speed_jingle = 0;
	}
	if(!IsDefined (level.revive_jingle))
	{
		level.revive_jingle = 0;
	}
	if(!IsDefined (level.doubletap_jingle))
	{
		level.doubletap_jingle = 0;
	}
	if(!IsDefined (level.jugger_jingle))
	{
		level.jugger_jingle = 0;
	}
	if(!IsDefined (level.packa_jingle))
	{
		level.packa_jingle = 0;
	}
	if(!IsDefined (level.eggs))
	{
		level.eggs = 0;
	}
	if (level.eggs == 0)
	{
		if(sound == "mx_speed_sting" && level.speed_jingle == 0 ) 
		{
//			iprintlnbold("stinger speed:" + level.speed_jingle);
			level.speed_jingle = 1;		
			temp_org_speed_s = spawn("script_origin", self.origin);		
			temp_org_speed_s playsound (sound, "sound_done");
			temp_org_speed_s waittill("sound_done");
			level.speed_jingle = 0;
			temp_org_speed_s delete();
//			iprintlnbold("stinger speed:" + level.speed_jingle);
		}
		else if(sound == "mx_revive_sting" && level.revive_jingle == 0)
		{
			level.revive_jingle = 1;
//			iprintlnbold("stinger revive:" + level.revive_jingle);
			temp_org_revive_s = spawn("script_origin", self.origin);		
			temp_org_revive_s playsound (sound, "sound_done");
			temp_org_revive_s waittill("sound_done");
			level.revive_jingle = 0;
			temp_org_revive_s delete();
//			iprintlnbold("stinger revive:" + level.revive_jingle);
		}
		else if(sound == "mx_doubletap_sting" && level.doubletap_jingle == 0) 
		{
			level.doubletap_jingle = 1;
//			iprintlnbold("stinger double:" + level.doubletap_jingle);
			temp_org_dp_s = spawn("script_origin", self.origin);		
			temp_org_dp_s playsound (sound, "sound_done");
			temp_org_dp_s waittill("sound_done");
			level.doubletap_jingle = 0;
			temp_org_dp_s delete();
//			iprintlnbold("stinger double:" + level.doubletap_jingle);
		}
		else if(sound == "mx_jugger_sting" && level.jugger_jingle == 0) 
		{
			level.jugger_jingle = 1;
//			iprintlnbold("stinger juggernog" + level.jugger_jingle);
			temp_org_jugs_s = spawn("script_origin", self.origin);		
			temp_org_jugs_s playsound (sound, "sound_done");
			temp_org_jugs_s waittill("sound_done");
			level.jugger_jingle = 0;
			temp_org_jugs_s delete();
//			iprintlnbold("stinger juggernog:"  + level.jugger_jingle);
		}
		else if(sound == "mx_packa_sting" && level.packa_jingle == 0) 
		{
			level.packa_jingle = 1;
//			iprintlnbold("stinger packapunch:" + level.packa_jingle);
			temp_org_pack_s = spawn("script_origin", self.origin);		
			temp_org_pack_s playsound (sound, "sound_done");
			temp_org_pack_s waittill("sound_done");
			level.packa_jingle = 0;
			temp_org_pack_s delete();
//			iprintlnbold("stinger packapunch:"  + level.packa_jingle);
		}
	}
}

perks_a_cola_jingle()
{	
	self thread play_random_broken_sounds();
	if(!IsDefined(self.perk_jingle_playing))
	{
		self.perk_jingle_playing = 0;
	}
	if (!IsDefined (level.eggs))
	{
		level.eggs = 0;
	}
	while(1)
	{
		//wait(randomfloatrange(60, 120));
		wait(randomfloatrange(31,45));
		if(randomint(100) < 15 && level.eggs == 0)
		{
			level notify ("jingle_playing");
			//playfx (level._effect["electric_short_oneshot"], self.origin);
			playsoundatposition ("electrical_surge", self.origin);
			
			if(self.script_sound == "mx_speed_jingle" && level.speed_jingle == 0) 
			{
				level.speed_jingle = 1;
				temp_org_speed = spawn("script_origin", self.origin);
				wait(0.05);
				temp_org_speed playsound (self.script_sound, "sound_done");
				temp_org_speed waittill("sound_done");
				level.speed_jingle = 0;
				temp_org_speed delete();
			}
			if(self.script_sound == "mx_revive_jingle" && level.revive_jingle == 0) 
			{
				level.revive_jingle = 1;
				temp_org_revive = spawn("script_origin", self.origin);
				wait(0.05);
				temp_org_revive playsound (self.script_sound, "sound_done");
				temp_org_revive waittill("sound_done");
				level.revive_jingle = 0;
				temp_org_revive delete();
			}
			if(self.script_sound == "mx_doubletap_jingle" && level.doubletap_jingle == 0) 
			{
				level.doubletap_jingle = 1;
				temp_org_doubletap = spawn("script_origin", self.origin);
				wait(0.05);
				temp_org_doubletap playsound (self.script_sound, "sound_done");
				temp_org_doubletap waittill("sound_done");
				level.doubletap_jingle = 0;
				temp_org_doubletap delete();
			}
			if(self.script_sound == "mx_jugger_jingle" && level.jugger_jingle == 0) 
			{
				level.jugger_jingle = 1;
				temp_org_jugger = spawn("script_origin", self.origin);
				wait(0.05);
				temp_org_jugger playsound (self.script_sound, "sound_done");
				temp_org_jugger waittill("sound_done");
				level.jugger_jingle = 0;
				temp_org_jugger delete();
			}
			if(self.script_sound == "mx_packa_jingle" && level.packa_jingle == 0) 
			{
				level.packa_jingle = 1;
				temp_org_packa = spawn("script_origin", self.origin);
				temp_org_packa playsound (self.script_sound, "sound_done");
				temp_org_packa waittill("sound_done");
				level.packa_jingle = 0;
				temp_org_packa delete();
			}

			self thread play_random_broken_sounds();
		}		
	}	
}
play_random_broken_sounds()
{
	level endon ("jingle_playing");
	if (!isdefined (self.script_sound))
	{
		self.script_sound = "null";
	}
	if (self.script_sound == "mx_revive_jingle")
	{
		while(1)
		{
			wait(randomfloatrange(7, 18));
			playsoundatposition ("broken_random_jingle", self.origin);
		//playfx (level._effect["electric_short_oneshot"], self.origin);
			playsoundatposition ("electrical_surge", self.origin);
	
		}
	}
	else
	{
		while(1)
		{
			wait(randomfloatrange(7, 18));
		// playfx (level._effect["electric_short_oneshot"], self.origin);
			playsoundatposition ("electrical_surge", self.origin);
		}
	}
}

play_packa_wait_dialog(player_index)
{
	waittime = 0.05;
	if(!IsDefined (self.vox_perk_packa_wait))
	{
		num_variants = maps\_zombiemode_spawner::get_number_variants(player_index + "vox_perk_packa_wait");
		self.vox_perk_packa_wait = [];
		for(i=0;i<num_variants;i++)
		{
			self.vox_perk_packa_wait[self.vox_perk_packa_wait.size] = "vox_perk_packa_wait_" + i;
		}
		self.vox_perk_packa_wait_available = self.vox_perk_packa_wait;
	}
	if(!isdefined (level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	sound_to_play = random(self.vox_perk_packa_wait_available);
	self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, waittime);
	self.vox_perk_packa_wait_available = array_remove(self.vox_perk_packa_wait_available,sound_to_play);
	
	if (self.vox_perk_packa_wait_available.size < 1 )
	{
		self.vox_perk_packa_wait_available = self.vox_perk_packa_wait;
	}
}

play_packa_get_dialog(player_index)
{
	waittime = 0.05;
	if(!IsDefined (self.vox_perk_packa_get))
	{
		num_variants = maps\_zombiemode_spawner::get_number_variants(player_index + "vox_perk_packa_get");
		self.vox_perk_packa_get = [];
		for(i=0;i<num_variants;i++)
		{
			self.vox_perk_packa_get[self.vox_perk_packa_get.size] = "vox_perk_packa_get_" + i;
		}
		self.vox_perk_packa_get_available = self.vox_perk_packa_get;
	}
	if(!isdefined (level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	sound_to_play = random(self.vox_perk_packa_get_available);
	self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, waittime);
	self.vox_perk_packa_get_available = array_remove(self.vox_perk_packa_get_available,sound_to_play);
	
	if (self.vox_perk_packa_get_available.size < 1 )
	{
		self.vox_perk_packa_get_available = self.vox_perk_packa_get;
	}
}

perk_give_bottle_begin( perk )
{
	self DisableOffhandWeapons();
	self DisableWeaponCycling();

	self AllowLean( false );
	self AllowAds( false );
	self AllowSprint( false );
	self AllowProne( false );		
	self AllowMelee( false );

	wait( 0.05 );

	if ( self GetStance() == "prone" )
	{
		self SetStance( "crouch" );
	}

	gun = self GetCurrentWeapon();
	weapon = "";

	switch( perk )
	{
	case "specialty_detectexplosive":
		weapon = "zombie_perk_bottle_revive";
		break;

	case "specialty_longersprint":
		weapon = "zombie_perk_bottle_doubletap";
		break;

	case "specialty_extraammo":
		weapon = "zombie_perk_bottle_sleight";
		break;

	case "specialty_bulletaccuracy":
		weapon = "zombie_perk_bottle_doubletap";
		break;
	}

	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );

	return gun;
}

electric_perks_dialog()
{

	self endon ("warning_dialog");
	level endon("switch_flipped");
	timer =0;
	while(1)
	{
		wait(0.5);
		players = get_players();
		for(i = 0; i < players.size; i++)
		{		
			dist = distancesquared(players[i].origin, self.origin );
			if(dist > 70*70)
			{
				timer = 0;
				continue;
			}
			if(dist < 70*70 && timer < 3)
			{
				wait(0.5);
				timer ++;
			}
			if(dist < 70*70 && timer == 3)
			{
				
				players[i] thread do_player_vo("vox_start", 5);	
				wait(3);				
				self notify ("warning_dialog");
				iprintlnbold("warning_given");
			}
		}
	}
}

play_no_money_perk_dialog()
{
	
	index = maps\_zombiemode_weapons::get_player_index(self);
	
	player_index = "plr_" + index + "_";
	if(!IsDefined (self.vox_nomoney_perk))
	{
		num_variants = maps\_zombiemode_spawner::get_number_variants(player_index + "vox_nomoney_perk");
		self.vox_nomoney_perk = [];
		for(i=0;i<num_variants;i++)
		{
			self.vox_nomoney_perk[self.vox_nomoney_perk.size] = "vox_nomoney_perk_" + i;	
		}
		self.vox_nomoney_perk_available = self.vox_nomoney_perk;		
	}	
	sound_to_play = random(self.vox_nomoney_perk_available);
	
	self.vox_nomoney_perk_available = array_remove(self.vox_nomoney_perk_available,sound_to_play);
	
	if (self.vox_nomoney_perk_available.size < 1 )
	{
		self.vox_nomoney_perk_available = self.vox_nomoney_perk;
	}
			
	self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, 0.25);
	
	
		
	
}
check_player_has_perk(perk)
{
		dist = 128 * 128;
		while(true)
		{
			players = get_players();
			for( i = 0; i < players.size; i++ )
			{
				if(DistanceSquared( players[i].origin, self.origin ) < dist)
				{
					if( !players[i] hasperk(perk) && !(players[i] in_revive_trigger()) && !players[i].being_revived )
						self setVisibleToPlayer(players[i]);
					else
						self setInvisibleToPlayer(players[i]);
				}
			}
			wait(0.1);
		}
}

bo_perks_thread()
{
	players = getplayers();
	for(i=0;i<players.size;i++)
	{
		players[i] thread staminup();
		players[i] thread deadshot();
		players[i] thread mulekick();
		players[i] thread DiveToNuke();
	}
}

staminup()
{
	while(1)
	{
		if(self hasperk("specialty_longersprint"))
		{
			self setClientDvar( "player_sprintSpeedScale", 1.65 );
			self setClientDvar( "player_sprintTime", 10 );
		}
		else
		{
			self setClientDvar( "player_sprintSpeedScale", 1.5 );
			self setClientDvar( "player_sprintTime", 4 );
		}
		wait .5;
	}
}

deadshot()
{
	while(1)
	{
		if(self hasperk("specialty_bulletaccuracy"))
			self setClientDvar( "perk_weapSpreadMultiplier", 0.4225 );
		else
			self setClientDvar( "perk_weapSpreadMultiplier", 0.65 );
		wait .1;
	}
}

mulekick()
{
	while(1)
	{
		if(self hasperk("specialty_extraammo"))
			self.inventorySize = 3;
		else
			self.inventorySize = 2;
		wait .1;
	}
}

DiveToNuke()
{
	self.oldSurface = self.origin[2];
	self.lastStance = self GetStance();
	MinFall = 5;
	for(;;)
	{
		if( self HasPerk( "specialty_detectexplosive" ) )
		{
			if( self GetStance() == "prone" && self IsOnGround() && ( self.lastStance == "stand" || self.lastStance == "crouch" ) )
			{
				self.newSurface = self.origin[2] + 0.007;
				ActualFall = self.oldSurface - self.newSurface;
				if( self.oldSurface > self.newSurface && MinFall < ActualFall )
				{
					self thread Nuke();
					self.oldSurface = self.origin[2];
					wait .2;
				}
			}
			if( self IsOnGround() )
			{
				self.oldSurface = self.origin[2];
				self.lastStance = self GetStance();
			}
		}
		wait .05;
	}
}

Nuke()
{
	self EnableInvulnerability();
	self PlaySound( "nuke_flash" );
	PlayFX( LoadFX( "explosions/default_explosion"), self.origin );
	RadiusDamage( self.origin, 300, 5000, 1000, self );
	self DisableInvulnerability();
}