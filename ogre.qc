/*
==============================================================================

OGRE

==============================================================================
*/

$cd id1/models/ogre_c
$origin 0 0 24
$base base		
$skin base

//=============================================================================

/*
===========
OgreCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() OgreCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

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

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
	{
		return FALSE;	// don't have a clear shot
	}
			
// missile attack
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;

	else if (enemy_range == RANGE_CLOSE)
		chance = 0.06;	
	else if (enemy_range == RANGE_NEAR)
		chance = 0.10;
	else if (enemy_range == RANGE_MID)
		chance = 0.05;
	else
		chance = 0;

	if (random () < chance)
	{
		self.th_missile ();
		SUB_AttackFinished (2 + random()*2);
		return TRUE;
	}
	return FALSE;
};

//=============================================================================

float MF_GUNNER_MG_1		=	1;
float MF_GUNNER_MG_2		=	2;
float MF_GUNNER_MG_3		=	3;
float MF_GUNNER_MG_4		=	4;
float MF_GUNNER_MG_5		=	5;
float MF_GUNNER_MG_6		=	6;
float MF_GUNNER_MG_7		=	7;
float MF_GUNNER_MG_8		=	8;
float MF_GUNNER_GREN_1		=	9;

vector m_gunner_flashoffset[] = // q2 port i guess idk
{
	'30.1  3.9 19.6',
	'29.1  2.5 20.7',
	'28.2  2.5 22.2',
	'28.2  3.6 22.0',
	'26.9  2.0 23.4',
	'26.5  0.6 20.8',
	'26.9  0.5 21.5',
	'29.0  2.4 19.5',
	'4.6  -16.8 7.3',
	'4.6  -16.8 7.3',
	'4.6  -16.8 7.3',
	'4.6  -16.8 7.3',
};

/*
================
OgreFireGrenade
================
*/

void() OgreFireGrenade =
{
	makevectors(self.angles);
	local	vector	dir, org;
	local float flashnum;
	local entity en = self.enemy;
	
	flashnum = MF_GUNNER_GREN_1; // the rest are fucking useless...

	org = ProjectAim(self.origin, m_gunner_flashoffset[flashnum]*1.15, v_forward, v_right);
	
	sound (self, CHAN_WEAPON, "gunner/gunatck2.wav", 1, ATTN_NORM);
	
//	particle (org, v_forward * 30 , 235, 25);
	self.effects = self.effects | EF_MUZZLEFLASH;
	
	dir = en.origin - en.velocity*0.2;
	dir = normalize (dir - org);
	
	monster_FireNade (org, dir, 50);
};


//=============================================================================


void() OgreFireNails =
{
	makevectors(self.angles);
	local	vector	dir, org;
	local	entity	en;
	local float flashnum = MF_GUNNER_MG_1 + (self.frame - 144);

	org = ProjectAim(self.origin, m_gunner_flashoffset[flashnum]*1.15, v_forward, v_right);
	
	sound (self, CHAN_WEAPON, "gunner/gunatck2.wav", 1, ATTN_NORM);
	
//	particle (org, v_forward * 30 , 235, 25);
	self.effects = self.effects | EF_MUZZLEFLASH;

	// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	dir = en.origin - en.velocity*0.2;
	dir = normalize (dir - org);
	
	monster_FireBullets (1, org, dir, '0.01 0.01 0', 3, 4);
};


//=============================================================================


void() ogre_stand1	=[	0,	ogre_stand2	] {ai_stand();};
void() ogre_stand2	=[	1,	ogre_stand3	] {ai_stand();};
void() ogre_stand3	=[	2,	ogre_stand4	] {ai_stand();};
void() ogre_stand4	=[	3,	ogre_stand5	] {ai_stand();};
void() ogre_stand5	=[	4,	ogre_stand6	] {
	if (random() < 0.8)
		sound (self, CHAN_VOICE, "gunner/gunidle1.wav", 1, ATTN_IDLE);

	ai_stand();
};

