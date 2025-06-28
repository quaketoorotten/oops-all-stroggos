/*
==============================================================================

KNIGHT

==============================================================================
*/

$cd id1/models/knight2
$origin 0 0 24
$base base
$skin skin

.float pissed;

void() hknight_run1;
void() hk_idle_sound; void() hk_srch_sound;

void(float base, float kick, float fly, float rad) BerserkerShock =
{
	local vector	delta;
	local float 	ldmg;
	local vector o;


	makevectors(self.angles);
	o = self.origin + v_forward * 20 + v_up * -24 + v_right * -45;
	SHOCKING_INNIT(o);
	
	if (!self.enemy)
		return;

	sound (self, CHAN_VOICE, "tank/tnkatck5.wav", 1, ATTN_NORM);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > rad)
		return;
		
	ldmg = base + random()*10 % 5;
	T_Damage (self.enemy, self, self, ldmg, kick);

	if(self.enemy.movetype == MOVETYPE_STEP)
		self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);

	self.enemy.origin_z += fly;
};

void(float base) hk_club =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
	{
		self.pissed += 0.5;
		return;
	}
	ldmg = base + random()*10 % 6;
	T_Damage (self.enemy, self, self, ldmg, 60);
	sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

};

void(float base, float fly, float fly2) hk_spike =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 80)
	{
		self.pissed += 0.3;
		return;
	}
		
	ldmg = base + random()*10 % 6;
	T_Damage (self.enemy, self, self, ldmg, 50);
	sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

	if(self.enemy.movetype == MOVETYPE_STEP)
		self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);

	self.enemy.origin_z += fly;
	self.enemy.velocity_z += fly2;
};

//===========================================================================

void()	hknight_stand1	=[	0,	hknight_stand2	] {ai_stand(); hk_idle_sound(); };
void()	hknight_stand2	=[	1,	hknight_stand3	] {ai_stand();};
void()	hknight_stand3	=[	2,	hknight_stand4	] {ai_stand();};
void()	hknight_stand4	=[	3,	hknight_stand5	] {ai_stand();};
void()	hknight_stand5	=[	4,	hknight_stand1	] {ai_stand();};

//===========================================================================

void()	hknight_walk1	=[	25,		hknight_walk2	] {ai_walk(9); hk_srch_sound(); };
void()	hknight_walk2	=[	26,		hknight_walk3	] {ai_walk(6);};
void()	hknight_walk3	=[	27,		hknight_walk4	] {ai_walk(4);};
void()	hknight_walk4	=[	28,		hknight_walk5	] {ai_walk(6);};
void()	hknight_walk5	=[	29,		hknight_walk6	] {ai_walk(6);};
void()	hknight_walk6	=[	30,		hknight_walk7	] {ai_walk(8);};
void()	hknight_walk7	=[	31,		hknight_walk8	] {ai_walk(7);};
void()	hknight_walk8	=[	32,		hknight_walk9	] {ai_walk(6);};
void()	hknight_walk9	=[	33,		hknight_walk10	] {ai_walk(4);};
void()	hknight_walk10	=[	34,		hknight_walk11	] {ai_walk(4);};
void()	hknight_walk11	=[	35,		hknight_walk1	] {ai_walk(4);};

//===========================================================================

void()	hknight_run1	=[	36,		hknight_run2	] {ai_run(21); CheckForCharge (2); };
void()	hknight_run2	=[	37,		hknight_run3	] {ai_run(11);};
void()	hknight_run3	=[	38,		hknight_run4	] {ai_run(21);};
void()	hknight_run4	=[	39,		hknight_run5	] {ai_run(25); hk_srch_sound(); };
void()	hknight_run5	=[	40,		hknight_run6	] {ai_run(18);};
void()	hknight_run6	=[	41,		hknight_run1	] {ai_run(19);};

//============================================================================

void()	hknight_pain1	=[	109,		hknight_pain2	] {};
void()	hknight_pain2	=[	200,		hknight_pain3	] {};
void()	hknight_pain3	=[	201,		hknight_pain4	] {};
void()	hknight_pain4	=[	202,		hknight_run1	] {};

