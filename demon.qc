/*
==============================================================================

DEMON

==============================================================================
*/

$cd id1/models/demon3
$scale	0.8
$origin 0 0 24
$base base
$skin base

//============================================================================

void() MutStepNoise =
{
	local float r = random();

	if(r < 0.6)
		sound(self, CHAN_VOICE, "mutant/step1.wav", 1, ATTN_NORM);
	else	if(r < 0.3)
		sound(self, CHAN_VOICE, "mutant/step2.wav", 1, ATTN_NORM);
	else	
		sound(self, CHAN_VOICE, "mutant/step3.wav", 1, ATTN_NORM);
}

void()	Demon_JumpTouch;

void()	demon1_stand2	=[	62,	demon1_stand3	] {ai_stand();}
void()	demon1_stand3	=[	63,	demon1_stand4	] {ai_stand();}
void()	demon1_stand4	=[	64,	demon1_stand5	] {ai_stand();}
void()	demon1_stand5	=[	65,	demon1_stand6	] {ai_stand();}
void()	demon1_stand6	=[	66,	demon1_stand7	] {ai_stand();}
void()	demon1_stand7	=[	67,	demon1_stand8	] {ai_stand();}
void()	demon1_stand8	=[	68,	demon1_stand9	] {ai_stand();}
void()	demon1_stand9	=[	69,	demon1_stand10	] {ai_stand();}
void()	demon1_stand10	=[	70,	demon1_stand11	] {ai_stand();}
void()	demon1_stand11	=[	71,	demon1_stand12	] {ai_stand();}
void()	demon1_stand12	=[	72,	demon1_stand13	] {ai_stand();}
void()	demon1_stand13	=[	73,	demon1_stand14	] {ai_stand();}
void()	demon1_stand14	=[	74,	demon1_stand15	] {ai_stand();}
void()	demon1_stand15	=[	75,	demon1_stand16	] {ai_stand();}
void()	demon1_stand16	=[	76,	demon1_stand17	] {ai_stand();}
void()	demon1_stand17	=[	77,	demon1_stand18	] {ai_stand();}
void()	demon1_stand18	=[	78,	demon1_stand19	] {ai_stand();}
void()	demon1_stand19	=[	79,	demon1_stand2	] {ai_stand(); 
if (random() < 0.2)
    sound (self, CHAN_VOICE, "mutant/mutidle1.wav", 1, ATTN_IDLE);}

void()	demon1_walk1	=[	130,		demon1_walk2	] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "mutant/mutsrch1.wav", 1, ATTN_IDLE);
ai_walk(8);
}
void()	demon1_walk2	=[	131,		demon1_walk3	] {ai_walk(6);}
void()	demon1_walk3	=[	132,		demon1_walk4	] {ai_walk(6);}
void()	demon1_walk4	=[	134,		demon1_walk5	] {ai_walk(7);}
void()	demon1_walk5	=[	135,		demon1_walk6	] {ai_walk(4);}
void()	demon1_walk6	=[	136,		demon1_walk7	] {ai_walk(6);}
void()	demon1_walk7	=[	137,		demon1_walk8	] {ai_walk(10);}
void()	demon1_walk8	=[	138,		demon1_walk9	] {ai_walk(6);}
void()	demon1_walk9	=[	139,		demon1_walk10	] {ai_walk(16);}
void()	demon1_walk10	=[	140,		demon1_walk11	] {ai_walk(15);}
void()	demon1_walk11	=[	141,		demon1_walk1	] {ai_walk(6);}

void()	demon1_run1	=[	56,		demon1_run2	] {
	ai_run(40);
};

void()	demon1_run2	=[	57,		demon1_run3	] {ai_run(40); MutStepNoise(); };
void()	demon1_run3	=[	58,		demon1_run4	] {ai_run(24);};
void()	demon1_run4	=[	59,		demon1_run5	] {ai_run(5); };
void()	demon1_run5	=[	60,		demon1_run6	] {ai_run(17); MutStepNoise(); };
void()	demon1_run6	=[	61,		demon1_run1	] {ai_run(10);};


