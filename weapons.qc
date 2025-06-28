/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

void(vector org, vector vel, float damage) SpawnBlood;
void() SuperDamageSound;

// called by worldspawn
void() W_Precache =
{
    precache_sound("weapons/r_exp3.wav"); // new rocket explosion
    precache_sound("weapons/rocket1i.wav"); // spike gun
    precache_sound("weapons/sgun1.wav");
    precache_sound("weapons/guncock.wav"); // player shotgun
    precache_sound("weapons/ric1.wav"); // ricochet (used in C code)
    precache_sound("weapons/ric2.wav"); // ricochet (used in C code)
    precache_sound("weapons/ric3.wav"); // ricochet (used in C code)
    precache_sound("weapons/spike2.wav"); // super spikes
    precache_sound("weapons/tink1.wav"); // spikes tink (used in C code)
    precache_sound("weapons/grenade.wav"); // grenade launcher
    precache_sound("weapons/bounce.wav"); // grenade bounce
    precache_sound("weapons/shotgn2.wav"); // super shotgun
};


float() crandom =
{
    return 2 * (random() - 0.5);
};

void(entity targ, float eta) Dodge =
{
	targ.flags += FL_DODGED;
	
	if( !(targ.th_dodge))
		return;			
	
	targ.dspeed = eta;
	targ.think = targ.th_dodge; 
};

void (vector src, vector dir, float speed) CheckDodge = 
{
	local float dtime;
	local float dist;

	if(skill <= 1)
		if(random() > 0.3)
			return;

	if(skill == 2)
		if(random() > 0.6)
			return;

	if(skill == 3)
		if(random() > 0.9)
			return;

	traceline (src, src + dir*2048, FALSE, self);
	
	dist = vlen(trace_endpos - src);

	dprint("distance: ");
	dprint(ftos(dist));
	dprint("\n");

	dtime = (dist - trace_ent.maxs_x) / speed;

	if(dtime <= 0) 
		dtime = 0.2;

	dprint("eta: ");
	dprint(ftos(dtime));
	dprint("\n");

	if(trace_ent.dcnt)
		return;

	if(trace_ent.dodge_finished > time)
		return;
	
	if((trace_ent.flags & FL_MONSTER) && (trace_ent.health > 0) && !(trace_ent.flags & FL_MEDIC) )
	{
		Dodge(trace_ent, dtime);
		if(trace_ent.th_dodge)
			trace_ent.enemy = self;
	}
};

/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
    local vector source;
    local vector org;

	self.solid = SOLID_BBOX;
    makevectors(self.v_angle);
    source = self.origin + '0 0 16';
    traceline(source, source + v_forward * 64, FALSE, self);
    if (trace_fraction == 1.0)
    {
		self.solid = SOLID_SLIDEBOX;
        return;
    }

    org = trace_endpos - v_forward * 4;
	
    if (trace_ent.takedamage)
    {
        trace_ent.axhitme = TRUE;
        SpawnBlood(org, '0 0 0', 20);
        T_Damage(trace_ent, self, self, 50);
    }
    else
    {
        // hit wall
        sound(self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
        WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
        WriteByte(MSG_BROADCAST, TE_GUNSHOT);
        WriteCoord(MSG_BROADCAST, org_x);
        WriteCoord(MSG_BROADCAST, org_y);
        WriteCoord(MSG_BROADCAST, org_z);
    }
	self.solid = SOLID_SLIDEBOX;
};


//============================================================================

vector() wall_velocity =
{
    local vector vel;

    vel = normalize(self.velocity);
    vel = normalize(vel + v_up * (random() - 0.5) + v_right * (random() - 0.5));
    vel = vel + 2 * trace_plane_normal;
    vel = vel * 200;

    return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
    local entity missile;

    missile = spawn();
    missile.owner = self;
    missile.movetype = MOVETYPE_BOUNCE;
    missile.solid = SOLID_NOT;

    makevectors(self.angles);

    missile.velocity = vel;
    missile.velocity_z = missile.velocity_z + 250 + 50 * random();

    missile.avelocity = '3000 1000 2000';

    // set missile duration
    missile.nextthink = time + 1;
    missile.think = SUB_Remove;

    setmodel(missile, "progs/zom_gib.mdl");
    setsize(missile, '0 0 0', '0 0 0');
    setorigin(missile, org);
};


