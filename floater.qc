/*
==============================================================================

WIZARD

==============================================================================
*/

$cd id1/models/a_floaterard
$origin 0 0 24
$base floaterbase	
$skin floaterbase

void() floater_run1;

/*
==============================================================================

FAST ATTACKS

==============================================================================
*/

/*
=================
FliesCheckAttack
=================
*/
float()	FliesCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;
	
	if ((enemy_range == RANGE_MELEE))
	{
		self.th_melee();
		return TRUE;
	}

	if (time < self.attack_finished)
		return FALSE;
	if (!enemy_vis)
		return FALSE;

	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			self.th_run ();
		}
		return FALSE;
	}
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
	{	// don't have a clear shot, so move to a side
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			self.th_run ();
		}
		return FALSE;
	}
			
	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_CLOSE)
		chance = 0.6;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.2;
	else if (enemy_range == RANGE_MID)
		chance = 0.1;
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	if (enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			self.th_run ();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
		}
	}
	
	return FALSE;
};

/*
=================
WizardAttackFinished
=================
*/
void()	FliesAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = self.th_run;
	}
	else
	{
		self.attack_state = AS_SLIDING;
	}
};



void(float off) Hover_StartFast =
{	
	ai_face();
	makevectors(self.angles);
	local vector org;
	org = self.origin + '0 0 16' + v_forward * 14 + v_right * off;
	LaunchLaser(org, self.enemy.origin - org + self.enemy.view_ofs);
};

void(float off) Flyer_StartFast =
{	
	ai_face();
	makevectors(self.angles);
	local vector org;
	org = self.origin + v_forward * 14 + v_right * off;
	LaunchLaser(org, self.enemy.origin - org + self.enemy.view_ofs);
};

void() Float_StartFast =
{	
	ai_face();
	makevectors(self.angles);
	sound (self, CHAN_WEAPON, "floater/fltatck1.wav", 1, ATTN_NORM);
	local vector org;
	org = self.origin + '0 0 16' + v_forward * 14;
	LaunchLaser(org, self.enemy.origin - org + self.enemy.view_ofs);
};

void() Wiz_srchsound =
{
local float wr;
	wr = random() * 5;

	if (self.waitmin < time)
	{
	 	self.waitmin = time + 2;
	 	if (wr > 4.5) 
	 		sound (self, CHAN_VOICE, "hover/hovsrch1.wav", 1,  ATTN_IDLE);
	 	if (wr < 1.5)
	 		sound (self, CHAN_VOICE, "hover/hovsrch2.wav", 1, ATTN_IDLE);
	}
	return;
};

void()	floater_stand1	= [	144,	floater_stand2		] {}
void()	floater_stand2	= [	self.frame,	floater_stand2	] 
{
	self.frame ++;
	if(self.frame >= 247)
		floater_stand1();

	ai_stand();

	if(self.frame == 246)
		if (random() > 0.8)
			sound (self, CHAN_VOICE, "floater/fltidle1.wav", 1, ATTN_IDLE);
};

void()	floater_walk1	= [	144,		floater_walk2	] 
{ai_walk(4);
if (random() > 0.8)
		sound (self, CHAN_VOICE, "floater/fltsrch1.wav", 1, ATTN_IDLE); }
void()	floater_walk2	= [	self.frame,	floater_walk2	] 
{
	self.frame ++;

	ai_walk(5);

	if(self.frame >= 247)
		floater_walk1();
};

void()	floater_run1	= [	144,		floater_run2	] 
{ai_run(15);
if (random() > 0.8)
		sound (self, CHAN_VOICE, "floater/fltsrch1.wav", 1, ATTN_IDLE); }
void()	floater_run2	= [	self.frame,	floater_run2	] 
{
	self.frame ++;

	ai_run(15);

	if(self.frame >= 247)
		floater_run1();
};