void()	hknight_painb1	=[	203,		hknight_painb2	] {};
void()	hknight_painb2	=[	204,		hknight_painb3	] {};
void()	hknight_painb3	=[	205,		hknight_painb4	] {};
void()	hknight_painb4	=[	206,		hknight_painb5	] {};
void()	hknight_painb5	=[	207,		hknight_painb6	] {};
void()	hknight_painb6	=[	208,		hknight_painb7	] {};
void()	hknight_painb7	=[	209,		hknight_painb8	] {};
void()	hknight_painb8	=[	210,		hknight_painb9	] {};
void()	hknight_painb9	=[	211,		hknight_painb10	] {};
void()	hknight_painb10	=[	212,		hknight_painb11	] {};
void()	hknight_painb11	=[	213,		hknight_painb12	] {};
void()	hknight_painb12	=[	214,		hknight_painb13	] {};
void()	hknight_painb13	=[	215,		hknight_painb14	] {};
void()	hknight_painb14	=[	216,		hknight_painb15	] {};
void()	hknight_painb15	=[	217,		hknight_painb16	] {};
void()	hknight_painb16	=[	218,		hknight_painb17	] {};
void()	hknight_painb17	=[	219,		hknight_painb18	] {};
void()	hknight_painb18	=[	220,		hknight_painb19	] {};
void()	hknight_painb19	=[	221,		hknight_painb20	] {};
void()	hknight_painb20	=[	222,		hknight_run1	] {};

void(entity attacker, float damage)	hknight_pain =
{
	if (self.health < self.max_health / 2)
		self.skin = 1;

	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "berserk/berpain2.wav", 1, ATTN_NORM);
	self.pain_finished = time + 3;

	if(self.dcnt)
		return;

	if (skill == 3) 
		return;

	if ((damage < 20) || (random() < 0.5))
		hknight_pain1();
	else
		hknight_painb1();
};


//============================================================================

void()	hknight_die1	=[	223,	hknight_die2	] {ai_back(10);};
void()	hknight_die2	=[	224,	hknight_die3	] {ai_back(8);};
void()	hknight_die3	=[	225,	hknight_die4	]
{self.maxs_z = -8; self.solid = SOLID_CORPSE; ai_forward(7);};
void()	hknight_die4	=[	226,	hknight_die5	] {};
void()	hknight_die5	=[	227,	hknight_die6	] {};
void()	hknight_die6	=[	228,	hknight_die7	] {};
void()	hknight_die7	=[	229,	hknight_die8	] {};
void()	hknight_die8	=[	230,	hknight_die9	] {};
void()	hknight_die9	=[	231,	hknight_die10	] {};
void()	hknight_die10	=[	232,	hknight_die11	] {};
void()	hknight_die11	=[	233,	hknight_die12	] {};
void()	hknight_die12	=[	234,	hknight_die13	] {};
void()	hknight_die13	=[	235,	hknight_die13	] {};

void()	hknight_dieb1	=[	236,	hknight_dieb2	] {ai_back(11);};
void()	hknight_dieb2	=[	237,	hknight_dieb3	] {};
void()	hknight_dieb3	=[	238,	hknight_dieb4	]
{self.maxs_z = -8; self.solid = SOLID_CORPSE;};
void()	hknight_dieb4	=[	239,	hknight_dieb5	] {};
void()	hknight_dieb5	=[	240,	hknight_dieb6	] {};
void()	hknight_dieb6	=[	241,	hknight_dieb7	] {};
void()	hknight_dieb7	=[	242,	hknight_dieb8	] {};
void()	hknight_dieb8	=[	243,	hknight_dieb8	] {};

void() hknight_die =
{	
	if(self.dcnt)
	{
		self.maxs_z = 40;
		self.dcnt = 0;
		self.flags = self.flags - (self.flags & FL_DODGED);
	}

// check for gib
	if (self.health < -60)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		MonsterGib (4, 0, 1, 0, 2, 0, self.health);
		return;
	}

// regular death
	if((self.deadflag & DEAD_DEAD))
		return;

	sound (self, CHAN_VOICE, "berserk/berdeth2.wav", 1, ATTN_NORM);
	if (random() > 0.5)
		hknight_die1 ();
	else
		hknight_dieb1 ();

	self.deadflag = DEAD_DEAD;
	self.takedamage = DAMAGE_YES;
};