/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood =
{
    particle(org, vel * 0.1, 73, damage * 2);
};


/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
    local vector vel;

    vel = wall_velocity() * 0.2;
    SpawnBlood(self.origin + vel * 0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
void(vector org, vector vel) SpawnChunk =
{
    particle(org, vel * 0.02, 0, 10);
};


/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity	multi_ent;
float	multi_damage;
float multi_knock;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
	multi_knock = 0;
};

void(float kick) ApplyMultiDamage =
{
	if (!multi_ent)
		return;

	T_Damage (multi_ent, self, self, multi_damage, multi_knock);
};

void(entity hit, float damage, float kick) AddMultiDamage =
{
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		multi_knock = 1;
		ApplyMultiDamage (kick);
		multi_damage = damage;
		multi_ent = hit;
		multi_knock = 0;
	}
	else
	{
		multi_damage = multi_damage + damage;
		multi_knock += kick;
	}
};
/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/

void(float damage, vector dir, float kick) TraceAttack =
{
	local	vector	vel, org;

	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{	
		SpawnBlood (org, vel*0.2, damage*1.25);

		AddMultiDamage (trace_ent, damage, kick);
	}
	else
	{	
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread, float damage, float kick) FireBullets =
{
    local vector direction;
    local vector src;

    makevectors(self.v_angle);

    src = self.origin + v_forward * 10;
    src_z = self.absmin_z + self.size_z * 0.7;

    ClearMultiDamage();

    while (  shotcount --)
    {
        direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;

        traceline(src, src + direction * 2048, FALSE, self);
        if (trace_fraction != 1.0)
        {
            TraceAttack(damage, direction, kick);
        }
    }
    ApplyMultiDamage(kick);
};


/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
    local vector dir;

    sound(self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);

    self.punchangle_x = -2;

    self.currentammo = self.ammo_shells = self.ammo_shells - 1;
    dir = aim(self, 100000);
    FireBullets(SHOTGUN_PELLETS, dir, '0.03 0.03 0', 6, 2);
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
    local vector dir;

    if (self.currentammo == 1)
    {
        W_FireShotgun();
        return;
    }

    sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);

    self.punchangle_x = -4;

    self.currentammo = self.ammo_shells = self.ammo_shells - 2;
    dir = aim(self, 100000);
    FireBullets(SSHOTGUN_PELLETS, dir, '0.14 0.08 0', 6, 3);
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void() s_explode1 = [ 0, s_explode2 ] {};
void() s_explode2 = [ 1, s_explode3 ] {};
void() s_explode3 = [ 2, s_explode4 ] {};
void() s_explode4 = [ 3, s_explode5 ] {};
void() s_explode5 = [ 4, s_explode6 ] {};
void() s_explode6 = [ 5, SUB_Remove ] {};

void() BecomeExplosion =
{
    self.movetype = MOVETYPE_NONE;
    self.velocity = '0 0 0';
    self.touch = SUB_Null;
    setmodel(self, "progs/s_explod.spr");
    self.solid = SOLID_NOT;
    s_explode1();
};


void() T_MissileTouch =
{
    local float damg;

    if (other == self.owner)
    {
        return; // don't explode on owner
    }

    if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove(self);
        return;
    }

    damg = 100 + random() * 20;

    if (other.health)
    {
        if (other.classname == "monster_shambler")
        {
            damg = damg * 0.5; // mostly immune
        }
        T_Damage(other, self, self.owner, damg, 50);
    }

    // don't do radius damage to the other, because all the damage
    // was done in the impact
    T_RadiusDamage(self, self.owner, 120, other);

    //sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
    self.origin = self.origin - 8 * normalize(self.velocity);

    WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte(MSG_BROADCAST, TE_EXPLOSION);
    WriteCoord(MSG_BROADCAST, self.origin_x);
    WriteCoord(MSG_BROADCAST, self.origin_y);
    WriteCoord(MSG_BROADCAST, self.origin_z);

    BecomeExplosion();
};


