void() movetarget_f;
void() t_movetarget;

void(entity etemp, entity stemp, entity stemp, float dmg, optional float kick) T_Damage;
/*

.enemy
Will be world if not currently angry at anyone.

.movetarget
The next path spot to walk toward.  If .enemy, ignore .movetarget.
When an enemy is killed, the monster will try to return to it's path.

.huntt_ime
Set to time + something when the player is in sight, but movement straight for
him is blocked.  This causes the monster to use wall following code for
movement direction instead of sighting on the player.

.ideal_yaw
A yaw angle of the intended direction, which will be turned towards at up
to 45 deg / state.  If the enemy is in view and hunt_time is not active,
this will be the exact line towards the enemy.

.pausetime
A monster will leave it's stand state and head towards it's .movetarget when
time > .pausetime.

walkmove(angle, speed) primitive is all or nothing
*/


//
// globals
//
//float	current_yaw;

//
// when a monster becomes angry at a player, that monster will be used
// as the sight target the next frame so that monsters near that one
// will wake up even if they wouldn't have noticed the player
//
entity	sight_entity;
float	sight_entity_time;


/*
==============================================================================

MOVETARGET CODE

The angle of the movetarget effects standing and bowing direction, but has no effect on movement, which allways heads to the next target.

targetname
must be present.  The name of this movetarget.

target
the next spot to move to.  If not present, stop here for good.

pausetime
The number of seconds to spend standing or bowing for path_stand or path_bow

==============================================================================
*/


void() movetarget_f =
{
	if (!self.targetname)
		objerror ("monster_movetarget: no targetname");
		
	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize (self, '-8 -8 -8', '8 8 8');
	
};

/*QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
Monsters will continue walking towards the next target corner.
*/
void() path_corner =
{
	movetarget_f ();
};


/*
=============
t_movetarget

Something has bumped into a movetarget.  If it is a monster
moving towards it, change the next destination and continue.
==============
*/
void() t_movetarget =
{
local entity	temp;

	if (other.movetarget != self)
		return;
	
	if (other.enemy)
		return;		// fighting, not following a path

	temp = self;
	self = other;
	other = temp;

//dprint ("t_movetarget\n");
	self.goalentity = self.movetarget = find (world, targetname, other.target);
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	if (!self.movetarget)
	{
		self.pausetime = time + 999999;
		self.th_stand ();
		return;
	}
};



//============================================================================

/*
=============
range

returns the range catagorization of an entity reletive to self
0	melee range, will become hostile even if back is turned
1	visibility and infront, or visibility and show hostile
2	infront and show hostile
3	only triggered by damage
=============
*/



float(entity targ) range =
{
local vector	spot1, spot2;
local float		r;	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	
	r = vlen (spot1 - spot2);
	if (r < 100)
		return RANGE_MELEE;
	if (r < 300)
		return RANGE_CLOSE;
	if (r < 500)
		return RANGE_NEAR;
	if (r < 1000)
		return RANGE_MID;
	return RANGE_FAR;
};

/*
=============
visible

returns 1 if the entity is visible to self, even if not infront ()
=============
*/
float (entity targ) visible =
{
	local vector	spot1, spot2;
	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};


/*
=============
infront

returns 1 if the entity is in front (in sight) of self
=============
*/
float(entity targ) infront =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.3)
	{
		return TRUE;
	}
	return FALSE;
};


//============================================================================

/*
===========
ChangeYaw

Turns towards self.ideal_yaw at self.yaw_speed
Sets the global variable current_yaw
Called every 0.1 sec by monsters
============
*/
/*

void() ChangeYaw =
{
	local float		ideal, move;

//current_yaw = self.ideal_yaw;
// mod down the current angle
	current_yaw = anglemod( self.angles_y );
	ideal = self.ideal_yaw;
	
	if (current_yaw == ideal)
		return;
	
	move = ideal - current_yaw;
	if (ideal > current_yaw)
	{
		if (move > 180)
			move = move - 360;
	}
	else
	{
		if (move < -180)
			move = move + 360;
	}
		
	if (move > 0)
	{
		if (move > self.yaw_speed)
			move = self.yaw_speed;
	}
	else
	{
		if (move < 0-self.yaw_speed )
			move = 0-self.yaw_speed;
	}

	current_yaw = anglemod (current_yaw + move);

	self.angles_y = current_yaw;
};

*/


