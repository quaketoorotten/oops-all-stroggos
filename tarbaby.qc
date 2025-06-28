/*
==============================================================================

BLOB

==============================================================================
*/

$cd id1/models/tarbaby
$origin 0 0 24
$base base		

$skin skin

void()	tbaby_slash = { sound (self, CHAN_VOICE, "flyer/flyatck2.wav", 1,  ATTN_NORM); }
void()	tbaby_pop 	= { sound (self, CHAN_WEAPON, "flyer/flyatck1.wav", 1,  ATTN_NORM); }
void()	tbaby_fire 	= { sound (self, CHAN_WEAPON, "flyer/flyatck3.wav", 1,  ATTN_NORM); }
void()	tbaby_die 	= { sound (self, CHAN_VOICE, "flyer/flydeth1.wav", 1,  ATTN_NORM); }

void()	tbaby_stand1	= [	13,		tbaby_stand2	] 
{ai_stand(); 
	if(random() < 0.1) 
		sound (self, CHAN_VOICE, "flyer/flyidle1.wav", 1,  ATTN_IDLE); }
void()	tbaby_stand2	= [	self.frame,	tbaby_stand2	] 
{
	self.frame ++;

	ai_stand();

	if(self.frame >= 57)
		tbaby_stand1();
};

void()	tbaby_walk1		= [	13,		tbaby_walk2	] 
{ai_walk(5); 
	if(random() < 0.1) 
		sound (self, CHAN_VOICE, "flyer/flyidle1.wav", 1,  ATTN_IDLE); }
void()	tbaby_walk2		= [	self.frame,	tbaby_walk2	] 
{
	self.frame ++;

	ai_walk(5);

	if(self.frame >= 57)
		tbaby_walk1();
};

void()	tbaby_run1	= [	13,		tbaby_run2	] 
{ai_run(10); 
	if(random() < 0.1) 
		sound (self, CHAN_VOICE, "flyer/flysrch1.wav", 1,  ATTN_IDLE); }

void()	tbaby_run2	= [	self.frame,	tbaby_run2	] 
{
	self.frame ++;

	ai_run(10);

	if(self.frame >= 57)
		tbaby_run1();
};

//============================================================================

void()	tbaby_fast1	=[	79,		tbaby_fast2	] {ai_face();};
void()	tbaby_fast2	=[	80,		tbaby_fast3	] {ai_face();};
void()	tbaby_fast3	=[	81,		tbaby_fast4	] {ai_face();};
void()	tbaby_fast4	=[	82,		tbaby_fast5	] {ai_charge(-10);Flyer_StartFast(8);  tbaby_fire ();};
void()	tbaby_fast5	=[	83,		tbaby_fast6	] {ai_charge(-10);Flyer_StartFast(-8); tbaby_fire ();};
void()	tbaby_fast6	=[	84,		tbaby_fast7	] {ai_charge(-10);Flyer_StartFast(8);  tbaby_fire ();};
void()	tbaby_fast7	=[	85,		tbaby_fast8	] {ai_charge(-10);Flyer_StartFast(-8); tbaby_fire ();};
void()	tbaby_fast8	=[	86,		tbaby_fast9	] {ai_charge(-10);Flyer_StartFast(8);  tbaby_fire ();};
void()	tbaby_fast9	=[	87,		tbaby_fast10] {ai_charge(-10);Flyer_StartFast(-8); tbaby_fire ();};
void()	tbaby_fast10=[	88,		tbaby_fast11] {ai_charge(-10);Flyer_StartFast(8);  tbaby_fire ();};
void()	tbaby_fast11=[	89,		tbaby_fast12] {ai_face(); };
void()	tbaby_fast12=[	90,		tbaby_fast13] {ai_face(); };
void()	tbaby_fast13=[	91,		tbaby_fast14] {ai_face(); };
void()	tbaby_fast14=[	92,		tbaby_fast15] {ai_face(); };
void()	tbaby_fast15=[	93,		tbaby_fast16] {ai_face(); };
void()	tbaby_fast16=[	94,		tbaby_fast17] {ai_face(); };
void()	tbaby_fast17=[	94,		tbaby_run1	] {ai_face(); SUB_AttackFinished(0.4); FliesAttackFinished(); };

void()	tbaby_atkchar1;

void()	tbaby_CheckHit =
{
	local vector delta;
	local float rad;
	delta = self.enemy.origin - self.origin;
	
	rad = 150;
	
	if (vlen(delta) > rad)
		return;

	tbaby_atkchar1();
}

void(float side) tbabyClaw =
{
local vector	delta;
local float 	ldmg;
	
	tbaby_slash ();

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 80)
		return;
		
	ldmg = 3 + random()*10 % 5;
	T_Damage (self.enemy, self, self, ceil(ldmg), 30);

	if (side)
	{
		makevectors (self.angles);
		SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};

void()	tbaby_atkrefire	= [	64,		tbaby_atkchar2	] {ai_charge(30);}

void()	tbaby_atkchar1	= [	58,		tbaby_atkchar2	] {ai_charge(30); tbaby_pop ();}
void()	tbaby_atkchar2	= [	self.frame,	tbaby_atkchar2	] 
{
	self.frame ++;

	ai_charge(30);
	
	if(self.frame == 66)
		tbabyClaw (250);
	if(self.frame == 71)
		tbabyClaw (-250);
	if(self.frame == 75)
		if(random() < 0.6)
			SUB_CheckRefire (tbaby_atkrefire);
	
	if(self.frame >= 78)
	{
		SUB_AttackFinished(1 + 2*random() );
		tbaby_run1 ();
	}
};

