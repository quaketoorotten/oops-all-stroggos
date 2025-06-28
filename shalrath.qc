/*
==============================================================================

SHAL-RATH

==============================================================================
*/
$cd id1/models/shalrath
$origin 0 0 24
$base base
$skin skin
$scale 0.7


void() ShalMissile;

void()	shal_stand1	= [	121,		shal_stand2	] {ai_stand();}
void()	shal_stand2	= [	self.frame,	shal_stand2	] 
{
	self.frame ++;

	ai_stand();

	if(self.frame == 180)
		shal_stand1();

	if (random() < 0.2 && self.frame == 179)
		sound (self, CHAN_VOICE, "chick/chkidle2.wav", 1, ATTN_IDLE);
};

void() shal_walk1     =[      191,       shal_walk2    ] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "chick/chkidle1.wav", 1, ATTN_IDLE);
ai_walk(6);};
void() shal_walk2     =[      192,       shal_walk3    ] {ai_walk(8);};
void() shal_walk3     =[      193,       shal_walk4    ] {ai_walk(13);};
void() shal_walk4     =[      194,       shal_walk5    ] {ai_walk(5);};
void() shal_walk5     =[      195,       shal_walk6    ] {ai_walk(7);};
void() shal_walk6     =[      196,       shal_walk7    ] {ai_walk(4);};
void() shal_walk7     =[      197,       shal_walk8    ] {ai_walk(11);};
void() shal_walk8     =[      198,       shal_walk9    ] {ai_walk(5);};
void() shal_walk9     =[      199,       shal_walk10   ] {ai_walk(9);};
void() shal_walk10    =[      200,       shal_walk1    ] {ai_walk(7);};

void() shal_run1     =[      191,       shal_run2    ] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "chick/chksrch1.wav", 1, ATTN_IDLE);
ai_run(6);};
void() shal_run2     =[      192,       shal_run3    ] {ai_run(8);};
void() shal_run3     =[      193,       shal_run4    ] {ai_run(13);};
void() shal_run4     =[      194,       shal_run5    ] {ai_run(5);};
void() shal_run5     =[      195,       shal_run6    ] {ai_run(7);};
void() shal_run6     =[      196,       shal_run7    ] {ai_run(4);};
void() shal_run7     =[      197,       shal_run8    ] {ai_run(11);};
void() shal_run8     =[      198,       shal_run9    ] {ai_run(5);};
void() shal_run9     =[      199,       shal_run10   ] {ai_run(9);};
void() shal_run10    =[      200,       shal_run1    ] {ai_run(7);};

void() shal_attack1     =[      0,       shal_attack2    ] {
sound (self, CHAN_VOICE, "chick/chkatck1.wav", 1, ATTN_NORM);
ai_face();
};
void() shal_attack2     =[      1,       shal_attack3     ] {ai_face();};
void() shal_attack3     =[      2,       shal_attack4     ] {ai_face();};
void() shal_attack4     =[      3,       shal_attack5     ] {ai_charge(4);};
void() shal_attack5     =[      4,       shal_attack6     ] {ai_face();};
void() shal_attack6     =[      5,       shal_attack7     ] {ai_charge(-3);};
void() shal_attack7     =[      6,       shal_attack8     ] {ai_charge(3);};
void() shal_attack8     =[      7,       shal_attack9     ] {ai_charge(5);};
void() shal_attack9     =[      8,       shal_attack10    ] {ai_charge(7);};
void() shal_attack10    =[      9,       shal_attack11    ] {ai_face();};
void() shal_attack11    =[      10,      shal_attack12    ] {ai_face();};
void() shal_attack12    =[      11,       shal_attack13   ] {ai_face();};
void() shal_attack13    =[      12,       shal_attack14   ] {ai_face();};
void() shal_attack14    =[      13,       shal_attack15   ] {ai_charge(14); ShalMissile(); };
void() shal_attack15    =[      14,       shal_attack16   ] {ai_charge(-6);};
void() shal_attack16    =[      15,       shal_attack17   ] {ai_charge(-5);};
void() shal_attack17    =[      16,       shal_attack18   ] {ai_charge(-2);};
void() shal_attack18    =[      17,       shal_attack19   ] {ai_charge(-7);};
void() shal_attack19    =[      18,       shal_attack20   ] {ai_face();};
void() shal_attack20    =[      19,       shal_attack21   ] {ai_charge(1);};
void() shal_attack21    =[      20,       shal_attack22   ] {ai_charge(10); sound (self, CHAN_VOICE, "chick/chkatck5.wav", 1, ATTN_NORM);};
void() shal_attack22    =[      21,       shal_attack23   ] {ai_charge(4);};
void() shal_attack23    =[      22,       shal_attack24   ] {ai_charge(5);};
void() shal_attack24    =[      23,       shal_attack25   ] {ai_charge(6);};
void() shal_attack25    =[      24,       shal_attack26   ] {ai_charge(6);};
void() shal_attack26    =[      25,       shal_attack27   ] {ai_charge(4);};
void() shal_attack27    =[      26,       shal_attack28   ] {ai_charge(3);};
void() shal_attack28    =[      27,       shal_attack29   ] 
{
	ai_charge(-3); 
	if(random() <= 0.6) 
		SUB_CheckRefire (shal_attack14); 
};
void() shal_attack29    =[      28,       shal_attack30   ] {ai_face();};
void() shal_attack30    =[      29,       shal_attack31   ] {ai_charge(-6);};
void() shal_attack31    =[      30,       shal_attack32   ] {ai_charge(-4);};
void() shal_attack32    =[      31,       shal_run1       ] {ai_charge(-2);};

