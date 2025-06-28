/*
==============================================================================

SHAMBLER

==============================================================================
*/

$cd id1/models/parasite
$origin 0 0 24
$base base		
$skin base

/*
===========
ParCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() ParCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	if (time < self.attack_finished)
		return FALSE;
	
	if (!enemy_vis)
		return FALSE;
		
	targ = self.enemy;
	
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
			
// missile attack
	
	if (enemy_range == RANGE_FAR)
		return FALSE;
	else if (enemy_range == RANGE_NEAR)
		return FALSE;
	else if (enemy_range == RANGE_MID)
		return FALSE;
	else if (enemy_range == RANGE_CLOSE)
		chance = 0.66;	
	else if (enemy_range == RANGE_MELEE)
		chance = 0.9;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (0.6 + random()*2);
		return TRUE;
	}

	return FALSE;
};


void() parasite_stand1	= [	self.frame,	parasite_stand1	] 
{
	if(self.frame < 82)
		self.frame = 82;

	self.frame ++;
	if(self.frame > 117)
		self.frame = 82;
	
	if(self.frame == 117)
		if (random() < 0.2)
			sound (self, CHAN_VOICE, "parasite/paridle1.wav", 1, ATTN_IDLE);
		else if (random() < 0.4)
			sound (self, CHAN_VOICE, "parasite/paridle2.wav", 1, ATTN_IDLE);

	ai_stand();
};

void() parasite_walk1       =[      70,        parasite_walk2      ] {ai_walk(23);}
void() parasite_walk2       =[      71,        parasite_walk3      ] {ai_walk(14);}
void() parasite_walk3       =[      72,        parasite_walk4      ] {ai_walk(14);}
void() parasite_walk4       =[      73,        parasite_walk5      ] {ai_walk(21);}
void() parasite_walk5       =[      74,        parasite_walk6      ] {ai_walk(12);}
void() parasite_walk6       =[      75,        parasite_walk7      ] {ai_walk(12);}
void() parasite_walk7       =[      76,        parasite_walk1      ] {ai_walk(13);
if (random() > 0.8 && time > self.show_hostile)
	sound (self, CHAN_VOICE, "parasite/parsrch1.wav", 1, ATTN_IDLE);
}

void() parasite_run1       =[      70,        parasite_run2      ] {ai_run(23);}
void() parasite_run2       =[      71,        parasite_run3      ] {ai_run(14);}
void() parasite_run3       =[      72,        parasite_run4      ] {ai_run(14);}
void() parasite_run4       =[      73,        parasite_run5      ] {ai_run(21);}
void() parasite_run5       =[      74,        parasite_run6      ] {ai_run(12);}
void() parasite_run6       =[      75,        parasite_run7      ] {ai_run(12);}
void() parasite_run7       =[      76,        parasite_run1      ] {ai_run(13);
if (random() > 0.8 && time > self.show_hostile)
	sound (self, CHAN_VOICE, "parasite/parsrch1.wav", 1, ATTN_IDLE);
}

//============================================================================


void() parasite_pain1       =[      57, parasite_pain2      ] {}
void() parasite_pain2       =[      58, parasite_pain3      ] {}
void() parasite_pain3       =[      59, parasite_pain4      ] {}
void() parasite_pain4       =[      60, parasite_pain5      ] {}
void() parasite_pain5       =[      61, parasite_pain6      ] {}
void() parasite_pain6       =[      62, parasite_pain7      ] {}
void() parasite_pain7       =[      63, parasite_pain8      ] {ai_painforward(6);}
void() parasite_pain8       =[      64, parasite_pain9      ] {ai_painforward(16);}
void() parasite_pain9       =[      65, parasite_pain10     ] {ai_pain(6);}
void() parasite_pain10      =[      66, parasite_pain11     ] {ai_pain(7);}
void() parasite_pain11      =[      67, parasite_run1       ] {}

void() spawnhook =
{
	local entity e;
	e = spawn();
	e.origin = self.pos1;
	e.solid = SOLID_BBOX;
	setsize (e, VEC_ORIGIN, VEC_ORIGIN);
	e.movetype = MOVETYPE_TOSS;
	e.velocity_z = 100;
	self.pos1 = e.origin + '0 0 -24';
	e.think = SUB_Remove;
	e.nextthink = time + 2;
}

void() CastCable2 =
{
	local vector org;
	
	org = self.origin + '0 0 -2';	

	traceline (org, self.pos1, TRUE, self);
	
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    	WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
    	WriteEntity(MSG_BROADCAST, self);
    	WriteCoord (MSG_BROADCAST, org_x);
    	WriteCoord (MSG_BROADCAST, org_y);
    	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);	
}; 

void() parasite_painb1      =[      0, parasite_painb2       ] {
	if(random() < 0.5)
		sound (self, CHAN_VOICE, "parasite/parpain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "parasite/parpain2.wav", 1, ATTN_NORM);
CastCable2(); spawnhook();}
void() parasite_painb2      =[      1, parasite_painb3       ] {CastCable2();ai_back(3);}
void() parasite_painb3      =[      2, parasite_painb4       ] {CastCable2();ai_forward(1);}
void() parasite_painb4      =[      3, parasite_painb5       ] {CastCable2();ai_forward(2);}
void() parasite_painb5      =[      4, parasite_painb6       ] {CastCable2();ai_back(3);}
void() parasite_painb6      =[      5, parasite_painb7       ] {CastCable2();ai_forward(1);}
void() parasite_painb7      =[      6, parasite_painb8       ] {CastCable2();ai_forward(1);}
void() parasite_painb8      =[      7, parasite_painb9       ] {CastCable2();ai_forward(3);}
void() parasite_painb9      =[      8, parasite_painb10      ] {CastCable2();}
void() parasite_painb10     =[      9, parasite_painb11      ] {CastCable2();ai_back(18);}
void() parasite_painb11     =[      10, parasite_painb12     ] {CastCable2();ai_forward(3);}
void() parasite_painb12     =[      11, parasite_painb13     ] {CastCable2();ai_forward(9);}
void() parasite_painb13     =[      12, parasite_painb14     ] {CastCable2();ai_forward(6);}
void() parasite_painb14     =[      13, parasite_painb15     ] {CastCable2();}
void() parasite_painb15     =[      14, parasite_painb16     ] {CastCable2();ai_back(18);}
void() parasite_painb16     =[      15, parasite_painb17     ] {CastCable2();}
void() parasite_painb17     =[      16, parasite_painb18     ] {CastCable2();ai_forward(8);}
void() parasite_painb18     =[      17, parasite_painb19     ] {CastCable2();ai_forward(9);}
void() parasite_painb19     =[      18, parasite_painb20     ] {CastCable2();}
void() parasite_painb20     =[      19, parasite_painb21     ] {CastCable2(); ai_back(18);}
void() parasite_painb21     =[      20, parasite_painb22     ] {}
void() parasite_painb22     =[      21, parasite_painb23     ] {}
void() parasite_painb23     =[      22, parasite_painb24     ] {}
void() parasite_painb24     =[      23, parasite_painb25     ] {}
void() parasite_painb25     =[      24, parasite_painb26     ] {}
void() parasite_painb26     =[      25, parasite_painb27     ] {}
void() parasite_painb27     =[      26, parasite_painb28     ] {}
void() parasite_painb28     =[      27, parasite_painb29     ] {ai_forward(4);}
void() parasite_painb29     =[      28, parasite_painb30     ] {ai_forward(11);}
void() parasite_painb30     =[      29, parasite_painb31     ] {ai_back(2);}
void() parasite_painb31     =[      30, parasite_painb32     ] {ai_back(5);}
void() parasite_painb32     =[      31, parasite_run1        ] {ai_forward(1);}

void() parasite_painc1       =[      57, parasite_painc2      ] {CastCable2(); spawnhook();}
void() parasite_painc2       =[      58, parasite_painc3      ] {CastCable2();}
void() parasite_painc3       =[      59, parasite_painc4      ] {}
void() parasite_painc4       =[      60, parasite_painc5      ] {}
void() parasite_painc5       =[      61, parasite_painc6      ] {}
void() parasite_painc6       =[      62, parasite_painc7      ] {}
void() parasite_painc7       =[      63, parasite_painc8      ] {ai_painforward(6);}
void() parasite_painc8       =[      64, parasite_painc9      ] {ai_painforward(16);}
void() parasite_painc9       =[      65, parasite_painc10     ] {ai_pain(6);}
void() parasite_painc10      =[      66, parasite_painc11     ] {ai_pain(7);}
void() parasite_painc11      =[      67, parasite_run1       ] {}

void() parasite_magic16;

void() CastCable =
{
	self.pos1 = self.enemy.origin + '0 0 -24'; 

	if (self.cnt)
	{
		parasite_painb1();
		self.pain_finished = time + 2;
		self.cnt = 0;
		return;
	}

	local vector org, end, delta;
	local float damage;
	
	org = self.origin + '0 0 6';
	end = self.enemy.origin + '0 0 6';
	
	delta = end - org;
	if (vlen(delta) > 300)
	{
		parasite_magic16();
		return;
	}
	
	traceline (self.origin, end, FALSE, self);
	if(trace_fraction != 1 && trace_ent != self.enemy)
	{
		if(random() < 0.6)
			parasite_pain1();
		else
			parasite_magic16();
		return;
	}	
	
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    	WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
    	WriteEntity(MSG_BROADCAST, self);
    	WriteCoord (MSG_BROADCAST, org_x);
    	WriteCoord (MSG_BROADCAST, org_y);
    	WriteCoord (MSG_BROADCAST, org_z);
    	WriteCoord (MSG_BROADCAST, end_x);
	WriteCoord (MSG_BROADCAST, end_y);
	WriteCoord (MSG_BROADCAST, end_z);	
	
	if(self.ltime < time)
		damage = 5;
	else
		damage = 3;
	
	T_Damage (self.enemy, self, self, damage, 0);

	if(self.frame == 43) sound (self, CHAN_WEAPON, "parasite/paratck2.wav", 1, ATTN_NORM);
};

void() CastCableCheck =
{
//	makevectors(self.angles);
	local vector org, end, delta;
	
	org = self.origin + '0 0 6';
	end = self.enemy.origin - self.enemy.velocity*0.2;
	
	delta = end - org;
	if (vlen(delta) > 300)
	{
		self.cnt = 1;
		return;
	}
	
	traceline (self.origin, end, FALSE, self);
	if(trace_fraction != 1 && trace_ent != self.enemy)
	{
		if(random() < 0.6)
			self.cnt = 1;
		else
			parasite_magic16();

		return;
	}
	else
		self.ltime = time + 0.6;
};


void() parasite_magic1     =[      39,       parasite_magic2    ] {ai_face(); CastCableCheck();}
void() parasite_magic2     =[      40,       parasite_magic3    ] {ai_face(); CastCableCheck();}
void() parasite_magic3     =[      41,       parasite_magic4    ] {ai_charge(15); CastCableCheck();}
void() parasite_magic4     =[      42,       parasite_magic5    ] {ai_face();CastCable();}
void() parasite_magic5     =[      43,       parasite_magic6    ] {ai_face();CastCable(); sound (self, CHAN_WEAPON, "parasite/paratck3.wav", 1, ATTN_NORM);}
void() parasite_magic6     =[      44,       parasite_magic9    ] {ai_face();CastCable();}
void() parasite_magic9     =[      45,       parasite_magic10   ] {ai_face();CastCable();}
void() parasite_magic10    =[      46,       parasite_magic11   ] {ai_charge(-2);CastCable();}
void() parasite_magic11    =[      47,       parasite_magic12   ] {ai_charge(-2);CastCable();}
void() parasite_magic12    =[      48,       parasite_magic13   ] {ai_charge(-3);CastCable();}
void() parasite_magic13    =[      49,       parasite_magic14   ] {ai_charge(-2);CastCable();}
void() parasite_magic14    =[      50,       parasite_magic15   ] {ai_face();CastCable();}
void() parasite_magic15    =[      51,       parasite_magic16   ] {ai_charge(-1);CastCable();}
void() parasite_magic16    =[      52,       parasite_magic17   ] {ai_face(); sound (self, CHAN_WEAPON, "parasite/paratck4.wav", 1, ATTN_NORM); }
void() parasite_magic17    =[      53,       parasite_magic18   ] {ai_charge(-2);}
void() parasite_magic18    =[      54,       parasite_magic19   ] {ai_charge(-2);}
void() parasite_magic19    =[      55,       parasite_magic20   ] {ai_charge(-3);}
void() parasite_magic20    =[      56,       parasite_run1      ] {ai_face();}

void() parasite_ranged = 
{
	parasite_magic1();
	sound (self, CHAN_WEAPON, "parasite/parsght1.wav", 1, ATTN_NORM);
	
}


void(entity attacker, float damage)	parasite_pain =
{
	if (self.health < self.max_health /2)
		self.skin = 1;
	
	if (self.health <= 0)
		return;		// allready dying, don't go into pain frame

	if (time < self.pain_finished)
		return;
	
	if (self.frame >= 43 && self.frame <= 50)
	{
		parasite_painb1 ();
		self.pain_finished = time + 4;
		return;
	}

	self.pain_finished = time + 3;

	if(random() < 0.5)
		sound (self, CHAN_VOICE, "parasite/parpain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "parasite/parpain2.wav", 1, ATTN_NORM);
	
	if(skill == 3)	return;

	parasite_pain1 ();
};


//============================================================================

void() parasite_death1      =[      32,       parasite_death2     ] {}
void() parasite_death2      =[      33,       parasite_death3     ] {}
void() parasite_death3      =[      34,       parasite_death4     ] {}
void() parasite_death4      =[      35,       parasite_death5     ] {}
void() parasite_death5      =[      36,       parasite_death6     ] {self.maxs_z = -8;  self.solid = SOLID_CORPSE;}
void() parasite_death6      =[      37,       parasite_death7     ] {}
void() parasite_death7      =[      38,       parasite_death7     ] {}


void() parasite_die =
{
// check for gib
	if (self.health < -175)
	{
		self.skin = 0;
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		MonsterGib (4, 0, 1, 0, 2, 0, self.health);
		return;
	}

// regular death
	if((self.deadflag & DEAD_DEAD))
		return;

	self.skin = 1;
	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_YES;

	self.deadflag = DEAD_DEAD;

	sound (self, CHAN_VOICE, "parasite/pardeth1.wav", 1, ATTN_NORM);
	parasite_death1 ();
};

//============================================================================


/*QUAKED monster_shambler (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/

void() spawn_parasite;

void() monster_parasite =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/parasite.mdl");
	precache_model ("progs/h_shams.mdl");
	precache_model ("progs/bolt.mdl");
	
	precache_sound ("parasite/paridle1.wav");
	precache_sound ("parasite/paridle2.wav");
	precache_sound ("parasite/pardeth1.wav");
	precache_sound ("parasite/parpain1.wav");
	precache_sound ("parasite/parpain2.wav");
	precache_sound ("parasite/parsrch1.wav");
	precache_sound ("parasite/paratck1.wav");
	precache_sound ("parasite/paratck2.wav");
	precache_sound ("parasite/paratck3.wav");
	precache_sound ("parasite/paratck4.wav");
	precache_sound ("parasite/parsght1.wav");

	spawn_parasite ();
};

void() spawn_parasite =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/parasite.mdl");

	setsize (self, '-16 -16 -24', '16 16 24');
	self.health = 175;
	self.max_health = 175;
	self.mass = 250;
	self.skin = 0;
	self.th_spawn = spawn_parasite;

	self.th_stand = parasite_stand1;
	self.th_walk = parasite_walk1;
	self.th_run = parasite_run1;
	self.th_die = parasite_die;
//	self.th_melee = parasite_melee;
	self.th_missile = parasite_ranged;
	self.th_pain = parasite_pain;
	self.th_checkatck = ParCheckAttack;
	walkmonster_start();
};