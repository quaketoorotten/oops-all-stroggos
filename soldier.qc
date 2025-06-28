/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

$cd id1/models/soldier3
$origin 0 -6 24
$base base		
$skin skin

/*
==============================================================================
SOLDIER CODE
==============================================================================
*/

float MF_SOLDIER_BLSTR_1	=	1;
float MF_SOLDIER_BLSTR_2	=	2;

vector m_soldier_flashoffset[] = // q2 port i guess idk
{
	'10.6 7.7 7.8',
	'21.1 3.6 19.0',
};

/*
===========
SoldierCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() SoldierCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
		return FALSE;	// don't have a clear shot
			
	
// missile attack
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_CLOSE)
		chance = 0.7;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.4;
	else if (enemy_range == RANGE_MID)
		chance = 0.05;
	else
		chance = 0;

	if (random () < chance)
	{
		self.th_missile ();
		SUB_AttackFinished (1.2 + random()*2);
		if (random() < 0.3)
			self.lefty = !self.lefty;

		return TRUE;
	}

	return FALSE;
};

void() army_fireShotgun =
{
	makevectors (self.angles);
	sound (self, CHAN_WEAPON, "soldier/solatck1.wav", 1, ATTN_NORM);	
	
	local entity en = self.enemy;
	local vector dir, org;
	local float flashnum;
	org = ProjectAim(self.origin, m_soldier_flashoffset[flashnum]*1.2, v_forward, v_right);
	
	if(self.frame == 293 || self.frame == 296)
	{
		flashnum = MF_SOLDIER_BLSTR_2;
		dir = (v_forward);
	}
	else
	{
		flashnum = MF_SOLDIER_BLSTR_1;
		dir = en.origin - en.velocity*0.2;
		dir = normalize (dir - org);
	}

	monster_FireBullets (12, org, dir, '0.1 0.1 0', 1, 2);
};

void() army_fireAuto =
{
	makevectors (self.angles);
	sound (self, CHAN_WEAPON, "soldier/solatck3.wav", 1, ATTN_NORM);	

	local entity en = self.enemy;
	local vector dir, org;

	local float flashnum;
	org = ProjectAim(self.origin, m_soldier_flashoffset[flashnum]*1.2, v_forward, v_right);
	
	if(self.frame == 293 || self.frame == 296)
	{
		flashnum = MF_SOLDIER_BLSTR_2;
		dir = (v_forward);
	}
	else
	{
		flashnum = MF_SOLDIER_BLSTR_1;
		dir = en.origin - en.velocity*0.2;
		dir = normalize (dir - org);
	}

	monster_FireBullets (1, org, dir, '0.01 0.01 0', 2, 4);
};

void() army_fireLight =
{
	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);	
		
	local entity en = self.enemy;
	local vector dir;

	local float flashnum;
	org = ProjectAim(self.origin, m_soldier_flashoffset[flashnum]*1.2, v_forward, v_right);
	
	if(self.frame == 293 || self.frame == 296)
	{
		flashnum = MF_SOLDIER_BLSTR_2;
		dir = (v_forward);
	}
	else
	{
		flashnum = MF_SOLDIER_BLSTR_1;
		dir = en.origin - en.velocity*0.2;
		dir = normalize (dir - org);
	}
	
	sound (self, CHAN_WEAPON, "soldier/solatck2.wav", 1, ATTN_NORM);		
	LaunchLaser(org, dir);
};

void() army_fire =
{
	  switch(self.classname)
   	  {
   		case "monster_ss":
    			army_fireAuto ();
     			break;

   		case "monster_dog":
     			army_fireLight ();	
			break;

   		default:
     			army_fireShotgun ();
     			break;
   	  } 
};

/*
==============================================================================
*/

void()	army_stand1	= [	self.frame,	army_stand1	] 
{
	if(self.frame < 146)
		self.frame = 146;

	self.frame ++;
	if(self.frame > 175)
		self.frame = 146;
	
	if(self.frame == 147)
		if (random() < 0.2)
			sound (self, CHAN_VOICE, "soldier/solidle1.wav", 1, ATTN_IDLE);

	ai_stand();
};

