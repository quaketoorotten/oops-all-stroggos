
/*QUAKED info_null (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for spotlights, etc.
*/
void() info_null =
{
	remove(self);
};

/*QUAKED info_notnull (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for lightning.
*/
void() info_notnull =
{
};

//============================================================================

float START_OFF = 1;

void() light_use =
{
	if (self.spawnflags & START_OFF)
	{
		lightstyle(self.style, "m");
		self.spawnflags = self.spawnflags - START_OFF;
	}
	else
	{
		lightstyle(self.style, "a");
		self.spawnflags = self.spawnflags + START_OFF;
	}
};

/*QUAKED light (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Non-displayed light.
Default light value is 300
Default style is 0
If targeted, it will toggle between on or off.
*/
void() light =
{
	if (!self.targetname)
	{	// inert light
		remove(self);
		return;
	}
	
	if (self.style >= 32)
	{
		self.use = light_use;
		if (self.spawnflags & START_OFF)
			lightstyle(self.style, "a");
		else
			lightstyle(self.style, "m");
	}
};

/*QUAKED light_fluoro (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Non-displayed light.
Default light value is 300
Default style is 0
If targeted, it will toggle between on or off.
Makes steady fluorescent humming sound
*/
void() light_fluoro =
{
	if (self.style >= 32)
	{
		self.use = light_use;
		if (self.spawnflags & START_OFF)
			lightstyle(self.style, "a");
		else
			lightstyle(self.style, "m");
	}
	
	precache_sound ("ambience/fl_hum1.wav");
	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};

/*QUAKED light_fluorospark (0 1 0) (-8 -8 -8) (8 8 8)
Non-displayed light.
Default light value is 300
Default style is 10
Makes sparking, broken fluorescent sound
*/
void() light_fluorospark =
{
	if (!self.style)
		self.style = 10;

	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
};

/*QUAKED light_globe (0 1 0) (-8 -8 -8) (8 8 8)
Sphere globe light.
Default light value is 300
Default style is 0
*/
void() light_globe =
{
	precache_model ("progs/s_light.spr");
	setmodel (self, "progs/s_light.spr");
	makestatic (self);
};

void() FireAmbient =
{
	precache_sound ("ambience/fire1.wav");
// attenuate fast
	ambientsound (self.origin, "ambience/fire1.wav", 0.5, ATTN_STATIC);
};

