// wow

void()	puff_anim1 =[ 0, puff_anim2 ] {self.alpha = 0.8;}
void()	puff_anim2 =[ 1, puff_anim3 ] {self.alpha = 0.6;}
void()	puff_anim3 =[ 2, puff_anim4 ] {}
void()	puff_anim4 =[ 3, SUB_Remove ] {}

void(vector org) m_puff =
{
	local entity puff;
	puff = spawn();
	setorigin(puff, org);
	puff.think = puff_anim1;
	puff.alpha = 1;
	setmodel(puff, "progs/smoke.mdl");
	puff.nextthink = time + 0.01;

	local entity flash;
	flash = spawn();
	setorigin(flash, org);
	flash.think = SUB_Remove;
	flash.scale = 2;
	flash.effects = EF_FULLBRIGHT;
	setmodel(flash, "progs/flash.mdl");
	flash.nextthink = time + 0.1;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_SPIKE);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_GUNSHOT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
}

void(float damage, vector dir, float kick) m_TraceAttack =
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
		m_puff (org);
};


void(float shotcount, vector start, vector dir, vector spread, float damage, float kick) monster_FireBullets =
{
    local vector direction;
    local vector src;

    makevectors(self.angles);
	
    m_puff (start + v_forward * 10);
    src = start + v_forward * 10;
    src_z = self.absmin_z + self.size_z * 0.7;

    ClearMultiDamage();

    while (  shotcount --)
    {
        direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;
		
        traceline(src, src + direction * 2048, FALSE, self);
        if (trace_fraction != 1.0)
        {
            m_TraceAttack(damage, direction, kick);
        }
    }
    ApplyMultiDamage(kick);
};

void() m_GrenadeExplode =
{
	T_RadiusDamage (self, self.owner, self.dmg, world);
	sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);

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

void() m_GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		m_GrenadeExplode();
		return;
	}
	sound (self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

void(vector org, vector dir, float damage) monster_FireNade =
{
	local	entity missile;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
		
// set missile speed	

	makevectors (self.angles);

	missile.velocity = normalize(dir);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = 200;
	missile.origin = org;
	missile.dmg = damage;

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = m_GrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = m_GrenadeExplode;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, missile.origin);
};