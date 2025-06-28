/*
==============================================================================

ZOMBIE

==============================================================================
*/
$cd id1/models/zombie

$origin	0 0 24

$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12
$frame run13 run14 run15 run16 run17 run18

$frame atta1 atta2 atta3 atta4 atta5 atta6 atta7 atta8 atta9 atta10 atta11
$frame atta12 atta13

$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7 attb8 attb9 attb10 attb11
$frame attb12 attb13 attb14

$frame attc1 attc2 attc3 attc4 attc5 attc6 attc7 attc8 attc9 attc10 attc11
$frame attc12

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10
$frame paina11 paina12

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16 painb17 painb18 painb19
$frame painb20 painb21 painb22 painb23 painb24 painb25 painb26 painb27 painb28

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13 painc14 painc15 painc16 painc17 painc18

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15 paine16 paine17 paine18 paine19
$frame paine20 paine21 paine22 paine23 paine24 paine25 paine26 paine27 paine28
$frame paine29 paine30

$frame cruc_1 cruc_2 cruc_3 cruc_4 cruc_5 cruc_6

float	SPAWN_CRUCIFIED	= 1;

//=============================================================================

/*
===========
ZomCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() ZomCheckAttack =
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

	else if (enemy_range == RANGE_CLOSE)
		chance = 0.06;	
	else if (enemy_range == RANGE_NEAR)
		chance = 0.10;
	else if (enemy_range == RANGE_MID)
		return FALSE;
	else if (enemy_range == RANGE_FAR)
		return FALSE;

	if (random () < chance)
	{
		self.th_missile ();
		SUB_AttackFinished (7 + random()*3);
		return TRUE;
	}
	return FALSE;
};


.float inpain;

void() zombie_stand1	= [	self.frame,	zombie_stand1	] 
{
	if(self.frame < 162)
		self.frame = 162;

	self.frame ++;
	if(self.frame > 221)
		self.frame = 162;

	ai_stand();
	
	if (random() < 0.1 && self.frame == 162)
		sound (self, CHAN_VOICE, "brain/brnidle1.wav", 1, ATTN_STATIC);
};

void() zombie_cruc1	=	[	$cruc_1,		zombie_cruc2	] {
if (random() < 0.1)
	sound (self, CHAN_VOICE, "zombie/idle_w2.wav", 1, ATTN_STATIC);};
void() zombie_cruc2	=	[	$cruc_2,		zombie_cruc3	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc3	=	[	$cruc_3,		zombie_cruc4	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc4	=	[	$cruc_4,		zombie_cruc5	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc5	=	[	$cruc_5,		zombie_cruc6	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc6	=	[	$cruc_6,		zombie_cruc1	] {self.nextthink = time + 0.1 + random()*0.1;};

void() zombie_walk1;

void() zombie_walkb1		=[	13,		zombie_walkb2	] {ai_walk(3);};
void() zombie_walkb2		=[	14,		zombie_walkb3	] {ai_walk(-2);};
void() zombie_walkb3		=[	15,		zombie_walkb4	] {ai_walk(-4);};
void() zombie_walkb4		=[	16,		zombie_walkb5	] {ai_walk(-3);};
void() zombie_walkb5		=[	17,		zombie_walkb6	] {ai_walk(0);};
void() zombie_walkb6		=[	18,		zombie_walkb7	] {ai_walk(1); sound (self, CHAN_VOICE, "brain/brnatck1.wav", 1, ATTN_IDLE);};
void() zombie_walkb7		=[	19,		zombie_walkb8	] {ai_walk(12);};
void() zombie_walkb8		=[	20,		zombie_walkb9	] {ai_walk(0);};
void() zombie_walkb9		=[	21,		zombie_walkb10	] {ai_walk(-3);};
void() zombie_walkb10		=[	22,		zombie_walkb11	] {ai_walk(0);};
void() zombie_walkb11		=[	23,		zombie_walkb12	] {ai_walk(-2);};
void() zombie_walkb12		=[	24,		zombie_walkb13	] {ai_walk(0);};
void() zombie_walkb13		=[	25,		zombie_walkb14	] {ai_walk(0);};
void() zombie_walkb14		=[	26,		zombie_walkb15	] {ai_walk(1);};
void() zombie_walkb15		=[	27,		zombie_walkb16	] {ai_walk(0);};
void() zombie_walkb16		=[	28,		zombie_walkb17	] {ai_walk(0);};
void() zombie_walkb17		=[	29,		zombie_walkb18	] {ai_walk(0);};
void() zombie_walkb18		=[	30,		zombie_walkb19	] {ai_walk(0);};
void() zombie_walkb19		=[	31,		zombie_walkb20	] {ai_walk(0);};
void() zombie_walkb20		=[	32,		zombie_walkb21	] {ai_walk(10);};
void() zombie_walkb21		=[	33,		zombie_walkb22	] {ai_walk(-1);};
void() zombie_walkb22		=[	34,		zombie_walkb23	] {ai_walk(7);};
void() zombie_walkb23		=[	35,		zombie_walkb24	] {ai_walk(0);};
void() zombie_walkb24		=[	36,		zombie_walkb25	] {ai_walk(3);};
void() zombie_walkb25		=[	37,		zombie_walkb26	] {ai_walk(-3);};
void() zombie_walkb26		=[	38,		zombie_walkb27	] {ai_walk(2);};
void() zombie_walkb27		=[	39,		zombie_walkb28	] {ai_walk(4);};
void() zombie_walkb28		=[	40,		zombie_walkb29	] {ai_walk(-3);};
void() zombie_walkb29		=[	41,		zombie_walkb30	] {ai_walk(2);};
void() zombie_walkb30		=[	42,		zombie_walkb31	] {ai_walk(0);};
void() zombie_walkb31		=[	43,		zombie_walkb32	] {ai_walk(4);};
void() zombie_walkb32		=[	44,		zombie_walkb33	] {ai_walk(-1);};
void() zombie_walkb33		=[	45,		zombie_walkb34	] {ai_walk(-1);};
void() zombie_walkb34		=[	46,		zombie_walkb35	] {ai_walk(-8);};
void() zombie_walkb35		=[	47,		zombie_walkb36	] {ai_walk(0); sound (self, CHAN_VOICE, "brain/brnatck3.wav", 1, ATTN_IDLE);};
void() zombie_walkb36		=[	48,		zombie_walkb37	] {ai_walk(1);};
void() zombie_walkb37		=[	49,		zombie_walkb38	] {ai_walk(5);};
void() zombie_walkb38		=[	50,		zombie_walkb39	] {ai_walk(2);};
void() zombie_walkb39		=[	51,		zombie_walkb40	] {ai_walk(-1);};
void() zombie_walkb40		=[	52,		zombie_walk1	] 
{
	ai_walk(-5);
	if (random() < 0.3)
		sound (self, CHAN_VOICE, "brain/brnlens1.wav", 1, ATTN_STATIC);
};

void() zombie_walk1		=[	0,		zombie_walk2	] {ai_walk(7);};
void() zombie_walk2		=[	1,		zombie_walk3	] {ai_walk(2);};
void() zombie_walk3		=[	2,		zombie_walk4	] {ai_walk(3);};
void() zombie_walk4		=[	3,		zombie_walk5	] {ai_walk(3);};
void() zombie_walk5		=[	4,		zombie_walk6	] {ai_walk(1);};
void() zombie_walk6		=[	5,		zombie_walk7	] {ai_walk(0);};
void() zombie_walk7		=[	6,		zombie_walk8	] {ai_walk(0);};
void() zombie_walk8		=[	7,		zombie_walk9	] {ai_walk(9);};
void() zombie_walk9		=[	8,		zombie_walk10	] {ai_walk(-4);};
void() zombie_walk10		=[	9,		zombie_walk11	] {ai_walk(-1);};
void() zombie_walk11		=[	10,		zombie_walk1	] 
{
	ai_walk(2);
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "brain/brnidle2.wav", 1, ATTN_STATIC);
	if (random() < 0.15)
		zombie_walkb1 ();
};


void() zombie_run1		=[	0,		zombie_run2	] {ai_run(11);};
void() zombie_run2		=[	1,		zombie_run3	] {ai_run(4);};
void() zombie_run3		=[	2,		zombie_run4	] {ai_run(5);};
void() zombie_run4		=[	3,		zombie_run5	] {ai_run(5);};
void() zombie_run5		=[	4,		zombie_run6	] {ai_run(3);};
void() zombie_run6		=[	5,		zombie_run7	] {ai_run(0);};
void() zombie_run7		=[	6,		zombie_run8	] {ai_run(0);};
void() zombie_run8		=[	7,		zombie_run9	] {ai_run(11);};
void() zombie_run9		=[	8,		zombie_run10] {ai_run(-4);};
void() zombie_run10		=[	9,		zombie_run11] {ai_run(-1);};
void() zombie_run11		=[	10,		zombie_run1	] 
{
	ai_run(2);
	if (random() < 0.1)
		sound (self, CHAN_VOICE, "brain/brnlens1.wav", 1, ATTN_STATIC);
};

/*
=============================================================================

ATTACKS

=============================================================================
*/

void() ZombieGrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage)
	{
		T_Damage (other, self, self.owner, 5);
		sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		remove (self);
		return;
	}
	sound (self, CHAN_WEAPON, "zombie/z_miss.wav", 1, ATTN_NORM);	// bounce sound
	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';
	self.touch = SUB_Remove;
};

/*
================
ZombieFireGrenade
================
*/
void(vector st) ZombieFireGrenade =
{
	local	entity missile;
	local	vector	org;
	local float vel;

	sound (self, CHAN_WEAPON, "zombie/z_shot1.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

// calc org
	org = self.origin + '0 0 16';
	
// set missile speed	

	makevectors (self.angles);
	
	vel = CalcVelocity(400, self.enemy.origin - self.origin, -200);

	missile.velocity = normalize(self.enemy.origin - org) * vel;
	missile.velocity_z = 200 + crandom() * 2;
	missile.velocity_y = missile.velocity_y + crandom() * 200;
	missile.velocity_x = missile.velocity_x + crandom() * 200;

	missile.avelocity = '3000 1000 2000';

	missile.touch = ZombieGrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};

void() zombie_attb1;

void(float side) ZomClaw =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 80)
	{
		if(random() < 0.33)
			zombie_attb1 ();
		return;
	}
		
	ldmg = 15 + (random()*10) % 5;
	T_Damage (self.enemy, self, self, ceil(ldmg), 40);
	sound (self, CHAN_VOICE, "brain/melee3.wav", 1, ATTN_NORM);

	if (side)
	{
		makevectors (self.angles);
		SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};

