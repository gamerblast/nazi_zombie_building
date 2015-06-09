#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;
#include maps\_anim; 

main()
{ 
	flag_wait("all_players_connected");
	players = get_players();
	
	cannon_trig = getEnt("cannon_trig", "targetname");
	cannon_trig SetHintString("Press &&1 to use the cannon");
	
	level.cannon_one_in_progress = 0;
	
	for(i=0; i<= players.size; i++)
	{
		players[i].yolo_cannon = 0;
		players[i].bleedout_cannon = 0;
		players[i].revived_cannon = 0;
	}
	
	cannon_one(cannon_trig);
}

cannon_one(cannon_trig)
{
	while(1)
	{	
		cannon_trig waittill("trigger", player);
		if(player.score >= 1000 && level.cannon_one_in_progress == 0)
		{
			level.cannon_one_in_progress = 1;
			player maps\_zombiemode_score::minus_to_player_score(1000);
			player SetMoveSpeedScale(0);
			
			gun_store = player GetCurrentWeapon();
			player TakeWeapon(gun_store);
			player giveWeapon("zombie_colt_upgraded");
			player switchToWeapon("zombie_colt_upgraded");
			player DisableWeaponCycling();
			player DisableOffhandWeapons();
			
			while(! (player IsMeleeing()))
			{
				player thread death();
				if(player.yolo_cannon == 1)
				{
					break;
				}

				cannon_trig SetHintString("Melee to release the cannon");
				wait(0.05);
			}
			level.cannon_one_in_progress = 0;
			player SetMoveSpeedScale(1);
			player TakeWeapon("zombie_colt_upgraded");
			player EnableWeaponCycling();
			player EnableOffhandWeapons();
			
			cannon_trig SetHintString("Press &&1 to use the cannon");
			
			if(player.yolo_cannon == 0)
			{
				player GiveWeapon( gun_store );
				player SwitchToWeapon( gun_store );
			}
			else
			{
				player thread check_revive();
				player waittill_any("player_revived", "bled_out");
				if(player.revived_cannon == 1)
				{
					player GiveWeapon( gun_store );
					player SwitchToWeapon( gun_store );
					player.revived_cannon = 0;
				}
				player.yolo_cannon = 0;
			}
			wait(0.05);
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
	if(level.cannon_one_in_progress == 1)
	{
		self.yolo_cannon = 1;
	}
}

check_revive()
{
	self waittill("player_revived");
	self.revived_cannon = 1;
}