void()	demon1_jump1	=[	0,		demon1_jump2	] {ai_face(); sound (self, CHAN_VOICE, "mutant/mutsght1.wav", 1, ATTN_IDLE);};
void()	demon1_jump2	=[	1,		demon1_jump3	] {ai_face();};
void()	demon1_jump3	=[	2,		demon1_jump4	] {ai_face();};
void()	demon1_jump4	=[	3,		demon1_jump5	]
{
	ai_face();
	
	self.touch = Demon_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 600 + '0 0 250';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	
	self.flags = self.flags | FL_LEAP;
};
void()	demon1_jump5	=[	3,		demon1_jump6	] {};
void()	demon1_jump6	=[	3,		demon1_jump7	] {};
void()	demon1_jump7	=[	3,		demon1_jump8	] {};
void()	demon1_jump8	=[ 	3,		demon1_jump9	] {};
void()	demon1_jump9	=[ 	3,		demon1_jump10	] {};
void()	demon1_jump10	=[ 	4,		demon1_jump1	] {
self.nextthink = time + 3;
// if three seconds pass, assume demon is stuck and jump again
};

void()	demon1_jump11	=[ 	5,		demon1_jump12	] {};
void()	demon1_jump12	=[ 	5,		demon1_run1	] {};


void()	demon1_atta1	=[	8,		demon1_atta2	] {ai_face();};
void()	demon1_atta2	=[	9,		demon1_atta3	] {ai_face();};
void()	demon1_atta3	=[	10,		demon1_atta4	] {ai_face();Demon_Melee(200);};
void()	demon1_atta4	=[	11,		demon1_atta5	] {ai_face();};
void()	demon1_atta5	=[	12,		demon1_atta6	] {ai_face();};
void()	demon1_atta6	=[	13,		demon1_atta7	] {ai_face();Demon_Melee(-200);};
void()	demon1_atta7	=[	14,		demon1_run1		] 
{ai_face();
	if(random() > 0.5) 
		SUB_CheckRefire(demon1_atta1); 
};

void()	demon1_pain1	=[	39,		demon1_pain2] {ai_pain(24);}
void()	demon1_pain2	=[	40,		demon1_pain3] {ai_painforward(11);}
void()	demon1_pain3	=[	41,		demon1_pain4] {ai_painforward(5);}
void()	demon1_pain4	=[	42,		demon1_pain5] {ai_pain(2);}
void()	demon1_pain5	=[	43,		demon1_pain6] {ai_painforward(6);}
void()	demon1_pain6	=[	44,		demon1_run1	] {ai_painforward(4);}

void()	demon1_painb1	=[	45,		demon1_painb2 ] {ai_pain(22);}
void()	demon1_painb2	=[	46,		demon1_painb3 ] {ai_painforward(3);}
void()	demon1_painb3	=[	47,		demon1_painb4 ] {ai_painforward(3);}
void()	demon1_painb4	=[	48,		demon1_painb5 ] {ai_painforward(2);}
void()	demon1_painb5	=[	49,		demon1_painb6 ] {ai_painforward(1);}
void()	demon1_painb6	=[	50,		demon1_painb7 ] {ai_painforward(1);}
void()	demon1_painb7	=[	51,		demon1_painb8 ] {ai_painforward(6);}
void()	demon1_painb8	=[	52,		demon1_painb9 ] {ai_painforward(3);}
void()	demon1_painb9	=[	53,		demon1_painb10] {ai_painforward(2);}
void()	demon1_painb10	=[	54,		demon1_run1	  ] {}

