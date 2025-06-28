/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

$cd id1/models/enforcer
$origin 0 -6 24
$base base		
$skin skin

//============================================================================

float MF_INFANTRY_CG_1	=	1;
float MF_INFANTRY_CG_2	=	2;
float MF_INFANTRY_CG_3	=	3;
float MF_INFANTRY_CG_4	=	4;
float MF_INFANTRY_CG_5	=	5;
float MF_INFANTRY_CG_6	=	6;
float MF_INFANTRY_CG_7	=	7;
float MF_INFANTRY_CG_8	=	8;
float MF_INFANTRY_CG_9	=	9;
float MF_INFANTRY_CG_10	=	10;
float MF_INFANTRY_CG_11	=	11;
float MF_INFANTRY_CG_12	=	12;
float MF_INFANTRY_CG_13	=	13;

vector m_infantry_flashoffset[] = // q2 port i guess idk
{
	'26.6 7.1 13.1',
	'18.2 7.5 15.4',
	'17.2 10.3 17.9',
	'17.0 12.8 20.1',
	'15.1 14.1 21.8',
	'11.8 17.2 23.1',
	'11.4 20.2 21.0',
	'9.0 23.0 18.9',
	'13.9 18.6 17.7',
	'15.4 15.6 15.8',
	'10.2 15.2 25.1',
	'-1.9 15.1 28.2',
	'-12.4 13.0 20.2',
};

void() infantry_chaingun =
{
	makevectors (self.angles);
	sound (self, CHAN_WEAPON, "infantry/infatck1.wav", 1, ATTN_NORM);	

	local entity en = self.enemy;
	local vector dir, start;
	local float flashnum = MF_INFANTRY_CG_1;

	start = ProjectAim(self.origin, m_infantry_flashoffset[flashnum], v_forward, v_right);

	dir = en.origin - en.velocity*0.2;
	dir = normalize (dir - self.origin);
	
	monster_FireBullets (1, start ,dir, '0.01 0.01 0', 3, 4);
};

void() infantrydied_chaingun =
{
	makevectors (self.angles);
	sound (self, CHAN_WEAPON, "infantry/infatck1.wav", 1, ATTN_NORM);	

	local vector start;
	local vector blank;

	local float flashnum = MF_INFANTRY_CG_2 + (self.frame - 155);
	start = ProjectAim(self.origin, m_infantry_flashoffset[flashnum - MF_INFANTRY_CG_2], v_forward, v_right);

	blank = self.angles - m_infantry_flashoffset[flashnum - MF_INFANTRY_CG_2];
	makevectors (blank);

	monster_FireBullets (1, start, v_forward, '0.01 0.01 0', 3, 4);
};

//============================================================================

void()	enf_stand1	= [	50,	enf_stand2		] {}
void()	enf_stand2	= [	self.frame,	enf_stand2	] 
{
	self.frame ++;
	if(self.frame >= 71)
		enf_stand1();

	ai_stand();

	if(self.frame == 70)
		if (random() > 0.8)
			sound (self, CHAN_VOICE, "infantry/infidle1.wav", 1, ATTN_IDLE);
};

void()	enf_walk1	=[	74 ,	enf_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "infantry/infidle1.wav", 1, ATTN_IDLE);
ai_walk(5);};
void()	enf_walk2	=[	75 ,	enf_walk3	] {ai_walk(4);};
void()	enf_walk3	=[	76 ,	enf_walk4	] {ai_walk(4);};
void()	enf_walk4	=[	77 ,	enf_walk5	] {ai_walk(5);};
void()	enf_walk5	=[	78 ,	enf_walk6	] {ai_walk(4);};
void()	enf_walk6	=[	79 ,	enf_walk7	] {ai_walk(5);};
void()	enf_walk7	=[	80 ,	enf_walk8	] {ai_walk(6);};
void()	enf_walk8	=[	81 ,	enf_walk9	] {ai_walk(4);};
void()	enf_walk9	=[	82 ,	enf_walk10	] {ai_walk(4);};
void()	enf_walk10	=[	83 ,	enf_walk11	] {ai_walk(4);};
void()	enf_walk11	=[	84 ,	enf_walk12	] {ai_walk(4);};
void()	enf_walk12	=[	85 ,	enf_walk1	] {ai_walk(5);};

void()	enf_run1	=[	92 ,	enf_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "infantry/infsrch1.wav", 1, ATTN_IDLE);
ai_run(10);};
void()	enf_run2	=[	93  ,	enf_run3	] {ai_run(20);};
void()	enf_run3	=[	94  ,	enf_run4	] {ai_run(5);};
void()	enf_run4	=[	95  ,	enf_run5	] {ai_run(7);};
void()	enf_run5	=[	96  ,	enf_run6	] {ai_run(30);};
void()	enf_run6	=[	97  ,	enf_run7	] {ai_run(35);};
void()	enf_run7	=[	98  ,	enf_run8	] {ai_run(2);};
void()	enf_run8	=[	99  ,	enf_run1	] {ai_run(6);};