//===========================================================================

void()	hknight_strtchr1  =[	110,	hknight_strtchr2  ] {ai_charge(21);}
void()	hknight_strtchr2  =[	111,	hknight_strtchr3  ] {ai_charge(11);}
void()	hknight_strtchr3  =[	112,	hknight_strtchr4  ] {ai_charge(21);}
void()	hknight_strtchr4  =[	113,	hknight_strtchr5  ] {ai_charge(25);}
void()	hknight_strtchr5  =[	114,	hknight_strtchr6  ] {ai_charge(18);}
void()	hknight_strtchr6  =[	115,	hknight_char_b1   ] {ai_charge(19);}

void()	hknight_hit_b1	=[	122,	hknight_hit_b2	] {ai_charge(21); sound (self, CHAN_WEAPON, "berserk/attack.wav", 1, ATTN_NORM); self.count += 1; }
void()	hknight_hit_b2	=[	123,	hknight_hit_b3	] {ai_charge(11);};
void()	hknight_hit_b3	=[	124,	hknight_hit_b4	] {ai_charge(21);};
void()	hknight_hit_b4	=[	125,	hknight_hit_b5	] {ai_charge(25);};
void()	hknight_hit_b5	=[	126,	hknight_hit_b6	] {ai_charge(18); hk_club(12);};
void()	hknight_hit_b6	=[	127,	hknight_run1	] {ai_charge(19);};

void()	hknight_smash1	=[	97,	hknight_smash2	] {ai_face();};
void()	hknight_smash2	=[	98,	hknight_smash3	] {ai_charge(1);};
void()	hknight_smash3	=[	99,	hknight_smash4	] {ai_charge(0);};
void()	hknight_smash4	=[	100,	hknight_smash5	] {ai_charge(3);};
void()	hknight_smash5	=[	101,	hknight_smash6	] {ai_charge(2);};
void()	hknight_smash6	=[	102,	hknight_smash7	] {ai_charge(5);};
void()	hknight_smash7	=[	103,	hknight_smash8	] {ai_charge(2); BerserkerShock (30, 20, 10, 175);};
void()	hknight_smash8	=[	104,	hknight_smash9	] {ai_face();};
void()	hknight_smash9	=[	105,	hknight_smash10	] {ai_charge(2);};
void()	hknight_smash10	=[	106,	hknight_smash11	] {ai_face();};
void()	hknight_smash11	=[	107,	hknight_smash12	] {ai_charge(4);};
void()	hknight_smash12	=[	108,	hknight_smash13	] {};
void()	hknight_smash13	=[	109,	hknight_run1	] {};

void()	HK_CheckHit =
{
	local vector delta;
	local float rad;
	delta = self.enemy.origin - self.origin;
	
	if (self.pissed >= 1)
		rad = 100;
	else
		rad = 125;
	
	if (vlen(delta) > rad)
		return;

	if (self.pissed >= 1)
	{	
		self.pissed = 0;
		sound (self, CHAN_WEAPON, "berserk/attack.wav", 1, ATTN_NORM);	
		hknight_smash1 ();
	}
	else	
		hknight_hit_b1();
}

void()	hknight_char_b1	=[	116,	hknight_char_b2	]  {CheckContinueCharge (3); ai_charge(21);};
void()	hknight_char_b2	=[	117,	hknight_char_b3	] {ai_charge(11); HK_CheckHit();};
void()	hknight_char_b3	=[	118,	hknight_char_b4	] {ai_charge(21); HK_CheckHit();};
void()	hknight_char_b4	=[	119,	hknight_char_b5	] {ai_charge(25); HK_CheckHit();};
void()	hknight_char_b5	=[	120,	hknight_char_b6	] {ai_charge(18); HK_CheckHit();};
void()	hknight_char_b6	=[	121,	hknight_char_b1	] {ai_charge(19); HK_CheckHit();};

//===========================================================================

void() hknight_jump10;

void() hknight_dodge;

void() hknight_touch;