//============================================================================

void(entity ent) HuntTarget =
{
	ent.goalentity = ent.enemy;
	if(!ent.dcnt)
		ent.think = ent.th_run;
	ent.ideal_yaw = vectoyaw(ent.enemy.origin - ent.origin);
	ent.nextthink = time + 0.1;
	SUB_AttackFinished_notself (ent, 1);	// wait a while before first attack
};

void(entity targ) SightSound =
{
// 	local float	rsnd;

	if (targ.classname == "monster_ogre")	
		sound (targ, CHAN_VOICE, "gunner/sight1.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_gladiator")
		sound (targ, CHAN_VOICE, "gladiator/sight.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_tank")
		sound (targ, CHAN_VOICE, "tank/sight1.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_demon2")
		sound (targ, CHAN_VOICE, "mutant/mutsght1.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_wizard")
		sound (targ, CHAN_VOICE, "hover/hovsght1.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_zombie")
		sound (targ, CHAN_VOICE, "brain/brnsght1.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_hell_knight1")
		sound (targ, CHAN_VOICE, "berserk/sight.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_tarbaby")
		sound (targ, CHAN_VOICE, "flyer/flysght1.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_floater")
		sound (targ, CHAN_VOICE, "floater/fltsght1.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_enforcer")
		sound (targ, CHAN_VOICE, "infantry/infsght1.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_army" || targ.classname == "monster_dog" || targ.classname == "monster_knight")
		sound (targ, CHAN_VOICE, "soldier/solsght1.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_shalrath")
		sound (targ, CHAN_VOICE, "chick/chksght1.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_medic")
		sound (targ, CHAN_VOICE, "medic/medsght1.wav", 1, ATTN_NORM);
	else if (targ.classname == "monster_parasite")
		sound (targ, CHAN_VOICE, "parasite/parsght1.wav", 1, ATTN_NORM);
};

void(entity targ) FoundTarget =
{
	if (targ.enemy.classname == "player")
	{	// let other monsters see this monster for a while
		sight_entity = targ;
		sight_entity_time = time;
	}
	
	targ.show_hostile = time + 1;		// wake up other monsters

	SightSound (targ);
	HuntTarget (targ);
};

/*
===========
FindTarget

Self is currently not attacking anything, so try to find a target

Returns TRUE if an enemy was sighted

When a player fires a missile, the point of impact becomes a fakeplayer so
that monsters that see the impact will respond as if they had seen the
player.

To avoid spending too much time, only a single client (or fakeclient) is
checked each frame.  This means multi player games will have slightly
slower noticing monsters.
============
*/
float() FindTarget =
{
	local entity	client;
	local float		r;

// if the first spawnflag bit is set, the monster will only wake up on
// really seeing the player, not another monster getting angry

// spawnflags & 3 is a big hack, because zombie crucified used the first
// spawn flag prior to the ambush flag, and I forgot about it, so the second
// spawn flag works as well
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & 3) )
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
			return FALSE;
	}
	else
	{
		client = checkclient ();
		if (!client)
			return FALSE;	// current check entity isn't in PVS
	}

	if (client == self.enemy)
		return FALSE;

	if (client.flags & FL_NOTARGET)
		return FALSE;
	if (client.items & IT_INVISIBILITY)
		return FALSE;

	r = range (client);
	if (r == RANGE_FAR)
		return FALSE;
		
	if (!visible (client))
		return FALSE;

	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront (client))
			return FALSE;
	}
	else if (r == RANGE_MID)
	{
		if ( /* client.show_hostile < time || */ !infront (client))
			return FALSE;
	}
	
//
// got one
//
	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FALSE;
		}
	}
	
	FoundTarget (self);

	return TRUE;
};


//=============================================================================

void(float dist) ai_forward =
{
	walkmove (self.angles_y, dist);
};

