/*
==============================================================================

WIZARD

==============================================================================
*/

$cd id1/models/a_wizard
$origin 0 0 24
$base wizbase	
$skin wizbase

void() wiz_run1;


/*
==============================================================================

FAST ATTACKS

==============================================================================
*/

void()	wiz_fire = { sound (self, CHAN_WEAPON, "hover/hovatck1.wav", 1, ATTN_NORM); }

void()	wiz_stand1	= [	self.frame,	wiz_stand1	] 
{
	self.frame ++;
	if(self.frame > 29)
		self.frame = 0;

	ai_stand();

	if(self.frame == 29)
		if (random() > 0.8)
			sound (self, CHAN_VOICE, "hover/hovidle1.wav", 1, ATTN_IDLE);
};

void()	wiz_walk1	= [	30,		wiz_walk2	] {ai_walk(4); Wiz_srchsound();}
void()	wiz_walk2	= [	self.frame,	wiz_walk2	] 
{
	self.frame ++;

	ai_walk(4);

	if(self.frame == 64)
		wiz_walk1();
};

void()	wiz_run1	= [	30,		wiz_run2	] {ai_run(16); Wiz_srchsound();}
void()	wiz_run2	= [	self.frame,	wiz_run2	] 
{
	self.frame ++;

	ai_run(16);

	if(self.frame == 64)
		wiz_run1();
};

void()	wiz_fast1	=[	197,		wiz_fast2	] {ai_face();};
void()	wiz_fast2	=[	198,		wiz_fast3	] {ai_face();};
void()	wiz_fast3	=[	199,		wiz_fast4	] {ai_face();};
void()	wiz_fast4	=[	200,		wiz_fast5	] {Hover_StartFast(8); wiz_fire(); };
void()	wiz_fast5	=[	201,		wiz_fast6	] {Hover_StartFast(-8); wiz_fire(); };
void()	wiz_fast6	=[	203,		wiz_fast7	] {ai_face(); if(random() < 0.6) SUB_CheckRefire(wiz_fast3); };
void()	wiz_fast7	=[	204,		wiz_run1	] {ai_face(); SUB_AttackFinished(0.3 + 2*random());};

void()	wiz_painc1	=[	153,		wiz_painc2	] {};
void()	wiz_painc2	=[	154,		wiz_painc3	] {};
void()	wiz_painc3	=[	155,		wiz_painc4	] {};
void()	wiz_painc4	=[	156,		wiz_painc5	] {};
void()	wiz_painc5	=[	157,		wiz_painc6	] {};
void()	wiz_painc6	=[	158,		wiz_painc7	] {};
void()	wiz_painc7	=[	159,		wiz_painc8	] {};
void()	wiz_painc8	=[	160,		wiz_painc9	] {};
void()	wiz_painc9	=[	161,		wiz_run1	] {};

void()	wiz_painb1	=[	141,		wiz_painb2	] {};
void()	wiz_painb2	=[	142,		wiz_painb3	] {};
void()	wiz_painb3	=[	143,		wiz_painb4	] {};
void()	wiz_painb4	=[	144,		wiz_painb5	] {};
void()	wiz_painb5	=[	145,		wiz_painb6	] {};
void()	wiz_painb6	=[	146,		wiz_painb7	] {};
void()	wiz_painb7	=[	147,		wiz_painb8	] {};
void()	wiz_painb8	=[	148,		wiz_painb9	] {};
void()	wiz_painb9	=[	149,		wiz_painb10	] {};
void()	wiz_painb10	=[	150,		wiz_painb11	] {};
void()	wiz_painb11	=[	151,		wiz_painb12	] {};
void()	wiz_painb12	=[	152,		wiz_run1	] {};

void()	wiz_pain1	=[	113,		wiz_pain2	] {self.gravity = 2.25 * (self.mass / 200); self.flags = self.flags - (self.flags & FL_FLY);};
void()	wiz_pain2	=[	114,		wiz_pain3	] {};
void()	wiz_pain3	=[	115,		wiz_pain4	] {ai_painforward(2);};
void()	wiz_pain4	=[	116,		wiz_pain5	] {ai_pain(8);};
void()	wiz_pain5	=[	117,		wiz_pain6	] {ai_pain(4);};
void()	wiz_pain6	=[	118,		wiz_pain7	] {ai_pain(6);};
void()	wiz_pain7	=[	119,		wiz_pain8	] {ai_pain(4);};
void()	wiz_pain8	=[	120,		wiz_pain9	] {ai_pain(3);};
void()	wiz_pain9	=[	121,		wiz_pain10	] {ai_painforward(1);};
void()	wiz_pain10	=[	122,		wiz_pain11	] {};
void()	wiz_pain11	=[	123,		wiz_pain12	] {};
void()	wiz_pain12	=[	124,		wiz_pain13	] {};
void()	wiz_pain13	=[	125,		wiz_pain14	] {ai_painforward(3);};
void()	wiz_pain14	=[	126,		wiz_pain15	] {ai_painforward(1);};
void()	wiz_pain15	=[	127,		wiz_pain16	] {};
void()	wiz_pain16	=[	128,		wiz_pain17	] {ai_painforward(2);};
void()	wiz_pain17	=[	129,		wiz_pain18	] {ai_painforward(3);};
void()	wiz_pain18	=[	130,		wiz_pain19	] {ai_painforward(2);};
void()	wiz_pain19	=[	131,		wiz_pain20	] {ai_painforward(7);};
void()	wiz_pain20	=[	132,		wiz_pain21	] {};
void()	wiz_pain21	=[	133,		wiz_pain22	] {};
void()	wiz_pain22	=[	134,		wiz_pain23	] {ai_painforward(2);};
void()	wiz_pain23	=[	135,		wiz_pain24	] {};
void()	wiz_pain24	=[	136,		wiz_pain25	] {};
void()	wiz_pain25	=[	137,		wiz_pain26	] {ai_painforward(5);};
void()	wiz_pain26	=[	138,		wiz_pain27	] {ai_painforward(3);};
void()	wiz_pain27	=[	139,		wiz_run1	] {ai_painforward(4); self.flags = self.flags | FL_FLY; self.gravity = 0;};