void() ZomTent =
{
	local vector	delta, org, end;
	local float 	ldmg;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 175)
		return;
	
	sound (self, CHAN_WEAPON, "brain/brnatck2.wav", 1, ATTN_NORM);
	
	org = self.origin + '0 0 24';
	end = self.enemy.origin + '0 0 6';
	
	traceline (self.origin, end, FALSE, self);
	if(trace_fraction != 1 && trace_ent != self.enemy)
		return;	
	
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    	WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
    	WriteEntity(MSG_BROADCAST, self);
    	WriteCoord (MSG_BROADCAST, org_x);
    	WriteCoord (MSG_BROADCAST, org_y);
    	WriteCoord (MSG_BROADCAST, org_z);
    	WriteCoord (MSG_BROADCAST, end_x);
	WriteCoord (MSG_BROADCAST, end_y);
	WriteCoord (MSG_BROADCAST, end_z);	

	ldmg = 5 + (random()*10) % 5;
	T_Damage (self.enemy, self, self, ceil(ldmg), -200);
	self.enemy.velocity_z = 0;
};

void() zombie_atta1		=[	53,		zombie_atta2	] {ai_charge(8);};
void() zombie_atta2		=[	54,		zombie_atta3	] {ai_charge(3);};
void() zombie_atta3		=[	55,		zombie_atta4	] {ai_charge(5);};
void() zombie_atta4		=[	56,		zombie_atta5	] {ai_charge(0);};
void() zombie_atta5		=[	57,		zombie_atta6	] {ai_charge(-3); sound (self, CHAN_WEAPON, "brain/melee1.wav", 1, ATTN_NORM);};
void() zombie_atta6		=[	58,		zombie_atta7	] {ai_charge(0);};
void() zombie_atta7		=[	59,		zombie_atta8	] {ai_charge(-5);};
void() zombie_atta8		=[	60,		zombie_atta9	] {ai_charge(-7);ZomClaw (-250);};
void() zombie_atta9		=[	61,		zombie_atta10	] {ai_charge(0);};
void() zombie_atta10		=[	62,		zombie_atta11	] {ai_charge(6); sound (self, CHAN_WEAPON, "brain/melee2.wav", 1, ATTN_NORM);};
void() zombie_atta11		=[	63,		zombie_atta12	] {ai_charge(1);};
void() zombie_atta12		=[	64,		zombie_atta13	] {ai_charge(2);ZomClaw (250);};
void() zombie_atta13		=[	65,		zombie_atta14	] {ai_charge(-3);};
void() zombie_atta14		=[	66,		zombie_atta15	] {ai_charge(6);};
void() zombie_atta15		=[	67,		zombie_atta16	] {ai_charge(-1);};
void() zombie_atta16		=[	68,		zombie_atta17	] {ai_charge(-3);};
void() zombie_atta17		=[	69,		zombie_atta18	] {ai_charge(2);};
void() zombie_atta18		=[	70,		zombie_run1		] {ai_charge(-11);};