/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
    local entity missile;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

    sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

    self.punchangle_x = -2;

    missile = spawn();
    missile.owner = self;
    missile.movetype = MOVETYPE_FLY;
    missile.solid = SOLID_BBOX;
    missile.classname = "missile";

    // set missile speed
    makevectors(self.v_angle);
    missile.velocity = aim(self, 1000);
    missile.velocity = missile.velocity * 1000;
    missile.angles = vectoangles(missile.velocity);

    missile.touch = T_MissileTouch;

    // set missile duration
    missile.nextthink = time + 5;
    missile.think = SUB_Remove;

    setmodel(missile, "progs/missile.mdl");
    setsize(missile, '0 0 0', '0 0 0');
    setorigin(missile, self.origin + v_forward * 8 + '0 0 16');
	CheckDodge(missile.origin, aim(self, 10000), 1000);

};


/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity shooter, float dmg, float kick, float tempent, float len) fireRail =
{
	local vector end;
	local vector from;
	local entity ignore;

	end = p1 + p2 * len;
	from = p1;

	ignore = self;

	while(ignore)
	{
		traceline (from, end, FALSE, ignore);

		if((trace_ent.flags & FL_MONSTER) || (trace_ent.flags & FL_CLIENT))
			ignore = trace_ent;
		else
			ignore = __NULL__;
		
		if((trace_ent != self) && (trace_ent.takedamage))
		{
			particle (trace_endpos, '0 0 100', 225, dmg*4);
			T_Damage (trace_ent, shooter, shooter, dmg, kick);
		}
		
		from = trace_endpos;
	}
		
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    	WriteByte(MSG_BROADCAST, tempent);
    	WriteEntity(MSG_BROADCAST, shooter);
    	WriteCoord(MSG_BROADCAST, p1_x);
    	WriteCoord(MSG_BROADCAST, p1_y);
    	WriteCoord(MSG_BROADCAST, p1_z);
    	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
};

.float dmg_rad;
.float dmg_lsr;

void() tbspray =
{
	local	entity target; 
	local float points, dist;
	local vector org;
	
// literal copy of quake 2's code
	for (target = findradius(self.origin, self.dmg_rad); target; target= target.chain)
	{
    		if(!target.takedamage)
                	continue;
        	if(target == self.owner)
                	continue;
        	if(!CanDamage(target, self.owner))
            	continue;
        	if(!CanDamage(target, self))
            	continue;
		if((target.movetype == MOVETYPE_PUSH))
			continue;
		if((target.movetype == MOVETYPE_NONE))
			continue;
		if((target.classname == "explo_box"))
			continue;

        	org = target.origin + (target.mins + target.maxs) * 0.5;
		dist = vlen(self.origin - org);
        	points = self.dmg * (1.0 - sqrt(dist / self.dmg_rad)); 
        	if (points < 0)
            	points = 0;
                    
        	if (points > 0)
        	{	
			T_Damage (target, self, self.owner, points, points * 0.5);  
			dprint("bfg damage: ");
			dprint(ftos(points));
			dprint("\n");
        	}
		
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, 6);

		if(self.owner.flags & FL_CLIENT)
			WriteEntity(MSG_BROADCAST, target);
		else
			WriteEntity(MSG_BROADCAST, self);

		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		WriteCoord(MSG_BROADCAST, target.origin_x);
		WriteCoord(MSG_BROADCAST, target.origin_y);
		WriteCoord(MSG_BROADCAST, target.origin_z);
	}
	if (!target)
		return;
};

void() tbThink =
{      
	local	entity ent, ignore;
	local vector point, dir, end, from;

	if(time > self.dspeed)
		remove(self);
		
// literal copy of quake 2's code
	
	for (ent= findradius(self.origin, 256); ent; ent = ent.chain)
	{
		if(!ent.takedamage)
                	continue;
        	if(ent== self.owner)
                	continue;
        	if(!CanDamage(ent, self))
            	continue;
		if((ent.movetype == MOVETYPE_PUSH))
			continue;
		if((ent.movetype == MOVETYPE_NONE))
			continue;
		if((ent.classname == "explo_box"))
			continue;
		
		point = (ent.maxs - ent.mins) * 0.5 + ent.absmin;	
		dir = normalize (point - self.origin);
		
		ignore = self;
		
		from = self.origin;
		end = self.origin + dir*2048;	
		
		while(1)
		{
			traceline (from, end, FALSE, ignore);

			if (!trace_ent)
				break;
		
			if((trace_ent != self.owner) && (trace_ent.takedamage))
			{
				T_Damage (trace_ent, self, self.owner, self.dmg_lsr, 0);
				particle (trace_ent.origin, '0 0 100', 225, self.dmg_lsr* 8);
			}
			
			if(!(trace_ent.flags & FL_MONSTER) && !(trace_ent.flags & FL_CLIENT))
			{
				WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte (MSG_BROADCAST, TE_GUNSHOT);
				WriteCoord (MSG_BROADCAST, trace_endpos_x);
				WriteCoord (MSG_BROADCAST, trace_endpos_y);
				WriteCoord (MSG_BROADCAST, trace_endpos_z);
			}
			
			ignore = trace_ent;
			from = trace_endpos;
		}

		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, 6);

		if(self.owner.flags & FL_CLIENT)
			WriteEntity(MSG_BROADCAST, ent);
		else
			WriteEntity(MSG_BROADCAST, self);

		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		WriteCoord(MSG_BROADCAST, trace_endpos_x);
		WriteCoord(MSG_BROADCAST, trace_endpos_y);
		WriteCoord(MSG_BROADCAST, trace_endpos_z);

		sound (self, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
	}

	self.think = tbThink;
	self.nextthink = time + 0.12;
};

