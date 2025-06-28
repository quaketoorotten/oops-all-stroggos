
/*

A monster is in fight mode if it thinks it can effectively attack its
enemy.

When it decides it can't attack, it goes into hunt mode.

*/

float RANGE_CLOSE = 1;

float(float v) anglemod;

float()	DemonCheckAttack;
void(float side)	Demon_Melee;

void(vector dest) ChooseTurn;

void() ai_face;


float	enemy_vis, enemy_infront, enemy_range;
float	enemy_yaw;


//=============================================================================

