/*
==============================================================================

SHAMBLER

==============================================================================
*/


/*QUAKED monster_shambler (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/

/*
============
ShamCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() ShamCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
//	local float		chance;

	if (enemy_range == RANGE_MELEE)
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return TRUE;
		}
	}

	if (time < self.attack_finished)
		return FALSE;
	
	if (!enemy_vis)
		return FALSE;
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	if (vlen(spot1 - spot2) > 600)
		return FALSE;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
	{
		return FALSE;	// don't have a clear shot
	}
			
// missile attack
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + 2*random());
	return TRUE;
};

//============================================================================


void() monster_gladiator;
void() monster_tank;

void() monster_shambler =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model ("progs/gladiatr.mdl");
	precache_model ("progs/h_shams.mdl");
	precache_model ("progs/bolt.mdl");
	
	precache_sound ("gladiator/death.wav");
	precache_sound ("gladiator/glddeth2.wav");
	precache_sound ("gladiator/pain.wav");
	precache_sound ("gladiator/gldpain2.wav");
	precache_sound ("gladiator/gldsrch1.wav");
	precache_sound ("gladiator/gldidle1.wav");
	precache_sound ("gladiator/melee1.wav");
	precache_sound ("gladiator/melee2.wav");
	precache_sound ("gladiator/melee3.wav");
	precache_sound ("gladiator/railgun.wav");
	precache_sound ("gladiator/sight.wav");

	precache_model ("progs/tank.mdl");
	precache_model ("progs/h_shams.mdl");
	
	precache_sound ("tank/tnkpain2.wav");
	precache_sound ("tank/tnkdeth2.wav");
	precache_sound ("tank/death.wav");
	precache_sound ("tank/step.wav");
	precache_sound ("tank/tnkidle1.wav");
	precache_sound ("tank/tnkatck4.wav");
	precache_sound ("tank/tnkatck5.wav");
	precache_sound ("tank/sight1.wav");

	precache_sound ("tank/tnkatck1.wav");
	precache_sound ("tank/tnkatck3.wav");
	precache_sound ("tank/tnkatk2a.wav");
	precache_sound ("tank/tnkatk2b.wav");
	precache_sound ("tank/tnkatk2c.wav");
	precache_sound ("tank/tnkatk2d.wav");
	
	self.th_checkatck = ShamCheckAttack;
	if(self.classname == "monster_gladiator")
	{
		monster_gladiator();
		return;
	}
	else if(self.classname == "monster_tank")
	{
		monster_tank();
		return;
	}

	if (world.model == "maps/e1m3.bsp") // special case
	{
		self.classname = "monster_gladiator";
		monster_gladiator();
		return;
	}
	
	local float r = random();
	
	if(r < 0.3)
	{
		self.classname = "monster_gladiator";
		monster_gladiator();
		return;
	}
	else
	{
		self.classname = "monster_tank";
		monster_tank();
		return;
	}
};
