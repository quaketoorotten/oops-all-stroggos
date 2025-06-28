/*
==============================================================================

SHAMBLER

==============================================================================
*/

$cd id1/models/tanks
$origin 0 0 24
$base base		
$skin base

float MF_TANK_BLSTR_1	=	1; // unused
float MF_TANK_BLSTR_2	=	2; // unused
float MF_TANK_BLSTR_3	=	3; // unused
float MF_TANK_MG_1	=	4;
float MF_TANK_MG_2	=	5;
float MF_TANK_MG_3	=	6;
float MF_TANK_MG_4	=	7;
float MF_TANK_MG_5	=	8;
float MF_TANK_MG_6	=	9;
float MF_TANK_MG_7	=	10;
float MF_TANK_MG_8	=	11;
float MF_TANK_MG_9	=	12;
float MF_TANK_MG_10	=	13;
float MF_TANK_MG_11	=	14;
float MF_TANK_MG_12	=	15;
float MF_TANK_MG_13	=	16;
float MF_TANK_MG_14	=	17;
float MF_TANK_MG_15	=	18;
float MF_TANK_MG_16	=	19;
float MF_TANK_MG_17	=	20;
float MF_TANK_MG_18	=	21;
float MF_TANK_MG_19	=	22;


vector m_tank_flashoffset[] = // q2 port i guess idk
{
	'20.7 -18.5 28.7',  // unused
	'16.6 -21.5 30.1',  // unused
	'11.8 -23.9 32.1',  // unused
	'22.9 -0.7 25.3',
	'22.2 6.2 22.3',
	'19.4 13.1 18.6',
	'19.4 18.8 18.6',
	'17.9 25.0 18.6',
	'14.1 30.5 20.6',
	'9.3 35.3 22.1',
	'4.7 38.4 22.1',
	'-1.1 40.4 24.1',
	'-6.5 41.2 24.1',
	'3.2 40.1 24.7',
	'11.7 36.7 26.0',
	'18.9 31.3 26.0',
	'24.4 24.4 26.4',
	'27.1 17.1 27.2',
	'28.5 9.1 28.0',
	'27.1 2.2 28.0',
	'24.9 -2.8 28.0',
	'21.6 -7.0 26.4',
	'6.2 29.1 49.1', // unused
	'6.9 23.8 49.1', // unused
	'8.3 17.8 49.5', // unused
};

void()	tank_stand1	= [	self.frame,	tank_stand1	] 
{
	self.frame ++;
	if(self.frame > 29)
		self.frame = 0;

	ai_stand();

	if(self.frame == 29)
		if (random() < 0.2)
			sound (self, CHAN_VOICE, "tank/tnkidle1.wav", 1, ATTN_IDLE);
};

void() tank_walk1		=[      34,        tank_walk2 ] {ai_walk(4);}
void() tank_walk2       =[      35,        tank_walk3 ] {ai_walk(5);}
void() tank_walk3       =[      36,        tank_walk4 ] {ai_walk(3);}
void() tank_walk4       =[      37,        tank_walk5 ] {ai_walk(2);}
void() tank_walk5       =[      38,        tank_walk6 ] {ai_walk(5);}
void() tank_walk6       =[      39,        tank_walk7 ] {ai_walk(5);}
void() tank_walk7       =[      40,        tank_walk8 ] {ai_walk(4);}
void() tank_walk8       =[      41,        tank_walk9 ] {ai_walk(4); sound (self, CHAN_VOICE, "tank/step.wav", 1, ATTN_IDLE);}
void() tank_walk9       =[      42,        tank_walk10] {ai_walk(3);}
void() tank_walk10      =[      43,        tank_walk11] {ai_walk(5);}
void() tank_walk11      =[      44,        tank_walk12] {ai_walk(4);}
void() tank_walk12      =[      45,        tank_walk13] {ai_walk(5);}
void() tank_walk13      =[      46,        tank_walk14] {ai_walk(7);}
void() tank_walk14      =[      47,        tank_walk15] {ai_walk(7);}
void() tank_walk15      =[      48,        tank_walk16] {ai_walk(6);}
void() tank_walk16      =[      49,        tank_walk1 ] {ai_walk(6); sound (self, CHAN_VOICE, "tank/step.wav", 1, ATTN_IDLE);}