void() ogre_stand6	=[	5,	ogre_stand7	] {ai_stand();};
void() ogre_stand7	=[	6,	ogre_stand8	] {ai_stand();};
void() ogre_stand8	=[	7,	ogre_stand9	] {ai_stand();};
void() ogre_stand9	=[	8,	ogre_stand10	] {ai_stand();};
void() ogre_stand10	=[	9,	ogre_stand11	] {ai_stand();};
void() ogre_stand11	=[	10,	ogre_stand12	] {ai_stand();};
void() ogre_stand12	=[	11,	ogre_stand13	] {ai_stand();};
void() ogre_stand13	=[	12,	ogre_stand14	] {ai_stand();};
void() ogre_stand14	=[	13,	ogre_stand15	] {ai_stand();};
void() ogre_stand15	=[	14,	ogre_stand16	] {ai_stand();};
void() ogre_stand16	=[	15,	ogre_stand17	] {ai_stand();};
void() ogre_stand17	=[	16,	ogre_stand18	] {ai_stand();};
void() ogre_stand18	=[	17,	ogre_stand19	] {ai_stand();};
void() ogre_stand19	=[	18,	ogre_stand20	] {ai_stand();};
void() ogre_stand20	=[	19,	ogre_stand21	] {ai_stand();};
void() ogre_stand21	=[	20,	ogre_stand22	] {ai_stand();};
void() ogre_stand22	=[	21,	ogre_stand23	] {ai_stand();};
void() ogre_stand23	=[	22,	ogre_stand24	] {ai_stand();};
void() ogre_stand24	=[	23,	ogre_stand25	] {ai_stand();};
void() ogre_stand25	=[	24,	ogre_stand26	] {ai_stand();};
void() ogre_stand26	=[	25,	ogre_stand27	] {ai_stand();};
void() ogre_stand27	=[	26,	ogre_stand28	] {ai_stand();};
void() ogre_stand28	=[	27,	ogre_stand29	] {ai_stand();};
void() ogre_stand29	=[	28,	ogre_stand1	] {ai_stand();};


void() ogre_walk1	=[	76,		ogre_walk2	] {ai_walk(0);};
void() ogre_walk2	=[	77,		ogre_walk3	] {ai_walk(3);};
void() ogre_walk3	=[	78,		ogre_walk4	] {
	ai_walk(4);

	if (random() < 0.2)
		sound (self, CHAN_VOICE, "gunner/gunidle1.wav", 1, ATTN_IDLE);
};

void() ogre_walk4	=[	79,		ogre_walk5	] {ai_walk(5);};
void() ogre_walk5	=[	80,		ogre_walk6	] {ai_walk(7);};
void() ogre_walk6	=[	81,		ogre_walk7	] {
	ai_walk(2);

	if (random() < 0.1)
		sound (self, CHAN_VOICE, "gunner/gunsrch1.wav", 1, ATTN_IDLE);
};

void() ogre_walk7	=[	82,		ogre_walk8	] {ai_walk(6);};
void() ogre_walk8	=[	83,		ogre_walk9	] {ai_walk(4);};
void() ogre_walk9	=[	84,		ogre_walk10	] {ai_walk(2);};
void() ogre_walk10	=[	85,	ogre_walk11	] {ai_walk(7);};
void() ogre_walk11	=[	86,	ogre_walk12	] {ai_walk(5);};
void() ogre_walk12	=[	87,	ogre_walk13	] {ai_walk(7);};
void() ogre_walk13	=[	88,	ogre_walk1	] {ai_walk(4);};

void() ogre_run1	=[	94,		ogre_run2	] {
	ai_run(26);
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "gunner/gunsrch1.wav", 1, ATTN_IDLE);
};

void() ogre_run2	=[	95,		ogre_run3	] {ai_run(9);};
void() ogre_run3	=[	96,		ogre_run4	] {ai_run(9);};
void() ogre_run4	=[	97,		ogre_run5	] {ai_run(9);};
void() ogre_run5	=[	98,		ogre_run6	] {ai_run(15);};
void() ogre_run6	=[	99,		ogre_run7	] {ai_run(10);};
void() ogre_run7	=[	100,		ogre_run8	] {ai_run(13);};
void() ogre_run8	=[	101,		ogre_run1	] {ai_run(6); CheckForCharge(4);};