void() zombie_attb1		=[	71,		zombie_attb2	] {ai_charge(5);};
void() zombie_attb2		=[	72,		zombie_attb3	] {ai_charge(-4);};
void() zombie_attb3		=[	73,		zombie_attb4	] {ai_charge(-4);};
void() zombie_attb4		=[	74,		zombie_attb5	] {ai_charge(-4);};
void() zombie_attb5		=[	75,		zombie_attb6	] {ai_charge(0); sound (self, CHAN_WEAPON, "brain/brnatck1.wav", 1, ATTN_NORM);};
void() zombie_attb6		=[	76,		zombie_attb7	] {ai_charge(0);};
void() zombie_attb7		=[	77,		zombie_attb8	] {ai_charge(13);ZombieFireGrenade('-10 -22 30');  ZomTent ();};
void() zombie_attb8		=[	78,		zombie_attb9	] {ai_charge(0); ZombieFireGrenade('30 22 30');};
void() zombie_attb9		=[	79,		zombie_attb10	] {ai_charge(2); ZombieFireGrenade('-20 -42 32');};
void() zombie_attb10		=[	80,		zombie_attb11	] {ai_charge(0); ZombieFireGrenade('25 32 26');};
void() zombie_attb11		=[	81,		zombie_attb12	] {ai_charge(-9); sound (self, CHAN_WEAPON, "brain/brnatck3.wav", 1, ATTN_NORM);};
void() zombie_attb12		=[	82,		zombie_attb13	] {ai_charge(0);};
void() zombie_attb13		=[	83,		zombie_attb14	] {ai_charge(4);};
void() zombie_attb14		=[	84,		zombie_attb15	] {ai_charge(3);};
void() zombie_attb15		=[	85,		zombie_attb16	] {ai_charge(2);};
void() zombie_attb16		=[	86,		zombie_attb17	] {ai_charge(-3);};
void() zombie_attb17		=[	87,		zombie_run1		] {ai_charge(-6);};