void() infantry_cock_gun =
{
	float		n;

	sound (self, CHAN_WEAPON, "infantry/infatck3.wav", 1, ATTN_NORM); 
	n = (random()*1000 & 15) + 3 + 7;
	self.pausetime = time + n * 0.1;
}

void(void()olthink, void() nuthink) infantry_fire =
{
	infantry_chaingun ();

	if (time >= self.pausetime)
		self.think = nuthink;
	else
		self.think = olthink;
}

void()	enf_atk1	=[	184,	enf_atk2	] {ai_charge(4);};
void()	enf_atk2	=[	185,	enf_atk3	] {ai_charge(-1);};
void()	enf_atk3	=[	186,	enf_atk4	] {ai_charge(-1);};
void()	enf_atk4	=[	187,	enf_atk5	] {ai_face(); infantry_cock_gun(); };
void()	enf_atk5	=[	188,	enf_atk6	] {ai_charge(-1);};
void()	enf_atk6	=[	189,	enf_atk7	] {ai_charge(1);};
void()	enf_atk7	=[	190,	enf_atk8	] {ai_charge(1);  };
void()	enf_atk8	=[	191,	enf_atk9	] {ai_charge(2); };
void()	enf_atk9	=[	192,	enf_atk10	] {ai_charge(-2);};
void()	enf_atk10	=[	193,	enf_atk11	] {ai_charge(-3);};
void()	enf_atk11	=[	194,	enf_fire	] {ai_charge(1); };
void()	enf_atk12	=[	195,	enf_atk13	] {ai_charge(5);};

void()	enf_fire	=[	194,	enf_fire	] {ai_face(); infantry_fire(enf_fire, enf_atk12);};

void()	enf_atk13	=[	196,	enf_atk14	] {ai_charge(-1);};
void()	enf_atk14	=[	197,	enf_atk15	] {ai_charge(-2);};
void()	enf_atk15	=[	198,	enf_run1	] {ai_charge(-3);};

void() infantry_smack =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 80)
		return;
		
	ldmg = 10 + (random()*10) % 5;
	T_Damage (self.enemy, self, self, ceil(ldmg), 50);
	sound (self, CHAN_VOICE, "infantry/melee2.wav", 1, ATTN_NORM);
};

void()	enf_atkb1	=[	199,	enf_atkb2	] {ai_charge(3);};
void()	enf_atkb2	=[	200,	enf_atkb3	] {ai_charge(6);};
void()	enf_atkb3	=[	201,	enf_atkb4	] {ai_face(); sound (self, CHAN_WEAPON, "infantry/infatck2.wav", 1, ATTN_NORM);};
void()	enf_atkb4	=[	202,	enf_atkb5	] {ai_charge(8);  };
void()	enf_atkb5	=[	203,	enf_atkb6	] {ai_charge(5);};
void()	enf_atkb6	=[	204,	enf_atkb7	] {ai_charge(8); infantry_smack(); };
void()	enf_atkb7	=[	205,	enf_atkb8	] {ai_charge(6);  };
void()	enf_atkb8	=[	206,	enf_run1	] {ai_charge(3); };



//============================================================================

void()	enf_painc1	=[	100,	enf_painc2	] {ai_pain(3);};
void()	enf_painc2	=[	101,	enf_painc3	] {ai_pain(2);};
void()	enf_painc3	=[	102,	enf_painc4	] {ai_pain(1);};
void()	enf_painc4	=[	103,	enf_painc5	] {ai_pain(2);};
void()	enf_painc5	=[	104,	enf_painc6	] {ai_pain(1);};
void()	enf_painc6	=[	105,	enf_painc7	] {ai_painforward(1);};
void()	enf_painc7	=[	106,	enf_painc8	] {ai_pain(1);};
void()	enf_painc8	=[	107,	enf_painc9	] {ai_painforward(1);};
void()	enf_painc9	=[	108,	enf_painc10	] {ai_painforward(6);};
void()	enf_painc10	=[	109,	enf_run1	] {ai_painforward(2);};