void() 	hknight_leap = 
{
	local float vel;
	local vector dir;
	ai_face();
	self.dcnt = 1;
	
	sound (self, CHAN_WEAPON, "berserk/attack.wav", 1, ATTN_NORM);
	vel = CalcVelocity(700, self.enemy.origin - self.origin, 125);
	dir = normalize(self.enemy.origin - self.origin);

//	makevectors (self.angles);

	self.origin_z = self.origin_z + 1;
	self.velocity = dir*vel + '0 0 350'; // better if it follows the dir than just v_forward
	dprint(ftos(vel));
	dprint("\n");

//	self.velocity = v_forward*vel + '0 0 350';

	self.touch = hknight_touch;
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	self.flags = self.flags | FL_LEAP;

	self.th_dodge = __NULL__;
}

void()	hk_setgrav	=
{
	if (self.velocity[2] < 0)
		self.gravity = 2.25 * (self.mass / 200);
	else
		self.gravity = 5.25 * (self.mass / 200);
}

void()	hknight_jump4	=[	147,		hknight_jump5	] {hknight_leap();}
void()	hknight_jump5	=[	148,		hknight_jump6	] {};
void()	hknight_jump6	=[	149,		hknight_jump7	] {};
void()	hknight_jump7	=[	150,		hknight_jump8	] {};
void()	hknight_jump8	=[ 	151,		hknight_jump9	] {};
void()	hknight_jump9	=[ 	152,		hknight_jump10	] {hk_setgrav(); };
void()	hknight_jump10	=[ 	153,		hknight_jump4	] {self.nextthink = time + 6; };  // if stuck retry! 
void()	hknight_jump11	=[ 	154,		hknight_jump12	] {self.gravity = 0; BerserkerShock (20, 20, 10, 150); self.velocity = '0 0 0'; };
void()	hknight_jump12	=[ 	155,		hknight_jump13	] {};
void()	hknight_jump13	=[ 	156,		hknight_jump14	] {ai_forward(4);};
void()	hknight_jump14	=[ 	157,		hknight_jump15	] {ai_forward(5);};
void()	hknight_jump15	=[ 	158,		hknight_jump16	] {ai_forward(2);};
void()	hknight_jump16	=[ 	159,		hknight_jump17	] {ai_forward(1);};
void()	hknight_jump17	=[ 	160,		hknight_jump18	] {ai_forward(1);};
void()	hknight_jump18	=[ 	161,		hknight_jump19	] {};
void()	hknight_jump19	=[ 	162,		hknight_jump20	] {};
void()	hknight_jump20	=[ 	163,		hknight_jump21	] {};
void()	hknight_jump21	=[ 	164,		hknight_jump22	] {ai_forward(3);};
void()	hknight_jump22	=[ 	165,		hknight_jump23	] {ai_forward(4);};
void()	hknight_jump23	=[ 	166,		hknight_jump24	] {ai_forward(3);};
void()	hknight_jump24	=[ 	167,		hknight_run1	] {self.th_dodge = hknight_dodge; self.dcnt = 0;};

void() hknight_touch =
{	
	if (self.health <= 0)
		self.th_die();
	
	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	
			self.touch = SUB_Null;
			self.think = hknight_jump4;
			self.nextthink = time;
		}
		return;	// not on ground yet
	}
	
	self.touch = SUB_Null;
	self.think = hknight_jump11;
	self.flags = self.flags - (self.flags & FL_LEAP);
	self.nextthink = time;
};

//===========================================================================

void()	hknight_duckdown1	=[	169,	hknight_duckdown2	] 
{
	ai_face();
	self.dcnt = 1; 
	self.nextthink = self.dspeed; 
	self.maxs_z = -1; 
	self.takedamage = DAMAGE_YES;
};
void()	hknight_duckdown2	=[	170,	hknight_duckdown3	] {};
void()	hknight_duckdown3	=[	171,	hknight_duckhold	] {ai_face(); self.dodge_finished = time + 0.25 + 2*random();};