void(float side) ShalClaw =
{
local vector	delta;
local float 	ldmg;
	
	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 80)
		return;
		
	ldmg = 10 + (random()*10) % 6;
	T_Damage (self.enemy, self, self, ceil(ldmg), 50);
	sound (self, CHAN_VOICE, "chick/chkatck4.wav", 1, ATTN_NORM);

	if (side)
	{
		makevectors (self.angles);
		SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};

void() shal_swingl4 =[      35,      shal_swingl5   ] {ai_charge(1); sound (self, CHAN_WEAPON, "chick/chkatck3.wav", 1, ATTN_NORM);}
void() shal_swingl5 =[      36,      shal_swingl6   ] {ai_charge(7); ShalClaw(250);}
void() shal_swingl6 =[      37,      shal_swingl7   ] {ai_charge(-7);}
void() shal_swingl7 =[      38,      shal_swingl8   ] {ai_charge(1); ShalClaw(-250);}
void() shal_swingl8 =[      39,      shal_swingl9   ] {ai_charge(-1);}
void() shal_swingl9 =[      40,      shal_swingl10  ] {ai_charge(1);}
void() shal_swingl10=[      41,      shal_swingl11  ] {ai_face();}
void() shal_swingl11=[      42,      shal_swingl12  ] {ai_charge(1);}
void() shal_swingl12=[      43,      shal_swingr1   ] {ai_charge(-2); if(random() < 0.9) SUB_CheckRefire(shal_swingl4); }
void() shal_swingr1 =[      44,      shal_swingr3   ] {ai_charge(-6);}
void() shal_swingr3 =[      45,      shal_swingr4   ] {ai_charge(-1);}
void() shal_swingr4 =[      46,      shal_swingr5   ] {ai_charge(-6);}
void() shal_swingr5 =[      47,      shal_run1      ] {ai_face();}

void() shal_melee =
{
	shal_swingl4 ();
};

void() shal_death1      =[      48,        shal_death2     ] {};
void() shal_death2      =[      49,        shal_death3     ] {ai_back(7);};
void() shal_death3      =[      50,        shal_death4     ] {ai_forward(4);};
void() shal_death4      =[      51,        shal_death5     ] {ai_forward(11);};
void() shal_death5      =[      52,        shal_death6     ] {};
void() shal_death6      =[      53,        shal_death7     ] {};
void() shal_death7      =[      54,        shal_death8     ] {};
void() shal_death8      =[      55,        shal_death9     ] {};
void() shal_death9      =[      56,        shal_death10    ] {};
void() shal_death10     =[      57,        shal_death11    ] {self.maxs_z = -8; self.solid = SOLID_CORPSE;};
void() shal_death11     =[      58,        shal_death12    ] {};
void() shal_death12     =[      59,        shal_death12    ] {};

