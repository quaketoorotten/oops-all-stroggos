/*
==============================================================================

SHAMBLER

==============================================================================
*/

$cd id1/models/glads
$origin 0 0 24
$base base		
$skin base

void() glad_stand1	=[	0,	glad_stand2	] {ai_stand();}
void() glad_stand2	=[	1,	glad_stand3	] {ai_stand();}
void() glad_stand3	=[	2,	glad_stand4	] {ai_stand();}
void() glad_stand4	=[	3,	glad_stand5	] {ai_stand();}
void() glad_stand5	=[	4,	glad_stand6	] {ai_stand();}
void() glad_stand6	=[	5,	glad_stand1	] {ai_stand();
if (random() > 0.2)
	sound (self, CHAN_VOICE, "gladiator/gldidle1.wav", 1, ATTN_IDLE);}

void() glad_walk1		=[      6,        glad_walk2 ] {ai_walk(15);}
void() glad_walk2       =[      7,        glad_walk3 ] {ai_walk(7);}
void() glad_walk3       =[      8,        glad_walk4 ] {ai_walk(6);}
void() glad_walk4       =[      9,        glad_walk5 ] {ai_walk(5);}
void() glad_walk5       =[      10,       glad_walk6 ] {ai_walk(2);}
void() glad_walk6       =[      11,       glad_walk7 ] {ai_walk(0);}
void() glad_walk7       =[      12,       glad_walk8 ] {ai_walk(2);}
void() glad_walk8       =[      13,       glad_walk9 ] {ai_walk(8);}
void() glad_walk9       =[      14,       glad_walk10] {ai_walk(12);}
void() glad_walk10      =[      15,       glad_walk11] {ai_walk(8);}
void() glad_walk11      =[      16,       glad_walk12] {ai_walk(5);}
void() glad_walk12      =[      17,       glad_walk13] {ai_walk(5);}
void() glad_walk13      =[      18,       glad_walk14] {ai_walk(2);}
void() glad_walk14      =[      19,       glad_walk15] {ai_walk(2);}
void() glad_walk15      =[      20,       glad_walk16] {ai_walk(1);}
void() glad_walk16      =[      21,       glad_walk1 ] {ai_walk(8);
if (random() > 0.2)
	sound (self, CHAN_VOICE, "gladiator/gldsrch1.wav", 1, ATTN_IDLE);}

void() glad_run1       =[      23,        glad_run2      ] {ai_run(23);}
void() glad_run2       =[      24,        glad_run3      ] {ai_run(14);}
void() glad_run3       =[      25,        glad_run4      ] {ai_run(14);}
void() glad_run4       =[      26,        glad_run5      ] {ai_run(21);}
void() glad_run5       =[      27,        glad_run6      ] {ai_run(12);}
void() glad_run6       =[      28,        glad_run1      ] {ai_run(13);
if (random() > 0.8 && time > self.show_hostile)
	sound (self, CHAN_VOICE, "gladiator/gldsrch1.wav", 1, ATTN_IDLE);
}

void(float side) ShamClaw =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
	{
		sound (self, CHAN_VOICE, "gladiator/melee3.wav", 1, ATTN_NORM);
		return;
	}
		
	ldmg = 20 + (random()*10) % 5;
	T_Damage (self.enemy, self, self, ceil(ldmg), 30);
	sound (self, CHAN_VOICE, "gladiator/melee2.wav", 1, ATTN_NORM);

	if (side)
	{
		makevectors (self.angles);
		SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};

void() glad_swingl1 =[      28,      glad_swingl2   ] {ai_face();}
void() glad_swingl2 =[      29,      glad_swingl3   ] {ai_face();}
void() glad_swingl3 =[      30,      glad_swingl4   ] {ai_face();}
void() glad_swingl4 =[      31,      glad_swingl5   ] {ai_face();}
void() glad_swingl5 =[      32,      glad_swingl6   ] {ai_face();	sound (self, CHAN_VOICE, "gladiator/melee1.wav", 1, ATTN_NORM);}
void() glad_swingl6 =[      33,      glad_swingl7   ] {ai_face();}
void() glad_swingl7 =[      34,      glad_swingl8   ] {ai_face(); ShamClaw(250);}
void() glad_swingl8 =[      35,      glad_swingl9   ] {}
void() glad_swingl9 =[      36,      glad_swingr1   ] {}

void() glad_swingr1 =[      37,      glad_swingr3   ] {ai_face();}
void() glad_swingr3 =[      38,      glad_swingr4   ] {ai_face();}
void() glad_swingr4 =[      39,      glad_swingr5   ] {ai_face();	sound (self, CHAN_VOICE, "gladiator/melee1.wav", 1, ATTN_NORM);}
void() glad_swingr5 =[      40,      glad_swingr6   ] {ai_face();}
void() glad_swingr6 =[      41,      glad_swingr7   ] {ai_face();}
void() glad_swingr7 =[      42,      glad_swingr8   ] {ai_face(); ShamClaw(-250);}
void() glad_swingr8 =[      43,      glad_swingr9   ] {}
void() glad_swingr9 =[      44,      glad_run1      ] {}

void() glad_melee =
{
	glad_swingl1 ();
};

//============================================================================