void() T_tbTouch =
{ 
	self.effects = 0;

	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.takedamage)
	{
		T_Damage (other, self, self.owner, 120, 50);
	}
	self.origin = self.origin - 8*normalize(self.velocity);

	T_RadiusDamage (self, self.owner, 120, other);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteByte (MSG_BROADCAST, 244);
	WriteByte (MSG_BROADCAST, 3);

      tbspray ();
	remove(self);
};

void(vector dir, vector org) launch_thunderball =
{
	newmis = spawn ();
	newmis.angles = vectoangles(dir);
	newmis.effects = newmis.effects | EF_BLUE;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	
	newmis.owner = self;
	newmis.classname = "thunderball";
	newmis.dspeed = time + 6;
	newmis.avelocity = '300 300 300';

	newmis.think = tbThink;
	newmis.touch = T_tbTouch;
	newmis.nextthink = time + 0.12;
	newmis.velocity = dir * 400;
		
	setmodel (newmis, "progs/plasma.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);	
	setorigin (newmis, org);
	
	if (self.flags & FL_CLIENT)
		CheckDodge(newmis.origin, dir, 650);
};

void() W_FireLightning =
{
	local	vector		org;
	local   float           cells;

	if (self.ammo_cells < 12)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35*cells, world);
		return;
	}

	self.punchangle_x = -2;
	self.currentammo = self.ammo_cells = self.ammo_cells - 12;
	org = self.origin + '0 0 16';
	
	launch_thunderball (aim (self, 1000), self.origin + '0 0 16' + v_forward * 24);
	newmis.dmg_rad = 1000;

	if (!deathmatch)
	{
		newmis.dmg = 300;
		newmis.dmg_lsr = 10;
	}
	else 
	{
		newmis.dmg = 150;
		newmis.dmg_lsr = 5;
	}
};

//=============================================================================

void() GrenadeExplode =
{
    T_RadiusDamage(self, self.owner, 120, world);

    WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte(MSG_BROADCAST, TE_EXPLOSION);
    WriteCoord(MSG_BROADCAST, self.origin_x);
    WriteCoord(MSG_BROADCAST, self.origin_y);
    WriteCoord(MSG_BROADCAST, self.origin_z);

    BecomeExplosion();
};


void() GrenadeTouch =
{
    if (other == self.owner)
    {
        return; // don't explode on owner
    }

    if (other.takedamage == DAMAGE_AIM)
    {
        GrenadeExplode();
        return;
    }

    sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM); // bounce sound

    if (self.velocity == '0 0 0')
    {
        self.avelocity = '0 0 0';
    }
};


/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{
    local entity missile;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

    sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

    self.punchangle_x = -2;

    missile = spawn();
    missile.owner = self;
    missile.movetype = MOVETYPE_BOUNCE;
    missile.solid = SOLID_BBOX;
    missile.classname = "grenade";

    // set missile speed
    makevectors(self.v_angle);
    if (self.v_angle_x)
    {
        missile.velocity = v_forward * 600 + v_up * 200 + crandom() * v_right * 10 + crandom() * v_up * 10;
    }
    else
    {
        missile.velocity = aim(self, 10000);
        missile.velocity = missile.velocity * 600;
        missile.velocity_z = 200;
    }

    missile.avelocity = '300 300 300';

    missile.angles = vectoangles(missile.velocity);

    missile.touch = GrenadeTouch;

    // set missile duration
    missile.nextthink = time + 2.5;
    missile.think = GrenadeExplode;

    setmodel(missile, "progs/grenade.mdl");
    setsize(missile, '0 0 0', '0 0 0');
    setorigin(missile, self.origin);
	CheckDodge(missile.origin, aim(self, 10000), 600);
};