void()	demon1_painc1	=[	34,		demon1_painc2] {ai_painforward(4);}
void()	demon1_painc2	=[	35,		demon1_painc3] {ai_pain(3);}
void()	demon1_painc3	=[	36,		demon1_painc4] {ai_pain(8);}
void()	demon1_painc4	=[	37,		demon1_painc5] {ai_painforward(2);}
void()	demon1_painc5	=[	38,		demon1_run1	 ] {ai_painforward(5);}

void(entity attacker, float damage)	demon1_pain =
{	
	if (self.health < self.max_health / 2)
		self.skin =1;

	if (self.touch == Demon_JumpTouch)
		return;
	
	local float r = random();

	if (self.pain_finished > time)
		return;

	if (random()*200 > damage)
		return;		// didn't flinch
	
	self.pain_finished = time + 3;
	
	if (r < 0.5)
    		sound (self, CHAN_VOICE, "mutant/mutpain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "mutant/mutpain2.wav", 1, ATTN_NORM);

	if(skill == 3) return;

	if (r < 0.33)
		demon1_painc1();
	else if (r < 0.66)
		demon1_pain1();
	else
		demon1_painb1();
}


void()	demon1_die1		=[	15,		demon1_die2	] {}
void()	demon1_die2		=[	16,		demon1_die4	] {}
void()	demon1_die4		=[	17,		demon1_die5	] {}
void()	demon1_die5		=[	18,		demon1_die6	] {}
void()	demon1_die6		=[	19,		demon1_die7	] {}
void()	demon1_die7		=[	20,		demon1_die8	] {self.maxs_z = -8; self.solid = SOLID_CORPSE;}
void()	demon1_die8		=[	21,		demon1_die9	] {}
void()	demon1_die9		=[	22,		demon1_die10] {}
void()	demon1_die10	=[	23,		demon1_die10] {}

void()	demon1_bdie1	=[	24,		demon1_bdie2	] {}
void()	demon1_bdie2	=[	25,		demon1_bdie3	] {}
void()	demon1_bdie3	=[	26,		demon1_bdie4	] {}
void()	demon1_bdie4	=[	27,		demon1_bdie5	] {}
void()	demon1_bdie5	=[	28,		demon1_bdie6	] {}
void()	demon1_bdie6	=[	29,		demon1_bdie7	] {}
void()	demon1_bdie7	=[	30,		demon1_bdie8	] {}
void()	demon1_bdie8	=[	31,		demon1_bdie9	] {self.maxs_z = -8; self.solid = SOLID_CORPSE;}
void()	demon1_bdie9	=[	32,		demon1_bdie10	] {}
void()	demon1_bdie10	=[	33,		demon1_bdie10     ] {}

void() demon_die =
{
// check for gib
	if (self.health < -120)
	{
		self.skin = 0;
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		MonsterGib (4, 0, 1, 0, 2, 0, self.health);
		return;
	}

// regular death
	if((self.deadflag & DEAD_DEAD))
		return;

	sound (self, CHAN_VOICE, "mutant/mutdeth1.wav", 1, ATTN_NORM);
	self.deadflag = DEAD_DEAD;
	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_YES;
	self.skin = 1;
	if(random() < 0.5)
		demon1_die1 ();
	else
		demon1_bdie1();
};


void() Demon_MeleeAttack =
{
	demon1_atta1 ();
};


/*QUAKED monster_demon1 (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/

void() spawn_mutant;

void() monster_medic;


/*
==============================================================================

DEMON

==============================================================================
*/

/*
==============
CheckDemonMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckDemonMelee =
{
	if (enemy_range == RANGE_MELEE)
	{	// FIXME: check canreach
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};

/*
==============
CheckDemonJump

==============
*/
float()	CheckDemonJump =
{
	local	vector	dist;
	local	float	d;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 100)
		return FALSE;
		
	if (d > 100)
	{
		if (random() < 0.9)
			return FALSE;
	}
		
	return TRUE;
};