void() tank_run1	     =[      34,        tank_run2 ] {ai_run(4);}
void() tank_run2       =[      35,        tank_run3 ] {ai_run(5);}
void() tank_run3       =[      36,        tank_run4 ] {ai_run(3);}
void() tank_run4       =[      37,        tank_run5 ] {ai_run(2);}
void() tank_run5       =[      38,        tank_run6 ] {ai_run(5);}
void() tank_run6       =[      39,        tank_run7 ] {ai_run(5);}
void() tank_run7       =[      40,        tank_run8 ] {ai_run(4);}
void() tank_run8       =[      41,        tank_run9 ] {ai_run(4); sound (self, CHAN_VOICE, "tank/step.wav", 1, ATTN_IDLE);}
void() tank_run9       =[      42,        tank_run10] {ai_run(3);}
void() tank_run10      =[      43,        tank_run11] {ai_run(5);}
void() tank_run11      =[      44,        tank_run12] {ai_run(4);}
void() tank_run12      =[      45,        tank_run13] {ai_run(5);}
void() tank_run13      =[      46,        tank_run14] {ai_run(7);}
void() tank_run14      =[      47,        tank_run15] {ai_run(7);}
void() tank_run15      =[      48,        tank_run16] {ai_run(6);}
void() tank_run16      =[      49,        tank_run1 ] {ai_run(6); sound (self, CHAN_VOICE, "tank/step.wav", 1, ATTN_IDLE);}

void(float base, float kick, float fly) TankShock =
{
local vector	delta;
local float 	ldmg;
local vector o;

	if(self.frame == 87)
	{
		makevectors(self.angles);
		o = self.origin + v_forward * 12 + v_up * -24 + v_right * 20;
		SHOCKING_INNIT(o);
	}
	else if(self.frame == 102)
	{
		makevectors(self.angles);
		o = self.origin + v_forward * 20 + v_up * -24 + v_right * -45;
		SHOCKING_INNIT(o);
	}

	if (!self.enemy)
		return;

	sound (self, CHAN_VOICE, "tank/tnkatck5.wav", 1, ATTN_NORM);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 175)
		return;
		
	ldmg = base + (random() + random() + random()) * 30;
	T_Damage (self.enemy, self, self, ldmg, kick);

	if(self.enemy.movetype == MOVETYPE_STEP)
		self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);


	self.enemy.origin_z += fly;
};


//============================================================================


void() TankMisTouch =
{
    if (other == self.owner)
    {
        return; // don't explode on owner
    }

    if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove(self);
        return;
    }

    if (other.health)
        T_Damage(other, self, self.owner, 50);

    // don't do radius damage to the other, because all the damage
    // was done in the impact
    T_RadiusDamage(self, self.owner, 70, other);

    //sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
    self.origin = self.origin - 8 * normalize(self.velocity);

    WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte(MSG_BROADCAST, TE_EXPLOSION);
    WriteCoord(MSG_BROADCAST, self.origin_x);
    WriteCoord(MSG_BROADCAST, self.origin_y);
    WriteCoord(MSG_BROADCAST, self.origin_z);

    BecomeExplosion();
};

void(float off) CastMissiles =
{
	local	vector	org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	
	makevectors (self.angles);

	org = self.origin + '0 0 60' + v_forward * 20 + v_right * off ;

	sound(self, CHAN_WEAPON, "tank/tnkatck1.wav", 1, ATTN_NORM);
	
	LaunchLaser(org, v_forward + '0 0 -0.14');
	setmodel (newmis, "progs/missile.mdl");
	setsize (newmis, '0 0 0', '0 0 0');	
	newmis.modelflags = MF_MISSILE;
	newmis.touch = TankMisTouch;
};

void() TankserTouch =
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	

	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, 30);
		T_Damage (other, self, self.owner, 30);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
	
	remove(self);	
};