//=============================================================================

void() spike_touch;
void() superspike_touch;

/*
===============
launch_spike

Used for both the player and the ogre
===============
*/

void() Laser_Touch =
{
	local vector org;
	local float dmg;
	
	if (self.owner.flags & FL_FLY)
		dmg = 5;
	else
		dmg = 15;
	
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
		SpawnBlood (org, self.velocity*0.2, dmg);
		T_Damage (other, self, self.owner, dmg, 2);
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

void(vector org, vector vec) LaunchLaser =
{
	vec = normalize(vec);
	local float speed;	

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		

	setorigin (newmis, org);
	
	if(self.classname == "monster_tank" || self.classname == "monster_medic")
		speed = 800;
	else if((self.flags & FL_FLY))
		speed = 1000;
	else
		speed = 600;

	newmis.velocity = vec * speed;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.ltime = time + 5;
	newmis.modelflags = MF_GRENADE;
	newmis.touch = Laser_Touch;
};

void(vector org, vector dir) launch_spike =
{
	local float speed;
	
	if(self.classname == "monster_tank")
		speed = 550; // rockets :)
	else if(self.classname == "player")
		speed = 1200;
	else 
		speed = 1000;

    newmis = spawn();
    newmis.owner = self;
    newmis.movetype = MOVETYPE_FLY;
    newmis.solid = SOLID_BBOX;

    newmis.angles = vectoangles(dir);

    newmis.touch = spike_touch;
    newmis.classname = "spike";
    newmis.think = SUB_Remove;
    newmis.nextthink = time + 6;
    setmodel(newmis, "progs/spike.mdl");
    setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
    setorigin(newmis, org);

    newmis.velocity = dir * speed;
};


void() W_FireSuperSpikes =
{
    local vector dir;

    sound(self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
    self.attack_finished = time + 0.2;
    self.currentammo = self.ammo_nails = self.ammo_nails - 2;
    dir = aim(self, 1000);
    launch_spike(self.origin + '0 0 16', dir);
    newmis.touch = superspike_touch;
    setmodel(newmis, "progs/s_spike.mdl");
    setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
    self.punchangle_x = -2;
	CheckDodge(newmis.origin, aim(self, 10000), 1000);
};


void(float ox) W_FireSpikes =
{
    local vector dir;

    makevectors(self.v_angle);

    if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
    {
        W_FireSuperSpikes();
        return;
    }

    if (self.ammo_nails < 1)
    {
        self.weapon = W_BestWeapon();
        W_SetCurrentAmmo();
        return;
    }

    sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
    self.attack_finished = time + 0.2;
    self.currentammo = self.ammo_nails = self.ammo_nails - 1;
    dir = aim(self, 1000);
    launch_spike (self.origin + '0 0 16' + v_right * ox, dir);

    self.punchangle_x = -2;

	CheckDodge(newmis.origin, aim(self, 10000), 1000);

};


void() spike_touch =
{
	local float dmg;
	
	if(self.owner.classname == "player")
		dmg = 10;
	else
		dmg = 8;
	
    if (other == self.owner)
    {
        return;
    }
    if (other.solid == SOLID_TRIGGER)
    {
        return; // trigger field, do nothing
    }

    if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove(self);
        return;
    }

    // hit something that bleeds
    if (other.takedamage)
    {
        spawn_touchblood(dmg);
        T_Damage(other, self, self.owner, dmg, 2);
    }
    else
    {
        WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
        if (self.classname == "wizspike")
        {
            WriteByte(MSG_BROADCAST, TE_WIZSPIKE);
        }
        else if (self.classname == "knightspike")
        {
            WriteByte(MSG_BROADCAST, TE_KNIGHTSPIKE);
        }
        else
        {
            WriteByte(MSG_BROADCAST, TE_SPIKE);
        }
        WriteCoord(MSG_BROADCAST, self.origin_x);
        WriteCoord(MSG_BROADCAST, self.origin_y);
        WriteCoord(MSG_BROADCAST, self.origin_z);
    }

    remove(self);
};


void() superspike_touch =
{	
	local float dmg;
	
	if(self.owner.classname == "player")
		dmg = 20;
	else
		dmg = 16;

    if (other == self.owner)
    {
        return;
    }
    if (other.solid == SOLID_TRIGGER)
    {
        return; // trigger field, do nothing
    }

    if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove(self);
        return;
    }

    // hit something that bleeds
    if (other.takedamage)
    {
        spawn_touchblood(dmg);
        T_Damage(other, self, self.owner, dmg, 3);
    }
    else
    {
        WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
        WriteByte(MSG_BROADCAST, TE_SUPERSPIKE);
        WriteCoord(MSG_BROADCAST, self.origin_x);
        WriteCoord(MSG_BROADCAST, self.origin_y);
        WriteCoord(MSG_BROADCAST, self.origin_z);
    }

    remove(self);
};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/
void()	player_run;