void() zombie_runb1		=[	13,		zombie_runb2	] {ai_charge(3);};
void() zombie_runb2		=[	14,		zombie_runb3	] {ai_charge(-2);};
void() zombie_runb3		=[	15,		zombie_runb4	] {ai_charge(-4);};
void() zombie_runb4		=[	16,		zombie_runb5	] {ai_charge(-3);};
void() zombie_runb5		=[	17,		zombie_runb6	] {ai_charge(0);};
void() zombie_runb6		=[	18,		zombie_runb7	] {ai_charge(1); sound (self, CHAN_WEAPON, "brain/brnatck1.wav", 1, ATTN_NORM); };
void() zombie_runb7		=[	19,		zombie_runb8	] {ai_charge(12); ZombieFireGrenade('-10 -22 30');};
void() zombie_runb8		=[	20,		zombie_runb9	] {ai_charge(0);};
void() zombie_runb9		=[	21,		zombie_runb10	] {ai_charge(-3); ZombieFireGrenade('6 -10 20');};
void() zombie_runb10		=[	22,		zombie_runb11	] {ai_charge(0); };
void() zombie_runb11		=[	23,		zombie_runb12	] {ai_charge(-2); ZombieFireGrenade('-10 -2 30');};
void() zombie_runb12		=[	24,		zombie_runb13	] {ai_charge(0); ZombieFireGrenade('-1 22 30');};
void() zombie_runb13		=[	25,		zombie_runb14	] {ai_charge(0); ZombieFireGrenade('7 -10 25');};
void() zombie_runb14		=[	26,		zombie_runb15	] {ai_charge(1); ZombieFireGrenade('12 -2 36');};
void() zombie_runb15		=[	27,		zombie_runb16	] {ai_charge(0); ZombieFireGrenade('20 42 32');};
void() zombie_runb16		=[	28,		zombie_runb17	] {ai_charge(0); ZombieFireGrenade('-11 2 31');};
void() zombie_runb17		=[	29,		zombie_runb18	] {ai_charge(0);};
void() zombie_runb18		=[	30,		zombie_runb19	] {ai_charge(0);};
void() zombie_runb19		=[	31,		zombie_runb20	] {ai_charge(0);};
void() zombie_runb20		=[	32,		zombie_runb21	] {ai_charge(10);};
void() zombie_runb21		=[	33,		zombie_runb22	] {ai_charge(-1); ZombieFireGrenade('-7 -21 32');};
void() zombie_runb22		=[	34,		zombie_runb23	] {ai_charge(7);};
void() zombie_runb23		=[	35,		zombie_runb24	] {ai_charge(0);  ZombieFireGrenade('-1 21 28');};
void() zombie_runb24		=[	36,		zombie_runb25	] {ai_charge(3);};
void() zombie_runb25		=[	37,		zombie_runb26	] {ai_charge(-3); ZombieFireGrenade('20 12 22');};
void() zombie_runb26		=[	38,		zombie_runb27	] {ai_charge(2);};
void() zombie_runb27		=[	39,		zombie_runb28	] {ai_charge(4); ZombieFireGrenade('-1 32 26');};
void() zombie_runb28		=[	40,		zombie_runb29	] {ai_charge(-3);};
void() zombie_runb29		=[	41,		zombie_runb30	] {ai_charge(2);};
void() zombie_runb30		=[	42,		zombie_runb31	] {ai_charge(0); ZombieFireGrenade('-14 -5 23');};
void() zombie_runb31		=[	43,		zombie_runb32	] {ai_charge(4);};
void() zombie_runb32		=[	44,		zombie_runb33	] {ai_charge(-1);};
void() zombie_runb33		=[	45,		zombie_runb34	] {ai_charge(-1);};
void() zombie_runb34		=[	46,		zombie_runb35	] {ai_charge(-8);};
void() zombie_runb35		=[	47,		zombie_runb36	] {ai_charge(0);sound (self, CHAN_WEAPON, "brain/brnatck3.wav", 1, ATTN_NORM);};
void() zombie_runb36		=[	48,		zombie_runb37	] {ai_charge(1);};
void() zombie_runb37		=[	49,		zombie_runb38	] {ai_charge(5);};
void() zombie_runb38		=[	50,		zombie_runb39	] {ai_charge(2);};
void() zombie_runb39		=[	51,		zombie_runb40	] {ai_charge(-1);};
void() zombie_runb40		=[	52,		zombie_run1		] 
{
	ai_charge(-5);
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "brain/brnidle2.wav", 1, ATTN_STATIC);
};

void()	zombie_melee =
{
	if(random() < 0.5)
		zombie_atta1 ();
	else
		zombie_attb1 ();
}

/*
=============================================================================

PAIN

=============================================================================
*/