void(float dist) ai_back =
{
	walkmove ( (self.angles_y+180), dist);
};


/*
=============
ai_pain

stagger back a bit
=============
*/
void(float dist) ai_pain =
{
	ai_back (dist);
/*
	local float	away;
	
	away = anglemod (vectoyaw (self.origin - self.enemy.origin) 
	+ 180*(random()- 0.5) );
	
	walkmove (away, dist);
*/
};

/*
=============
ai_painforward

stagger back a bit
=============
*/
void(float dist) ai_painforward =
{
	walkmove (self.ideal_yaw, dist);
};

/*
=============
ai_walk

The monster is walking it's beat
=============
*/
void(float dist) ai_walk =
{
//	local vector		mtemp;
	
	movedist = dist;
	
	if (self.classname == "monster_dragon")
	{
		movetogoal (dist);
		return;
	}
	// check for noticing a player
	if (FindTarget ())
		return;

	movetogoal (dist);
};


/*
=============
ai_stand

The monster is staying in one place for a while, with slight angle turns
=============
*/
void() ai_stand =
{
	if (FindTarget ())
		return;
	
	if (time > self.pausetime)
	{
		self.th_walk ();
		return;
	}
	
// change angle slightly

};

/*
=============
ai_turn

don't move, but turn towards ideal_yaw
=============
*/
void() ai_turn =
{
	if (FindTarget ())
		return;
	
	ChangeYaw ();
};

//=============================================================================

/*
=============
ChooseTurn
=============
*/
void(vector dest3) ChooseTurn =
{
	local vector	dir, newdir;
	
	dir = self.origin - dest3;

	newdir_x = trace_plane_normal_y;
	newdir_y = 0 - trace_plane_normal_x;
	newdir_z = 0;
	
	if (dir * newdir > 0)
	{
		dir_x = 0 - trace_plane_normal_y;
		dir_y = trace_plane_normal_x;
	}
	else
	{
		dir_x = trace_plane_normal_y;
		dir_y = 0 - trace_plane_normal_x;
	}

	dir_z = 0;
	self.ideal_yaw = vectoyaw(dir);	
};

/*
============
FacingIdeal

============
*/
float() FacingIdeal =
{
	local	float	delta;
	
	delta = anglemod(self.angles_y - self.ideal_yaw);
	if (delta > 45 && delta < 315)
		return FALSE;
	return TRUE;
};


//=============================================================================


/*
=============
ai_run_melee

Turn and close until within an angle to launch a melee attack
=============
*/
void() ai_run_melee =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();

	if (FacingIdeal())
	{
		self.th_melee ();
		self.attack_state = AS_STRAIGHT;
	}
};


/*
=============
ai_run_missile

Turn in place until within an angle to launch a missile attack
=============
*/
void() ai_run_missile =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (FacingIdeal())
	{
		self.th_missile ();
		self.attack_state = AS_STRAIGHT;
	}
};

.float l;
/*
=============
ai_run_slide

Strafe sideways, but stay at aproximately the same range
=============
*/
void(float d) ai_run_slide =
{
	local float	ofs;
	
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (self.lefty)
	{
		ofs = 90;
		self.l = 0;
	}
	else
	{
		ofs = -90;
		self.l = 1;
	}
	
	if (walkmove (self.ideal_yaw + ofs, d))
		return;
		
	self.lefty = 1 - self.lefty;
	
	walkmove (self.ideal_yaw - ofs, d);
};




/*
=============
ai_face

Stay facing the enemy
=============
*/
void() ai_face =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};

/*
=============
ai_charge

The monster is in a melee attack, so get as close as possible to .enemy
=============
*/
float (entity targ) visible;
float(entity targ) infront;
float(entity targ) range;

void(float d) ai_charge =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
	walkmove (self.angles_y, d);		// done in C code...
};

void() ai_charge_side =
{
	local	vector	dtemp;
	local	float	heading;
	
// aim to the left of the enemy for a flyby

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	makevectors (self.angles);
	dtemp = self.enemy.origin - 30*v_right;
	heading = vectoyaw(dtemp - self.origin);
	
	walkmove(heading, 20);
};


