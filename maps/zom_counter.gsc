//================================================================================================
// Script Placer Z - Zombie Counter
//================================================================================================

#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

zom_counter_bc()
{   
	Remaining = create_simple_hud();
  	Remaining.horzAlign = "center";
  	Remaining.vertAlign = "middle";
   	Remaining.alignX = "Left";
   	Remaining.alignY = "middle";
   	Remaining.y = 230;
   	Remaining.x = 60;
   	Remaining.foreground = 1;
   	Remaining.fontscale = 8.0;
   	Remaining.alpha = 1;
   	Remaining.color = ( 0.423, 0.004, 0 );


   	ZombiesLeft = create_simple_hud();
   	ZombiesLeft.horzAlign = "center";
   	ZombiesLeft.vertAlign = "middle";
   	ZombiesLeft.alignX = "center";
   	ZombiesLeft.alignY = "middle";
   	ZombiesLeft.y = 230;
   	ZombiesLeft.x = -1;
   	ZombiesLeft.foreground = 1;
   	ZombiesLeft.fontscale = 8.0;
   	ZombiesLeft.alpha = 1;
   	ZombiesLeft.color = ( 0.423, 0.004, 0 );
   	ZombiesLeft SetText("Zombies Left: ");


	while(1)
	{
		remainingZombies = get_enemy_count() + level.zombie_total;
		Remaining SetValue(remainingZombies);

		if(remainingZombies == 0 )
			{
			Remaining.alpha = 0; 
			while(1)
				{
					remainingZombies = get_enemy_count() + level.zombie_total;
					if(remainingZombies != 0 )
					{
					Remaining.alpha = 1; 
					break;
					}
					wait 0.5;
				}
			}
		wait 0.5;
	}		
}

zom_counter_tr()
{   
   Remaining = create_simple_hud();
   Remaining.horzAlign = "right";
   Remaining.vertAlign = "right";
      Remaining.alignX = "center";
      Remaining.alignY = "top";
      Remaining.y = 5;
      Remaining.x = -30;
      Remaining.foreground = 1;
      Remaining.fontscale = 8.0;
      Remaining.alpha = 1;
      Remaining.color = ( 0.423, 0.004, 0 );


      ZombiesLeft = create_simple_hud();
      ZombiesLeft.horzAlign = "right";
      ZombiesLeft.vertAlign = "right";
      ZombiesLeft.alignX = "center";
      ZombiesLeft.alignY = "top";
      ZombiesLeft.y = 5;
      ZombiesLeft.x = -115;
      ZombiesLeft.foreground = 1;
      ZombiesLeft.fontscale = 8.0;
      ZombiesLeft.alpha = 1;
      ZombiesLeft.color = ( 0.423, 0.004, 0 );
      ZombiesLeft SetText("Zombies Left: ");


   while(1)
   {
      remainingZombies = get_enemy_count() + level.zombie_total;
      Remaining SetValue(remainingZombies);

      if(remainingZombies == 0 )
         {
         Remaining.alpha = 0; 
         while(1)
            {
               remainingZombies = get_enemy_count() + level.zombie_total;
               if(remainingZombies != 0 )
               {
               Remaining.alpha = 1; 
               break;
               }
               wait 0.5;
            }
         }
      wait 0.5;
   }     
}