void() zombie_paina1	=[	88,	zombie_paina2	] {ai_pain(6);};
void() zombie_paina2	=[	89,	zombie_paina3	] {ai_pain(2);};
void() zombie_paina3	=[	90,	zombie_paina4	] {ai_pain(6);};
void() zombie_paina4	=[	91,	zombie_paina5	] {};
void() zombie_paina5	=[	92,	zombie_paina6	] {};
void() zombie_paina6	=[	93,	zombie_paina7	] {};
void() zombie_paina7	=[	94,	zombie_paina8	] {};
void() zombie_paina8	=[	95,	zombie_paina9	] {};
void() zombie_paina9	=[	96,	zombie_paina10	] {};
void() zombie_paina10	=[	97,	zombie_paina11	] {};
void() zombie_paina11	=[	98,	zombie_paina12	] {};
void() zombie_paina12	=[	99,	zombie_paina13	] {};
void() zombie_paina13	=[	100,	zombie_paina14	] {};
void() zombie_paina14	=[	101,	zombie_paina15	] {ai_painforward(2);};
void() zombie_paina15	=[	102,	zombie_paina16	] {};
void() zombie_paina16	=[	103,	zombie_paina17	] {ai_painforward(2);};
void() zombie_paina17	=[	104,	zombie_paina18	] {ai_painforward(1);};
void() zombie_paina18	=[	105,	zombie_paina19	] {ai_painforward(7);};
void() zombie_paina19	=[	106,	zombie_paina20	] {};
void() zombie_paina20	=[	107,	zombie_paina21	] {ai_painforward(3);};
void() zombie_paina21	=[	108,	zombie_run1		] {ai_pain(1);};

void() zombie_painb1	=[	109,	zombie_painb2	] {ai_painforward(2);};
void() zombie_painb2	=[	110,	zombie_painb3	] {ai_pain(0);};
void() zombie_painb3	=[	111,	zombie_painb4	] {ai_pain(0);};
void() zombie_painb4	=[	112,	zombie_painb5	] {ai_pain(0);};
void() zombie_painb5	=[	113,	zombie_painb6	] {ai_pain(0);};
void() zombie_painb6	=[	114,	zombie_painb7	] {ai_painforward(3);};
void() zombie_painb7	=[	115,	zombie_painb8	] {ai_painforward(1);};
void() zombie_painb8	=[	116,	zombie_run1		] {ai_pain(2);};

void() zombie_painc1	=[	117,	zombie_painc2	] {ai_pain(2);};
void() zombie_painc2	=[	118,	zombie_painc3	] {ai_painforward(2);};
void() zombie_painc3	=[	119,	zombie_painc4	] {ai_painforward(1);};
void() zombie_painc4	=[	120,	zombie_painc5	] {ai_painforward(3);};
void() zombie_painc5	=[	121,	zombie_painc6	] {ai_painforward(0);};
void() zombie_painc6	=[	122,	zombie_run1		] {ai_pain(4);};

void() zombie_dieb1	=[	141,	zombie_dieb2	] {};
void() zombie_dieb2	=[	142,	zombie_dieb3	] {};
void() zombie_dieb3	=[	143,	zombie_dieb4	] {self.maxs_z = -8; self.solid = SOLID_CORPSE;};
void() zombie_dieb4	=[	144,	zombie_dieb5	] {ai_forward(9);};
void() zombie_dieb5	=[	145,	zombie_dieb5	] {};

void() zombie_die1	=[	123,	zombie_die2	] {};
void() zombie_die2	=[	124,	zombie_die3	] {};
void() zombie_die3	=[	125,	zombie_die4	] {ai_back(2);};
void() zombie_die4	=[	126,	zombie_die5	] {ai_forward(9);};
void() zombie_die5	=[	127,	zombie_die6	] {};
void() zombie_die6	=[	128,	zombie_die7	] {};
void() zombie_die7	=[	129,	zombie_die8	] {};
void() zombie_die8	=[	130,	zombie_die9	] {};
void() zombie_die9	=[	131,	zombie_die10] {};
void() zombie_die10	=[	132,	zombie_die11] {};
void() zombie_die11	=[	133,	zombie_die12] {};
void() zombie_die12	=[	134,	zombie_die13] {};
void() zombie_die13	=[	135,	zombie_die14] {self.maxs_z = -8; self.solid = SOLID_CORPSE;};
void() zombie_die14	=[	136,	zombie_die15] {};
void() zombie_die15	=[	137,	zombie_die16] {};
void() zombie_die16	=[	138,	zombie_die17] {};
void() zombie_die17	=[	139,	zombie_die18] {};
void() zombie_die18	=[	140,	zombie_die18] {};