float()	DemonCheckAttack =
{	
// if close enough for slashing, go for it
	if (CheckDemonMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckDemonJump ())
	{
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished(3);
		return TRUE;
	}
	
	return FALSE;
};


//===========================================================================

void(float side)	Demon_Melee =
{
	local	float	ldmg;
	local vector	delta;
	
	ai_face ();
	walkmove (self.ideal_yaw, 12);	// allow a little closing

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
	{
		sound (self, CHAN_WEAPON, "mutant/mutatck1.wav", 1, ATTN_NORM);
		return;
	}
	if (!CanDamage (self.enemy, self))
		return;
	
	if(side == 200)
   		sound (self, CHAN_WEAPON, "mutant/mutatck2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "mutant/mutatck3.wav", 1, ATTN_NORM);

	ldmg = 10 + 10*random() % 5;
	T_Damage (self.enemy, self, self, ldmg);	

	makevectors (self.angles);
	SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
};


void()	Demon_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
	
	self.dmgtime = time + 0.6;
	if (other.takedamage && self.dmgtime > time)
	{
		if ( vlen(self.velocity) > 400 )
		{
			ldmg = 40 + 10*random();
			T_Damage (other, self, self, ldmg);	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	self.think = demon1_jump1;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = demon1_jump11;
	self.nextthink = time + 0.1;
	self.flags = self.flags - (self.flags & FL_LEAP);
};

//===========================================================================

void() monster_mutant =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/mutant.mdl");
	precache_model ("progs/h_demon.mdl");

	precache_sound ("mutant/mutsrch1.wav");
	precache_sound ("mutant/mutsght1.wav");
	precache_sound ("mutant/step1.wav");
	precache_sound ("mutant/step2.wav");
	precache_sound ("mutant/step3.wav");
	precache_sound ("mutant/mutpain1.wav");
	precache_sound ("mutant/mutpain2.wav");
	precache_sound ("mutant/mutidle1.wav");
	precache_sound ("mutant/mutdeth1.wav");
	precache_sound ("mutant/mutatck1.wav");
	precache_sound ("mutant/mutatck2.wav");
	precache_sound ("mutant/mutatck3.wav");

	spawn_mutant();
};

void() spawn_mutant =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/mutant.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 300;
	self.max_health = 300;
	self.mass = 300;
	self.skin = 0;

	self.th_stand = demon1_stand2;
	self.th_walk = demon1_walk1;
	self.th_run = demon1_run1;
	self.th_die = demon_die;
	self.th_melee = Demon_MeleeAttack;		// one of two attacks
	self.th_missile = demon1_jump1;			// jump attack
	self.th_pain = demon1_pain;
	self.th_spawn = spawn_mutant;
	self.th_checkatck = DemonCheckAttack;

	walkmonster_start();
};

void() monster_demon1 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/mutant.mdl");
	precache_model ("progs/h_demon.mdl");

	precache_sound ("mutant/mutsrch1.wav");
	precache_sound ("mutant/mutsght1.wav");
	precache_sound ("mutant/step1.wav");
	precache_sound ("mutant/step2.wav");
	precache_sound ("mutant/step3.wav");
	precache_sound ("mutant/mutpain1.wav");
	precache_sound ("mutant/mutpain2.wav");
	precache_sound ("mutant/mutidle1.wav");
	precache_sound ("mutant/mutdeth1.wav");
	precache_sound ("mutant/mutatck1.wav");
	precache_sound ("mutant/mutatck2.wav");
	precache_sound ("mutant/mutatck3.wav");

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

	if(self.classname == "monster_medic")
	{
		monster_medic();
		return;
	}
	else if(self.classname == "monster_mutant")
	{
		monster_mutant ();
		return;
	}
	
	local float r = random();
	
	if(r < 0.33)
	{
		self.classname = "monster_medic";
		monster_medic();
		return;
	}
	else
	{
		self.classname = "monster_mutant";
		monster_mutant ();
		return;
	}
};


