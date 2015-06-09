#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;

main()
{
	flag_wait("all_players_connected");
	players = get_players();
	
	jug2_trig = GetEnt("jug2_trig", "targetname");
	jug_hintstring = "Press & hold &&1 to buy Juggernog 2.0 [Cost: 1500]";
	jug_cost = 1500;
	
	speed2_trig = GetEnt("speed2_trig", "targetname");
	speed_hintstring = "Press & hold &&1 to buy Speed Cola 2.0[ Cost: 1500]";
	speed_cost = 1500;
	
	double2_trig = GetEnt("double2_trig", "targetname");
	double_hintstring = "Press & hold &&1 to buy Double Tap Root Beer 2.0 [Cost: 1500]";
	double_cost = 1500;
	
	quick2_trig = GetEnt("quick2_trig", "targetname");
	quick_hintstring = "Press & hold &&1 to buy Quick Revive 2.0 [Cost: 1500]";
	quick_cost = 1500;
		
	for(i = 0; i < players.size; i++)
	{
		players[i].hasdouble2 = 0;
		players[i].hasquick2 = 0;
		players[i].hasspeed2 = 0;
		players[i].hasjug2 = 0;
		players[i] thread perk_upgrade("specialty_armorvest", jug2_trig, jug_hintstring, jug_cost);
		players[i] thread perk_upgrade("specialty_fastreload", speed2_trig, speed_hintstring, speed_cost);
		players[i] thread perk_upgrade("specialty_rof", double2_trig, double_hintstring, double_cost);
		players[i] thread perk_upgrade("specialty_quickrevive", quick2_trig, quick_hintstring, quick_cost);
	}
}

perk_upgrade(perk, trigger, hintstring, cost)
{
	trigger SetHintString(hintstring);
	trigger SetCursorHint( "HINT_NOICON" );
	trigger SetInvisibleToPlayer(self);
	while(1)
	{
		while (self HasPerk(perk) == 0)
		{
			wait(0.05);
		}
		wait(0.5);
		while (self HasPerk(perk) == 0)
		{
			wait(0.05);
		}
		trigger SetVisibleToPlayer(self);
		trigger waittill("trigger", player);
		if (self.score >= cost && self HasPerk(perk) && self == player)
		{
			wait(0.05);
			self maps\_zombiemode_score::minus_to_player_score( cost );
			trigger SetInvisibleToPlayer(self);
			gun = maps\_zombiemode_perks::perk_give_bottle_begin( perk );
			self.is_drinking = 1;
			self waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
			self maps\_zombiemode_perks::perk_give_bottle_end( gun, perk );
			self.is_drinking = undefined;
			if ( self maps\_laststand::player_is_in_laststand() || (IsDefined(self.being_revived) && self.being_revived == 1))
			{
				continue;
			}
			switch(perk)
			{
				case "specialty_armorvest": 
					self.hasjug2 = 1;
					break;
				case "specialty_fastreload": 
					self.hasspeed2 = 1;
					break;
				case "specialty_rof":   
					self.hasdouble2 = 1;
					break;
				case "specialty_quickrevive": 
					self.hasquick2 = 1;
					break;
				default:
					break;
			}
			self waittill_any("fake_death", "death", "player_downed");
			switch(perk)
			{
				case "specialty_armorvest":
					self.hasjug2 = 0;
					break;
				case "specialty_fastreload":
					break;
				case "specialty_rof":
					self.hasdouble2 = 0;
					break;
				case "specialty_quickrevive":
					break;
				default:
					break;
			}
			while (IsAlive(self) == 0 || self maps\_laststand::player_is_in_laststand() || (IsDefined(self.being_revived) && self.being_revived == 1))
			{
				wait(0.05);
			}
			
		}
		else
		{
			wait(0.05);
		}
	}	
}		