void(float offset) CastLasers =
{	
//	ai_face();
	local	vector	offang;
	local	vector	org, vec;

// from hell knight code lol //

	offang = vectoangles (self.pos1 - self.origin - self.enemy.view_ofs);
	offang_y = offang_y + offset * 7;
	self.effects = self.effects | EF_MUZZLEFLASH;
	
	makevectors (offang);

	org = ProjectAim(self.origin, m_tank_flashoffset[MF_TANK_BLSTR_2]*1.4, v_forward, v_right); // not this one
	
	// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z ;

// from hell knight code lol //

	sound(self, CHAN_WEAPON, "tank/tnkatck3.wav", 1, ATTN_NORM);
	
	LaunchLaser(org, vec);
	newmis.touch = TankserTouch;
};

void() AutofireTankNoise =
{
	local float r = random();

	if(r < 0.9)
		sound(self, CHAN_WEAPON, "tank/tnkatk2a.wav", 1, ATTN_NORM);
	else	if(r < 0.6)
		sound(self, CHAN_WEAPON, "tank/tnkatk2b.wav", 1, ATTN_NORM);
	else	if(r < 0.3)
		sound(self, CHAN_WEAPON, "tank/tnkatk2c.wav", 1, ATTN_NORM);
	else	if(r < 0.15)
		sound(self, CHAN_WEAPON, "tank/tnkatk2d.wav", 1, ATTN_NORM);
	else
		sound(self, CHAN_WEAPON, "tank/tnkatk2e.wav", 1, ATTN_NORM);
}	

void() CastfireAuto =
{
	local	entity	en;
	
	local	vector	dir;
	local	vector	vec;
	local	vector	org;
	local float		flashnum;
	
	AutofireTankNoise ();
	
	makevectors (self.angles);
	flashnum = MF_TANK_MG_1 + (self.frame - 173);
	org = ProjectAim(self.origin, m_tank_flashoffset[flashnum]*1.4, v_forward, v_right);
	org = org + '0 0 8';
	
	if(self.enemy)
	{
		en = self.enemy;
		vec = en.origin + en.view_ofs;
		vec = vec - self.origin;
		vec = vectoangles(vec);
		dir_x = vec_x;
	}
	else
		dir_x = 0;
	
	if (self.frame <= 182)
		dir[1] = self.angles[1] - 8 * (self.frame - 178);
	else
		dir[1] = self.angles[1] + 8 * (self.frame - 186);

	dir[2] = 0;

	makevectors (dir);
	
	monster_FireBullets (1 ,org ,normalize (v_forward), '0.02 0.02 0', 20, 1);
};

void() tank_magic1     =[      55,       tank_magic2    ]{ai_face();}
void() tank_magic2     =[      56,       tank_magic3    ]{ai_face();}
void() tank_magic3     =[      57,       tank_magic4    ]{ai_face();}
void() tank_magic4     =[      58,       tank_magic5    ]{ai_face();}
void() tank_magic5     =[      59,       tank_magic6    ]{ai_face();}
void() tank_magic6     =[      60,       tank_magic9    ]{ai_face();}
void() tank_magic9     =[      61,       tank_magic10   ]{ai_face();}
void() tank_magic10    =[      62,       tank_magic11   ]{ai_face();}
void() tank_magic11    =[      62,       tank_magic12   ]{ai_face();self.pos1 = self.enemy.origin;}
void() tank_magic12    =[      63,       tank_magic13   ]{CastLasers(-2); }
void() tank_magic13    =[      64,       tank_magic14   ]{CastLasers(-1.75);}
void() tank_magic14    =[      65,       tank_magic15   ]{CastLasers(-1.5);}
void() tank_magic15    =[      66,       tank_magic16   ]{CastLasers(0); }
void() tank_magic16    =[      67,       tank_magic17   ]{CastLasers(0.7);}
void() tank_magic17    =[      68,       tank_magic18   ]{CastLasers(1.5);}
void() tank_magic18    =[      69,       tank_magic19   ]{CastLasers(2);}
void() tank_magic19    =[      70,       tank_magic20   ]
{
	ai_face();

	if(skill >= 2 && enemy_vis && self.enemy.health > 0)
		if(random() <= 0.6)
		{
			SUB_CheckRefire(tank_magic1);
			return;
		}
}
void() tank_magic20    =[      71,       tank_magic21   ]{ai_face();}
void() tank_magic21    =[      72,       tank_magic22   ]{ai_face();}
void() tank_magic22    =[      73,       tank_magic23   ]{ai_face();}
void() tank_magic23    =[      74,       tank_run1      ]{}