void()	hknight_duckup1	=[	173,	hknight_duckup2	] {};
void()	hknight_duckup2	=[	174,	hknight_duckup3	] {};
void()	hknight_duckup3	=[	175,	hknight_duckup4	] 
{self.dodge_finished = time + 1 + random()*2; self.takedamage = DAMAGE_AIM; self.flags = self.flags - (self.flags & FL_DODGED); self.dcnt = 0; self.maxs_z = 40;};
void()	hknight_duckup4	=[	176,	hknight_duckup5	] {};
void()	hknight_duckup5	=[	177,	hknight_duckup6	] {};
void()	hknight_duckup6	=[	178,	hknight_run1	] 	{};

void()	hknight_duckhold =[	172,	hknight_duckhold 	]	
{
	if(time > self.dodge_finished)
		self.think = hknight_duckup1;
};

void()	hknight_duckdownb1 =[	180,	hknight_duckdownb2 ] 
{	
	ai_forward(6);
	self.dcnt = 1; 
	self.nextthink = self.dspeed; 
	self.maxs_z = -1; 
	self.takedamage = DAMAGE_YES;
};
void()	hknight_duckdownb2 =[	181,	hknight_duckdownb3 ] {ai_forward(20);};
void()	hknight_duckdownb3 =[	182,	hknight_duckdownb4 ] {ai_forward(16);};
void()	hknight_duckdownb4 =[	183,	hknight_duckdownb5 ] {ai_forward(14);};
void()	hknight_duckdownb5 =[	184,	hknight_duckdownb6 ] {ai_forward(12);};
void()	hknight_duckdownb6 =[	185,	hknight_duckdownb7 ] {ai_forward(5);};
void()	hknight_duckdownb7 =[	186,	hknight_duckdownb8 ] {};
void()	hknight_duckdownb8 =[	187,	hknight_duckdownb9 ] {ai_forward(1);};
void()	hknight_duckdownb9 =[	188,	hknight_duckdownb10] {};
void()	hknight_duckdownb10=[	189,	hknight_duckdownb11] {ai_forward(2);};
void()	hknight_duckdownb11=[	190,	hknight_duckdownb12] {};
void()	hknight_duckdownb12=[	191,	hknight_duckdownb13] {ai_forward(3); self.dodge_finished = time + 2 + random()*2;};
void()	hknight_duckdownb13=[	192,	hknight_duckdownb14] {ai_forward(5);};
void()	hknight_duckdownb14=[	193,	hknight_duckdownb15] {};
void()	hknight_duckdownb15=[	194,	hknight_duckdownb16] 
{ai_forward(1); self.takedamage = DAMAGE_AIM; self.flags = self.flags - (self.flags & FL_DODGED); self.dcnt = 0; self.maxs_z = 40; };
void()	hknight_duckdownb16=[	195,	hknight_duckdownb17] {ai_forward(4);};
void()	hknight_duckdownb17=[	196,	hknight_run1	 ] {};


void()	hknight_dodge =
{	
	if ((self.frame >= 36 && self.frame <= 41) || (self.frame >= 110 && self.frame <= 121))
	{
		hknight_duckdownb1();
		return;
	}
	else
		hknight_duckdown1();
}

//===========================================================================

void()	hknight_slice1	=[	42,	hknight_slice2	] {ai_face();self.count += 1; sound (self, CHAN_WEAPON, "berserk/attack.wav", 1, ATTN_NORM);	};
void()	hknight_slice2	=[	43,	hknight_slice3	] {ai_face();};
void()	hknight_slice3	=[	44,	hknight_slice4	] {ai_face();};
void()	hknight_slice4	=[	45,	hknight_slice5	] {ai_face();};
void()	hknight_slice5	=[	46,	hknight_slice6	] {ai_face();};
void()	hknight_slice6	=[	47,	hknight_slice7	] {ai_face();};
void()	hknight_slice7	=[	48,	hknight_slice8	] {ai_face();};
void()	hknight_slice8	=[	49,	hknight_slice9	] {ai_face();};
void()	hknight_slice9	=[	50,	hknight_slice10	] {ai_face(); hk_spike(8, 16, 250);};
void()	hknight_slice10	=[	51,	hknight_slice11	] {ai_face();};
void()	hknight_slice11	=[	52,	hknight_slice12	] {ai_face();};
void()	hknight_slice12	=[	53,	hknight_slice13	] {};
void()	hknight_slice13	=[	54,	hknight_run1	] {};