void()	floater_fast1	=[	31,		floater_fast2	] {ai_face();};
void()	floater_fast2	=[	32,		floater_fast3	] {ai_face();};
void()	floater_fast3	=[	33,		floater_fast4	] {Float_StartFast();};
void()	floater_fast4	=[	34,		floater_fast5	] {Float_StartFast();};
void()	floater_fast5	=[	35,		floater_fast6	] {Float_StartFast();};
void()	floater_fast6	=[	36,		floater_fast7	] {Float_StartFast();};
void()	floater_fast7	=[	37,		floater_fast8	] {Float_StartFast();};
void()	floater_fast8	=[	38,		floater_fast9	] {Float_StartFast();};
void()	floater_fast9	=[	39,		floater_fast10	] {Float_StartFast();};
void()	floater_fast10	=[	40,		floater_fast11	] {Float_StartFast();};
void()	floater_fast11	=[	41,		floater_fast12	] {ai_face();};
void()	floater_fast12	=[	42,		floater_fast13	] {ai_face();};
void()	floater_fast13	=[	43,		floater_fast14	] {ai_face();};
void()	floater_fast14	=[	44,		floater_run1	] {ai_face(); SUB_AttackFinished(1); FliesAttackFinished(); };

void()	floater_atkchar2;

void() floatClaw =
{
	local vector	delta;
	local float 	ldmg;
	
	sound (self, CHAN_WEAPON, "floater/fltatck3.wav", 1, ATTN_NORM);
	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 80)
		return;
		
	ldmg = 5 + random()*10 % 6;
	T_Damage (self.enemy, self, self, ceil(ldmg), 30);

};
void()	floater_atkrefire	= [	56,		floater_atkchar2	] {ai_charge(15);}
void()	floater_atkchar1	= [	45,		floater_atkchar2	] {ai_charge(15); }
void()	floater_atkchar2	= [	self.frame,	floater_atkchar2	] 
{
	self.frame ++;

	ai_charge(15);
	
	if(self.frame == 57)
		floatClaw ();
	
	if(self.frame == 63)
		if(random() < 0.6)
			SUB_CheckRefire (floater_atkrefire);

	if(self.frame >= 69)
		floater_run1 ();
};

void() floatZap =
{
	local	vector	org, dir, loc;
	local float 	ldmg;

	local vector 	end, delta;
	
	org = self.origin + '0 0 16';
	end = self.enemy.origin + '0 0 16';
	
	delta = end - org;
	if (vlen(delta) > 300)
	{
		self.frame = 98;
		return;
	}
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	
	makevectors(self.angles);
	org = self.origin + '0 0 16' + v_forward*14;
	
	loc = self.enemy.origin - self.enemy.velocity * 0.2 + self.enemy.view_ofs;
	dir = loc - org;
	dir = normalize (dir);

//	THING(loc);
	
	ldmg = 3 + random()*10 % 5;
	ldmg = ceil(ldmg);
	fireRail (org, dir, self, ldmg, 2, TE_LIGHTNING2, 512);
	
	if(self.frame >= 84 && self.frame <= 97)
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);	
};

void()	floater_zap1	= [	70,		floater_zap2	] {ai_face(); }
void()	floater_zap2	= [	self.frame,	floater_zap2	] 
{
	self.frame ++;

	ai_face();
	
	if(self.frame == 79)
		sound (self, CHAN_WEAPON, "floater/fltatck2.wav", 1, ATTN_NORM);	
	
	if(self.frame >= 79 && self.frame <= 97)
		floatZap();
	
	if(self.frame >= 103)
	{
		SUB_AttackFinished(1 + 2*random() );
		floater_run1 ();
	}
};


void()	floater_painc1	=[	117,		floater_painc2	] {};
void()	floater_painc2	=[	118,		floater_painc3	] {};
void()	floater_painc3	=[	119,		floater_painc4	] {};
void()	floater_painc4	=[	120,		floater_painc5	] {};
void()	floater_painc5	=[	121,		floater_painc6	] {};
void()	floater_painc6	=[	122,		floater_painc7	] {};
void()	floater_painc7	=[	123,		floater_run1	] {};

void()	floater_painb1	=[	124,		floater_painb2	] {};
void()	floater_painb2	=[	125,		floater_painb3	] {};
void()	floater_painb3	=[	126,		floater_painb4	] {};
void()	floater_painb4	=[	127,		floater_painb5	] {};
void()	floater_painb5	=[	128,		floater_painb6	] {};
void()	floater_painb6	=[	129,		floater_painb7	] {};
void()	floater_painb7	=[	130,		floater_painb8	] {};
void()	floater_painb8	=[	131,		floater_run1	] {};