void() tank_magicb1     =[      168,       tank_magicb2    ]{ai_face();}
void() tank_magicb2     =[      169,       tank_magicb3    ]{ai_face();}
void() tank_magicb3     =[      170,       tank_magicb4    ]{ai_face();}
void() tank_magicb4     =[      171,       tank_magicb5    ]{ai_face();}

void() tank_magicb28;
void() tank_magicb5     =[      self.frame,tank_magicb5    ]
{
	CastfireAuto();   
	self.frame ++;
	if(self.frame == 192)
	{
		tank_magicb28();
		return;
	}
}

void() tank_magicb28    =[      193,       tank_magicb29   ]{ai_face();}
void() tank_magicb29    =[      194,       tank_magicb30   ]{ai_face();}
void() tank_magicb30    =[      195,       tank_magicb31   ]{ai_face();}
void() tank_magicb31    =[      196,       tank_run1       ]{}


void() tank_magicc1     =[      115,       tank_magicc2    ]{ai_face();}
void() tank_magicc2     =[      116,       tank_magicc3    ]{ai_face();}
void() tank_magicc3     =[      117,       tank_magicc4    ]{ai_face();}
void() tank_magicc4     =[      118,       tank_magicc5    ]{ai_face();}
void() tank_magicc5     =[      119,       tank_magicc6    ]{ai_face();}
void() tank_magicc6     =[      120,       tank_magicc9    ]{ai_face();}
void() tank_magicc9     =[      121,       tank_magicc10   ]{ai_face();}
void() tank_magicc10    =[      122,       tank_magicc11   ]{ai_face();}
void() tank_magicc11    =[      123,       tank_magicc12   ]{ai_face();}
void() tank_magicc12    =[      124,       tank_magicc13   ]{ai_face();}
void() tank_magicc13    =[      125,       tank_magicc14   ]{ai_face();}
void() tank_magicc14    =[      126,       tank_magicc15   ]{ai_face();}
void() tank_magicc15    =[      127,       tank_magicc16   ]{ai_face();}
void() tank_magicc16    =[      128,       tank_magicc17   ]{ai_charge(5);}
void() tank_magicc17    =[      129,       tank_magicc18   ]{ai_charge(8);}
void() tank_magicc18    =[      130,       tank_magicc19   ]{ai_charge(1);}
void() tank_magicc19    =[      131,       tank_magicc20   ]{ai_charge(2);}
void() tank_magicc20    =[      132,       tank_magicc21   ]{ai_charge(2);}
void() tank_magicc21    =[      133,       tank_magicc22   ]{ai_charge(4);}
void() tank_magicc22    =[      134,       tank_magicc23   ]{ai_charge(5);}
void() tank_magicc23    =[      135,       tank_magicc24   ]{ai_charge(1);}

void() tank_magicc25;

void() tank_magicc24     =[      self.frame,tank_magicc24    ]
{
	if(self.frame == 137)
		CastMissiles(40); 
	if(self.frame == 140)
		CastMissiles(30);  
	if(self.frame == 143)
		CastMissiles(20);   
 
	self.frame ++;
	if(self.frame == 155)
	{
		tank_magicc25();
		return;
	}
}
void() tank_magicc25    =[      156,       tank_magicc26   ]{ai_charge(6);}
void() tank_magicc26    =[      157,       tank_magicc27   ]{ai_charge(8);}
void() tank_magicc27    =[      158,       tank_magicc28   ]{ai_charge(12);}
void() tank_magicc28    =[      159,       tank_magicc29   ]{ai_charge(7);

	if(skill >= 2 && enemy_vis && self.enemy.health > 0)
		if(random() <= 0.4)
		{
			SUB_CheckRefire(tank_magicc1);
			return;
		}
}

void() tank_magicc29    =[      self.frame,tank_magicc29   ]
{
	self.frame ++;
	if(self.frame == 167)
	{
		tank_run1();
		return;
	}
}