void()	army_walk1	=[	256,	army_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/solidle1.wav", 1, ATTN_IDLE);
ai_walk(4);};
void()	army_walk2	=[	257,	army_walk3	] {ai_walk(4);};
void()	army_walk3	=[	258,	army_walk4	] {ai_walk(9);};
void()	army_walk4	=[	259,	army_walk5	] {ai_walk(8);};
void()	army_walk5	=[	260,	army_walk6	] {ai_walk(5);};
void()	army_walk6	=[	261,	army_walk7	] {ai_walk(1);};
void()	army_walk7	=[	262,	army_walk8	] {ai_walk(3);};
void()	army_walk8	=[	263,	army_walk9	] {ai_walk(7);};
void()	army_walk9	=[	264,	army_walk10	] {ai_walk(6);};
void()	army_walk10	=[	265,	army_walk1	] {ai_walk(7);};


void()	army_run1	=[	99,		army_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/solsrch1.wav", 1, ATTN_IDLE);
CheckForCharge (3);
ai_run(10);};
void()	army_run2	=[	100,		army_run3	] {ai_run(11);};
void()	army_run3	=[	101,		army_run4	] {ai_run(11);};
void()	army_run4	=[	102,		army_run5	] {ai_run(16);};
void()	army_run5	=[	103,		army_run6	] {ai_run(10);};
void()	army_run6	=[	104,		army_run1	] {ai_run(15);};

/*
==============================================================================
*/

void()	army_char1	=[	109,		army_char2	] {  // LG/SG/SS soldiers attack code
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/solsght1.wav", 1, ATTN_IDLE);
ai_charge(11);};

void()	army_char4;

void()	army_char2	=[	110,		army_char3	] {	ai_charge(10); };

void()	army_char3	=[	111,		self.think	] 
{
	ai_charge(2); 
	army_fire(); 
	self.effects = self.effects | EF_MUZZLEFLASH; 

	if(self.classname == "monster_army" || self.classname == "monster_dog")
	{
		self.think = army_char4;
		return;
	}
	else
		self.think = army_char3;
	
	if(self.attack_finished < time)
	{
		self.think = army_char4;
		return;
	}
}
void()	army_char4	=[	112,		army_char5	] {ai_charge(10);};
void()	army_char5	=[	113,		army_char6	] {ai_charge(8); };
void()	army_char6	=[	114,		army_char7	] {ai_charge(11); };
void()	army_char7	=[	115,		army_char8	] {ai_charge(15);};
void()	army_char8	=[	116,		army_char9	] {ai_charge(10);};
void()	army_char9	=[	117,		army_char10 ] {ai_charge(10);};
void()	army_char10	=[	118,		army_char11 ] {ai_charge(8); };
void()	army_char11	=[	119,		army_char12 ] {ai_charge(11);};
void()	army_char12	=[	120,		army_char13 ] {ai_charge(15);};
void()	army_char13	=[	121,		army_char14 ] {ai_charge(10);};
void()	army_char14	=[	122,		army_run1	] {ai_charge(10);};

void() army_atkb1;

void()	army_atk1	=[	0,	army_atk2	] {ai_face();}; // LG/SG soldiers attack code
void()	army_atk2	=[	1,	army_atk3	] {ai_face();};
void()	army_atk3	=[	2,	army_atk4	] {ai_face(); 
army_fire(); 
self.effects = self.effects | EF_MUZZLEFLASH; };
void()	army_atk4	=[	3,	army_atk5	] {ai_face();};
void()	army_atk5	=[	4,	army_atk6	] {ai_face();};
void()	army_atk6	=[	5,	army_atk7	] {ai_face(); SUB_CheckRefire (army_atkb1);};
void()	army_atk7	=[	6,	army_atk8	] {ai_face();};
void()	army_atk8	=[	7,	army_atk9	] {ai_face();};
void()	army_atk9	=[	8,	army_atk10	] {ai_face(); SUB_CheckRefire (army_atk1);};
void()	army_atk10	=[	9,	army_run1	] {ai_face();};