void() zombie_die =
{
	// check for gib
	if (self.health < -150)
	{
		self.skin = 0;
		self.effects = 0;
		sound (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM);
		MonsterGib (4, 0, 1, 0, 2, 0, self.health);
		return;
	}

// regular death
	if((self.deadflag & DEAD_DEAD))
		return;
	
	sound (self, CHAN_VOICE, "brain/brndeth1.wav", 1, ATTN_NORM);
	self.skin = 1;
	self.effects = 0;
	self.movetype = MOVETYPE_TOSS;
	self.takedamage = DAMAGE_YES;

	self.deadflag = DEAD_DEAD;

	if (random() < 0.5)
		zombie_die1();
	else
		zombie_dieb1();
};

/*
=================
zombie_pain

Zombies can only be killed (gibbed) by doing 60 hit points of damage
in a single frame (rockets, grenades, quad shotgun, quad nailgun).

A hit of 25 points or more (super shotgun, quad nailgun) will allways put it
down to the ground.

A hit of from 10 to 40 points in one frame will cause it to go down if it
has been twice in two seconds, otherwise it goes into one of the four
fast pain frames.

A hit of less than 10 points of damage (winged by a shotgun) will be ignored.

FIXME: don't use pain_finished because of nightmare hack
=================
*/
void(entity attacker, float take) zombie_pain =
{
	local float r;

	if (self.health < self.max_health /2)
		self.skin = 1;
	
	if (time < self.pain_finished)
		return;

	r = random();

	if (r < 0.5)
		sound (self, CHAN_VOICE, "brain/brnpain1.wav", 1, ATTN_NORM);
	else 
		sound (self, CHAN_VOICE, "brain/brnpain2.wav", 1, ATTN_NORM);

	self.pain_finished = time + 3;

	if (self.dcnt)
		return;
	if (skill == 3)
		return;

	if (r < 0.33)
		zombie_paina1 ();
	else if (r < 0.66)
		zombie_painb1 ();
	else
		zombie_painc1 ();
};

void()	zombie_duckdown1	=[	146,	zombie_duckdown2	] 
{
	self.dcnt = 1; 
	self.nextthink = self.dspeed; 
	self.maxs_z -= 32; 
	ai_face();
};
void()	zombie_duckdown2	=[	147,	zombie_duckhold	] {ai_face(); self.dodge_finished = time + 0.25 + 2*random();};

void()	zombie_duckup1	=[	149,	zombie_duckup2	] 
{self.dodge_finished = time + 1 + random()*2; self.takedamage = DAMAGE_AIM; self.flags = self.flags - (self.flags & FL_DODGED); self.dcnt = 0; self.maxs_z += 32;};
void()	zombie_duckup2	=[	150,	zombie_duckup3	] {};
void()	zombie_duckup3	=[	151,	zombie_duckup4	] {};
void()	zombie_duckup4	=[	152,	zombie_duckup5	] {};
void()	zombie_duckup5	=[	153,	zombie_run1		] {};

void()	zombie_duckhold =[	148,	zombie_duckhold 	]	
{
	if(time > self.dodge_finished)
		self.think = zombie_duckup1;
};

void()	zombie_defens1	=[	154,	zombie_defens2	] 
{
	self.dcnt = 1; 
	self.nextthink = self.dspeed; 
	self.armortype = 0.8;
	self.armorvalue = 50;
	self.takedamage = DAMAGE_AIM;
	ai_face(); 
};
void()	zombie_defens2	=[	155,	zombie_defens3	] { ai_face();};
void()	zombie_defens3	=[	156,	zombie_defens4	] {};
void()	zombie_defens4	=[	157,	zombie_defens5	] {};
void()	zombie_defens5	=[	158,	zombie_defens6	] 
{
	self.dodge_finished = time + 1 + random()*2; 
	self.flags = self.flags - (self.flags & FL_DODGED); 
	self.dcnt = 0;
};
void()	zombie_defens6	=[	159,	zombie_defens7	] {};
void()	zombie_defens7	=[	160,	zombie_defens8	] {self.armortype = 0; self.armorvalue = 0;};
void()	zombie_defens8	=[	161,	zombie_run1		] {};

void()	zombie_dodge =
{
	if(random() < 0.5)
		zombie_duckdown1 ();
	else
		zombie_defens1 ();
}

