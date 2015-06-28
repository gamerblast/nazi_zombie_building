#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;
#include maps\_anim; 

main()
{ 
	flag_wait("all_players_connected");
	players = get_players();
	
	water = getEnt("english_channel", "targetname");
	
	level.high_tide = 0;
	
}
