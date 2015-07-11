// ==========================================================
// Coding Projects
//
// Component: WaW
// Purpose: Attachment Box main script
// NOTES: Script has been dropped for support
// as WaW has problems with loading duped assets for FX
//
// Initial author: DidUknowiPwn
// Started: 2015-03-16
//	© 2015 DidUknowiPwn™
// ==========================================================

#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

main()
{
	SetDvar("scr_zom_attachment_jug_cost", 		5000);
	SetDvar("scr_zom_attachment_speed_cost", 			5000);
	SetDvar("scr_zom_attachment_double_cost", 		5000);
	SetDvar("scr_zom_attachment_quick_cost", 		5000);

	PrecacheMenu("dukip_attachment_box_01");
	PrecacheMenu("dukip_attachment_box_02");
	PrecacheMenu("dukip_attachment_box_03");

	attachBox_trigger = GetEntArray("attachment_box_trigg", "targetname");
	array_thread(attachBox_trigger, ::attachmentBox_trigg);

	level.attachment_map = [];
	level.attachment_map["cost"]["jug"] = GetDvarInt("scr_zom_attachment_jug_cost");
	level.attachment_map["cost"]["speed"] =	GetDvarInt("scr_zom_attachment_speed_cost");
	level.attachment_map["cost"]["double"] =	GetDvarInt("scr_zom_attachment_double_cost");
	level.attachment_map["cost"]["quick"] = GetDvarInt("scr_zom_attachment_quick_cost");

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnct");
	for(;;)
	{
		self waittill("spawned_player");
		self.jug_specialist_equipped = 0;
		self.speed_specialist_equipped = 0;
		self.double_specialist_equipped = 0;
		self.quick_specialist_equipped = 0;
		self.specialist_timer = 60;
		self thread onMenuResponse();
		self thread specialist_timer();
	}
}

onMenuResponse()
{
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		self waittill("menuresponse", menu, response);

		if(menu != "dukip_attachment_box_01")
			continue;

		self thread attachmentBox_internal(response);
	}
}

attachmentBox_trigg()
{
	level endon("end_game");

	self UseTriggerRequireLookAt();
	self SetHintString("Press and Hold ^3&&1^7 to open the Specialist menu.");
	self SetCursorHint("HINT_NOICON");

	while(IsDefined(self))
	{
		self waittill("trigger", player);
		//DUKIP - Just keep it simple.
		if (player maps\_laststand::player_is_in_laststand() )
		{
			wait( 0.1 );
			continue;
		}

		if( player isThrowingGrenade() )
		{
			wait( 0.1 );
			continue;
		}

		if( player isSwitchingWeapons() )
		{
			wait(0.1);
			continue;
		}


		player OpenMenuNoMouse("dukip_attachment_box_01");
	}
}

attachmentBox_internal(specialist)
{
	self endon("death");
	self endon("fake_death");
	self endon("player_downed");
	level endon("end_game");

	attachmentCost = level.attachment_map["cost"][specialist];
	//DUKIP - Just in case force set everything to off.
	if(!IsDefined(specialist) || (self.score < attachmentCost))
	{
		self CloseMenu();
		self closeInGameMenu();
		self PlayLocalSound( "no_cha_ching" );
		return;
	}
	
	self maps\_zombiemode_score::minus_to_player_score( attachmentCost );
	
	if(specialist == "jug")
	{
		self.speed_specialist_equipped = 0;
		self.double_specialist_equipped = 0;
		self.quick_specialist_equipped = 0;
		self.jug_specialist_equipped = 1;
	}
	else if(specialist == "speed")
	{
		self.jug_specialist_equipped = 0;
		self.double_specialist_equipped = 0;
		self.quick_specialist_equipped = 0;
		self.speed_specialist_equipped = 1;
	}
	else if(specialist == "double")
	{
		self.jug_specialist_equipped = 0;
		self.quick_specialist_equipped = 0;
		self.speed_specialist_equipped = 0;
		self.double_specialist_equipped = 1;
	}
	else if(specialist == "quick")
	{
		self.jug_specialist_equipped = 0;
		self.double_specialist_equipped = 0;
		self.speed_specialist_equipped = 0;
		self.quick_specialist_equipped = 1;
	}
	self closeMenu();
	self closeInGameMenu();
}

specialist_timer()
{
	for(;;)
	{
		while(self.specialist_timer > 0)
		{
			self.specialist_timer -=1;
			iprintln(self.specialist_timer);
			wait(1);
		}
		wait(0.05);
	}
}