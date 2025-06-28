
void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;

void() monster_death_use;

//============================================================================

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
{
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}
	
	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
};


/// deimos code rip

/*
============
Killed
============
*/
void(entity targ, entity attacker) Killed =
{
// why the fuck wasn't this only for the player before
	if (targ.health < -99 && (targ.flags & FL_CLIENT))
		targ.health = -99;		// don't let sbar look bad if a player

	if (targ.movetype == MOVETYPE_PUSH || targ.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		targ.th_die ();
		return;
	}

	if(attacker.classname == "monster_medic") // if medic killed fuck, no fucks give
		targ.owner = attacker;

	targ.enemy = attacker;
	
// bump the monster counter
	if ((targ.flags & FL_MONSTER) && !(targ.deadflag & DEAD_DEAD) )
	{
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}

	ClientObituary(targ, attacker);
	
	if(!(targ.flags & FL_MONSTER) )
		targ.takedamage = DAMAGE_NO;

	targ.touch = SUB_Null;

	monster_death_use();
	targ.th_die ();
	if (targ.mass > 0)
		targ.mass = 0;
};

void M_React (entity attacker, entity targ) // q2 port
{	
	if (!(attacker.flags & FL_MONSTER) && !(attacker.flags & FL_CLIENT))
		return;
	
	if (attacker == targ || attacker == targ.enemy)
		return;

	if (targ.flags & FL_MEDIC)
		return;
		
	if (attacker.flags & FL_CLIENT)
	{
		if (targ.enemy.flags & FL_CLIENT && targ.enemy)
		{
			if(visible(targ.enemy))
			{
				targ.oldenemy = attacker;
				return;
			}
			targ.oldenemy = targ.enemy;
		}
		targ.enemy = attacker;
		FoundTarget(targ);
		return;
	}
	
	if ( (targ.classname != attacker.classname) 
		&& (attacker.classname != "monster_medic" ) 
		&& (attacker.classname != "monster_tank" )
		&& (attacker.classname != "monster_commander" ) )
	{
		if (targ.enemy.classname == "player")
			targ.oldenemy = targ.enemy;

		targ.enemy = attacker;
		FoundTarget (targ);
	}
	else if (attacker.enemy == targ)
	{
		if (targ.enemy.classname == "player")
			targ.oldenemy = targ.enemy;

		targ.enemy = attacker;
		FoundTarget (targ);
	}
	else if (attacker.enemy && attacker.enemy != targ) // otherwise get mad at whoever they are mad at (help our buddy) unless it is us!
	{
		if ((targ.enemy.flags & FL_CLIENT) && targ.enemy)
			targ.oldenemy = targ.enemy;
		targ.enemy = attacker.enemy;
		FoundTarget (targ);
	}
}


/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void(entity targ, entity inflictor, entity attacker, float damage, float kick) T_Damage=
{
	local	entity	oldself;
	local	float	save;
	local	float	take;

	if (!targ.takedamage)
		return;

// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

// check for quad damage powerup on the attacker
	if (attacker.super_damage_finished > time)
	{
		damage = damage * 4;
		kick = kick * 4;
	}

// save damage based on the target's armor level

	save = ceil(targ.armortype*damage);
	if (save >= targ.armorvalue)
	{
		save = targ.armorvalue;
		targ.armortype = 0;	// lost all armor
		targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	}
	
	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage-save);

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}
	
	// figure momentum add
	if ((targ.mass > 0) && (targ.movetype != MOVETYPE_PUSH))
	{
		if(kick && !(targ.flags & FL_LEAP))
		{
			local vector dir = ((targ.maxs - targ.mins) * 0.5 + targ.absmin) - ((inflictor.maxs - inflictor.mins) * 0.5 + inflictor.absmin);
			dir = normalize(dir);
	
			if((checkbottom(targ)) && (targ.flags & FL_MONSTER) && !(targ.flags & FL_FLY))
			{
				targ.flags = targ.flags - (targ.flags & FL_ONGROUND);
				targ.velocity_z = targ.velocity_z + vlen(dir) * (500.0 * kick / targ.mass );
			}

			if ((targ.flags & FL_CLIENT) && attacker == targ)
				targ.velocity = targ.velocity + dir* (1600.0 * kick / targ.mass );	
			else
				targ.velocity = targ.velocity + dir* (500.0 * kick / targ.mass );
		}
	}
	
// check for godmode or invincibility
	if (targ.flags & FL_GODMODE)
		return;
	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}

// team play damage avoidance
	if ( (teamplay == 1) && (targ.team > 0)&&(targ.team == attacker.team) )
		return;
		
// do the damage
	if(take > 0)
	{	
		targ.health = targ.health - take;
			
		if (targ.health <= 0)
		{		
			oldself = self;
			self = targ;
	
			if(self.classname == "func_breakable")
				self.enemy = inflictor;

			Killed (self, attacker);
			self = oldself;
			return;
		}
	}

// react to the damage
	oldself = self;
	self = targ;

	if (self.flags & FL_MONSTER)
	{
		M_React (attacker, self);
		
		if(take > 0)
		{
			self.th_pain (attacker, take);
				// nightmare mode monsters don't make pain noises often	
			if (skill == 3)
				self.pain_finished = time + 4 + random()*2;
			else if (skill == 2)
				self.pain_finished = time + 4;
		}
	}

	else if (take > 0 && self.th_pain)
		self.th_pain (attacker, take);
	
	self = oldself;
};
/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage =
{
	local	float 	points;
	local	entity	head;
	local	vector	org;

	head = findradius(inflictor.origin, damage+40);
	
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;
				points = damage - points;
				if (head == attacker)
					points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage (head, inflictor))
					{	// shambler takes half damage from all explosions
						if (head.classname == "monster_nazicultist")						
							T_Damage (head, inflictor, attacker, points*0.5, points*0.2);
						else
							T_Damage (head, inflictor, attacker, points, points*0.7);
					}
				}
			}
		}
		head = head.chain;
	}
};

