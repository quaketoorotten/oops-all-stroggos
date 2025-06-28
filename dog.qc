/*
==============================================================================

DOG

==============================================================================
*/
$cd id1/models/dog
$origin 0 0 24
$base base
$skin skin

void() spawn_dog;

void() monster_dog =
{	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	army_precache();
	spawn_dog();
};

void() spawn_dog =
{
	generic_army ();
	self.health = 25;
	self.max_health = 25;
	self.th_spawn = spawn_dog;

	self.skin = 0;

	self.th_melee = army_atkrnd;
	self.th_missile = army_atkrnd;
	walkmonster_start();
};

void() monster_soldier_light  =
{
	self.classname = "monster_dog";	
	monster_dog ();
}