/*
==============================================================================

OGRE

==============================================================================
*/

$cd id1/models/medic_c
$origin 0 0 24
$base base		
$skin base

//=============================================================================

void()  monster_medic;
void()	 medic_srch;

//=============================================================================

/*
===========
MedicCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() MedicCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;
	
	medic_srch ();
	
	if (self.flags & FL_MEDIC)
	{	
		spot1 = self.origin + self.view_ofs;
		spot2 = targ.origin + targ.view_ofs;

		traceline (spot1, spot2, FALSE, self);

		if (trace_fraction < 1)
			return FALSE;			// sight line crossed contents

		if (enemy_range == RANGE_CLOSE || enemy_range == RANGE_MELEE)
		{
			self.attack_state = AS_MISSILE;
			return TRUE;
		}
	}
	

	// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
	{
		return FALSE;	// don't have a clear shot
	}
	
	if (!enemy_vis)
		return FALSE;

	if (time < self.attack_finished)
		return FALSE;
		
	targ = self.enemy;
			
// missile attack
	
	if (enemy_range == RANGE_FAR)
		return FALSE;
	else if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_CLOSE)
		chance = 0.6;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.3;
	else if (enemy_range == RANGE_MID)
		chance = 0.01;
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (2 + random()*2);
		return TRUE;
	}

	return FALSE;
};

entity(optional string ig) medic_findent = 
{
	local entity ent, best;
	local string ignore;
	
	if(ig) ignore = ig;
	
	for (ent = findradius(self.origin, 1024); ent; ent = ent.chain)
	{
        	if(ent == self)
                	continue;
		if(ent == world)
                	continue;
		if(ignore && ent.classname == ignore)
                	continue;
		if((ent.flags & FL_CLIENT))
			continue;
		if(ent.solid != SOLID_CORPSE)
			continue;
		if(ent.health > 0)
			continue;
		if(!visible(ent))
			continue;
		if(!(ent.flags & FL_MONSTER))
			continue;
		if((ent.owner))
			continue;
		if(!CanDamage(ent, self))
            	continue;
		if(!best) 
		{
			best = ent;
			continue;
		}
		if(ent.max_health <= best.max_health)
			continue;
		best = ent;
	}
	
	return best;
}
.float patience;

void() medic_srch =
{	
	local string ig = " ";
	if(!(self.flags & FL_MEDIC) && self.patience < time)
	{	
		if(skill < 3)
			ig = "monster_medic";

		local entity e = medic_findent(ig);
		if(e)
		{
			self.oldenemy = self.enemy;
			self.enemy = e;
			self.enemy.owner = self;
			self.flags |= FL_MEDIC;
			HuntTarget (self);
			return;
		}
	}
}

void() SpawnAs =
{
	self.nextthink = time;
	self.think = self.th_spawn;
	self.effects = 0;
	spawn_tfog(self.origin);
	self.flags = self.flags | FL_RESURRECTED;
	self.owner = __NULL__;
	self.deadflag = 0;
	self.target = __NULL__;
	self.origin_z += 10; // no stuck ?
}


void() checkOccupation =
{
	if(!walkmove(0,0)) // if in wall or something is standing at its location
	{
		T_Damage (self, self, self, 99999, 0);
		self.nextthink = -1;
	}
	else
		self.think = SpawnAs;

	self.effects = self.effects | EF_RED;
	self.nextthink = time;
}	

void(entity ent) medic_revive = 
{	
	setorigin(ent, ent.origin);
	ent.think = checkOccupation;
	ent.nextthink = time;
};

void() medic_cable24;

	
void() medic_domedic =
{
	makevectors(self.angles);
	self.enemy.owner = self;
	medic_revive(self.enemy);
	self.enemy.owner = __NULL__;	

//	idk if this ever did anything
	self.show_hostile = time + 1; // wake monsters up
	
	if(self.oldenemy && (self.oldenemy.flags & FL_CLIENT))
	{
		self.enemy = self.oldenemy;
		HuntTarget (self);
	}
	else
		self.enemy = __NULL__;

	self.flags = self.flags - (self.flags & FL_MEDIC);
}		 


void() medic_stand1	= [ self.frame,	medic_stand1 ] 
{
	if(self.frame < 12)
		self.frame = 12;
	self.frame ++;
	if(self.frame > 101)
		self.frame = 12;

	if (self.frame == 101 || self.frame == 90)
		if(random() < 0.2)
			sound (self, CHAN_VOICE, "medic/idle.wav", 1, ATTN_IDLE);
	
	if (self.frame == 101 || self.frame == 90 || self.frame == 14)
		medic_srch();
	
	ai_stand();
};

void() medic_walk1	=[	0,		medic_walk2	] {ai_walk(6); medic_srch(); };
void() medic_walk2	=[	1,		medic_walk3	] {ai_walk(18); };
void() medic_walk3	=[	2,		medic_walk4	] {
	ai_walk(1);

	if (random() < 0.2)
		sound (self, CHAN_VOICE, "medic/idle.wav", 1, ATTN_IDLE);
};

void() medic_walk4	=[	3,		medic_walk5	] {ai_walk(9);};
void() medic_walk5	=[	4,		medic_walk6	] {ai_walk(10); medic_srch(); };
void() medic_walk6	=[	5,		medic_walk7	] {ai_walk(9);};

void() medic_walk7	=[	6,	medic_walk8	] {ai_walk(11);};
void() medic_walk8	=[	7,	medic_walk9	] {ai_walk(12);};
void() medic_walk9	=[	8,	medic_walk10] {ai_walk(2);};
void() medic_walk10	=[	9,	medic_walk11] {ai_walk(10); medic_srch(); };
void() medic_walk11	=[	10,	medic_walk12] {ai_walk(14);};
void() medic_walk12	=[	11,	medic_walk1 ] {ai_walk(9);};

void() medic_run1	=[	102,		medic_run2	] {
	medic_srch();
	ai_run(18);
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "medic/medsrch1.wav", 1, ATTN_IDLE);
};

void() medic_run2	=[	103,		medic_run3	] {ai_run(22); };
void() medic_run3	=[	104,		medic_run4	] {ai_run(25); };
void() medic_run4	=[	105,		medic_run5	] {ai_run(23); medic_srch();};
void() medic_run5	=[	106,		medic_run6	] {ai_run(24); };
void() medic_run6	=[	107,		medic_run1	] {ai_run(35); };

void() medic_scan =
{
	ai_face();
	makevectors (self.angles);
	local vector org = self.origin + '0 0 14' + v_forward * 40 + v_right * -10;

	if(!self.enemy.flags || self.enemy == world)	// was gibbed when its scanning
	{
		medic_cable24();
		if(self.enemy != world)
			self.enemy.owner = __NULL__;

		if(self.oldenemy && (self.oldenemy.flags & FL_CLIENT) && self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget (self);
		}
		else
			self.enemy = __NULL__;

		self.flags = self.flags - (self.flags & FL_MEDIC);
	}
	
	local vector end;
	end =  self.enemy.origin;
	
//	tracebox (self.origin,self.mins,self.maxs, end, FALSE, self);

	traceline (self.origin, end, FALSE, self);

	if(self.frame >= 217 && self.frame <= 227)
	{	
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    		WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
    		WriteEntity(MSG_BROADCAST, self);
    		WriteCoord (MSG_BROADCAST, org_x);
    		WriteCoord (MSG_BROADCAST, org_y);
    		WriteCoord (MSG_BROADCAST, org_z);
    		WriteCoord (MSG_BROADCAST, end_x);
		WriteCoord (MSG_BROADCAST, end_y);
		WriteCoord (MSG_BROADCAST, end_z);
	}

	if(trace_fraction != 1 && trace_ent != self.enemy)
	{
		medic_cable24();
		if(self.enemy != world)
			self.enemy.owner = __NULL__;

		if(self.oldenemy && (self.oldenemy.flags & FL_CLIENT) && self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget (self);
		}
		else
			self.enemy = __NULL__;

		self.flags = self.flags - (self.flags & FL_MEDIC);
		self.patience = time + 20;
	}
	
	if(self.frame == 227)
		medic_domedic();
}

void() AutofireMedNoise =
{
	local float r = random();

	if(r < 0.8)
		sound(self, CHAN_WEAPON, "medic/medatck1.wav", 1, ATTN_NORM);
	else	if(r < 0.6)
		sound(self, CHAN_WEAPON, "medic/medatck2.wav", 1, ATTN_NORM);
	else	if(r < 0.3)
		sound(self, CHAN_WEAPON, "medic/medatck3.wav", 1, ATTN_NORM);
	else	if(r < 0.15)
		sound(self, CHAN_WEAPON, "medic/medatck4.wav", 1, ATTN_NORM);
	else
		sound(self, CHAN_WEAPON, "medic/medatck5.wav", 1, ATTN_NORM);
}

void(float offset) medCastLasers =
{	
	ai_face();
	local	vector	offang;
	local	vector	org, vec;

	offang = vectoangles (self.enemy.origin - self.origin - self.enemy.view_ofs);
	offang_y = offang_y + offset * 6;
	self.effects = self.effects | EF_MUZZLEFLASH;
	
	makevectors (offang);

	org = self.origin + '0 0 20' + v_forward * 20 + v_right * 10;

	AutofireMedNoise();

	// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z ;
	
	LaunchLaser(org, vec);
};

void() medic_cable8	=[	213,		medic_cable9	] {ai_face(); ai_forward(2); };
void() medic_cable9	=[	214,		medic_cable10	] {ai_face(); ai_forward(3);};
void() medic_cable10	=[	215,		medic_cable11	] {ai_face(); ai_forward(5);};
void() medic_cable11	=[	216,		medic_cable12	] {ai_face(); ai_forward(4);};
void() medic_cable12	=[	217,		medic_cable13	] {ai_charge(4.4); medic_scan();};
void() medic_cable13	=[	218,		medic_cable14	] {ai_charge(4.7); medic_scan();};
void() medic_cable14	=[	219,		medic_cable15	] {ai_charge(5);   medic_scan();};
void() medic_cable15	=[	220,		medic_cable16	] {ai_charge(6);   medic_scan();};
void() medic_cable16	=[	221,		medic_cable17	] {ai_charge(4);   medic_scan();};
void() medic_cable17	=[	222,		medic_cable21	] {medic_scan();};
void() medic_cable21	=[	226,		medic_cable22	] {medic_scan();};
void() medic_cable22	=[	227,		medic_cable23	] {medic_scan();};
void() medic_cable23	=[	228,		medic_cable24	] {ai_back(15); };
void() medic_cable24	=[	229,		medic_cable25	] {ai_back(1.5);};
void() medic_cable25	=[	230,		medic_cable26	] {ai_back(1.2);};
void() medic_cable26	=[	231,		medic_cable27	] {ai_back(3);  };
void() medic_cable27	=[	232,		medic_cable28	] {ai_back(2);  };
void() medic_cable28	=[	233,		medic_cable29	] {ai_back(0.3);};
void() medic_cable29	=[	234,		medic_cable30	] {ai_back(0.7);};
void() medic_cable30	=[	235,		medic_cable31	] {ai_back(1.2);};
void() medic_cable31	=[	236,		medic_run1	      ] {ai_back(1.3);};

void() medic_hyper8	=[	191,		medic_hyper9	] {ai_face();};
void() medic_hyper9	=[	192,		medic_hyper10	] {ai_face();};
void() medic_hyper10	=[	193,		medic_hyper11	] {ai_face();};
void() medic_hyper11	=[	194,		medic_hyper12	] {ai_face();};
void() medic_hyper12	=[	195,		medic_hyper13	] {ai_face(); medCastLasers(0);};
void() medic_hyper13	=[	196,		medic_hyper14	] {ai_face(); medCastLasers(0.25);};
void() medic_hyper14	=[	197,		medic_hyper15	] {ai_face(); medCastLasers(0.5);};
void() medic_hyper15	=[	198,		medic_hyper16	] {ai_face(); medCastLasers(0.75);};
void() medic_hyper16	=[	199,		medic_hyper17	] {ai_face(); medCastLasers(1);};
void() medic_hyper17	=[    200,		medic_hyper18	] {ai_face(); medCastLasers(1.5);};
void() medic_hyper18	=[	201,		medic_hyper19	] {ai_face(); medCastLasers(1);};
void() medic_hyper19	=[	202,		medic_hyper20	] {ai_face(); medCastLasers(0.7);};
void() medic_hyper20	=[	203,		medic_hyper21	] {ai_face(); medCastLasers(0.5);};
void() medic_hyper21	=[	204,		medic_hyper22	] {ai_face(); medCastLasers(0.2);};
void() medic_hyper22	=[	205,		medic_hyper23	] {ai_face(); medCastLasers(0);};
void() medic_hyper23	=[	206,		medic_hyperend1  	] {ai_face(); medCastLasers(0);};

void() medic_hyperend1	=[	207,		medic_hyperend2	] {ai_forward(1);};
void() medic_hyperend2	=[	208,		medic_hyperend3	] {ai_forward(2);};
void() medic_hyperend3	=[	209,		medic_hyperend4	] {ai_forward(2);};
void() medic_hyperend4	=[	210,		medic_hyperend5	] {ai_forward(1);};
void() medic_hyperend5	=[	211,		medic_run1		] {ai_forward(0.2);};

void() medic_blaster8	=[	177,		medic_blaster9	] {ai_face();};
void() medic_blaster9	=[	178,		medic_blaster10	] {ai_charge(5);};
void() medic_blaster10	=[	179,		medic_blaster11	] {ai_charge(5);};
void() medic_blaster11	=[	180,		medic_blaster12	] {ai_charge(3);};
void() medic_blaster12	=[	181,		medic_blaster13	] {ai_charge(2);};
void() medic_blaster13	=[	182,		medic_blaster14	] {ai_face(); };
void() medic_blaster14	=[	183,		medic_blaster15	] {ai_face(); };
void() medic_blaster15	=[	184,		medic_blaster16	] {ai_face();};
void() medic_blaster16	=[	185,		medic_blaster17	] {ai_face(); medCastLasers(0);};
void() medic_blaster17	=[	186,		medic_blaster18	] {ai_face();};
void() medic_blaster18	=[	187,		medic_blaster19	] {ai_face();};
void() medic_blaster19	=[	188,		medic_blaster20	] {ai_face(); medCastLasers(0);};
void() medic_blaster20	=[	189,		medic_blaster21	] {ai_face();};
void() medic_blaster21	=[	190,		medic_run1  	] 
{	
	if(random() < 0.9 && visible(self.enemy) && !(self.flags & FL_MEDIC))
		medic_hyper8();
};

void() medic_attack = 
{
	medic_srch();
	if((self.flags & FL_MEDIC))
		medic_cable8();
	else if(!(self.flags & FL_MEDIC))
		medic_blaster8();

	SUB_AttackFinished (0.2 + 2*random());
}

void()	medic_pain1	=[	109,		medic_pain2	] {};
void()	medic_pain2	=[	110,		medic_pain3	] {};
void()	medic_pain3	=[	111,		medic_pain4	] {};
void()	medic_pain4	=[	112,		medic_pain5	] {};
void()	medic_pain5	=[	113,		medic_pain6	] {};
void()	medic_pain6	=[	114,		medic_run1	] {};


void()	medic_painb1	=[	117,	medic_painb2] {};
void()	medic_painb2	=[	118,	medic_painb3] {};
void()	medic_painb3	=[	119,	medic_painb4] {};
void()	medic_painb4	=[	120,	medic_painb5] {};
void()	medic_painb5	=[	123,	medic_painb6] {};
void()	medic_painb6	=[	124,	medic_painb7] {};
void()	medic_painb7	=[	125,	medic_painb8] {};
void()	medic_painb8	=[	126,	medic_painb9] {};
void()	medic_painb9	=[	127,	medic_painb10] {};
void()	medic_painb10	=[	128,	medic_painb11] {};
void()	medic_painb11	=[	129,	medic_run1	] {};

float halfamedic = 150;

void(entity attacker, float damage)	medic_pain =
{
	local float	r;
	r = random();

	if (self.health < halfamedic)
		self.skin = 1;
		
	if (self.flags & FL_MEDIC) return;

	// don't make multiple pain sounds right after each other
	if (self.pain_finished > time)
		return;

	if (r < 0.5)
		sound (self, CHAN_VOICE, "medic/medpain1.wav", 1, ATTN_NORM);	
	else
		sound (self, CHAN_VOICE, "medic/medpain2.wav", 1, ATTN_NORM);	

	if (self.dcnt)
		return;
	if (skill == 3)
		return;	
	self.pain_finished = time + 3;	
	
	if (r < 0.5)
		medic_pain1();	
	else
		medic_painb1();
};

void()	medic_die1	=[	148,	medic_die2	] {};
void()	medic_die2	=[	149,	medic_die3	] {ai_back(13);};
void()	medic_die3	=[	150,	medic_die4	] {ai_back(13);};

void()	medic_die4	=[	151,	medic_die5	] {};
void()	medic_die5	=[	152,	medic_die6	] {};
void()	medic_die6	=[	153,	medic_die7	] {};
void()	medic_die7	=[	154,	medic_die8	] {};
void()	medic_die8	=[	155,	medic_die9	] {};
void()	medic_die9	=[	156,	medic_die10	] {};
void()	medic_die10	=[	157,	medic_die11	] {self.maxs_z = -8; self.solid = SOLID_CORPSE;};

void() medic_die11	= [ self.frame,	medic_die11	] 
{
	if(self.frame < 158)
		self.frame = 158;

	if(self.frame == 176)
	{
		self.nextthink = -1;
		return;
	}

	self.frame ++;
};

void()	medic_duckdown1	=[	132,	medic_duckdown2	] 
{
	self.dcnt = 1; 
	self.nextthink = self.dspeed; 
	self.maxs_z -= 32; 
	self.takedamage = DAMAGE_YES;
	ai_face();
};
void()	medic_duckdown2	=[	133,	medic_duckdown3	] {ai_face(); self.dodge_finished = time + 0.33 + 2*random();};
void()	medic_duckdown3	=[	134,	medic_duckhold	] {ai_face();};

void()	medic_duckup1	=[	137,	medic_duckup2	] 
{self.dodge_finished = time + 1 + random()*2; self.takedamage = DAMAGE_AIM; self.flags = self.flags - (self.flags & FL_DODGED); self.dcnt = 0; self.maxs_z += 32;};
void()	medic_duckup2	=[	139,	medic_duckup3	] {};
void()	medic_duckup3	=[	140,	medic_duckup4	] {};
void()	medic_duckup4	=[	141,	medic_duckup5	] {};
void()	medic_duckup5	=[	142,	medic_duckup6	] {};
void()	medic_duckup6	=[	143,	medic_duckup7	] {};
void()	medic_duckup7	=[	144,	medic_run1		] {};

void()	medic_duckhold =[	136,	medic_duckhold 	]	
{
	if(time > self.dodge_finished)
		self.think = medic_duckup1;
};

void() 	medic_duck =
{
	if (self.flags & FL_MEDIC) return;
	medic_duckdown1 ();
}

void() medic_die =
{	
	if(self.enemy && self.enemy.owner == self)
		self.enemy.owner = __NULL__;	

	if(self.dcnt)
	{
		self.maxs_z += 32;
		self.dcnt = 0;
		self.flags = self.flags - (self.flags & FL_DODGED);
	}

	// check for gib
	if (self.health < -130)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		MonsterGib (4, 0, 1, 0, 2, 0, self.health);
		return;
	}

	// don't die a regular death again as corpse
	if((self.deadflag & DEAD_DEAD))
		return;

// regular death
	
	sound (self, CHAN_VOICE, "medic/meddeth1.wav", 1, ATTN_NORM);
	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_YES;
	self.skin = 1;

	medic_die1 ();

	self.deadflag = DEAD_DEAD;
};

/*QUAKED monster_medic (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/
void() spawn_medic;
void() monster_medic =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/medic.mdl");
	precache_model ("progs/h_ogre.mdl");

	precache_sound ("medic/meddeth1.wav");
	precache_sound ("medic/gunidle1.wav");
	precache_sound ("medic/medatck1.wav");
	precache_sound ("medic/medatck2.wav");
	precache_sound ("medic/medatck3.wav");
	precache_sound ("medic/medatck4.wav");
	precache_sound ("medic/medatck5.wav");
	precache_sound ("medic/medpain1.wav");
	precache_sound ("medic/medpain2.wav");
	precache_sound ("medic/medsrch1.wav");
	precache_sound ("medic/idle.wav");
	precache_sound ("medic/medsght1.wav");

	spawn_medic();
};

void() spawn_medic =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/medic.mdl");
	
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 300;
	self.max_health = 99999999; // hack?
	self.mass = 400;
	self.skin = 0;

	self.th_stand = medic_stand1;
	self.th_walk = medic_walk1;
	self.th_run = medic_run1;
	self.th_die = medic_die;
	self.th_dodge = medic_duck;
	self.th_missile = medic_attack;
	self.th_pain = medic_pain;
	self.th_spawn = spawn_medic;
	self.th_checkatck = MedicCheckAttack;
	
	walkmonster_start();
};