void() shal_deathb1      =[      60,        shal_deathb2     ] {ai_back(6);};
void() shal_deathb2      =[      61,        shal_deathb3     ] {};
void() shal_deathb3      =[      62,        shal_deathb4     ] {ai_back(1);};
void() shal_deathb4      =[      63,        shal_deathb5     ] {ai_back(5);};
void() shal_deathb5      =[      64,        shal_deathb6     ] {};
void() shal_deathb6      =[      65,        shal_deathb7     ] {ai_back(1);};
void() shal_deathb7      =[      66,        shal_deathb8     ] {ai_back(2);};
void() shal_deathb8      =[      67,        shal_deathb9     ] {ai_forward(1);};
void() shal_deathb9      =[      68,        shal_deathb10    ] {ai_forward(10);};
void() shal_deathb10     =[      69,        shal_deathb11    ] {ai_forward(2);};
void() shal_deathb11     =[      70,        shal_deathb12    ] {ai_forward(3);};
void() shal_deathb12     =[      71,        shal_deathb13    ] {ai_forward(1);};
void() shal_deathb13     =[      72,        shal_deathb14    ] {ai_forward(2);};
void() shal_deathb14     =[      73,        shal_deathb15    ] {};
void() shal_deathb15     =[      74,        shal_deathb16    ] {ai_forward(3);};
void() shal_deathb16     =[      75,        shal_deathb17    ] {ai_forward(3);};
void() shal_deathb17     =[      76,        shal_deathb18    ] {ai_forward(1);};
void() shal_deathb18     =[      77,        shal_deathb19    ] {ai_back(3);};
void() shal_deathb19     =[      78,        shal_deathb20    ] {ai_back(5);};
void() shal_deathb20     =[      79,        shal_deathb21    ] {ai_forward(4);self.maxs_z = 16; self.solid = SOLID_CORPSE;};
void() shal_deathb21     =[      80,        shal_deathb22    ] {ai_forward(15);};
void() shal_deathb22     =[      81,        shal_deathb23    ] {ai_forward(14);};
void() shal_deathb23     =[      82,        shal_deathb23    ] {};

void() shal_pain1       =[      90, shal_pain2      ] {};
void() shal_pain2       =[      91, shal_pain3      ] {};
void() shal_pain3       =[      92, shal_pain4      ] {};
void() shal_pain4       =[      93, shal_pain5      ] {};
void() shal_pain5       =[      94, shal_run1       ] {};

void() shal_painc1       =[      95, shal_painc2      ] {};
void() shal_painc2       =[      96, shal_painc3      ] {};
void() shal_painc3       =[      97, shal_painc4      ] {};
void() shal_painc4       =[      98, shal_painc5      ] {};
void() shal_painc5       =[      99, shal_run1        ] {};

void() shal_painb1       =[      100, shal_painb2      ] {};
void() shal_painb2       =[      101, shal_painb3      ] {};
void() shal_painb3       =[      102, shal_painb4      ] {ai_back(6);};
void() shal_painb4       =[      103, shal_painb5      ] {ai_forward(3);};
void() shal_painb5       =[      104, shal_painb6      ] {ai_forward(11);};
void() shal_painb6       =[      105, shal_painb7      ] {ai_forward(3);};
void() shal_painb7       =[      106, shal_painb8      ] {};
void() shal_painb8       =[      107, shal_painb9      ] {};
void() shal_painb9       =[      108, shal_painb10     ] {ai_forward(4);};
void() shal_painb10      =[      109, shal_painb11     ] {ai_forward(1);};
void() shal_painb11      =[      110, shal_painb12     ] {};
void() shal_painb12      =[      111, shal_painb14     ] {ai_back(3);};
void() shal_painb14      =[      112, shal_painb15     ] {ai_back(4);};
void() shal_painb15      =[      113, shal_painb16     ] {ai_forward(5);};
void() shal_painb16      =[      114, shal_painb17     ] {ai_forward(7);};
void() shal_painb17      =[      115, shal_painb18     ] {ai_back(2);};
void() shal_painb18      =[      116, shal_painb19     ] {ai_forward(3);};
void() shal_painb19      =[      117, shal_painb20     ] {ai_back(5);};
void() shal_painb20      =[      118, shal_painb21     ] {ai_back(2);};
void() shal_painb21      =[      119, shal_painb22     ] {ai_back(8);};
void() shal_painb22      =[      200, shal_run1	       ] {ai_forward(2);};