void() tank_magicd1     =[      76,       tank_magicd2    ]{ai_face(); sound (self, CHAN_VOICE, "tank/tnkatck4.wav", 1, ATTN_NORM);}
void() tank_magicd2     =[      79,       tank_magicd3    ]{ai_face();}
void() tank_magicd3     =[      80,       tank_magicd4    ]{ai_face();}
void() tank_magicd4     =[      81,       tank_magicd5    ]{ai_charge(6);}
void() tank_magicd5     =[      83,       tank_magicd6    ]{ai_charge(12);}
void() tank_magicd6     =[      86,       tank_magicd7    ]{ai_charge(8);}
void() tank_magicd7     =[      87,       tank_magicd8    ]{ai_face(); TankShock(5, 10, 7);}
void() tank_magicd8     =[      95,       tank_magicd9    ]{ai_face();}
void() tank_magicd9     =[      99,       tank_magicd10   ]{ai_face();}
void() tank_magicd10    =[      100,      tank_magicd11   ]{ai_face();}
void() tank_magicd11    =[      101,      tank_magicd12   ]{ai_face();}
void() tank_magicd12    =[      102,      tank_magicd13   ]{ai_face(); TankShock(25, 80, 25);}
void() tank_magicd13    =[      103,      tank_magicd14   ]{ai_face();}
void() tank_magicd14    =[      104,      tank_magicd15   ]{ai_face();}
void() tank_magicd15    =[      105,      tank_magicd16   ]{ai_face();}
void() tank_magicd16    =[      106,      tank_magicd17   ]{ai_face();}
void() tank_magicd17    =[      107,      tank_magicd18   ]{ai_charge(4);}
void() tank_magicd18    =[      108,      tank_magicd19   ]{ai_charge(8);}
void() tank_magicd19    =[      109,      tank_magicd20   ]{ai_charge(6);}
void() tank_magicd20    =[      110,      tank_magicd21   ]{ai_charge(2);}
void() tank_magicd21    =[      111,      tank_magicd22   ]{ai_face();}
void() tank_magicd22    =[      112,      tank_magicd23   ]{ai_face();}
void() tank_magicd23    =[      113,      tank_magicd24   ]{ai_face();}
void() tank_magicd24    =[      114,      tank_run1	    ]{ai_face();}


void() tank_pain1       =[      197, tank_pain2      ] {}
void() tank_pain2       =[      198, tank_pain3      ] {}
void() tank_pain3       =[      199, tank_pain4      ] {}
void() tank_pain4       =[      200, tank_run1       ] {}

void() tank_painb1      =[      201, tank_painb2     ] {}
void() tank_painb2      =[      202, tank_painb3     ] {}
void() tank_painb3      =[      203, tank_painb4     ] {}
void() tank_painb4      =[      204, tank_painb5     ] {}
void() tank_painb5      =[      205, tank_run1       ] {}

void() tank_painc1      =[      206, tank_painc2     ] {ai_pain(6);}
void() tank_painc2      =[      207, tank_painc3     ] {ai_pain(2);}
void() tank_painc3      =[      208, tank_painc4     ] {ai_pain(1);}
void() tank_painc4      =[      209, tank_painc5     ] {}
void() tank_painc5      =[      210, tank_painc6     ] {}
void() tank_painc6      =[      211, tank_painc7     ] {}
void() tank_painc7      =[      212, tank_painc8     ] {}
void() tank_painc8      =[      213, tank_painc9     ] {}
void() tank_painc9      =[      214, tank_painc10    ] {}
void() tank_painc10     =[      215, tank_painc11    ] {}
void() tank_painc11     =[      216, tank_painc12    ] {}
void() tank_painc12     =[      217, tank_painc13    ] {}
void() tank_painc13     =[      218, tank_painc14    ] {}
void() tank_painc14     =[      219, tank_painc15    ] {}
void() tank_painc15     =[      220, tank_painc16    ] {}
void() tank_painc16     =[      221, tank_run1       ] {}