void() W_SetCurrentAmmo =
{
    player_run(); // get out of any weapon firing states

    self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

    if (self.weapon == IT_AXE)
    {
        self.currentammo = 0;
        self.weaponmodel = "progs/v_axe.mdl";
        self.weaponframe = 0;
    }
    else if (self.weapon == IT_SHOTGUN)
    {
        self.currentammo = self.ammo_shells;
        self.weaponmodel = "progs/v_shot.mdl";
        self.weaponframe = 0;
        self.items = self.items | IT_SHELLS;
    }
    else if (self.weapon == IT_SUPER_SHOTGUN)
    {
        self.currentammo = self.ammo_shells;
        self.weaponmodel = "progs/v_shot2.mdl";
        self.weaponframe = 0;
        self.items = self.items | IT_SHELLS;
    }
    else if (self.weapon == IT_NAILGUN)
    {
        self.currentammo = self.ammo_nails;
        self.weaponmodel = "progs/v_nail.mdl";
        self.weaponframe = 0;
        self.items = self.items | IT_NAILS;
    }
    else if (self.weapon == IT_SUPER_NAILGUN)
    {
        self.currentammo = self.ammo_nails;
        self.weaponmodel = "progs/v_nail2.mdl";
        self.weaponframe = 0;
        self.items = self.items | IT_NAILS;
    }
    else if (self.weapon == IT_GRENADE_LAUNCHER)
    {
        self.currentammo = self.ammo_rockets;
        self.weaponmodel = "progs/v_rock.mdl";
        self.weaponframe = 0;
        self.items = self.items | IT_ROCKETS;
    }
    else if (self.weapon == IT_ROCKET_LAUNCHER)
    {
        self.currentammo = self.ammo_rockets;
        self.weaponmodel = "progs/v_rock2.mdl";
        self.weaponframe = 0;
        self.items = self.items | IT_ROCKETS;
    }
    else if (self.weapon == IT_LIGHTNING)
    {
        self.currentammo = self.ammo_cells;
        self.weaponmodel = "progs/v_light.mdl";
        self.weaponframe = 0;
        self.items = self.items | IT_CELLS;
    }
    else
    {
        self.currentammo = 0;
        self.weaponmodel = "";
        self.weaponframe = 0;
    }
};


float() W_BestWeapon =
{
    local float it;

    it = self.items;

    if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING))
    {
        return IT_LIGHTNING;
    }
    if (self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN))
    {
        return IT_SUPER_NAILGUN;
    }
    if (self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN))
    {
        return IT_SUPER_SHOTGUN;
    }
    if (self.ammo_nails >= 1 && (it & IT_NAILGUN))
    {
        return IT_NAILGUN;
    }
    if (self.ammo_shells >= 1 && (it & IT_SHOTGUN))
    {
        return IT_SHOTGUN;
    }

    return IT_AXE;
};


float() W_CheckNoAmmo =
{
    if (self.currentammo > 0)
    {
        return TRUE; // has at least one ammo
    }

    if (self.weapon == IT_AXE)
    {
        return TRUE; // weapon doesn't need ammo
    }

    self.weapon = W_BestWeapon();

    W_SetCurrentAmmo();

    // drop the weapon down
    return FALSE;
};