void()	hknight_sliceb1	=[	77,	hknight_sliceb2	] {ai_face();sound (self, CHAN_WEAPON, "berserk/attack.wav", 1, ATTN_NORM);	};
void()	hknight_sliceb2	=[	78,	hknight_sliceb3	] {ai_face();};
void()	hknight_sliceb3	=[	79,	hknight_sliceb4	] {ai_face();};
void()	hknight_sliceb4	=[	80,	hknight_sliceb5	] {ai_face(); hk_spike(15, 16, 450);};
void()	hknight_sliceb5	=[	81,	hknight_sliceb6	] {ai_face();};
void()	hknight_sliceb6	=[	82,	hknight_sliceb7	] {};
void()	hknight_sliceb7	=[	83,	hknight_sliceb8	] {};
void()	hknight_sliceb8	=[	84,	hknight_run1	] {};

void()	hknight_smack1	=[	56,	hknight_smack2	] {ai_face(); sound (self, CHAN_WEAPON, "berserk/attack.wav", 1, ATTN_NORM);	 self.count += 1;};
void()	hknight_smack2	=[	57,	hknight_smack3	] {ai_face();};
void()	hknight_smack3	=[	58,	hknight_smack4	] {ai_face();};
void()	hknight_smack4	=[	59,	hknight_smack5	] {ai_face();};
void()	hknight_smack5	=[	60,	hknight_smack6	] {ai_face();};
void()	hknight_smack6	=[	61,	hknight_smack7	] {ai_face();};
void()	hknight_smack7	=[	62,	hknight_smack8	] {ai_face();};
void()	hknight_smack8	=[	63,	hknight_smack9	] {ai_face();};
void()	hknight_smack9	=[	64,	hknight_smack10	] {ai_face();};
void()	hknight_smack10	=[	65,	hknight_smack11	] {ai_face();};
void()	hknight_smack11	=[	66,	hknight_smack12	] {ai_face();};
void()	hknight_smack12	=[	67,	hknight_smack13	] {ai_face(); hk_club(10);};
void()	hknight_smack13	=[	68,	hknight_smack14	] {ai_face();};
void()	hknight_smack14	=[	69,	hknight_smack15	] {ai_face();};
void()	hknight_smack15	=[	70,	hknight_smack16	] {ai_face();};
void()	hknight_smack16	=[	71,	hknight_smack17	] {};
void()	hknight_smack17	=[	72,	hknight_smack18	] {};
void()	hknight_smack18	=[	73,	hknight_smack19	] {};
void()	hknight_smack19	=[	74,	hknight_smack20	] {};
void()	hknight_smack20	=[	75,	hknight_smack21	] {};
void()	hknight_smack21	=[	76,	hknight_run1	] {};

void()	hknight_smackb1	=[	85,	hknight_smackb2	] {ai_face(); sound (self, CHAN_WEAPON, "berserk/attack.wav", 1, ATTN_NORM);	};
void()	hknight_smackb2	=[	86,	hknight_smackb3	] {ai_face();};
void()	hknight_smackb3	=[	87,	hknight_smackb4	] {ai_face();};
void()	hknight_smackb4	=[	88,	hknight_smackb5	] {ai_face();};
void()	hknight_smackb5	=[	89,	hknight_smackb6	] {ai_face(); hk_club(25);};
void()	hknight_smackb6	=[	90,	hknight_smackb7	] {ai_face();};
void()	hknight_smackb7	=[	91,	hknight_smackb8	] {ai_face();};
void()	hknight_smackb8	=[	92,	hknight_smackb9	] {ai_face();};
void()	hknight_smackb9	=[	93,	hknight_smackb10	] {};
void()	hknight_smackb10	=[	94,	hknight_smackb11	] {};
void()	hknight_smackb11	=[	95,	hknight_smackb12	] {};
void()	hknight_smackb12	=[	96,	hknight_run1	] {};