void()	army_atkb1	=[	10,	army_atkb2	] {ai_face();}; // LG/SG soldiers attack code
void()	army_atkb2	=[	11,	army_atkb3	] {ai_face();};
void()	army_atkb3	=[	12,	army_atkb4	] {ai_face();};
void()	army_atkb4	=[	13,	army_atkb5	] {ai_face();
army_fire();
 self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_atkb5	=[	14,	army_atkb6	] {ai_face();};
void()	army_atkb6	=[	15,	army_atkb7	] {ai_face();};
void()	army_atkb7	=[	16,	army_atkb8	] {ai_face(); SUB_CheckRefire (army_atkb1);};
void()	army_atkb8	=[	17,	army_atkb9	] {ai_face();};
void()	army_atkb9	=[	18,	army_atkb10	] {ai_face();};
void()	army_atkb10	=[	19,	army_atkb11	] {ai_face();};
void()	army_atkb11	=[	20,	army_atkb12	] {ai_face();};
void()	army_atkb12	=[	21,	army_atkb13	] {ai_face();};
void()	army_atkb13	=[	22,	army_atkb14	] {ai_face();};
void()	army_atkb14	=[	23,	army_atkb15	] {ai_face();};
void()	army_atkb15	=[	24,	army_atkb16	] {ai_face(); SUB_CheckRefire (army_atkb1);};
void()	army_atkb16	=[	25,	army_atkb17	] {ai_face();};
void()	army_atkb17	=[	26,	army_run1   ] {ai_face();};

void()	army_atkc1	=[	39,	army_atkc2	] {ai_face();}; // SS soldiers attack code
void()	army_atkc2	=[	40,	army_atkc3	] {ai_face();};
void()	army_atkc3	=[	41,	army_atkc4	] {ai_face(); SUB_AttackFinished((3 + random()*10 % 8));};

void() army_atkc5;

void()	army_atkc4	=[	self.frame,	army_atkc4	] 
{
	if(self.attack_finished < time)
	{
		army_atkc5 ();
		return;
	}

	ai_face(); 
	army_fire(); 

	self.effects = self.effects | EF_MUZZLEFLASH;

	self.frame ++; 
	if(self.frame > 42)
		self.frame = 41;
};

void()	army_atkc5	=[	43,	army_run1	] {ai_face(); };

void() 	army_atkrnd =
{
	if(random() < 0.5)
		army_atk1();
	else
		army_atkb1();
	return;
}

/*
==============================================================================
*/

void()	army_pain1	=[	55,		army_pain2	] {ai_pain(12);};
void()	army_pain2	=[	56,		army_pain3	] {ai_pain(1);};
void()	army_pain3	=[	57,		army_pain4	] {ai_painforward(2);};
void()	army_pain4	=[	58,		army_pain5	] {ai_painforward(4);};
void()	army_pain5	=[	59,		army_pain6	] {ai_painforward(2);};
void()	army_pain6	=[	60,		army_run1	] {ai_painforward(3);};

void()	army_painb1	=[	62,	army_painb2	] {ai_pain(2);};
void()	army_painb2	=[	63,	army_painb3	] {ai_pain(13);};
void()	army_painb3	=[	64,	army_painb4	] {ai_pain(9);};
void()	army_painb4	=[	65,	army_painb5	] {ai_pain(2);};
void()	army_painb5	=[	66,	army_painb6	] {};
void()	army_painb6	=[	67,	army_painb7	] {};
void()	army_painb7	=[	68,	army_painb8	] {};
void()	army_painb8	=[	69,	army_painb9	] {};
void()	army_painb9	=[	70,	army_painb10] {};
void()	army_painb10=[	71,	army_painb11] {};
void()	army_painb11=[	72,	army_painb12] {};
void()	army_painb12=[	73,	army_painb13] {ai_pain(2);};
void()	army_painb13=[	74,	army_painb14] {};
void()	army_painb14=[	75,	army_painb15] {};
void()	army_painb15=[	76,	army_painb16] {ai_painforward(3);};
void()	army_painb16=[	77,	army_painb17] {ai_painforward(9);};
void()	army_painb17=[	78,	army_run1	] {ai_painforward(13);};

void()	army_painc1	=[	50,	army_painc2	] {ai_pain(3);};
void()	army_painc2	=[	51,	army_painc3	] {ai_painforward(4);};
void()	army_painc3	=[	52,	army_painc4	] {ai_pain(1);};
void()	army_painc4	=[	53,	army_run1	] {ai_pain(1);};

void()	army_paind1	=[	80,	army_paind2	] {};
void()	army_paind2	=[	81,	army_paind3	] {};
void()	army_paind3 =[	82,	army_paind4	] {};
void()	army_paind4	=[	83,	army_paind5	] {ai_pain(10);};
void()	army_paind5	=[	84,	army_paind6	] {ai_pain(6);};
void()	army_paind6	=[	85,	army_paind7	] {ai_painforward(8);};
void()	army_paind7	=[	86,	army_paind8	] {ai_painforward(4);};
void()	army_paind8	=[	87,	army_paind9	] {ai_painforward(1);};
void()	army_paind9	=[	88,	army_paind10] {};
void()	army_paind10=[	89,	army_paind11] {ai_painforward(2);};
void()	army_paind11=[	90,	army_paind12] {ai_painforward(5);};
void()	army_paind12=[	91,	army_paind13] {ai_painforward(2);};
void()	army_paind13=[	92,	army_paind14] {ai_pain(1);};
void()	army_paind14=[	93,	army_paind15] {ai_pain(1);};
void()	army_paind15=[	94,	army_paind16] {ai_painforward(3);};
void()	army_paind16=[	95,	army_paind17] {ai_painforward(2);};
void()	army_paind17=[	96,	army_run1	] {};


void(entity attacker, float damage)	army_pain =
{
	local float r;
	
	if (self.health < self.max_health /2)
	{
		switch(self.classname)
   	  	{
		case "monster_ss":
    			self.skin = 5;
     			break;

   		case "monster_dog":
     			self.skin = 1;	
			break;

   		default:
     			self.skin = 3;
     			break;
		}
	}
	
	if (time < self.pain_finished)
		return;
	
	self.pain_finished = time + 3;

	r = random();

	  switch(self.classname)
   	  {
   		case "monster_ss":
    			sound (self, CHAN_VOICE, "soldier/solpain3.wav", 1, ATTN_NORM);
     			break;

   		case "monster_dog":
     			sound (self, CHAN_VOICE, "soldier/solpain2.wav", 1, ATTN_NORM);	
			break;

   		default:
     			sound (self, CHAN_VOICE, "soldier/solpain1.wav", 1, ATTN_NORM);
     			break;
   	  } 	
	
	if (self.dcnt)
		return;
	if (skill == 3)
		return;
	
	if (self.velocity[2] > 100)
	{
		army_paind1 ();
		return;
	}

	if (r < 0.33)
		army_pain1 ();
	else if (r < 0.66)
		army_painb1 ();
	else
		army_painc1 ();
};

void()	army_die1	=[	272,	army_die2	] {}
void()	army_die2	=[	273,	army_die3	] {ai_back(10);}
void()	army_die3	=[	274,	army_die4	] {ai_back(10);}
void()	army_die4	=[	275,	army_die5	] {ai_back(10);}
void()	army_die5	=[	276,	army_die6	] {ai_back(5);}
void()	army_die6	=[	277,	army_die7	] {}
void()	army_die7	=[	278,	army_die8	] {}
void()	army_die8	=[	279,	army_die9	] {}
void()	army_die9	=[	280,	army_die10	] {}
void()	army_die10	=[	281,	army_die11	] {}
void()	army_die11	=[	282,	army_die12	] {}
void()	army_die12	=[	283,	army_die13	] {}
void()	army_die13	=[	284,	army_die14	] {}
void()	army_die14	=[	285,	army_die15	] {}
void()	army_die15	=[	286,	army_die16	] {}
void()	army_die16	=[	287,	army_die17	] {}
void()	army_die17	=[	288,	army_die18	] {}
void()	army_die18	=[	289,	army_die19	] {}
void()	army_die19	=[	290,	army_die20	] {}
void()	army_die20	=[	291,	army_die21	] {}
void()	army_die21	=[	292,	army_die22	] {	self.ltime = time + 0.5;}

void()	army_die23;
void()	army_die26;
void()	army_die22	=[	293,	self.think	] 
{makevectors(self.angles);
army_fire();
	if(self.ltime < time)
	{
		self.think = army_die26;
		return;
	}
if(self.classname == "monster_army" || self.classname == "monster_dog")
	{
		self.think = army_die23;
		return;
	}
	else
		self.think = army_die22;
	

}
void()	army_die23	=[	294,	army_die24	] {}
void()	army_die24	=[	295,	army_die25	] {}
void()	army_die25	=[	296,	army_die26	] { makevectors(self.angles);
army_fire(); }
void()	army_die26	=[	297,	army_die27	] {}
void()	army_die27	=[	298,	army_die28	] {}
void()	army_die28	=[	299,	army_die29	] {}
void()	army_die29	=[	300,	army_die30	] {}
void()	army_die30	=[	301,	army_die31	] {self.solid = SOLID_CORPSE;
		self.maxs_z = -8;}

void()	army_die31	=[	302,	army_die32	] {}
void()	army_die32	=[	303,	army_die33	] {}
void()	army_die33	=[	304,	army_die34	] {}
void()	army_die34	=[	305,	army_die35	] {}
void()	army_die35	=[	306,	army_die35	] {}
void()	army_die36	=[	307,	army_die36	] {}

void()	army_bdie1	=[	308,	army_bdie2	] {ai_back(5);};
void()	army_bdie2	=[	309,	army_bdie3	] {ai_back(5);};
void()	army_bdie3	=[	310,	army_bdie4	] {ai_back(5);};
void()	army_bdie4	=[	311,	army_bdie5	] {};

void() army_bdie5	= [ self.frame,	army_bdie5	] 
{
	if(self.frame < 312)
		self.frame = 312;

	if(self.frame == 338)
	{
		self.solid = SOLID_CORPSE;
		self.maxs_z = -8;
	}

	if(self.frame == 342)
	{
		self.nextthink = -1;
		return;
	}

	self.frame ++;
};

void() army_ddie1	= [ self.frame,	army_ddie1	] 
{
	if(self.frame < 388)
		self.frame = 388;
	if(self.frame == 436)
	{
		self.solid = SOLID_CORPSE;
		self.maxs_z = -8;
	}
		
	if(self.frame == 440)
	{
		self.nextthink = -1;
		return;
	}

	self.frame ++;
};

void()	army_edie1	=[	343,	army_edie2	] {ai_back(5);};
void()	army_edie2	=[	344,	army_edie3	] {ai_back(5);};
void()	army_edie3	=[	345,	army_edie4	] {ai_back(5);};
void()	army_edie4	=[	346,	army_edie5	] {};

void() army_edie5	= [ self.frame,	army_edie5	] 
{
	if(self.frame < 441)
		self.frame = 441;

	if(self.frame == 456)
	{
		self.solid = SOLID_CORPSE;
		self.maxs_z = -8;
	}

	if(self.frame == 464)
	{
		self.nextthink = -1;
		return;
	}

	self.frame ++;
};

void() army_fdie1	= [ self.frame,	army_fdie1	] 
{
	if(self.frame < 465)
		self.frame = 465;
	if(self.frame == 469)
	{
		self.solid = SOLID_CORPSE;
		self.maxs_z = -8;
	}
		
	if(self.frame == 474)
	{
		self.nextthink = -1;
		return;
	}

	self.frame ++;
};

void() army_die =
{
	if(self.dcnt)
	{
		self.maxs_z += 32;
		self.dcnt = 0;
		self.flags = self.flags - (self.flags & FL_DODGED);
	}
	
// check for gib
	if (self.health < -35)
	{
		self.skin = 0;
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		MonsterGib (3, 0, 1, 1, 0, 0, self.health);
		return;
	}

// regular death
	if((self.deadflag & DEAD_DEAD))
		return;
	
	switch(self.classname)
   	  	{
		case "monster_ss":
    			self.skin = 5;
     			break;

   		case "monster_dog":
     			self.skin = 1;	
			break;

   		default:
     			self.skin = 3;
     			break;
		}

	self.deadflag = DEAD_DEAD;
	  switch(self.classname)
   	  {
   		case "monster_knight":
    			sound (self, CHAN_VOICE, "soldier/soldeth3.wav", 1, ATTN_NORM);
     			break;

   		case "monster_dog":
     			sound (self, CHAN_VOICE, "soldier/soldeth2.wav", 1, ATTN_NORM);	
			break;

   		default:
     			sound (self, CHAN_VOICE, "soldier/soldeth1.wav", 1, ATTN_NORM);
     			break;
   	  } 	

	local float n = floor((random()*10) % 5);
	
	if (n == 0)
		army_die1();
	else if (n == 1)
		army_bdie1();
	else if (n == 2)
		army_ddie1();
	else if (n == 3)
		army_edie1();
	else
		army_fdie1();
};

void()	army_duckdownb1	=[	30,	army_duckdownb2	] 
{
	self.dcnt = 1; 
	self.nextthink = self.dspeed; 
	self.maxs_z -= 32; 
	self.takedamage = DAMAGE_YES;
	ai_face();
};
void()	army_duckdownb2	=[	31,	army_duckdownb3	] {ai_face(); self.dodge_finished = time + 0.8 + 2*random();};
void()	army_duckdownb3	=[	32,	army_duckdownb4	] {ai_face(); SUB_AttackFinished(1 + 2*random()); };

void() army_duckdownb5;

void()	army_duckdownb4	=[	33,		self.think	] 
{
	ai_face(); army_fire(); 
	 self.effects = self.effects | EF_MUZZLEFLASH; 

	if(self.classname == "monster_army" || self.classname == "monster_dog")
	{
		self.think = army_duckdownb5;
		return;
	}
	else
		self.think = army_duckdownb4;
	
	if(self.attack_finished < time)
	{
		self.think = army_duckdownb5;
		return;
	}
};

void()	army_duckdownb5	=[	34,	army_duckdownb6	] {ai_face(); };
void()	army_duckdownb6	=[	35,	army_duckdownb7	] {ai_face(); };
void()	army_duckdownb7	=[	36,	army_duckupb1	] {ai_face(); };

void()	army_duckupb1	=[	37,	army_duckupb2	] 
{self.dodge_finished = time + 1 + random()*2; self.takedamage = DAMAGE_AIM; self.flags = self.flags - (self.flags & FL_DODGED); self.dcnt = 0; self.maxs_z += 32;};
void()	army_duckupb2	=[	38,	army_run1	] {};

void()	army_duckdown1	=[	45,	army_duckdown2	] 
{
	self.dcnt = 1; 
	self.nextthink = self.dspeed; 
	self.maxs_z -= 32; 
	self.takedamage = DAMAGE_YES;
	ai_face();
};
void()	army_duckdown2	=[	46,	army_duckhold	] {ai_face(); self.dodge_finished = time + 0.6 + 2*random();};

void()	army_duckup1	=[	48,	army_duckup2	] 
{self.dodge_finished = time + 1 + random()*2; self.takedamage = DAMAGE_AIM; self.flags = self.flags - (self.flags & FL_DODGED); self.dcnt = 0; self.maxs_z += 32;};
void()	army_duckup2	=[	49,	army_run1	] {};

void()	army_duckhold =[	47,	army_duckhold 	]	
{
	if(time > self.dodge_finished)
		self.think = army_duckup1;
};

void()	army_dodge =
{	
	if (skill == 0)
	{
		army_duckdown1();
		return;
	}

	if (skill == 1)
	{
		if (random() > 0.33)
			army_duckdown1();
		else
			army_duckdownb1();
		return;
	}

	if (skill >= 2)
	{
		if (random() > 0.66)
			army_duckdown1();
		else
			army_duckdownb1();
		return;
	}
}

/*QUAKED monster_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() army_precache = 
{
	precache_model ("progs/soldier.mdl");
	precache_model ("progs/h_guard.mdl");

	precache_sound ("soldier/solatck1.wav");
	precache_sound ("soldier/solatck2.wav");
	precache_sound ("soldier/solatck3.wav");
	precache_sound ("soldier/solidle1.wav");
	precache_sound ("soldier/solpain1.wav");
	precache_sound ("soldier/solpain2.wav");
	precache_sound ("soldier/solpain3.wav");
	precache_sound ("soldier/solsrch1.wav");
	precache_sound ("soldier/solsght1.wav");
	precache_sound ("soldier/soldeth1.wav");
	precache_sound ("soldier/soldeth2.wav");
	precache_sound ("soldier/soldeth3.wav");

	precache_sound ("player/udeath.wav");		// gib death
}

void() generic_army =
{	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/soldier.mdl");

	setsize (self, '-16 -16 -24', '16 16 32');

	self.mass = 100;
//	self.flags += FL_DUCKER;

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	self.th_char = army_char1;
	self.th_dodge = army_dodge; 
	self.th_checkatck = SoldierCheckAttack;
};
void() spawn_army;

void() monster_army =
{	
	if (deathmatch)
	{
		remove(self);
		return;
	}

	army_precache ();
	spawn_army ();
};

void() monster_soldier =
{
	self.classname = "monster_army";
	monster_army ();
}

void() spawn_army =
{
	generic_army ();
	self.health = 30;
	self.max_health = 30;
	self.th_spawn = spawn_army;
	self.skin = 2;

	self.th_melee = army_atkrnd;
	self.th_missile = army_atkrnd;

	walkmonster_start();
};