/*
============
W_ChangeWeapon
============
*/
void() W_ChangeWeapon =
{
    local float it, am, fl;

    it = self.items;
    am = FALSE;

    if (self.impulse == 1)
    {
        fl = IT_AXE;
    }
    else if (self.impulse == 2)
    {
        fl = IT_SHOTGUN;
        if (self.ammo_shells < 1)
        {
            am = TRUE;
        }
    }
    else if (self.impulse == 3)
    {
        fl = IT_SUPER_SHOTGUN;
        if (self.ammo_shells < 2)
        {
            am = TRUE;
        }
    }
    else if (self.impulse == 4)
    {
        fl = IT_NAILGUN;
        if (self.ammo_nails < 1)
        {
            am = TRUE;
        }
    }
    else if (self.impulse == 5)
    {
        fl = IT_SUPER_NAILGUN;
        if (self.ammo_nails < 2)
        {
            am = TRUE;
        }
    }
    else if (self.impulse == 6)
    {
        fl = IT_GRENADE_LAUNCHER;
        if (self.ammo_rockets < 1)
        {
            am = TRUE;
        }
    }
    else if (self.impulse == 7)
    {
        fl = IT_ROCKET_LAUNCHER;
        if (self.ammo_rockets < 1)
        {
            am = TRUE;
        }
    }
    else if (self.impulse == 8)
    {
        fl = IT_LIGHTNING;
        if (self.ammo_cells < 1)
        {
            am = TRUE;
        }
    }

    self.impulse = 0;

    if (!(self.items & fl))
    {
        // don't have the weapon or the ammo
        sprint(self, "no weapon.\n");
        return;
    }

    if (am)
    {
        // don't have the ammo
        sprint(self, "not enough ammo.\n");
        return;
    }

    //
    // set weapon, set ammo
    //
    self.weapon = fl;
    W_SetCurrentAmmo();
};


/*
============
CheatCommand
============
*/
void() CheatCommand =
{
    if (deathmatch || coop)
    {
        return;
    }

    self.ammo_rockets = 100;
    self.ammo_nails = 200;
    self.ammo_shells = 100;
    self.items = self.items |
                 IT_AXE |
                 IT_SHOTGUN |
                 IT_SUPER_SHOTGUN |
                 IT_NAILGUN |
                 IT_SUPER_NAILGUN |
                 IT_GRENADE_LAUNCHER |
                 IT_ROCKET_LAUNCHER;

    self.ammo_cells = 100;
    self.items = self.items | IT_LIGHTNING;

    self.impulse = 0;
    W_SetCurrentAmmo();
};


/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
    local float it, am;

    it = self.items;
    self.impulse = 0;

    while (TRUE)
    {
        am = FALSE;

        if (self.weapon == IT_LIGHTNING)
        {
            self.weapon = IT_AXE;
        }
        else if (self.weapon == IT_AXE)
        {
            self.weapon = IT_SHOTGUN;
            if (self.ammo_shells < 1)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_SHOTGUN)
        {
            self.weapon = IT_SUPER_SHOTGUN;
            if (self.ammo_shells < 2)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_SUPER_SHOTGUN)
        {
            self.weapon = IT_NAILGUN;
            if (self.ammo_nails < 1)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_NAILGUN)
        {
            self.weapon = IT_SUPER_NAILGUN;
            if (self.ammo_nails < 2)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_SUPER_NAILGUN)
        {
            self.weapon = IT_GRENADE_LAUNCHER;
            if (self.ammo_rockets < 1)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_GRENADE_LAUNCHER)
        {
            self.weapon = IT_ROCKET_LAUNCHER;
            if (self.ammo_rockets < 1)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_ROCKET_LAUNCHER)
        {
            self.weapon = IT_LIGHTNING;
            if (self.ammo_cells < 1)
            {
                am = TRUE;
            }
        }

        if ((it & self.weapon) && am == FALSE)
        {
            W_SetCurrentAmmo();
            return;
        }
    }
};


