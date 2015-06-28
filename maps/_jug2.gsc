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
		players[i].is_exo_jumping = 0;
		players[i].is_exo_boosting = 0;
		players[i].exo_strength = 100;
		players[i] thread exo_jump();
		players[i] thread exo_boost();
		players[i] thread exo_strength();
		players[i] thread exo_recharge();
	}
}

exo_jump()
{  
	while(1)
	{
		if(self.hasjug2 == 1)
		{
			while(self isOnGround() == 0)
			{
				if(self useButtonPressed() && self.exo_strength >= 10)
				{
					self.is_exo_jumping = 1;
					self.exo_strength -= 10;
					self SetVelocity((0, 0, 200));
					
					wait(0.1);
				}
				else
				{
					wait(0.1);
				}
			}
			self.is_exo_jumping = 0;
			wait(0.05);
		}
		else
		{
			wait(0.05);
		}
	}
}

exo_boost()
{
	while(1)
	{
		if(self.hasjug2 == 1)
		{
			while(self isOnGround() == 0)
			{
				movement = self GetNormalizedMovement();
				if(self AdsButtonPressed() && movement[0] == 1 && self.exo_strength >= 5)
				{
					self.is_exo_boosting = 1;
					self.exo_strength -= 5;
					
					angles = self GetPlayerAngles();
					angle = 90 - angles[1];
					
					x = Sin(angle) * 200;
					y = Cos(angle) * 200;
					self setVelocity((x, y, 0));
					wait(0.1);
				}
				else if(self AdsButtonPressed() && movement[0] == -1 && self.exo_strength >= 5)
				{
					self.is_exo_boosting = 1;
					self.exo_strength -= 5;
					
					angles = self GetPlayerAngles();
					angle = 90 - angles[1];
					
					x = -1 * (Sin(angle) * 200);
					y = -1 * (Cos(angle) * 200);
					self setVelocity((x, y, 0));
					wait(0.1);
				}
				else if(self AdsButtonPressed() && movement[1] == 1 && self.exo_strength >= 5)
				{
					self.is_exo_boosting = 1;
					self.exo_strength -= 5;
					
					angles = self GetPlayerAngles();
					angle = angles[1] - 90;
					
					x = Cos(angle) * 200;
					y = Sin(angle) * 200;
					self setVelocity((x, y, 0));
					wait(0.1);
				}
				else if(self AdsButtonPressed() && movement[1] == -1 && self.exo_strength >= 5)
				{
					self.is_exo_boosting = 1;
					self.exo_strength -= 5;
					
					angles = self GetPlayerAngles();
					angle = angles[1] - 90;
					
					x = -1 * (Cos(angle) * 200);
					y = -1 * (Sin(angle) * 200);
					self setVelocity((x, y, 0));
					wait(0.1);
				}
				else
				{
					wait(0.1);
				}
			}
			self.is_exo_boosting = 0;
			wait(0.05);
		}
		else
		{
			wait(0.05);
		}
	}
}

exo_strength()
{
	while(1)
	{
		if(self.hasjug2 == 1)
		{
			if(self.exo_strength <= 0)
			{
				self.exo_strength = 0;
			}
			if(IsDefined(self.exo_strength_hud))
			{
				self.exo_strength_hud destroy();
			}
			self.exo_strength_hud = newClientHudElem( self );
			self.exo_strength_hud.x = 275;
			self.exo_strength_hud.y = 50;
			self.exo_strength_hud.foreground = 1;
			self.exo_strength_hud.fontscale = 3;
			self.exo_strength_hud.alpha = 1;
			self.exo_strength_hud.sort = 0;
			self.exo_strength_hud.color = ( 0, 204, 204 );
			self.exo_strength_hud SetText(self.exo_strength);
			wait(0.05);
		}
		else
		{
			if(IsDefined(self.exo_strength_hud))
			{
				self.exo_strength_hud destroy();
				self.exo_strength = 100;
			}
			wait(0.05);
		}
	}
}

exo_recharge()
{
	while(1)
	{
		if(self.hasjug2 == 1 && self.exo_strength < 100 && self.is_exo_boosting == 0 && self.is_exo_jumping == 0)
		{
			self.exo_strength += 1;
			wait(0.05);
		}
		else
		{
			wait(0.05);
		}
	}
}