/*
=============
ai_melee

=============
*/
void() ai_melee =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;
		
	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self, ldmg);
};


void() ai_melee_side =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	ai_charge_side();
	
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;
	if (!CanDamage (self.enemy, self))
		return;
	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self, ldmg);
};


//=============================================================================

void(float t) CheckForCharge =
{
// check for mad charge
if (!enemy_vis)
	return;
if (time < self.attack_finished)
	return;	
if ( fabs(self.origin_z - self.enemy.origin_z) > 20)
	return;		// too much height change
if ( vlen (self.origin - self.enemy.origin) < 80)
	return;		// use regular attack

// charge		
	SUB_AttackFinished (t);
	self.th_char ();

};

void(float t) CheckContinueCharge =
{
	if (time > self.attack_finished)
	{
		SUB_AttackFinished (t);
		self.th_run ();
		return;		// done charging
	}
};

// code rip from my other mod, deimos

float() CheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);
	
	if (trace_ent != targ)
		return FALSE;		// don't have a clear shot
			
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (enemy_range == RANGE_MELEE)
	{	// melee attack
		if (self.th_melee)
		{
			self.attack_state = AS_MELEE;
			return TRUE;
		}
	}
	
// missile attack
	
	if (!self.th_missile)
		return FALSE;
	
	if (self.flags & FL_DODGED)
		return FALSE;
		
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
		self.attack_finished = 0;
	}
	else if (enemy_range == RANGE_CLOSE)
	{
		if (self.th_melee)
			chance = 0.4;
		else
			chance = 0.8;
	}
	else if (enemy_range == RANGE_NEAR)
	{
		if (self.th_melee)
			chance = 0.2;
		else
			chance = 0.4;
	}
	else if (enemy_range == RANGE_MID)
	{
		if (self.th_melee)
			chance = 0.05;
		else
			chance = 0.1;
	}
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (1 + 4*random());
		return TRUE;
	}

	return FALSE;
};



float() CheckAnyAttack =
{
	if (!enemy_vis)
		return FALSE;
	if (self.th_checkatck)
		return self.th_checkatck();
	return CheckAttack ();
};

float() ai_checkattack =
{
	local float hesDeadJim = FALSE;
	
// see if the enemy is dead
	if (self.flags & FL_MEDIC)
	{
		if(self.enemy.health > 0)
		{
			self.flags = self.flags - (self.flags & FL_MEDIC);
			hesDeadJim = TRUE;
		}
	}
	else if (self.enemy.health <= 0)
		hesDeadJim = TRUE;

	if (hesDeadJim)
	{
		self.enemy = world;
	// FIXME: look all around for other targets
	
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget (self);
		}
		else
		{
			if (self.movetarget)
				self.th_walk ();
			else
				self.th_stand ();
			return TRUE;
		}
	}

// check knowledge of enemy	
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
	{
		self.last_sighting = self.enemy.origin;
		self.search_time = time + 5;
	}

// look for other coop players
	if (coop && self.search_time < time)
	{
		if (FindTarget ())
			return TRUE;
	}

	if (self.attack_state == AS_MISSILE)
	{
		ai_run_missile ();
		return TRUE;
	}
	if (self.attack_state == AS_MELEE)
	{
		ai_run_melee ();
		return TRUE;
	}

	return CheckAnyAttack();
};

//=============================================================================

/*
=============
ai_run

The monster has an enemy it is trying to kill
=============
*/
void(float dist) ai_run =
{		
	movedist = dist;
	local entity tempgoal, save;
	local float left, right, dis1, dis2, center;
	local vector view, Ltarg, Rtarg;

	self.show_hostile = time + 1;		// wake up other monsters

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);

	if (ai_checkattack())
		return;					// beginning an attack

	if ( ( self.flags & FL_STRAFE) )
	{	
		local float strafedist = 0;
		if(dist < 10)
			strafedist = dist * 4.5;
		else if(dist < 20)
			strafedist = dist * 2.5;
		else if(dist > 25)
			strafedist = dist * 1.25;
		else
			strafedist = dist * 1.5;	
		ai_run_slide (strafedist);
		self.flags = self.flags - (self.flags & FL_STRAFE);
	}

	if (self.attack_state == AS_SLIDING)
	{	
		if ((self.aiflags & AI_LOST_SIGHT))
			self.attack_state = AS_STRAIGHT;
		else 
			ai_run_slide (movedist);
		return;
	}