/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
    local float it, am;

    it = self.items;
    self.impulse = 0;

    while (TRUE)
    {
        am = FALSE;

        if (self.weapon == IT_LIGHTNING)
        {
            self.weapon = IT_ROCKET_LAUNCHER;
            if (self.ammo_rockets < 1)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_ROCKET_LAUNCHER)
        {
            self.weapon = IT_GRENADE_LAUNCHER;
            if (self.ammo_rockets < 1)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_GRENADE_LAUNCHER)
        {
            self.weapon = IT_SUPER_NAILGUN;
            if (self.ammo_nails < 2)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_SUPER_NAILGUN)
        {
            self.weapon = IT_NAILGUN;
            if (self.ammo_nails < 1)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_NAILGUN)
        {
            self.weapon = IT_SUPER_SHOTGUN;
            if (self.ammo_shells < 2)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_SUPER_SHOTGUN)
        {
            self.weapon = IT_SHOTGUN;
            if (self.ammo_shells < 1)
            {
                am = TRUE;
            }
        }
        else if (self.weapon == IT_SHOTGUN)
        {
            self.weapon = IT_AXE;
        }
        else if (self.weapon == IT_AXE)
        {
            self.weapon = IT_LIGHTNING;
            if (self.ammo_cells < 1)
            {
                am = TRUE;
            }
        }

        if ((it & self.weapon) && am == FALSE)
        {
            W_SetCurrentAmmo();
            return;
        }
    }
};

void()	player_axe1;
void()	player_axeb1;
void()	player_axec1;
void()	player_axed1;
void()	player_shot1; 
void()	player_nail1;
void()	player_light1;
void()	player_rocket1;


void() W_Attack =
{

	if (!W_CheckNoAmmo ())
		return;

	local float r; r = random();

    if (!W_CheckNoAmmo())
    {
        return;
    }

    makevectors(self.v_angle); // calculate forward angle for velocity
    self.show_hostile = time + 1; // wake monsters up

    if (self.weapon == IT_AXE)
    {
        sound(self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);

        if (r < 0.25)
        {
            player_axe1();
        }
        else if (r < 0.5)
        {
            player_axeb1();
        }
        else if (r < 0.75)
        {
            player_axec1();
        }
        else
        {
            player_axed1();
        }
        	self.attack_finished = time + 0.5;
    	}
    	else if (self.weapon == IT_SHOTGUN)
    	{
        player_shot1();
	self.solid = SOLID_BBOX;
        W_FireShotgun();
	self.solid = SOLID_SLIDEBOX;
        self.attack_finished = time + 0.5;
    	}
    	else if (self.weapon == IT_SUPER_SHOTGUN)
    	{
        player_shot1();
	self.solid = SOLID_BBOX;
        W_FireSuperShotgun();
	self.solid = SOLID_SLIDEBOX;
        self.attack_finished = time + 0.7;
    	}
    	else if (self.weapon == IT_NAILGUN)
    	{
        	player_nail1();
    	}
    	else if (self.weapon == IT_SUPER_NAILGUN)
    	{
        	player_nail1();
    	}
    	else if (self.weapon == IT_GRENADE_LAUNCHER)
    	{
        	player_rocket1();
        	W_FireGrenade();
        	self.attack_finished = time + 0.6;
    	}
    	else if (self.weapon == IT_ROCKET_LAUNCHER)
    	{
        	player_rocket1();
        	W_FireRocket();
        	self.attack_finished = time + 0.8;
    	}
	
	else if (self.weapon == IT_LIGHTNING)
	{
		player_light1();
		W_FireLightning();
		self.attack_finished = time + 1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
		//stuffcmd (self, "vibrate tactile/weapons/lstart.bnvib");
	}

};

/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand =
{
    serverflags = serverflags * 2 + 1;
};


void() QuadCheat =
{
    if (deathmatch || coop)
    {
        return;
    }

    self.super_time = 1;
    self.super_damage_finished = time + 30;
    self.items = self.items | IT_QUAD;
    dprint("quad cheat\n");
};

/*
============
ImpulseCommands

============
*/
void() ImpulseCommands =
{
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

	if (self.impulse == 9)
		CheatCommand ();
	if (self.impulse == 10)
		CycleWeaponCommand ();
	if (self.impulse == 11)
		ServerflagsCommand ();
	if (self.impulse == 12)
		CycleWeaponReverseCommand ();
	if (self.impulse == 210)

	if (self.impulse == 255)
		QuadCheat ();
		
	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_Attack; void() ImpulseCommands;

void() W_WeaponFrame =
{
    if (time < self.attack_finished)
    {
        return;
    }

    ImpulseCommands();

    // check for attack
    if (self.button0)
    {
        SuperDamageSound();
        W_Attack();
    }
};


/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
    if (self.super_damage_finished > time)
    {
        if (self.super_sound < time)
        {
            self.super_sound = time + 1;
            sound(self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
        }
    }
    return;
};