void() hknight_melee =
{
	if (self.pissed >= 1) // he's pissed off.
	{	
		self.pissed = 0;
		hknight_smash1();
	}
	
	else if (self.count == 0)
		hknight_slice1 ();

	else if (self.count == 1)
		hknight_smack1 ();
	
	else  
	{
		if(random() < 0.6)
			hknight_sliceb1 ();
		else
			hknight_smackb1 ();
		
		self.count = 0;
	}

};

//===========================================================================
/*
==============
CheckDemonJump

==============
*/
float()	CheckHKJump =
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
	
	if (d < 500)
		return FALSE;

	if (d > 1000)
		return FALSE;

	if (random() < 0.4)
		return FALSE;
	
	return TRUE;
};

float()	CheckHKMelee =
{
	if (enemy_range == RANGE_MELEE)
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return TRUE;
		}
	}
	return FALSE;
};

float()	CheckHKPissed =
{	
	if (self.pissed < 1)
		return FALSE;

	local	vector	dist;
	local	float	d;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 150)
		return TRUE;
	
	return FALSE;
};

float()	HKCheckAttack =
{	
	if (CheckHKPissed ())
	{
		self.th_char ();
		return TRUE;
	}

	// if close enough for slashing, go for it
	if (CheckHKMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}

	if(self.attack_finished > time)
		return FALSE;

	if (CheckHKJump ())
	{	
		ai_face();
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished(2 + random()*2);
		return TRUE;
	}
	
	return FALSE;
};

//===========================================================================

void() hk_idle_sound =
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "berserk/beridle1.wav", 1, ATTN_IDLE);
};

void() hk_srch_sound =
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "berserk/bersrch1.wav", 1, ATTN_IDLE);
};

/*QUAKED monster_hell_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/

void() spawn_berserk;
void() monster_berserk =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model  ("progs/berserk.mdl");
	precache_model2 ("progs/k_spike.mdl");
	precache_model2 ("progs/h_hellkn.mdl");

	precache_sound ("shambler/smack.wav");
	precache_sound2 ("berserk/attack.wav");
	precache_sound2 ("berserk/berdeth2.wav");
	precache_sound2 ("berserk/berpain2.wav");
	precache_sound2 ("berserk/beridle1.wav");
	precache_sound  ("berserk/bersrch1.wav");		
	precache_sound2 ("berserk/slash1.wav");
	precache_sound2 ("berserk/idle.wav");
	precache_sound2 ("berserk/sight.wav");
	precache_sound  ("tank/tnkatck5.wav");
	
	spawn_berserk();
};

void() monster_hell_knight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/berserk.mdl");
	precache_model2 ("progs/k_spike.mdl");
	precache_model2 ("progs/h_hellkn.mdl");
	
	precache_sound2 ("berserk/attack.wav");
	precache_sound2 ("berserk/berdeth2.wav");
	precache_sound2 ("berserk/berpain2.wav");
	precache_sound2 ("berserk/beridle1.wav");
	precache_sound  ("berserk/bersrch1.wav");		
	precache_sound2 ("berserk/slash1.wav");
	precache_sound2 ("berserk/idle.wav");
	precache_sound2 ("berserk/sight.wav");
	precache_sound ("tank/tnkatck5.wav");
	precache_sound ("shambler/smack.wav");

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
	
	if(self.classname == "monster_berserk")
	{
		monster_berserk();
		return;
	}
	else if(self.classname == "monster_parasite")
	{
		monster_parasite();
		return;
	}
	
	local float r = random();
	
	if(r < 0.1)
	{
		self.classname = "monster_parasite";
		monster_parasite();
		return;
	}
	else
	{
		self.classname = "monster_berserk";
		monster_berserk();
		return;
	}
};

void() spawn_berserk=
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/berserk.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 240;
	self.max_health = 240;
	self.mass = 250;
	self.skin = 0;

	self.th_stand = hknight_stand1;
	self.th_walk = hknight_walk1;
	self.th_run = hknight_run1;
	self.th_melee = hknight_melee;
	self.th_missile = hknight_jump4;
	self.th_pain = hknight_pain;
	self.th_die = hknight_die;
	self.th_spawn = spawn_berserk;
	self.th_char = hknight_strtchr1;
	self.th_checkatck = HKCheckAttack;
	self.th_dodge = hknight_dodge;

	walkmonster_start();
};