void() ogre_nail1	=[	130,		ogre_nail2	] {ai_face(); sound (self, CHAN_VOICE, "gunner/gunatck1.wav", 1, ATTN_NORM);};
void() ogre_nail2	=[	131,		ogre_nail3	] {ai_face();};
void() ogre_nail3	=[	132,		ogre_nail4	] {ai_face();};
void() ogre_nail4	=[	133,		ogre_nail5	] {ai_face();};
void() ogre_nail5	=[	134,		ogre_nail6	] {ai_face();};
void() ogre_nail6	=[	135,		ogre_nail7	] {ai_face();};
void() ogre_nail7	=[	136,		ogre_nail8	] {ai_face();};
void() ogre_nail8	=[	138,		ogre_nail9	] {ai_face();};
void() ogre_nail9	=[	139,		ogre_nail10	] {ai_face();};
void() ogre_nail10=[	140,		ogre_nail11	] {ai_face();};
void() ogre_nail11=[	141,		ogre_nail12	] {ai_face();};
void() ogre_nail12=[	142,		ogre_nail13	] {ai_face();};
void() ogre_nail13=[	143,		ogre_nail14	] {ai_face();OgreFireNails();};
void() ogre_nail14=[	144,		ogre_nail15	] {ai_face();OgreFireNails();};
void() ogre_nail15=[	145,		ogre_nail16	] {ai_face();OgreFireNails();};
void() ogre_nail16=[	146,		ogre_nail17	] {ai_face();OgreFireNails();};
void() ogre_nail17=[	147,		ogre_nail18	] {ai_face();OgreFireNails();};
void() ogre_nail18=[	148,		ogre_nail19	] {ai_face();OgreFireNails();};
void() ogre_nail19=[	149,		ogre_nail20	] {ai_face();OgreFireNails();};
void() ogre_nail20=[	150,		ogre_nail21	] {ai_face();OgreFireNails();};
void() ogre_nail21=[	151,		ogre_nail22	] {ai_face();OgreFireNails();};
void() ogre_nail22=[	152,		ogre_nail23	] {ai_face();OgreFireNails();};
void() ogre_nail23=[	153,		ogre_nail24	] {ai_face();};
void() ogre_nail24=[	154,		ogre_nail25	] {ai_face();};
void() ogre_nail25=[	155,		ogre_nail26	] {ai_face();};
void() ogre_nail26=[	156,		ogre_nail27	] {ai_face();};
void() ogre_nail27=[	157,		ogre_run1	] {ai_face();};


void() ogre_nailrun1	=[	102,		ogre_nailrun2	] {ai_charge(32); sound (self, CHAN_VOICE, "gunner/gunatck1.wav", 1, ATTN_NORM);};
void() ogre_nailrun2	=[	103,		ogre_nailrun3	] {ai_charge(15);};
void() ogre_nailrun3	=[	104,		ogre_nailrun4	] {ai_charge(10);OgreFireGrenade();};
void() ogre_nailrun4	=[	105,		ogre_nailrun5	] {ai_charge(18);};
void() ogre_nailrun5	=[	106,		ogre_nailrun6	] {ai_charge(8);OgreFireGrenade();};
void() ogre_nailrun6	=[	107,		ogre_run1 	      ] {ai_charge(20);};

void() ogre_nade1	=[	108,		ogre_nade2	] {ai_face(); sound (self, CHAN_VOICE, "gunner/gunatck1.wav", 1, ATTN_NORM);};
void() ogre_nade2	=[	109,		ogre_nade3	] {ai_face();};
void() ogre_nade3	=[	110,		ogre_nade4	] {ai_face();};
void() ogre_nade4	=[	111,		ogre_nade5	] {ai_face();};
void() ogre_nade5	=[	112,		ogre_nade6	] {ai_face(); OgreFireGrenade();};
void() ogre_nade6	=[	113,		ogre_nade7	] {ai_face();};
void() ogre_nade7	=[	114,		ogre_nade8	] {ai_face();};
void() ogre_nade8	=[	115,		ogre_nade9	] {ai_face(); OgreFireGrenade();};
void() ogre_nade9	=[	116,		ogre_nade10	] {ai_face();};
void() ogre_nade10=[	117,		ogre_nade11	] {ai_face();};
void() ogre_nade11=[	118,		ogre_nade12	] {ai_face(); OgreFireGrenade();};
void() ogre_nade12=[	119,		ogre_nade13	] {ai_face();};
void() ogre_nade13=[	120,		ogre_nade14	] {ai_face();};
void() ogre_nade14=[	121,		ogre_nade15	] {ai_face(); OgreFireGrenade();};
void() ogre_nade15=[	122,		ogre_nade16	] {ai_face();};
void() ogre_nade16=[	123,		ogre_nade17	] {ai_face();};
void() ogre_nade17=[	124,		ogre_nade18	] {ai_face();};
void() ogre_nade18=[	125,		ogre_nade19	] {ai_face();};
void() ogre_nade19=[	126,		ogre_nade20	] {ai_face();};
void() ogre_nade20=[	127,		ogre_nade21	] {ai_face();};
void() ogre_nade21=[	128,		ogre_run1	] {ai_face();};