//--------- q2 port kinda
	if (enemy_vis)
	{
		movetogoal (dist);
		self.aiflags &= ~AI_LOST_SIGHT;
		self.last_sighting = self.enemy.origin;
		return;
	}

	save = self.goalentity;
	
	if (!(self.aiflags & AI_LOST_SIGHT))
	{
		self.aiflags |= AI_LOST_SIGHT;
		self.aiflags &= ~AI_PURSUE_NEXT;
	}
	
	if (self.aiflags & AI_PURSUE_NEXT)
	{
		self.aiflags &= ~AI_PURSUE_NEXT;

		// give ourself more time since we got this far
		self.search_time = time + 5;

		if (self.aiflags & AI_PURSUE_TEMP)
		{
			self.aiflags &= ~AI_PURSUE_TEMP;
			self.last_sighting = self.saved_goal;
		}
	}
	
	if (vlen(self.origin - self.last_sighting) <= dist)
	{
		self.aiflags |= AI_PURSUE_NEXT;
		dist = vlen(self.origin - self.last_sighting);
	}

	tempgoal = spawn();
	self.goalentity = tempgoal;	
	self.goalentity.origin = self.last_sighting;
	
	if((self.aiflags & AI_LOST_SIGHT))
	{		
		tracebox(self.origin, self.mins, self.maxs, self.goalentity.origin, FALSE, self);
	
		if(trace_fraction < 1)
		{	
			view = normalize(self.goalentity.origin - self.origin);
			dis1 = vlen(self.goalentity.origin - self.origin);
			center = trace_fraction;
			dis2 = dis1 * (center+1) / 2;
			self.angles_y = self.ideal_yaw = vectoyaw(view);
			makevectors(self.angles);
		
			view = setvector(dis2, -16, 0);
			Ltarg = ProjectAim(self.origin, view, v_forward, v_right);
			tracebox(self.origin, self.mins, self.maxs, Ltarg, FALSE, self);
			left = trace_fraction;

			view = setvector(dis2, 16, 0);
			Rtarg = ProjectAim(self.origin, view, v_forward, v_right);
			tracebox(self.origin, self.mins, self.maxs, Rtarg, FALSE, self);
			right = trace_fraction;
		
			center = (dis1*center)/dis2;
			if (left >= center && left > right)
			{
				if (left < 1)
				{
					view = setvector(dis2 * left * 0.5, -16, 0);
					Ltarg = ProjectAim(self.origin, view, v_forward, v_right);
				}
				self.aiflags |= AI_PURSUE_TEMP;
				self.saved_goal = self.last_sighting;
				self.goalentity.origin = Ltarg;
				self.last_sighting = Ltarg;
				view = normalize(self.goalentity.origin - self.origin);
				self.angles_y = self.ideal_yaw = vectoyaw(view);
				dprint("turn left");
				dprint("\n");
				//line(self.goalentity.origin);
			}
			else if (right >= center && right > left)
			{
				if (right < 1)
				{
					view = setvector(dis2 * right * 0.5, 16, 0);
					Rtarg = ProjectAim(self.origin, view, v_forward, v_right);
				}
				self.aiflags |= AI_PURSUE_TEMP;
				self.saved_goal = self.last_sighting;
				self.goalentity.origin = Rtarg;
				self.last_sighting = Rtarg;
				view = normalize(self.goalentity.origin - self.origin);
				self.angles_y = self.ideal_yaw = vectoyaw(view);
				dprint("turn right");
				dprint("\n");
				//line(self.goalentity.origin);
			}
		}
		else
		{
			dprint("good path");
			dprint("\n");
			//line(self.goalentity.origin);
		}
	}
		
// head straight in

	dist = dist + 25;
	movetogoal (dist);		// done in C code...
	remove(tempgoal);
	self.goalentity = save;
}