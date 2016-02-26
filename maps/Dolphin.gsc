dolphinDive()
{
	self endon("dolphindiveoff");
	self.isSliding = false;
	while(1)
	{
		veloc = self getVelocity();
		wait(0.05);
		iprintln(abv(veloc[1]));
		if(abv(veloc[1]) > 190 && self getstance() == "crouch" && !self.isSliding)
		{
			self.isSliding = true;
			self launchMe();
			wait(0.01);
		}
		wait(0.01);
	}
}

launchMe()
{
	//self allowProne(false);
	//self allowStand(false);
	self setStance("crouch");
	angles = self GetPlayerAngles();
	angle = 90 - angles[1];
	
	x = Sin(angle) * 1000;
	y = Cos(angle) * 1000;
	for(i = 0; i < 6; i++) {
		self setVelocity((x, y, 0));
		wait(0.08);
	}
	
	wait(0.5);
	
	//wait(1);
	//wait(3);
	//self setVelocity(0, 0, 0);
	self.isSliding = false;
	//self allowProne(true);
	//self allowStand(true);

	/*
	vec = anglestoforward(self getplayerangles());
	mo = self.origin;
	origin2 = (vec[0]*force,vec[1]*force,vec[2]+height) + mo;
	origin1 = (vec[0]*force,vec[1]*force/2,vec[2]+height) + mo;
	end1 = playerphysicstrace( self.origin, origin1 );
	end2 = playerphysicstrace( self.origin, origin2 );
	self setorigin(end1);
	wait 0.05; self setorigin(end2);
	if(isDefined(slide) && slide)
	{
		while(!self isonground())
		{
			wait 0.001;
		}
		vec = anglestoforward(self getplayerangles());
		mo = self.origin;
		so = (vec[0]*1.5,vec[1]*1.5,vec[2]*1.5) + mo;
		se = playerphysicstrace( self.origin, so );
		self setorigin(se);
	}
	*/
}

abv(n)
{
	if(n < 0 )
	{
		return n * -1;
	}
	else
	{
		return n;
	}
}
