dolphinDive()
{
	self endon("dolphindiveoff");
	self.isSliding = false;
	while(1)
	{
		veloc = self getVelocity();
		wait(0.05);
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

	slideDistance = 500;
	
	if(self HasPerk("specialty_boost"))
		slideDistance = 1000;
	
	x = Sin(angle) * slideDistance;
	y = Cos(angle) * slideDistance;
	
	fxOrigins = [];
	
	for(i = 0; i < 6; i++) {
		self setVelocity((x, y, 0));
		if(self HasPerk("specialty_boost"))
			fxOrigins[i] = self.origin;
			
		wait(0.08);
	}
	
	thread slipAndSlide(fxOrigins);
	
	wait(0.5);
	
	self.isSliding = false;
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

slipAndSlide(fxOrigins) {
	fxSpots = [];
	
	for(i = 0; i < fxOrigins.size; i++) 
	{
		temp_model = spawn("script_model", fxOrigins[i]);
		temp_model.angles = (0,0,0);
		temp_model setModel("tag_origin");
		playFXOnTag(level._effect["powerup_on"], temp_model, "tag_origin");
		fxSpots[i] = temp_model;
		wait(0.01);
	}

	wait(10);
	for(i = 0; i < fxSpots.size; i++) {
		fxSpots[i] delete();
	}
}


