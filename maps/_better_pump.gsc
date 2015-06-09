#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;
#include maps\_anim; 

main()
{
	flag_wait("all_players_connected"); // waits for all players to be connected 
	level.pump_in_progress = 0; // makes sure that no two pumps go at the same time
	
	players = get_players();
	for(i=0; i<= players.size; i++)
	{
		players[i].yolo = 0;
		players[i].bleedout = 0;
		players[i].revived = 0;
		players[i] thread fake_death();
		players[i] thread real_death();
		players[i] thread player_downed();
	}
	
	jug_pad = getEnt("jug_pad", "targetname"); 
	jug_pump_trig = getEnt("jug_pump_trig", "targetname"); 
	jug_trig = getEnt("specialty_armorvest", "script_noteworthy");
	jug2_trig = GetEnt("jug2_trig", "targetname");
	jug_machine = getEnt("vending_jugg", "targetname");
	jug_machine_on = "zombie_vending_jugg_on";
	jug_machine_off = "zombie_vending_jugg";
	jug_notify = "juggernog_on";
	thread blood_pump(jug_pad, jug_pump_trig, jug_trig, jug2_trig, jug_machine, jug_machine_on, jug_machine_off, jug_notify);
	
	speed_pad = getEnt("speed_pad", "targetname");
	speed_pump_trig = getEnt("speed_pump_trig", "targetname");
	speed_trig = getEnt("specialty_fastreload", "script_noteworthy");
	speed2_trig = GetEnt("speed2_trig", "targetname");
	speed_machine = getEnt("vending_sleight", "targetname");
	speed_machine_on = "zombie_vending_sleight_on";
	speed_machine_off = "zombie_vending_sleight";
	speed_notify = "sleight_on";
	thread blood_pump(speed_pad, speed_pump_trig, speed_trig, speed2_trig, speed_machine, speed_machine_on, speed_machine_off, speed_notify);
	
	quick_pad = getEnt("quick_pad", "targetname");
	quick_pump_trig = getEnt("quick_pump_trig", "targetname");
	quick_trig = getEnt("specialty_quickrevive", "script_noteworthy");
	quick2_trig = GetEnt("quick2_trig", "targetname");
	quick_machine = getEnt("vending_revive", "targetname");
	quick_machine_on = "zombie_vending_revive_on";
	quick_machine_off = "zombie_vending_revive";
	quick_notify = "revive_on";
	thread blood_pump(quick_pad, quick_pump_trig, quick_trig, quick2_trig, quick_machine, quick_machine_on, quick_machine_off, quick_notify);
	
	double_pad = getEnt("double_pad", "targetname");
	double_pump_trig = getEnt("double_pump_trig", "targetname");
	double_trig = getEnt("specialty_rof", "script_noteworthy");
	double2_trig = GetEnt("double2_trig", "targetname");
	double_machine = getEnt("vending_doubletap", "targetname");
	double_machine_on = "zombie_vending_doubletap_on";
	double_machine_off = "zombie_vending_doubletap";
	double_notify = "doubletap_on";
	thread blood_pump(double_pad, double_pump_trig, double_trig, double2_trig, double_machine, double_machine_on, double_machine_off, double_notify);
	
}

