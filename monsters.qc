/* ALL MONSTERS SHOULD BE 1 0 0 IN COLOR */

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink
//		<code>
// };


float SPAWN_LATER = 4;

/*
================
monster_use

Using a monster makes it angry at the current activator
================
*/

void() monster_spawn =
{	
	self.spawnflags &= ~SPAWN_LATER;

	spawn_tfog(self.origin);
	self.th_spawn();
	self.enemy = activator;
	self.nextthink = time + 0.1;
	FoundTarget(self);
}

void() monster_use =
{	
	if (self.enemy)
		return;
	if (self.health <= 0)
		return;
	if (activator.items & IT_INVISIBILITY)
		return;
	if (activator.flags & FL_NOTARGET)
		return;
	if (activator.classname != "player")
		return;

	if (self.spawnflags & SPAWN_LATER)
	{
		self.think = monster_spawn;
		if(self.delay > 0)
			self.nextthink = time + self.delay;
		else
			self.nextthink = time + 0.1;
		return;
	}
	
// delay reaction so if the monster is teleported, its sound is still
// heard
	self.enemy = activator;
	self.nextthink = time + 0.1;
	FoundTarget(self);
};

/*
================
monster_death_use

When a mosnter dies, it fires all of its targets with the current
enemy as activator.
================
*/
void() monster_death_use =
{
//	local entity 	ent, otemp, stemp;

// fall to ground
	if (self.flags & FL_FLY)
		self.flags = self.flags - FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - FL_SWIM;

	if (!self.target)
		return;

	activator = self.enemy;
	SUB_UseTargets ();
};


//============================================================================

void() walkmonster_start_go =
{
	self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor();
	
	if (!walkmove(0,0))
	{
		dprint ("walkmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}
	
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	
	self.flags = self.flags | FL_MONSTER;

	if (self.spawnflags & SPAWN_LATER)
	{
		self.model = string_null;
		self.solid = SOLID_NOT;
		return;
	}
	
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
			self.pausetime = 99999999;
			self.th_stand ();
	}
	else if((self.enemy != world || self.oldenemy != world))
	{
		if(self.enemy.health > 0)
		{
			self.pausetime = 0;
			FoundTarget(self);
		}
		else if(self.oldenemy.health > 0) // was resurrected
		{	
			self.enemy = self.oldenemy;
			self.pausetime = 0;
			FoundTarget(self);
		}
		else 
		{
			self.pausetime = 99999999;
			self.th_stand ();
		}
	}
	else 
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}


// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
};


void() walkmonster_start =
{
// delay drop to floor to make sure all doors have been spawned
// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = walkmonster_start_go;
	if(!(self.flags & FL_RESURRECTED))
		total_monsters = total_monsters + 1;
};



void() flymonster_start_go =
{
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;

	if (!walkmove(0,0))
	{
		dprint ("flymonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}
	
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
			self.pausetime = 99999999;
			self.th_stand ();
	}
	 // was resurrected
	else if((self.enemy != world || self.oldenemy != world))
	{
		if(self.enemy.health > 0)
		{
			self.pausetime = 0;
			FoundTarget(self);
		}
		else if(self.oldenemy.health > 0) // was resurrected
		{	
			self.enemy = self.oldenemy;
			self.pausetime = 0;
			FoundTarget(self);
		}
		else 
		{
			self.pausetime = 99999999;
			self.th_stand ();
		}
	}
	else 
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

};

void() flymonster_start =
{
// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = flymonster_start_go;

	if(!(self.flags & FL_RESURRECTED))
		total_monsters = total_monsters + 1;
};


void() swimmonster_start_go =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 10';
	self.use = monster_use;
	
	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;
	
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk ();
	}
	else	if((self.enemy != world || self.oldenemy != world))
	{
		if(self.enemy.health > 0)
		{
			self.pausetime = 0;
			FoundTarget(self);
		}
		else if(self.oldenemy.health > 0) // was resurrected
		{	
			self.enemy = self.oldenemy;
			self.pausetime = 0;
			FoundTarget(self);
		}
		else 
		{
			self.pausetime = 99999999;
			self.th_stand ();
		}
	}
	else 
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}


// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
};

void() swimmonster_start =
{
// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = swimmonster_start_go;

	if(!(self.flags & FL_RESURRECTED))
		total_monsters = total_monsters + 1;
};