void()	enf_paind1	=[	110,	enf_paind2	] {ai_pain(3);};
void()	enf_paind2	=[	111,	enf_paind3	] {ai_pain(3);};
void()	enf_paind3	=[	112,	enf_paind4	] {};
void()	enf_paind4	=[	113,	enf_paind5	] {ai_pain(1);};
void()	enf_paind5	=[	114,	enf_paind6	] {ai_pain(2);};
void()	enf_paind6	=[	115,	enf_paind7	] {};
void()	enf_paind7	=[	116,	enf_paind8	] {};
void()	enf_paind8	=[	117,	enf_paind9	] {ai_painforward(2);};
void()	enf_paind9	=[	118,	enf_paind10	] {ai_painforward(5);};
void()	enf_paind10	=[	119,	enf_run1	] {ai_painforward(2);};

void(entity attacker, float damage)	enf_pain =
{
	local float r;
		
	if (self.health < self.max_health / 2)
		self.skin = 1;
	
	r = random ()*10 % 2;
	if (self.pain_finished > time)
		return;
	
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "infantry/infpain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "infantry/infpain2.wav", 1, ATTN_NORM);

	self.pain_finished = time + 3;
	
	if(skill == 3) return;
	if(self.dcnt) return;
	
	if (r == 0)
		enf_painc1 ();
	else
		enf_paind1 ();
};

//============================================================================

void()	enf_die1	=[	125,	enf_die2	] {ai_back(4);};
void()	enf_die2	=[	126,	enf_die3	] {};
void()	enf_die3	=[	127,	enf_die4	] {};
void()	enf_die4	=[	128,	enf_die5	] {ai_back(1);};
void()	enf_die5	=[	129,	enf_die6	] {ai_back(4);};
void()	enf_die6	=[	130,	enf_die7	] {};
void()	enf_die7	=[	131,	enf_die8	] {};
void()	enf_die8	=[	132,	enf_die9	] {};
void()	enf_die9	=[	133,	enf_die10	] {ai_back(1); };
void()	enf_die10	=[	134,	enf_die11	] {ai_forward(3);};
void()	enf_die11	=[	135,	enf_die12	] {ai_forward(1);};
void()	enf_die12	=[	136,	enf_die13	] {ai_forward(1);};
void()	enf_die13	=[	137,	enf_die14	] {ai_back(2);};
void()	enf_die14	=[	138,	enf_die15	] {ai_forward(2);};
void()	enf_die15	=[	139,	enf_die16	] {ai_forward(2);};
void()	enf_die16	=[	140,	enf_die17	] {ai_forward(9);};
void()	enf_die17	=[	141,	enf_die18	] {ai_forward(9);};
void()	enf_die18	=[	142,	enf_die19	] {ai_forward(5);};
void()	enf_die19	=[	143,	enf_die20	] {ai_back(3); self.maxs_z = -8; self.solid = SOLID_CORPSE;};
void()	enf_die20	=[	144,	enf_die21	] {ai_back(3);};
void()	enf_die21	=[	144,	enf_die21	] {};

void()	enf_bdie1	=[	145,	enf_bdie2	] {};
void()	enf_bdie2	=[	146,	enf_bdie3	] {ai_forward(1);};
void()	enf_bdie3	=[	147,	enf_bdie4	] {ai_forward(5);};
void()	enf_bdie4	=[	148,	enf_bdie5	] {ai_back(1);};
void()	enf_bdie5	=[	149,	enf_bdie6	] {};
void()	enf_bdie6	=[	150,	enf_bdie7	] {ai_forward(1);};
void()	enf_bdie7	=[	151,	enf_bdie8	] {ai_forward(1);};
void()	enf_bdie8	=[	152,	enf_bdie9	] {ai_forward(4);};
void()	enf_bdie9	=[	153,	enf_bdie10	] {ai_forward(3);};
void()	enf_bdie10	=[	154,	enf_bdie11	] {};
void()	enf_bdie11	=[	155,	enf_bdie12	] {ai_back(2);    infantrydied_chaingun();};
void()	enf_bdie12	=[	156,	enf_bdie13	] {ai_back(2);    infantrydied_chaingun();};
void()	enf_bdie13	=[	157,	enf_bdie14	] {ai_back(3);    infantrydied_chaingun();};
void()	enf_bdie14	=[	158,	enf_bdie15	] {ai_back(1);	infantrydied_chaingun();};
void()	enf_bdie15	=[	159,	enf_bdie16	] {ai_back(2);	infantrydied_chaingun();};
void()	enf_bdie16	=[	160,	enf_bdie17	] {			infantrydied_chaingun();};
void()	enf_bdie17	=[	161,	enf_bdie18	] {ai_forward(2);	infantrydied_chaingun();};
void()	enf_bdie18	=[	162,	enf_bdie19	] {ai_forward(2);	infantrydied_chaingun();};
void()	enf_bdie19	=[	163,	enf_bdie20	] {ai_forward(3); infantrydied_chaingun();};
void()	enf_bdie20	=[	164,	enf_bdie21	] {ai_back(10);   infantrydied_chaingun();};
void()	enf_bdie21	=[	165,	enf_bdie22	] {ai_back(7);    infantrydied_chaingun();};
void()	enf_bdie22	=[	166,	enf_bdie23	] {ai_back(8);    infantrydied_chaingun();};
void()	enf_bdie23	=[	167,	enf_bdie24	] {ai_back(6);};
void()	enf_bdie24	=[	168,	enf_bdie25	] {ai_forward(4); self.maxs_z = -8; self.solid = SOLID_CORPSE;};
void()	enf_bdie25	=[	169,	enf_bdie25	] {};

