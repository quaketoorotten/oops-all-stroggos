/*
==============================================================================

KNIGHT

==============================================================================
*/

$cd id1/models/knight
$origin 0 0 24
$base base
$skin badass3


/*QUAKED monster_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/

void() spawn_ss;

void() monster_ss =
{	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	army_precache();
	spawn_ss();
};

void() monster_enforcer;

void() monster_knight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

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
	
	if(self.classname == "monster_ss")
	{
		monster_ss();
		return;
	}
	else if(self.classname == "monster_enforcer")
	{
		monster_enforcer();
		return;
	}
	
	local float r = random();
	
	if (r < 0.7)
	{
		self.classname = "monster_ss";
		monster_ss();
		return;
	}
	else
	{
		self.classname = "monster_enforcer";
		monster_enforcer();
		return;
	}
};

void() monster_soldier_ss  =
{
	self.classname = "monster_ss";
	monster_ss ();
}

void() monster_infantry  =
{
	self.classname = "monster_enforcer";
	monster_enforcer ();
}

void() spawn_ss=
{
	generic_army ();
	self.health = 40;
	self.max_health = 40;
	self.th_spawn = spawn_ss;
	self.skin = 4;

	self.th_melee = army_atkc1;
	self.th_missile = army_atkc1;
	walkmonster_start();
};