/*QUAKED light_torch_small_walltorch (0 .5 0) (-10 -10 -20) (10 10 20)
Short wall torch
Default light value is 200
Default style is 0
*/
void() light_torch_small_walltorch =
{
	precache_model ("progs/flame.mdl");
	setmodel (self, "progs/flame.mdl");
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_large_yellow (0 1 0) (-10 -10 -12) (12 12 18)
Large yellow flame ball
*/
void() light_flame_large_yellow =
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	self.frame = 1;
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_small_yellow (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Small yellow flame ball
*/
void() light_flame_small_yellow =
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_small_white (0 1 0) (-10 -10 -40) (10 10 40) START_OFF
Small white flame ball
*/
void() light_flame_small_white =
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	FireAmbient ();
	makestatic (self);
};

//============================================================================


/*QUAKED misc_fireball (0 .5 .8) (-8 -8 -8) (8 8 8)
Lava Balls
*/

void() fire_fly;
void() fire_touch;
void() misc_fireball =
{
	precache_model ("progs/lavaball.mdl");
	self.classname = "fireball";
	self.nextthink = time + (random() * 5);
	self.think = fire_fly;
	if (!self.speed)
		self.speed = 1000;
};

void() fire_fly =
{
local entity	fireball;

	fireball = spawn();
	fireball.solid = SOLID_TRIGGER;
	fireball.movetype = MOVETYPE_TOSS;
	fireball.velocity = '0 0 1000';
	fireball.velocity_x = (random() * 100) - 50;
	fireball.velocity_y = (random() * 100) - 50;
	fireball.velocity_z = self.speed + (random() * 200);
	fireball.classname = "fireball";
	setmodel (fireball, "progs/lavaball.mdl");
	setsize (fireball, '0 0 0', '0 0 0');
	setorigin (fireball, self.origin);
	fireball.nextthink = time + 5;
	fireball.think = SUB_Remove;
	fireball.touch = fire_touch;
	
	self.nextthink = time + (random() * 5) + 3;
	self.think = fire_fly;
};


void() fire_touch =
{
	T_Damage (other, self, self, 20);
	remove(self);
};

//============================================================================

/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
TESTING THING
*/

void(string gibname, float vel, vector org) ThrowDebri;
vector(float dm) VelocityForDamage;

void() barrel_explode =
{
	local vector chunkorigin, size;
	local float spd;
		
	size = (self.maxs - self.mins) * 0.5;
	//org = size + self.absmin;
	self.origin = size + self.absmin;
	
	spd = 1.5 * self.dmg / 200;
	for(float i = 0; i < 2; i++)
	{
		chunkorigin = self.origin + crandom() * size;
		ThrowDebri ("progs/debris1.mdl", spd, chunkorigin);
	}

	// bottom corners
	spd = 1.75 * self.dmg / 200;
	chunkorigin = self.absmin;
	ThrowDebri ("progs/debris3.mdl", spd, chunkorigin);
	chunkorigin= self.absmin;
	chunkorigin[0] += size[0];
	ThrowDebri ("progs/debris3.mdl", spd, chunkorigin);
	chunkorigin= self.absmin;
	chunkorigin[1] += size[1];
	ThrowDebri ("progs/debris3.mdl", spd, chunkorigin);
	chunkorigin= self.absmin;
	chunkorigin[0] += size[0];
	chunkorigin[1] += size[1];
	ThrowDebri ("progs/debris3.mdl", spd, chunkorigin);

	// a bunch of little chunks
	spd = 2 * self.dmg / 200;

	for(float i = 0; i < 8; i++)
	{
		chunkorigin = self.origin + crandom() * size;
		ThrowDebri ("progs/debris2.mdl", spd, chunkorigin);
	}

	BecomeExplosion ();
	
	T_RadiusDamage (self, self, self.dmg, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
};

void()	barrel_anim2 = [2, barrel_anim3   ] {};
void()	barrel_anim3 = [3, barrel_explode ] {};

void() barrel_die = 
{
	// check for gib
	if (self.health < -self.mass)
	{
		barrel_explode();
		return;
	}

	self.takedamage = DAMAGE_NO;
	self.think = barrel_anim2;
	self.nextthink = time * 0.1;
	self.th_die = SUB_Null;
};

float CLIMBABLE = 1;

void() barrel_touch =
{
	if(!(other.flags & FL_ONGROUND) && (other.classname != "player") && (other.health <= 0))
		return;

	if (!(other.flags & FL_ONGROUND) )
	{	
		other.flags = other.flags + FL_ONGROUND;
		return;
	}

	if(!checkbottom(other)) return;
	
	local float ratio;
	local vector v;
	
	ratio = other.mass / self.mass;
	v = ((self.maxs - self.mins) * 0.5 + self.absmin) - ((other.maxs - other.mins) * 0.5 + other.absmin);
	
	walkmove (vectoyaw(v), 25 * ratio * 0.1);
};

/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
TESTING THING
*/

void() misc_explobox =
{
	local float	oldz;
	
	if(!self.mdl) 
		self.mdl = "progs/barrels.mdl";

	self.classname = "explo_box";
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_STEP;
	precache_model (self.mdl);
	setmodel (self, self.mdl);

	setsize (self, '-16 -16 0', '16 16 40');
   	setorigin (self, self.origin);

	if (!self.mass)
		self.mass = 400;
	if (!self.health)
		self.health = 10;
	if (!self.dmg)
		self.dmg = 150;

	self.max_health = self.health;
	self.th_die = barrel_die;
	self.touch = barrel_touch;

	self.takedamage = DAMAGE_YES;
	self.netname = "$qc_exploding_barrel";

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();

	if (oldz - self.origin_z > 250)
	{
		dprint ("explobox fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

/*QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64)
Smaller exploding box, REGISTERED ONLY
*/

void() misc_explobox2 =
{
	misc_explobox();
};

void() explosive_explo =
{
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";

	local vector size, chunkorigin, org;
	local float count;
	local entity en;

	if(!self.use)
		en = self.enemy;
	else 
		en = self;
		
	size = (self.maxs - self.mins) * 0.5;
	org = size + self.absmin;
	self.origin = org;
	
	SUB_UseTargets();
	if(self.dmg)
	{	
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
		BecomeExplosion();
		T_RadiusDamage (self, self, self.dmg + 60, world);
	}

	if(!self.mass && !self.dmg)
	{
		remove(self);
		return;
	}

	self.velocity = normalize(en.origin - self.origin)*150;
		
	if(self.mass >= 100)
	{
		count = self.mass / 100;
		if(count > 8)
		{
			count = 8;
			while(count--)
			{
				chunkorigin = self.origin + crandom() * size;
				ThrowDebri ("progs/debris1.mdl", 1, chunkorigin);
			}
		}
	}

	count = self.mass / 25;
	if (count > 16)
		count = 16;
	while(count--)
	{
		chunkorigin = self.origin + crandom() * size;
		ThrowDebri ("progs/debris2.mdl", 1, chunkorigin);
	}
	
	if(!self.dmg)
		remove(self);
};

void(entity attacker, float dmg) explosive_pain =
{
	self.enemy = attacker;
}

float EXPLO_ON_USE = 1;

void() func_explosive =
{
	self.classname = "func_explosive";
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.takedamage = DAMAGE_NO;
	self.th_pain = explosive_pain;
	setmodel (self, self.model);

	if(!self.targetname)
	{
		if(!self.health)
			self.health = 100;
		if(!self.mass)
			self.mass = 75;
		self.takedamage = DAMAGE_YES;
		self.th_die = explosive_explo;
	}
	
	self.use = explosive_explo;
	
	if((self.spawnflags & EXPLO_ON_USE))
	{
  		self.model = string_null;
		self.solid = SOLID_NOT;
	}

	setorigin (self, self.origin);
};

void() func_breakable =
{
	func_explosive ();
}

//============================================================================

float SPAWNFLAG_SUPERSPIKE	= 1;
float SPAWNFLAG_LASER = 2;

void(vector org, vector vec) LaunchLaser;

void() spikeshooter_use =
{
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		sound (self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
		LaunchLaser (self.origin, self.movedir);
	}
	else
	{
		sound (self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
		launch_spike (self.origin, self.movedir);
		newmis.velocity = self.movedir * 500;
		if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
			newmis.touch = superspike_touch;
	}
};

void() shooter_think =
{
	spikeshooter_use ();
	self.nextthink = time + self.wait;
	newmis.velocity = self.movedir * 500;
};


/*QUAKED trap_spikeshooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
When triggered, fires a spike in the direction set in QuakeEd.
Laser is only for REGISTERED.
*/

void() trap_spikeshooter =
{
	SetMovedir ();
	self.use = spikeshooter_use;
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		precache_model2 ("progs/laser.mdl");
		
		precache_sound2 ("enforcer/enfire.wav");
		precache_sound2 ("enforcer/enfstop.wav");
	}
	else
		precache_sound ("weapons/spike2.wav");
};


/*QUAKED trap_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
*/
void() trap_shooter =
{
	trap_spikeshooter ();
	
	if (self.wait == 0)
		self.wait = 1;
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
};



/*
===============================================================================


===============================================================================
*/


void() make_bubbles;
void() bubble_remove;
void() bubble_bob;

/*QUAKED air_bubbles (0 .5 .8) (-8 -8 -8) (8 8 8)

testing air bubbles
*/

void() air_bubbles =

{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	precache_model ("progs/s_bubble.spr");
	self.nextthink = time + 1;
	self.think = make_bubbles;
};

void() make_bubbles =
{
local entity	bubble;

	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() + 0.5;
	self.think = make_bubbles;
};

void() bubble_split =
{
local entity	bubble;
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = self.velocity;
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 1;
	bubble.cnt = 10;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.frame = 1;
	self.cnt = 10;
	if (self.waterlevel != 3)
		remove (self);
};

void() bubble_remove =
{
	if (other.classname == self.classname)
	{
//		dprint ("bump");
		return;
	}
	remove(self);
};

void() bubble_bob =
{
local float		rnd1, rnd2, rnd3;

	self.cnt = self.cnt + 1;
	if (self.cnt == 4)
		bubble_split();
	if (self.cnt == 20)
		remove(self);

	rnd1 = self.velocity_x + (-10 + (random() * 20));
	rnd2 = self.velocity_y + (-10 + (random() * 20));
	rnd3 = self.velocity_z + 10 + random() * 10;

	if (rnd1 > 10)
		rnd1 = 5;
	if (rnd1 < -10)
		rnd1 = -5;
		
	if (rnd2 > 10)
		rnd2 = 5;
	if (rnd2 < -10)
		rnd2 = -5;
		
	if (rnd3 < 10)
		rnd3 = 15;
	if (rnd3 > 30)
		rnd3 = 25;
	
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;
		
	self.nextthink = time + 0.5;
	self.think = bubble_bob;
};

/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~*/

/*QUAKED viewthing (0 .5 .8) (-8 -8 -8) (8 8 8)

Just for the debugging level.  Don't use
*/

void() viewthing =

{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	precache_model ("progs/player.mdl");
	setmodel (self, "progs/player.mdl");
};


/*
==============================================================================

SIMPLE BMODELS

==============================================================================
*/

void() func_wall_use =
{	// change to alternate textures
	self.frame = 1 - self.frame;
};

/*QUAKED func_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
*/
void() func_wall =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};


/*QUAKED func_illusionary (0 .5 .8) ?
A simple entity that looks solid but lets you walk through it.
*/
void() func_illusionary =

{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self, self.model);
	makestatic (self);
};

/*QUAKED func_episodegate (0 .5 .8) ? E1 E2 E3 E4
This bmodel will appear if the episode has allready been completed, so players can't reenter it.
*/
void() func_episodegate =

{
	if (!(serverflags & self.spawnflags))
		return;			// can still enter episode

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

/*QUAKED func_bossgate (0 .5 .8) ?
This bmodel appears unless players have all of the episode sigils.
*/
void() func_bossgate =

{
	if ( (serverflags & 15) == 15)
		return;		// all episodes completed
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

//============================================================================
/*QUAKED ambient_suck_wind (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_suck_wind =
{
	precache_sound ("ambience/suck1.wav");
	ambientsound (self.origin, "ambience/suck1.wav", 1, ATTN_STATIC);
};

/*QUAKED ambient_drone (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_drone =
{
	precache_sound ("ambience/drone6.wav");
	ambientsound (self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
};

/*QUAKED ambient_flouro_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_flouro_buzz =
{
	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 1, ATTN_STATIC);
};
/*QUAKED ambient_drip (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_drip =
{
	precache_sound ("ambience/drip1.wav");
	ambientsound (self.origin, "ambience/drip1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_comp_hum (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_comp_hum =
{
	precache_sound ("ambience/comp1.wav");
	ambientsound (self.origin, "ambience/comp1.wav", 1, ATTN_STATIC);
};
/*QUAKED ambient_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_thunder =
{
	precache_sound ("ambience/thunder1.wav");
	ambientsound (self.origin, "ambience/thunder1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_light_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_light_buzz =
{
	precache_sound ("ambience/fl_hum1.wav");
	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_swamp1 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp1 =
{
	precache_sound ("ambience/swamp1.wav");
	ambientsound (self.origin, "ambience/swamp1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_swamp2 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp2 =
{
	precache_sound ("ambience/swamp2.wav");
	ambientsound (self.origin, "ambience/swamp2.wav", 0.5, ATTN_STATIC);
};

//============================================================================

void() noise_think =
{
	self.nextthink = time + 0.5;
	sound (self, 1, "enforcer/enfire.wav", 1, ATTN_NORM);
	sound (self, 2, "enforcer/enfstop.wav", 1, ATTN_NORM);
	sound (self, 3, "enforcer/sight1.wav", 1, ATTN_NORM);
	sound (self, 4, "enforcer/sight2.wav", 1, ATTN_NORM);
	sound (self, 5, "enforcer/sight3.wav", 1, ATTN_NORM);
	sound (self, 6, "enforcer/sight4.wav", 1, ATTN_NORM);
	sound (self, 7, "enforcer/pain1.wav", 1, ATTN_NORM);
};

/*QUAKED misc_noisemaker (1 0.5 0) (-10 -10 -10) (10 10 10)

For optimzation testing, starts a lot of sounds.
*/

void() misc_noisemaker =

{
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/idle1.wav");

	self.nextthink = time + 0.1 + random();
	self.think = noise_think;
};

//============================================================================

float GIB_ORGANIC = 0;
float GIB_METAL = 1;

void(string gibname, float dm, optional float gibtype) ThrowGib =
{	
	local vector size = (self.maxs - self.mins) * 0.5;
	local	vector org = size + self.absmin;
	local vector chunkorg;
	
	chunkorg_x = org_x + crandom() * size_x;
	chunkorg_y = org_y + crandom() * size_y;
	chunkorg_z = org_z + crandom() * size_z;
	
	local	entity new;
	new = spawn();
	new.origin = chunkorg;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');

	local float vscale = 1;

	if(gibtype == GIB_ORGANIC)
	{
		new.movetype = MOVETYPE_TOSS;
		vscale = 0.5;
	}
	else
		new.movetype = MOVETYPE_BOUNCE;
	
	new.velocity = self.velocity + VelocityForDamage(dm)*vscale;
	new.velocity = ClipGibVelocity(new.velocity);
	new.modelflags = MF_GIB;
	new.solid = SOLID_NOT;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random()*10;
	new.frame = 0;
	new.flags = 0;
};

void(string gibname, float dm) ThrowHead =
{
	setmodel (self, gibname);
	setsize (self, '-16 -16 0', '16 16 56');

	self.velocity = self.velocity + VelocityForDamage(dm);
	self.velocity = ClipGibVelocity(self.velocity);
	
	self.movetype = MOVETYPE_BOUNCE;
	self.modelflags = MF_GIB;
	self.solid = SOLID_NOT;
	self.avelocity = crandom() * '0 600 0';
	self.origin_z = self.origin_z + 4;
	self.think = SUB_Remove;
	self.ltime = time;
	self.nextthink = time + 10 + random()*10;
	self.frame = 0;
	self.flags = 0;
};

void(string gibname, float vel, vector org) ThrowDebri =
{
	local	entity new;
	new = spawn();
	new.origin = org;

	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	
	new.velocity = self.velocity + VelocityForDamage(vel);
	new.velocity = ClipGibVelocity(new.velocity);
	
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 5 + random()*5;
	new.frame = 0;
	new.flags = 0;
};

void(float sm_meat, float sm_metal, float head2, float chest, float bone, float gear, float dm) MonsterGib =
{
	if(sm_meat > 0)
		for(float i = 0; i < sm_meat; i++)
			ThrowGib ("progs/sm_meat.mdl", dm, GIB_ORGANIC);
	if(sm_metal > 0)
		for(float i = 0; i < sm_metal; i++)
			ThrowGib ("progs/sm_metal.mdl", dm, GIB_METAL);
	if(bone > 0)
		for(float i = 0; i < bone; i++)
			ThrowGib ("progs/bone.mdl", dm, GIB_ORGANIC);

	if(gear > 0)
		ThrowGib ("progs/gear.mdl", dm, GIB_METAL);
	if(chest > 0)
		ThrowGib ("progs/chest.mdl", dm, GIB_ORGANIC);
	if(head2 > 0)
		ThrowHead ("progs/head2.mdl", dm);
}


void(vector org) SHOCKING_INNIT =
{
	for(float i = 0; i < 4; i++)
		ThrowDebri ("progs/debris2.mdl", 10, org);
	for(float i = 0; i < 2; i++)
		ThrowDebri ("progs/debris1.mdl", 5, org);
}