void(entity attacker, float damage) shalrath_pain =
{
	local float	r;

	if (self.health < (self.max_health / 2))
		self.skin = 1;

	if (time < self.pain_finished)
		return;

	self.pain_finished = time + 3;

	r = random();
	if (r < 0.33)
		sound (self, CHAN_VOICE, "chick/chkpain1.wav", 1, ATTN_NORM);
	else if (r < 0.66)
		sound (self, CHAN_VOICE, "chick/chkpain2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "chick/chkpain3.wav", 1, ATTN_NORM);

	if (skill == 3)
		return;		// no pain anims in nightmare
	
	if (self.dcnt)
		return;	

	if (damage <= 10)
		shal_pain1();
	else if (damage <= 25)
		shal_painc1();
	else
		shal_painb1();
};

void() shalrath_die =
{
	if(self.dcnt)
	{
		self.maxs_z += 32;
		self.dcnt = 0;
		self.flags = self.flags - (self.flags & FL_DODGED);
	}

	// check for gib
	if (self.health < -70)
	{
		self.skin = 0;
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		MonsterGib (4, 0, 1, 0, 2, 0, self.health);
		return;
	}
	if((self.deadflag & DEAD_DEAD))
		return;

	self.deadflag = DEAD_DEAD;
	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_YES;

	local float n = random()*10 % 2;
	if (n == 0)
	{
		shal_death1 ();
		sound (self, CHAN_VOICE, "chick/chkdeth1.wav", 1, ATTN_NORM);
	}
	else
	{
		shal_deathb1 ();
		sound (self, CHAN_VOICE, "chick/chkdeth2.wav", 1, ATTN_NORM);
	}
};

void()	shal_duckdown1	=[	83,	shal_duckdown2	] 
{
	self.dcnt = 1; 
	self.nextthink = self.dspeed; 
	self.maxs_z -= 32; 
	ai_face();
};
void()	shal_duckdown2	=[	84,	shal_duckhold	] {ai_face(); self.dodge_finished = time + 0.25 + 2*random();};

void()	shal_duckup1	=[	87,	shal_duckup2	] 
{self.dodge_finished = time + 1 + random()*2; self.takedamage = DAMAGE_AIM; self.flags = self.flags - (self.flags & FL_DODGED); self.dcnt = 0; self.maxs_z += 32;};
void()	shal_duckup2	=[	88,	shal_duckup3	] {};
void()	shal_duckup3	=[	89,	shal_run1	] {};

void()	shal_duckhold =[	85,	shal_duckhold 	]	
{
	if(time > self.dodge_finished)
		self.think = shal_duckup1;
};
/*
================
ShalMissile
================
*/

void() ShalMissileTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	T_RadiusDamage (self, self.owner, 70, world);
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() ShalMissile =
{
	ai_face();
	local	vector	org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	
	makevectors (self.angles);

	org = self.origin + '0 0 40' + v_forward * 20 + v_right * -16;

	sound(self, CHAN_WEAPON, "chick/chkatck2.wav", 1, ATTN_NORM);
	
	LaunchLaser(org, self.enemy.origin - org + self.enemy.view_ofs);
	setmodel (newmis, "progs/missile.mdl");
	setsize (newmis, '0 0 0', '0 0 0');	
	newmis.modelflags = MF_MISSILE;
	newmis.touch = ShalMissileTouch;
	newmis.velocity = newmis.velocity * 0.8;
};

//=================================================================

/*QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) Ambush
*/
void() spawn_chick;
void() spawn_commander;
void() monster_chick =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
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
	
	spawn_chick();
};

void() monster_commander =
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

	spawn_commander();
};

void() spawn_commander = 
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/tank.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 1000;
	self.max_health = 1000;
	self.mass = 500;
	self.skin = 2;
	self.scale = 1.4;
	self.th_spawn = spawn_commander;

	self.th_stand = tank_stand1;
	self.th_walk = tank_walk1;
	self.th_run = tank_run1;
	self.th_die = tank_die;
	self.th_melee = tank_magicd1;
	self.th_missile = tank_attack;
	self.th_pain = tank_pain;

	walkmonster_start();
}

void() spawn_chick =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/bitch.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	self.health = 175;
	self.max_health = 175; 
	self.mass = 200;

	self.th_stand = shal_stand1;
	self.th_walk = shal_walk1;
	self.th_run = shal_run1;
	self.th_die = shalrath_die;
	self.th_pain = shalrath_pain;
	self.th_missile = shal_attack1;
	self.th_spawn = spawn_chick;
	self.th_melee = shal_melee;
	self.th_dodge = shal_duckdown1;

	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random ()*0.1;	
}

void() monster_shalrath =
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
	
	self.th_checkatck = ShamCheckAttack;
	if(self.classname == "monster_commander")
	{
		monster_commander();
		return;
	}
	else if(self.classname == "monster_gladiator")
	{
		monster_gladiator();
		return;
	}
	
	local float r = random();
	
	if(r <= 0.7)
	{
		self.classname = "monster_gladiator";
		monster_gladiator();
		return;
	}
	else
	{
		self.classname = "monster_commander";
		monster_commander();
		return;
	}
};