void(vector org) THING =
{
	newmis = spawn();
	newmis.velocity = '0 0 0';
	newmis.origin = org;
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 0.2;
}

void() CastLightning =
{
	local	vector	org, dir, loc;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	ai_face ();

	org = self.origin + '0 0 24';
	loc = org + v_right * -16;

	dir = self.pos1 - org;
	dir = normalize (dir);

//	THING(loc);

	fireRail (loc, dir, self, 50, 40, TE_BEAM, 8192);
};


void() glad_magic1     =[      45,       glad_magic2    ] {ai_face();}
void() glad_magic2     =[      46,       glad_magic3    ] {ai_face();}
void() glad_magic3     =[      47,       glad_magic4    ] {ai_face(); self.pos1 = self.enemy.origin + self.enemy.view_ofs; }
void() glad_magic4     =[      48,       glad_magic5    ] {ai_face();}
void() glad_magic5     =[      49,       glad_magic6    ] {CastLightning();}
void() glad_magic6     =[      50,       glad_magic9    ] {}
void() glad_magic9     =[      51,       glad_magic10   ] {}
void() glad_magic10    =[      52,       glad_run1      ] {}

void() glad_ranged = 
{
	if (enemy_range == RANGE_MELEE)
		if (CanDamage (self.enemy, self))
		{
			self.th_melee();
			return;
		}

	sound (self, CHAN_WEAPON, "gladiator/railgun.wav", 1, ATTN_NORM);
	glad_magic1();
}


void() glad_pain1       =[      54, glad_pain2      ] {}
void() glad_pain2       =[      55, glad_pain3      ] {}
void() glad_pain3       =[      56, glad_pain4      ] {}
void() glad_pain4       =[      57, glad_pain5      ] {}
void() glad_pain5       =[      58, glad_pain6      ] {}
void() glad_pain6       =[      59, glad_run1       ] {}

void() glad_painb1       =[      83, glad_painb2      ] {}
void() glad_painb2       =[      84, glad_painb3      ] {}
void() glad_painb3       =[      85, glad_painb4      ] {}
void() glad_painb4       =[      86, glad_painb5      ] {}
void() glad_painb5       =[      87, glad_painb6      ] {}
void() glad_painb6       =[      88, glad_painb7      ] {}
void() glad_painb7       =[      89, glad_run1        ] {}

void(entity attacker, float damage)	glad_pain =
{
	if (self.health < self.max_health /2)
		self.skin = 1;
	
	if (self.health <= 0)
		return;		// allready dying, don't go into pain frame

	if (time < self.pain_finished)
	{
		if ((self.velocity[2] > 100) && (self.frame >= 54 && self.frame <= 89))
			glad_painb1 ();
		return;
	}

	self.pain_finished = time + 3;

	if(random() < 0.5)
		sound (self, CHAN_VOICE, "gladiator/pain.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "gladiator/gldpain2.wav", 1, ATTN_NORM);
	
	if(skill == 3)	return;

	if ((self.velocity[2] > 100))
		glad_painb1 ();
	else
		glad_pain1 ();
};


//============================================================================

void() glad_death1      =[      60,       glad_death2     ] {}
void() glad_death2      =[      61,       glad_death3     ] {}
void() glad_death3      =[      62,       glad_death4     ] {}
void() glad_death4      =[      63,       glad_death5     ] {}
void() glad_death5      =[      64,       glad_death6     ] {}
void() glad_death6      =[      65,       glad_death7     ] {}
void() glad_death7      =[      67,       glad_death8     ] {}
void() glad_death8      =[      68,       glad_death9     ] {}
void() glad_death9      =[      69,       glad_death10    ] {}
void() glad_death10     =[      70,       glad_death11    ] {}
void() glad_death11     =[      71,       glad_death12    ] {}
void() glad_death12     =[      72,       glad_death13    ] {}
void() glad_death13     =[      73,       glad_death14    ] {}
void() glad_death14     =[      74,       glad_death15    ] {self.maxs_z = -8;  self.solid = SOLID_CORPSE;}
void() glad_death15     =[      75,       glad_death16    ] {}
void() glad_death16     =[      75,       glad_death17    ] {}
void() glad_death17     =[      77,       glad_death18    ] {}
void() glad_death18     =[      78,       glad_death19    ] {}
void() glad_death19     =[      79,       glad_death20    ] {}
void() glad_death20     =[      80,       glad_death21    ] {}
void() glad_death21     =[      81,       glad_death21    ] {}

void() glad_die =
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

	sound (self, CHAN_VOICE, "gladiator/glddeth2.wav", 1, ATTN_NORM);
	glad_death1 ();
};

//============================================================================


/*QUAKED monster_shambler (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/

void() spawn_glad;

void() monster_gladiator =
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

	spawn_glad();
};

void() spawn_glad =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/gladiatr.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 400;
	self.max_health = 400;
	self.mass = 400;
	self.skin = 0;
	self.th_spawn = spawn_glad;

	self.th_stand = glad_stand1;
	self.th_walk = glad_walk1;
	self.th_run = glad_run1;
	self.th_die = glad_die;
	self.th_melee = glad_melee;
	self.th_missile = glad_ranged;
	self.th_pain = glad_pain;
	walkmonster_start();
};