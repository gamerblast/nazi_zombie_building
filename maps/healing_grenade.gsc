#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;
#include maps\_hud_util;

main()
{
	flag_wait("all_players_connected");
	players = get_players();
	for( i = 0; i < players.size; i++)
	{
		players[i] thread check_thrown(players);
	}
}

check_thrown(players)
{
	while(1)
	{
		self waittill( "grenade_fire", grenade, weapName );
		if( weapName == "zombie_cymbal_monkey" )
		{
			wait(0.05);
			self thread spawn_aura(players, grenade, self);
		}
		else
		{
			wait(0.05);
		}		
	}
}

spawn_aura(players, grenade, reviver)
{
	while(1)
	{
		while( IsDefined( grenade ) )
		{
			iprintln("Checking...");
			for( i = 0; i < players.size; i++ )
			{
				players[i] players_check(grenade, reviver);
			}
			wait(0.05);
		}
		wait(0.05);
	}
}

players_check(grenade, reviver)
{
	player_revived = 0;
	if((DistanceSquared(grenade.origin, self.origin) <= 160000) && (IsDefined(self.is_down_prayers) && self.is_down_prayers == 1))
	{ 
		self.bleedout_bar destroyElem();
		self thread maps\_laststand::revive_success( reviver );
		player_revived = 1;
		iprintln("1st Acheivement: I'm Alive!");
	}
	
	wait(0.05);
	
	
	if(player_revived == 1)
	{
		player_revived = 0;
		self.ignoreme = true;
		self EnableInvulnerability();
		// self VisionSetLastStand( "laststand", 1 );
		self.angel_bar = self createPrimaryProgressBar();
		self.angel_bar updateBar( 0.01, 1 / 10 );
		for(x=10; x>=1; x--)
		{
			wait(1);
		}
		self.angel_bar destroyElem();
		self.ignoreme = false;
		self DisableInvulnerability();
		//  set_vision_set( "zombie_factory", 1 );
	}
}