void(entity attacker, float damage)	tank_pain =
{
	if (self.health < self.max_health /2)
		if(self.classname == "monster_tank")
			self.skin = 1;
		else
			self.skin = 3;
	
	if (self.health <= 0)
		return;		// allready dying, don't go into pain frame

	if (self.pain_finished > time)
		return;
	
	if(damage <= 10) return;
	
	if (damage <= 30)
		if(random() < 0.2)
			return;		// didn't flinch

	if (skill >= 2)
	{
		if ( (self.frame >= 115) && (self.frame <= 144) )
			return;
		if ( (self.frame >= 55) && (self.frame <= 70) )
			return;
	}	

	self.pain_finished = time + 3;
	sound (self, CHAN_VOICE, "tank/tnkpain2.wav", 1, ATTN_NORM);

	if(skill == 3) return;
		
	if(damage <= 30)
		tank_pain1 ();
	else if(damage <= 60)
		tank_painb1 ();
	else
		tank_painc1 ();
};

void() tank_attack = 
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		r = random();
	
	targ = self.enemy;
	
	// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;


	if (vlen(spot1 - spot2) <= 150)
	{
		if (r < 0.2)
			tank_magicb1();
		else
			tank_magicd1();
	}
	else	if (vlen(spot1 - spot2) <= 250)
	{
		if (r < 0.5)
			tank_magicb1();
		else
			tank_magic1();
	}
	else 
	{
		if (r < 0.33)
			tank_magicb1();
		else if (r < 0.66)
		{
			tank_magicc1();
			self.pain_finished = time + 5;	// no pain for a while
		}
		else
			tank_magic1();
	}
};

//============================================================================

void() tank_death1      =[      222,       tank_death2     ] {}
void() tank_death2      =[      223,       tank_death3     ] {ai_charge(4);}
void() tank_death3      =[      224,       tank_death4     ] {ai_charge(7);}
void() tank_death4      =[      225,       tank_death5     ] {ai_charge(10);}
void() tank_death5      =[      226,       tank_death6     ] {ai_charge(2);}
void() tank_death6      =[      227,       tank_death7     ] {}
void() tank_death7      =[      228,       tank_death8     ] {}
void() tank_death8      =[      229,       tank_death9     ] {ai_charge(4);}
void() tank_death9      =[      230,       tank_death10    ] {ai_charge(2);}
void() tank_death10     =[      231,       tank_death11    ] {}
void() tank_death11     =[      232,       tank_death12    ] {}
void() tank_death12     =[      234,       tank_death13    ] {}
void() tank_death13     =[      235,       tank_death14    ] {}
void() tank_death14     =[      236,       tank_death15    ] {sound (self, CHAN_BODY, "tank/tnkdeth2.wav", 1, ATTN_NORM); self.maxs_z = -8; self.solid = SOLID_CORPSE;}
void() tank_death15     =[      237,       tank_death16    ] {}
void() tank_death16     =[      238,       tank_death17    ] {}
void() tank_death17     =[      239,       tank_death18    ] {}
void() tank_death18     =[      240,       tank_death19    ] {}
void() tank_death19     =[      241,       tank_death20    ] {}
void() tank_death20     =[      242,      tank_death21     ] {}
void() tank_death21     =[      243,      tank_death22     ] {}

void() tank_death22	=[	self.frame, tank_death22     ]
{
	self.frame ++;
	if(self.frame == 250)
		self.nextthink = -1;
}



void() tank_die =
{
// check for gib
	if (self.health < -200)
	{
		self.skin = 0;
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		MonsterGib (4, 4, 1, 1, 0, 1, self.health);
		return;
	}

// regular death
	if((self.deadflag & DEAD_DEAD))
		return;

	if(self.classname == "monster_tank")
			self.skin = 1;
		else
			self.skin = 3;

	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_YES;

	self.deadflag = DEAD_DEAD;

	sound (self, CHAN_VOICE, "tank/death.wav", 1, ATTN_NORM);
	tank_death1 ();
};

//============================================================================


void() spawn_tank;

/*QUAKED monster_tank (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/
void() monster_tank =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
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
	precache_sound ("tank/tnkatk2e.wav");

	spawn_tank();
};

void() spawn_tank = 
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/tank.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 750;
	self.max_health = 750;
	self.mass = 500;
	self.skin = 0;
	self.scale = 1.4;
	self.th_spawn = spawn_tank;

	self.th_stand = tank_stand1;
	self.th_walk = tank_walk1;
	self.th_run = tank_run1;
	self.th_die = tank_die;
	self.th_melee = tank_magicd1;
	self.th_missile = tank_attack;
	self.th_pain = tank_pain;

	walkmonster_start();
}