void()	wiz_death1	=[	162,		wiz_death2	] {};
void()	wiz_death2	=[	163,		wiz_death3	] {};
void()	wiz_death3	=[	164,		wiz_death4	] {};
void()	wiz_death4	=[	165,		wiz_death5	] {};
void()	wiz_death5	=[	166,		wiz_death6	] {};
void()	wiz_death6	=[	167,		wiz_death7	] {};
void()	wiz_death7	=[	168,		wiz_death8	] {self.maxs_z = -8; self.solid = SOLID_CORPSE;};
void()	wiz_death8	=[	169,		wiz_death9	] {};
void()	wiz_death9	=[	170,		wiz_death10	] {};
void()	wiz_death10	=[	171,		wiz_death11	] {};
void()	wiz_death11	=[	172,		wiz_run1	] 
{
	self.skin = 0;
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	MonsterGib (0, 3, 0, 0, 0, 2, self.health);
	BecomeExplosion ();
	
};

void() wiz_die =
{
// check for gib
	if (self.health < -100)
	{
		self.skin = 0;
		MonsterGib (0, 3, 0, 0, 0, 2, self.health);
		BecomeExplosion ();
		return;
	}
	if((self.deadflag & DEAD_DEAD))
		return;

	self.deadflag = DEAD_DEAD;
	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_YES;
	self.skin = 1;
	wiz_death1 ();
};


void(entity attacker, float damage) Wiz_Pain =
{
	if (self.health < (self.max_health / 2))
		self.skin = 1;

	if (time < self.pain_finished)
		return;

	self.pain_finished = time + 3;

	if (skill == 3)
		return;		// no pain anims in nightmare

	if (damage <= 25)
	{
		if (random() < 0.5)
		{
			sound (self, CHAN_VOICE, "hover/hovpain1.wav", 1, ATTN_NORM);
			wiz_painc1();
		}
		else
		{
			sound (self, CHAN_VOICE, "hover/hovpain2.wav", 1, ATTN_NORM);
			wiz_painb1();
		}
	}
	else
	{
		sound (self, CHAN_VOICE, "hover/hovpain1.wav", 1, ATTN_NORM);
		wiz_pain1();
	}
};


void() Wiz_Missile =
{
	wiz_fast1();
};

/*QUAKED monster_wizard (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() spawn_hover;
void() monster_hover =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/hover.mdl");
	precache_model ("progs/h_wizard.mdl");
	precache_model ("progs/w_spike.mdl");

	precache_sound ("hover/hovatck1.wav");	
	precache_sound ("hover/hovdeth1.wav");
	precache_sound ("hover/hovdeth2.wav");
	precache_sound ("hover/hovidle1.wav");
	precache_sound ("hover/hovpain1.wav");
	precache_sound ("hover/hovpain2.wav");
	precache_sound ("hover/hovsrch1.wav");
	precache_sound ("hover/hovsrch2.wav");
	precache_sound ("hover/hovsght1.wav");

	spawn_hover();
};

void() spawn_hover = 
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/hover.mdl");

	setsize (self, '-24 -24 -24', '24 24 32');
	self.health = 240;
	self.max_health = 240; // reminder to add floaters
	self.mass = 150;
	self.skin = 0;

	self.th_stand = wiz_stand1;
	self.th_walk = wiz_walk1;
	self.th_run = wiz_run1;
	self.th_missile = Wiz_Missile;
	self.th_melee = Wiz_Missile;
	self.th_pain = Wiz_Pain;
	self.th_die = wiz_die;
	self.th_spawn = spawn_hover;
	self.th_checkatck = FliesCheckAttack;

	flymonster_start ();
}

void() monster_wizard =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/hover.mdl");
	precache_model ("progs/h_wizard.mdl");
	precache_model ("progs/w_spike.mdl");

	precache_sound ("hover/hovatck1.wav");	
	precache_sound ("hover/hovdeth1.wav");
	precache_sound ("hover/hovdeth2.wav");
	precache_sound ("hover/hovidle1.wav");
	precache_sound ("hover/hovpain1.wav");
	precache_sound ("hover/hovpain2.wav");
	precache_sound ("hover/hovsrch1.wav");
	precache_sound ("hover/hovsrch2.wav");
	precache_sound ("hover/hovsght1.wav");

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

	if(self.classname == "monster_hover")
	{
		monster_hover();
		return;
	}
	else if(self.classname == "monster_floater")
	{
		monster_floater();
		return;
	}
	
	local float r = random();
	
	if(r < 0.4)
	{
		self.classname = "monster_hover";
		monster_hover();
		return;
	}
	else
	{
		self.classname = "monster_floater";
		monster_floater();
		return;
	}
};
