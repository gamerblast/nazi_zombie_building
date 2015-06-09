#include maps\_anim; 
#include maps\_utility; 
#include common_scripts\utility;
#include maps\_music; 
#include maps\_zombiemode_utility; 

main()
{
	flag_wait("all_players_connected");
	wait(1);
	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread cherry_effect();
		players[i] thread cherry_down_effect();
	}
}

cherry_effect()
{  
	while(1)
	{
		self waittill( "reload_start" );
		if( self.hasspeed2 == 1)
		{
			cherry_weapon = self GetCurrentWeapon();
			ammo_left = self GetWeaponAmmoClip( cherry_weapon );
			clip_size = WeaponClipSize( cherry_weapon );
			ratio = ammo_left / clip_size;
			damage = 1200 - (ratio * 1200);
			iprintln( damage );
			PlayFxOnTag(level._effect["elec_torso"], self, "tag_weapon_right");
			touching_check = spawn("trigger_radius",self.origin,1,200,200);
			zombies = getaispeciesarray("axis","all");
			for(j = 0; j < zombies.size; j++)
			{
				if(zombies[j] IsTouching( touching_check ))
				{
					zombies[j] maps\_zombiemode_tesla::tesla_play_death_fx( 1 );
					zombies[j] SetFlashBanged( true, 1 );
				}
				else
				{
					continue;
				}
			}
			touching_check delete();
			SetPlayerIgnoreRadiusDamage( true );
			RadiusDamage( self.origin, 200, damage, 50, self );
			wait(5);
		}
		else
		{
		}
	}
}

cherry_down_effect()
{
	while(1)
	{
		if(self.hasspeed2 == 1)
		{
			self waittill_any( "fake_death", "death", "player_downed" );
			touching_check = spawn("trigger_radius",self.origin,1,200,200);
			zombies = getaispeciesarray("axis","all");
			for(j = 0; j < zombies.size; j++)
			{
				if(zombies[j] IsTouching( touching_check ))
				{
					zombies[j] maps\_zombiemode_tesla::tesla_play_death_fx( 1 );
					zombies[j] SetFlashBanged( true, 1 );
				}
				else
				{
					continue;
				}
			}
			touching_check delete();
			SetPlayerIgnoreRadiusDamage( true );
			RadiusDamage( self.origin, 150, 1200, 50, self );
			self.hasspeed2 = 0;
		}
		else
		{
			wait(0.05);
			continue;
		}
	}
}