void()	ogre_pain1	=[	159,		ogre_pain2	] {};
void()	ogre_pain2	=[	160,		ogre_pain3	] {};
void()	ogre_pain3	=[	161,		ogre_pain4	] {};
void()	ogre_pain4	=[	162,		ogre_pain5	] {};
void()	ogre_pain5	=[	163,		ogre_pain6	] {};
void()	ogre_pain6	=[	164,		ogre_pain7	] {};
void()	ogre_pain7	=[	165,		ogre_pain8	] {};
void()	ogre_pain8	=[	166,		ogre_pain9	] {};
void()	ogre_pain9	=[	167,		ogre_pain10	] {};
void()	ogre_pain10	=[	168,		ogre_pain11	] {};
void()	ogre_pain11	=[	169,		ogre_pain12	] {};
void()	ogre_pain12	=[	170,		ogre_pain13	] {};
void()	ogre_pain13	=[	171,		ogre_pain14	] {};
void()	ogre_pain14	=[	172,		ogre_pain15	] {};
void()	ogre_pain15	=[	173,		ogre_pain16	] {};
void()	ogre_pain16	=[	174,		ogre_pain17	] {};
void()	ogre_pain17	=[	175,		ogre_run1	] {};

void()	ogre_painb1	=[	177,	ogre_painb2	] {};
void()	ogre_painb2	=[	178,	ogre_painb3	] {};
void()	ogre_painb3	=[	180,	ogre_painb4	] {};
void()	ogre_painb4	=[	181,	ogre_painb5	] {};
void()	ogre_painb5	=[	182,	ogre_painb6	] {};
void()	ogre_painb6	=[	183,	ogre_painb7	] {};
void()	ogre_painb7	=[	184,	ogre_run1	] {};

void()	ogre_painc1	=[	185,	ogre_painc2	] {};
void()	ogre_painc2	=[	186,	ogre_painc3	] {};
void()	ogre_painc3	=[	187,	ogre_painc4	] {};
void()	ogre_painc4	=[	188,	ogre_painc5	] {};
void()	ogre_painc5	=[	189,	ogre_run1	] {};

void(entity attacker, float damage)	ogre_pain =
{
	local float	r;
	r = random();

	if (self.health < (self.max_health / 2))
		self.skin = 1;

	// don't make multiple pain sounds right after each other
	if (self.pain_finished > time)
		return;
	
	if (r < 0.5)
		sound (self, CHAN_VOICE, "gunner/gunpain1.wav", 1, ATTN_NORM);	
	else
		sound (self, CHAN_VOICE, "gunner/gunpain2.wav", 1, ATTN_NORM);	

	if (self.dcnt)
		return;
	if (skill == 3)
		return;	
	self.pain_finished = time + 3;	
	
	if (damage <= 10)
		ogre_painc1 ();
	else if (damage <= 25)
		ogre_painb1 ();
	else 
		ogre_pain1 ();
};

void()	ogre_die1	=[	190,	ogre_die2	] {};
void()	ogre_die2	=[	191,	ogre_die3	] {ai_back(13);};
void()	ogre_die3	=[	192,	ogre_die4	] {ai_back(13);};

void()	ogre_die4	=[	193,	ogre_die5	] {};
void()	ogre_die5	=[	194,	ogre_die6	] {};
void()	ogre_die6	=[	195,	ogre_die7	] {};
void()	ogre_die7	=[	196,	ogre_die8	] {};
void()	ogre_die8	=[	198,	ogre_die9	] {};
void()	ogre_die9	=[	199,	ogre_die10	] {self.maxs_z = -8; self.solid = SOLID_CORPSE;};
void()	ogre_die10	=[	200,	ogre_die10	] {};


void()	ogre_duckdown1	=[	201,	ogre_duckdown2	] 
{
	if (skill >= 2)
	{
		if (random() > 0.5)
			OgreFireGrenade();
	}
	self.dcnt = 1; 
	self.nextthink = self.dspeed; 
	self.maxs_z -= 32; 
	self.takedamage = DAMAGE_YES;
	ai_face();
};
void()	ogre_duckdown2	=[	202,	ogre_duckhold	] {ai_face(); self.dodge_finished = time + 0.25 + 2*random();};

void()	ogre_duckup1	=[	204,	ogre_duckup2	] 
{self.dodge_finished = time + 1 + random()*2; self.takedamage = DAMAGE_AIM; self.flags = self.flags - (self.flags & FL_DODGED); self.dcnt = 0; self.maxs_z += 32;};
void()	ogre_duckup2	=[	205,	ogre_duckup3	] {};
void()	ogre_duckup3	=[	206,	ogre_duckup4	] {};
void()	ogre_duckup4	=[	207,	ogre_run1	] 	{};