//============================================================================

void() spawn_brain;

void() monster_tarbaby;

/*QUAKED monster_zombie (1 0 0) (-16 -16 -24) (16 16 32) Crucified ambush

If crucified, stick the bounding box 12 pixels back into a wall to look right.
*/
void() monster_brain =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/brain.mdl");
	
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("zombie/z_shot1.wav");
	precache_sound ("zombie/z_gib.wav");
	precache_sound ("zombie/z_fall.wav");
	precache_sound ("zombie/idle_w2.wav");

	precache_sound ("brain/brnidle1.wav");
	precache_sound ("brain/brnidle2.wav");
	precache_sound ("brain/brnlens1.wav");
	precache_sound ("brain/brnpain1.wav");
	precache_sound ("brain/brnpain2.wav");
	precache_sound ("brain/brndeth1.wav");
	precache_sound ("brain/brnsrch1.wav");
	precache_sound ("brain/brnsght1.wav");
	precache_sound ("brain/melee1.wav");
	precache_sound ("brain/melee2.wav");
	precache_sound ("brain/melee3.wav");
	precache_sound ("brain/brnatck1.wav");
	precache_sound ("brain/brnatck2.wav");
	precache_sound ("brain/brnatck3.wav");

	spawn_brain ();
};

void() spawn_brain =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/brain.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 300;
	self.max_health = 300;
	self.mass = 400;
	self.skin = 0;

	self.th_stand = zombie_stand1;
	self.th_walk = zombie_walk1;
	self.th_run = zombie_run1;
	self.th_pain = zombie_pain;
	self.th_die = zombie_die;
	self.th_melee = zombie_melee;
	self.th_missile = zombie_runb1;
	self.th_checkatck = ZomCheckAttack;
	self.th_dodge = zombie_dodge;
	self.th_spawn = spawn_brain ;

	walkmonster_start();
}

void() monster_zombie =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/brain.mdl");
	
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("zombie/z_shot1.wav");
	precache_sound ("zombie/z_gib.wav");
	precache_sound ("zombie/z_fall.wav");
	precache_sound ("zombie/idle_w2.wav");

	precache_sound ("brain/brnidle1.wav");
	precache_sound ("brain/brnidle2.wav");
	precache_sound ("brain/brnlens1.wav");
	precache_sound ("brain/brnpain1.wav");
	precache_sound ("brain/brnpain2.wav");
	precache_sound ("brain/brndeth1.wav");
	precache_sound ("brain/brnsrch1.wav");
	precache_sound ("brain/brnsght1.wav");
	precache_sound ("brain/melee1.wav");
	precache_sound ("brain/melee2.wav");
	precache_sound ("brain/melee3.wav");
	precache_sound ("brain/brnatck1.wav");
	precache_sound ("brain/brnatck2.wav");
	precache_sound ("brain/brnatck3.wav");

	precache_model2 ("progs/flyer.mdl");

	precache_sound2 ("flyer/flyidle1.wav");
	precache_sound2 ("flyer/flydeth1.wav");
	precache_sound2 ("flyer/flysrch1.wav");
	precache_sound2 ("flyer/flysght1.wav");
	precache_sound2 ("flyer/flyatck1.wav");
	precache_sound2 ("flyer/flyatck2.wav");
	precache_sound2 ("flyer/flyatck3.wav");
	precache_sound2 ("flyer/flypain1.wav");
	precache_sound2 ("flyer/flypain2.wav");
		
	if (self.spawnflags & SPAWN_CRUCIFIED)
	{
		precache_model ("progs/zombie.mdl");
		setmodel (self, "progs/zombie.mdl");
		self.movetype = MOVETYPE_NONE;
		self.solid = SOLID_NOT;
		zombie_cruc1 ();
		return;
	}
	
	if(self.classname == "monster_brain")
	{
		monster_brain();
		return;
	}
	else if(self.classname == "monster_tarbaby")
	{
		monster_tarbaby();
		return;
	}
	
	local float r = random();
	
	if(r < 0.5)
	{
		self.classname = "monster_tarbaby";
		monster_tarbaby();
		return;
	}
	else
	{
		self.classname = "monster_brain";
		monster_brain();
		return;
	}
};