void()	tbaby_char1	= [	13,		tbaby_char2	] {ai_charge(35); tbaby_CheckHit(); SUB_AttackFinished(3); }
void()	tbaby_char2	= [	self.frame,	tbaby_char2	] 
{	
	tbaby_CheckHit();

	if(time > self.attack_finished)
	{
		self.th_run();
		return;
	}

	self.frame ++;

	ai_charge(35);

	if(self.frame >= 57)
		tbaby_char1();
};

float tbaby_type;

void() tbaby_changetypes =
{
	tbaby_type = tbaby_type + 1;

	if (tbaby_type == 1)
		tbaby_char1 ();
	else if (tbaby_type == 2)
		tbaby_fast1();
	else 
	{
		tbaby_fast1();
		tbaby_type = 0;
	}
};

//=============================================================================

void()	tbaby_bankl1 = [ 96,  tbaby_bankl2 ]  {ai_run(30);};
void()	tbaby_bankl2 = [ 97,  tbaby_bankl3 ]  {ai_run(30);};
void()	tbaby_bankl3 = [ 98,  tbaby_bankl4 ]  {ai_run(30);};
void()	tbaby_bankl4 = [ 99,  tbaby_bankl5 ]  {ai_run(30);};
void()	tbaby_bankl5 = [ 100, tbaby_bankl6 ]  {ai_run(30);};
void()	tbaby_bankl6 = [ 101, tbaby_bankl7 ]  {ai_run(30);};
void()	tbaby_bankl7 = [ 102, tbaby_run1   ]  
{
	ai_run(30); 
	self.attack_state = AS_STRAIGHT; 
	self.dodge_finished = time + 1 + random()*2; 
	self.takedamage = DAMAGE_AIM; 
	self.flags = self.flags - (self.flags & FL_DODGED); 
	self.dcnt = 0;
};

void()	tbaby_bankr1 = [ 103, tbaby_bankr2 ]  {ai_run(30);};
void()	tbaby_bankr2 = [ 104, tbaby_bankr3 ]  {ai_run(30);};
void()	tbaby_bankr3 = [ 105, tbaby_bankr4 ]  {ai_run(30);};
void()	tbaby_bankr4 = [ 106, tbaby_bankr5 ]  {ai_run(30);};
void()	tbaby_bankr5 = [ 107, tbaby_bankr6 ]  {ai_run(30);};
void()	tbaby_bankr6 = [ 108, tbaby_bankr7 ]  {ai_run(30);};
void()	tbaby_bankr7 = [ 109, tbaby_run1   ]  
{
	ai_run(30); 
	self.attack_state = AS_STRAIGHT; 
	self.dodge_finished = time + 1 + random()*2; 
	self.takedamage = DAMAGE_AIM; 
	self.flags = self.flags - (self.flags & FL_DODGED); 
	self.dcnt = 0;
};

void()	tbaby_dodge =
{	
	self.attack_state = AS_SLIDING;
	
	self.dcnt = 1; 
	self.nextthink = self.dspeed; 
	self.takedamage = DAMAGE_YES;

	if(self.l)
		tbaby_bankl1 ();
	else
		tbaby_bankr1 ();
}

void()	tbaby_die2	=
{
	tbaby_die();
	self.takedamage = DAMAGE_NO;
	self.skin = 0;
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	MonsterGib (0, 3, 0, 0, 0, 2, self.health);
	BecomeExplosion ();
};

//=============================================================================

void()	tbaby_pain3	= [	142,		tbaby_run1	] { }
void()	tbaby_pain1	= [	134,		tbaby_pain2	] { }

void()	tbaby_pain2	= [	self.frame,	tbaby_pain2	] 
{	
	self.frame ++;

	if(self.frame >= 141)
		tbaby_pain3();
};

void()	tbaby_painb3	= [	146,		tbaby_run1	] { }
void()	tbaby_painb1	= [	143,		tbaby_painb2	] { }

void()	tbaby_painb2	= [	self.frame,	tbaby_painb2	] 
{	
	self.frame ++;

	if(self.frame >= 145)
		tbaby_pain3();
};

void()	tbaby_painc3	= [	150,		tbaby_run1	] { }
void()	tbaby_painc1	= [	147,		tbaby_painc2	] { }

void()	tbaby_painc2	= [	self.frame,	tbaby_painc2	] 
{	
	self.frame ++;

	if(self.frame >= 149)
		tbaby_pain3();
};

void tbaby_pain (entity attacker, float damage) =
{
	local	float	n;

	if (self.health < (self.max_health / 2))
		self.skin = 1;

	if (time < self->pain_finished)
		return;
	
	n = random()*10 % 3;
	if (n == 0)
		sound (self, CHAN_VOICE, "flyer/flypain1.wav", 1, ATTN_NORM);
	else if (n == 1)
		sound (self, CHAN_VOICE, "flyer/flypain2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "flyer/flypain1.wav", 1, ATTN_NORM);
	
	self.pain_finished = time + 3;

	if (skill == 3)
		return;		// no pain anims in nightmare

	if (n == 0)
		tbaby_pain1 ();

	else if (n == 1)
		tbaby_painb1 ();

	else
		tbaby_painc1 ();

}

//=============================================================================


/*QUAKED monster_tarbaby (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/
void() monster_tarbaby =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
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
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/flyer.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 50;
	self.max_health = 50;
	self.mass = 150;

	self.th_stand = tbaby_stand1;
	self.th_walk = tbaby_walk1;
	self.th_run = tbaby_run1;
	self.th_missile = tbaby_changetypes;
	self.th_pain = tbaby_pain;
	self.th_melee = tbaby_atkchar1;
	self.th_die = tbaby_die2;
	self.th_checkatck = FliesCheckAttack;
	self.th_dodge = tbaby_dodge;
	
	flymonster_start ();
};