void()	ogre_duckhold =[	203,	ogre_duckhold 	]	
{
	if(time > self.dodge_finished)
		self.think = ogre_duckup1;
};

void() ogre_die =
{
	if(self.dcnt)
	{
		self.maxs_z += 32;
		self.dcnt = 0;
		self.flags = self.flags - (self.flags & FL_DODGED);
	}

	// check for gib
	if (self.health < -80)
	{
		self.skin = 0;
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		MonsterGib (4, 0, 1, 0, 2, 0, self.health);
		return;
	}

	// don't die a regular death again as corpse
	if((self.deadflag & DEAD_DEAD))
		return;

// regular death
	
	sound (self, CHAN_VOICE, "gunner/death1.wav", 1, ATTN_NORM);
	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_YES;
	self.skin = 1;

	ogre_die1 ();

	self.deadflag = DEAD_DEAD;
};

void() ogre_ranged =
{
	if (random() > 0.6)
		ogre_nail1 ();
	else 
		ogre_nade1 ();
};


/*QUAKED monster_ogre (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/

void() spawn_gunner;
void() monster_chick;
void() monster_gunner =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/gunner.mdl");
	precache_model ("progs/h_ogre.mdl");
	precache_model ("progs/grenade.mdl");

	precache_sound ("gunner/death1.wav");
	precache_sound ("gunner/gunidle1.wav");
	precache_sound ("gunner/gunsrch1.wav");
	precache_sound ("gunner/gunpain1.wav");
	precache_sound ("gunner/gunpain2.wav");
	precache_sound ("gunner/gunatck1.wav");
	precache_sound ("gunner/gunatck2.wav");
	precache_sound ("gunner/gunatck3.wav");
	precache_sound ("gunner/sight1.wav");
	
	spawn_gunner();
};

void() spawn_gunner =
{	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/gunner.mdl");

	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = 175;
	self.max_health = 175;
	self.mass = 200;
//	self.flags = self.flags + FL_DUCKER;
	self.skin = 0;

	self.th_stand = ogre_stand1;
	self.th_walk = ogre_walk1;
	self.th_run = ogre_run1;
	self.th_die = ogre_die;
	self.th_dodge = ogre_duckdown1;
	self.th_melee = ogre_nail1;
	self.th_missile = ogre_ranged;
	self.th_pain = ogre_pain;
	self.th_spawn = spawn_gunner;
	self.th_char = ogre_nailrun1;
	self.th_checkatck = OgreCheckAttack;

	walkmonster_start();
};

void() monster_ogre =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/gunner.mdl");
	precache_model ("progs/h_ogre.mdl");
	precache_model ("progs/grenade.mdl");

	precache_sound ("gunner/death1.wav");
	precache_sound ("gunner/gunidle1.wav");
	precache_sound ("gunner/gunsrch1.wav");
	precache_sound ("gunner/gunpain1.wav");
	precache_sound ("gunner/gunpain2.wav");
	precache_sound ("gunner/gunatck1.wav");
	precache_sound ("gunner/gunatck2.wav");
	precache_sound ("gunner/gunatck3.wav");
	precache_sound ("gunner/sight1.wav");

	precache_model2 ("progs/bitch.mdl");
//	precache_model2 ("progs/h_shal.mdl");
//	precache_model2 ("progs/v_spike.mdl");
	
	precache_sound2 ("chick/chkatck1.wav");
	precache_sound2 ("chick/chkatck2.wav");
	precache_sound2 ("chick/chkatck3.wav");	
	precache_sound2 ("chick/chkatck4.wav");
	precache_sound2 ("chick/chkatck5.wav");
	precache_sound2 ("chick/chkdeth2.wav");
	precache_sound2 ("chick/chkdeth1.wav");
	precache_sound2 ("chick/chkpain1.wav");
	precache_sound2 ("chick/chkpain2.wav");
	precache_sound2 ("chick/chkpain3.wav");
	precache_sound2 ("chick/chksght1.wav");
	precache_sound2 ("chick/chksrch1.wav");
	precache_sound2 ("chick/chkidle2.wav");
	precache_sound2 ("chick/chkidle1.wav");
	
	if(self.classname == "monster_chick")
	{
		monster_chick();
		return;
	}
	else if(self.classname == "monster_gunner")
	{
		monster_gunner();
		return;
	}
	
	local float r = random();
	
	if(r <= 0.5)
	{
		self.classname = "monster_chick";
		monster_chick();
		return;
	}
	else
	{
		self.classname = "monster_gunner";
		monster_gunner();
		return;
	}
};