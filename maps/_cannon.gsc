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
	cannon_in_progress = 0;
	
	while(1)
	{
		
		cannon_trig waittill("trigger", player);
		if(player.score >= 1000 && cannon_in_progress == 0)
		{
			cannon_in_progress = 1;
			player maps\_zombiemode_score::minus_to_player_score(1000);
			while(! (player IsMeleeing()))
			{
				player SetMoveSpeedScale(0);
				player giveWeapon("zombie_colt_upgraded");
				player switchToWeapon("zombie_colt_upgraded");

				cannon_trig SetHintString("Melee to release the cannon");
				wait(0.05);
			}
			cannon_in_progress = 0;
			player SetMoveSpeedScale(1);
			player TakeWeapon("zombie_colt_upgraded");
			wait(0.05);
		}
		else if(cannon_in_progress == 1)
		{
			cannon_trig SetHintString("The cannon is being used right now");
			wait(0.05);
		}
		else
		{
			wait(0.05);
		}
	}
	
}