void()	enf_fdie1	=[	170,	enf_fdie2	] {};
void()	enf_fdie2	=[	171,	enf_fdie3	] {};
void()	enf_fdie3	=[	172,	enf_fdie4	] {};
void()	enf_fdie4	=[	173,	enf_fdie5	] {};
void()	enf_fdie5	=[	174,	enf_fdie6	] {};
void()	enf_fdie6	=[	175,	enf_fdie7	] {};
void()	enf_fdie7	=[	176,	enf_fdie8	] {};
void()	enf_fdie8	=[	177,	enf_fdie9	] {self.maxs_z = -8; self.solid = SOLID_CORPSE;};
void()	enf_fdie9	=[	178,	enf_fdie9	] {};


void() enf_die =
{
	local float n = floor((random()*10) % 3);
	if(self.dcnt)
	{
		self.maxs_z += 32;
		self.dcnt = 0;
		self.flags = self.flags - (self.flags & FL_DODGED);
	}

// check for gib
	if (self.health < -40)
	{
		self.skin = 0;
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		MonsterGib (4, 0, 1, 0, 2, 0, self.health);
		return;
	}

// regular death
	if((self.deadflag & DEAD_DEAD))
		return;

	self.deadflag = DEAD_DEAD;
	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_AIM;
	self.skin = 1;

	if (n == 0)
	{
		enf_die1 (); 
		sound (self, CHAN_VOICE, "infantry/infdeth2.wav", 1, ATTN_NORM);
	}
	else if (n == 1)
	{
		enf_bdie1 ();
		sound (self, CHAN_VOICE, "infantry/infdeth1.wav", 1, ATTN_NORM);
	}
	else
	{
		enf_fdie1 ();
		sound (self, CHAN_VOICE, "infantry/infdeth2.wav", 1, ATTN_NORM);
	}
};

void()	enf_duckdown1	=[	119,	enf_duckdown2	] 
{
	self.dcnt = 1; 
	self.nextthink = self.dspeed; 
	self.maxs_z -= 32; 
	self.takedamage = DAMAGE_YES;
	ai_face();
};
void()	enf_duckdown2	=[	120,	enf_duckhold	] {ai_face(); self.dodge_finished = time + 0.25 + 2*random();};

void()	enf_duckup1	=[	122,	enf_duckup2	] 
{self.dodge_finished = time + 1 + random()*2; self.takedamage = DAMAGE_AIM; self.flags = self.flags - (self.flags & FL_DODGED); self.dcnt = 0; self.maxs_z += 32;};
void()	enf_duckup2	=[	123,	enf_duckup3	] {};
void()	enf_duckup3	=[	124,	enf_run1	] {};

void()	enf_duckhold =[	121,	enf_duckhold 	]	
{
	if(time > self.dodge_finished)
		self.think = enf_duckup1;
};

/*QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) Ambush

*/
void() spawn_enf;
void() monster_enforcer =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/infantry.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	precache_sound2 ("infantry/infdeth1.wav");
	precache_sound2 ("infantry/infdeth2.wav");
	precache_sound2 ("infantry/infpain1.wav");
	precache_sound2 ("infantry/infpain2.wav");
	precache_sound2 ("infantry/infidle1.wav");
	precache_sound2 ("infantry/infatck1.wav");
	precache_sound2 ("infantry/infatck2.wav");
	precache_sound2 ("infantry/infatck3.wav");
	precache_sound2 ("infantry/melee2.wav");
	precache_sound2 ("infantry/infsght1.wav");
	precache_sound2 ("infantry/infsrch1.wav");
	
	spawn_enf ();
};

void() spawn_enf =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/infantry.mdl");

	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = 100;
	self.max_health = 100;
	self.mass = 200;
	self.skin = 0;

	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
	self.th_missile = enf_atk1;
	self.th_melee = enf_atkb1;
	self.th_spawn = spawn_enf;
	self.th_dodge = enf_duckdown1;

	walkmonster_start();
};