void()	floater_pain3	= [	143,		floater_run1	] { }
void()	floater_pain1	= [	132,		floater_pain2	] { }

void()	floater_pain2	= [	self.frame,	floater_pain2	] 
{	
	self.frame ++;

	if(self.frame >= 142)
		floater_pain3();
};

void()	floater_explode	=
{
	self.gravity = 0;
	self.skin = 0;
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	MonsterGib (0, 6, 0, 0, 0, 4, self.health);
	BecomeExplosion ();
	
};

void()	floater_death1	=[	104,		floater_death2	] {};
void()	floater_death2	=[	105,		floater_death3	] {};
void()	floater_death3	=[	106,		floater_death4	] {};
void()	floater_death4	=[	107,		floater_death5	] {};
void()	floater_death5	=[	108,		floater_death6	] {};
void()	floater_death6	=[	109,		floater_death7	] {};
void()	floater_death7	=[	110,		floater_death8	] {};
void()	floater_death8	=[	111,		floater_death9	] {};
void()	floater_death9	=[	112,		floater_death10	] {};
void()	floater_death10	=[	113,		floater_death11	] {};
void()	floater_death11	=[	114,		floater_death12	] {};
void()	floater_death12	=[	115,		floater_death13	] {};
void()	floater_death13	=[	116,		floater_death13	] {floater_explode(); };

void() floater_die =
{
// check for gib
	if (self.health < -80)
	{
		self.skin = 0;
		MonsterGib (0, 6, 0, 0, 0, 4, self.health);
		BecomeExplosion ();
		return;
	}
	if((self.deadflag & DEAD_DEAD))
		return;
	
	sound (self, CHAN_VOICE, "floater/fltdeth1.wav", 1, ATTN_NORM);
	self.deadflag = DEAD_DEAD;
	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_YES;
	self.skin = 1;
	floater_death1 ();
//	self.touch = floater_explode;
	self.gravity = 2.25 * (self.mass / 200);
};


void(entity attacker, float damage) floater_Pain =
{
	if (self.health < (self.max_health / 2))
		self.skin = 1;

	if (time < self.pain_finished)
		return;
	
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "floater/fltpain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "floater/fltpain2.wav", 1, ATTN_NORM);

	self.pain_finished = time + 3;

	if (skill == 3)
		return;		// no pain anims in nightmare

	if (random() < 0.33)
		floater_painc1 ();
	else if (random() < 0.66)
		floater_painb1 ();
	else
		floater_pain1 ();
};


void() floater_Missile =
{	
	local vector org, end, delta;
	
	org = self.origin + '0 0 16';
	end = self.enemy.origin + '0 0 16';
	
	delta = end - org;
	if (vlen(delta) < 300)
	{	
		if(random() < 0.4)
			floater_zap1();
		return;
	}

	floater_fast1();
};

/*QUAKED monster_floater (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() spawn_floater;
void() monster_floater=
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/float.mdl");

	precache_sound ("floater/fltatck1.wav");		
	precache_sound ("floater/fltatck2.wav");
	precache_sound ("floater/fltatck3.wav");
	precache_sound ("floater/fltdeth1.wav");
	precache_sound ("floater/fltidle1.wav");
	precache_sound ("floater/fltpain1.wav");
	precache_sound ("floater/fltpain2.wav");
	precache_sound ("floater/fltsght1.wav");
	precache_sound ("floater/fltsrch1.wav");

	spawn_floater();
};

void() spawn_floater = 
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/float.mdl");

	setsize (self, '-24 -24 -24', '24 24 32');
	self.health = 200;
	self.max_health = 200;
	self.mass = 300;
	self.skin = 0;

	self.th_stand = floater_stand1;
	self.th_walk = floater_walk1;
	self.th_run = floater_run1;
	self.th_missile = floater_Missile;
	self.th_melee = floater_atkchar1;
	self.th_pain = floater_Pain;
	self.th_die = floater_die;
	self.th_spawn = spawn_floater;
	self.th_checkatck = FliesCheckAttack;

	flymonster_start ();
}