blood_pump(perk_pad, perk_pump_trig, perk_trig, perk2_trig, perk_machine, perk_machine_on, perk_machine_off, perk_notify)
{
	finish = 0;
	turned_on_before = 0;
	while(1)
	{
		player = undefined;
		perk_pump_trig SetHintString("Press &&1 to start powering the pump with blood");
		perk_pump_trig waittill("trigger", player);
		if(level.pump_in_progress == 0)
		{
			level.pump_in_progress = 1;
			kills_before_activation = player.stats["kills"];
			perk_pump_trig disable_trigger();
			perk2_trig disable_trigger();
			first_time = 1;
			kills_in_process = undefined;
			display = undefined;
			previous_kills = undefined;
			gun_store = player GetCurrentWeapon();
			player TakeWeapon(gun_store);
			player GiveWeapon( "zombie_ppsh_upgraded" );
			player SwitchToWeapon( "zombie_ppsh_upgraded" );
			player DisableWeaponCycling();
			player DisableOffhandWeapons();
			while(1)
			{
				wait(0.05);
				if(player IsTouching(perk_pad))
				{
				}
				else
				{
					iprintln("Off the pad!");
					break;
				}
				player thread death();
				if(player.yolo == 1)
				{
					break;
				}
				else
				{
				}
				if(IsDefined(kills_in_process))
				{
					previous_kills = kills_in_process;
				}
				kills_after_activation = player.stats["kills"];
				kills_in_process = 5 - (kills_after_activation - kills_before_activation);
				kills_display_text = "Kills required to activate the pump: " + kills_in_process;
				if(first_time == 1)
				{
					display = create_simple_hud(NewClientHudElem(player));
					display.foreground = true; 
					display.sort = 4; 
					display.hidewheninmenu = false; 
					display.alignX = "right"; 
					display.alignY = "top";
					display.horzAlign = "right"; 
					display.vertAlign = "top";
					display.fontScale = 1.5; 
					display.x = -2;  
					display.y = 5; 
					display.color = (1,0,0);
					display setText(kills_display_text);
					first_time = 0;
				}
				else
				{
					wait(0.05);
				}
				if(kills_in_process <= 0)
				{
					finish = 1;
					break;
				}
				else
				{
					if(previous_kills != kills_in_process)
					{
						display destroy();
						display = NewClientHudElem(player);
						display.foreground = true; 
						display.sort = 4; 
						display.hidewheninmenu = false; 
						display.alignX = "right"; 
						display.alignY = "top";
						display.horzAlign = "right"; 
						display.vertAlign = "top";
						display.fontScale = 1.5; 
						display.x = -2;  
						display.y = 5; 
						display.color = (1,0,0);
						display setText(kills_display_text);
					}
					continue;
				}
			}
			display destroy();
			player EnableWeaponCycling();
			player EnableOffhandWeapons();
			player TakeWeapon( "zombie_ppsh_upgraded" );
			if(player.yolo == 0)
			{
				player GiveWeapon( gun_store );
				player SwitchToWeapon( gun_store );
			}
			else
			{
				player thread check_revive();
				player waittill_any("player_revived", "bled_out");
				if(self.revived == 1)
				{
					player GiveWeapon( gun_store );
					player SwitchToWeapon( gun_store );
					self.revived = 0;
				}
				player.yolo = 0;
			}
			if(finish == 1)
			{
				finish = 0;
				perk2_trig enable_trigger();
				if(turned_on_before == 0)
				{
					level notify( perk_notify );
					turned_on_before = 1;
				}
				else
				{
					perk_trig enable_trigger();
					perk_machine setmodel( perk_machine_on );
					perk_machine vibrate((0,-100,0), 0.3, 0.4, 3);
					perk_machine playsound("perks_power_on");
				}
				level.pump_in_progress = 0;
				wait(300);
				perk_trig disable_trigger();
				perk2_trig disable_trigger();
				perk_machine setmodel( perk_machine_off );
				perk_machine playsound("no_cha_ching");
				perk_pump_trig enable_trigger();
				iprintln("A perk has just run out of power!");
				continue;
			}
			else
			{
				perk_pump_trig enable_trigger();
				level.pump_in_progress = 0;
				continue;
			}
		}
		else
		{
			wait(0.05);
		}
	}
}

death()
{
	self waittill_any( "fake_death", "player_downed" );
	if(level.pump_in_progress == 1)
	{
		self.yolo = 1;
	}
}

fake_death()
{
	while(1)
	{
		self waittill("fake_death");
		iprintln("Fake Death");
		wait(0.05);
	}
	
}

real_death()
{
	while(1)
	{
	self waittill("death");
	iprintln("Death");
	wait(0.05);
	}
}

player_downed()
{
	while(1)
	{
	self waittill("player_downed");
	iprintln("Player Downed");
	wait(0.05);
	}
}

check_revive()
{
	self waittill("player_revived");
	self.revived = 1;
}

	
