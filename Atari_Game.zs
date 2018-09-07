// Atari Game Script
// v0.3
// 24th August, 2018
// By: ZoriaRPG

import "std.zh"

const float MOVE_RATE = 1;

const int PLAYER_WIDTH = 5;
const int PLAYER_HEIGHT = 8;

const int MIN_ZC_ALPHA_BUILD = 35; //Alphas are negatives, so we neex to check maximum, not minimum.

typedef const int DEFINE;

//PALETTE INDEX COLUMN FOR EACH GAME OBJECT



DEFINE COL_BACKGROUND 		= 0x00;
DEFINE COL_PLAYFIELD 		= 0x10;
DEFINE COL_DOOR 		= 0x01;
DEFINE COL_PLAYER 		= 0x02;
DEFINE COL_WALL 		= 0x04;

DEFINE COL_ENEMY_WEAPON 	= 0x08;
DEFINE COL_PLAYER_WEAPON 	= 0x09;
DEFINE COL_ENEMY 		= 0x0A;

DEFINE COL_ITEM 		= 0x0F;

DEFINE NUM_PLAYERS = 5;



typedef ffc sprite;

sprite player[NUM_PLAYERS];

bitmap playfield;

ffc script Player
{
	DEFINE ACTION_SPRITE = 0;
	DEFINE ACTION_SLOT = 1;
	DEFINE ACTION_COMBO = 188;
	
	DEFINE ACTION_HEIGHT = 8;
	DEFINE ACTION_WIDTH = 5;
	void run(){}
	void init(sprite s, int sprite_index, int sprite_combo, int screen_slot)
	{
		
		s[sprite_index] = Screen->LoadFFC(screen_slot);
		s[sprite_index]->Data = sprite_combo;
	}
	
	
	void move_sprite(sprite s, int sprite_index, bitmap bmp, int sprite_height, int sprite_width, int check_col)
	{
		if ( Input->Press[CB_LEFT] ) 
		{
			if ( canmove(DIR_LEFT, s, sprite_index, bmp, sprite_height, sprite_width, check_col) )
			{
				--s[sprite_index]->X;
			}
		}
		if ( Input->Hold[CB_LEFT] ) 
		{
			if ( canmove(DIR_LEFT, s, sprite_index, bmp, sprite_height, sprite_width, check_col) )
			{
				--s[sprite_index]->X;
			}
		}
		if ( Input->Press[CB_DOWN] ) 
		{
			if ( canmove(DIR_DOWN, s, sprite_index, bmp, sprite_height, sprite_width, check_col) )
			{
				++s[sprite_index]->Y;
			}
		}
		if ( Input->Hold[CB_DOWN] ) 
		{
			if ( canmove(DIR_DOWN, s, sprite_index, bmp, sprite_height, sprite_width, check_col) )
			{
				++s[sprite_index]->Y;
			}
		}
		if ( Input->Press[CB_UP] ) 
		{
			if ( canmove(DIR_UP, s, sprite_index, bmp, sprite_height, sprite_width, check_col) )
			{
				--s[sprite_index]->Y;
			}
		}
		if ( Input->Hold[CB_UP] ) 
		{
			if ( canmove(DIR_UP, s, sprite_index, bmp, sprite_height, sprite_width, check_col) )
			{
				--s[sprite_index]->Y;
			}
		}
		if ( Input->Press[CB_RIGHT] ) 
		{
			if ( canmove(DIR_RIGHT, s, sprite_index, bmp, sprite_height, sprite_width, check_col) )
			{
				++s[sprite_index]->X;
			}
		}
		if ( Input->Hold[CB_RIGHT] ) 
		{
			if ( canmove(DIR_RIGHT, s, sprite_index, bmp, sprite_height, sprite_width, check_col) )
			{
				++s[sprite_index]->X;
			}
		}

	}
	
	//bool canmove(int dir, ffc p, bitmap bmp)
	bool canmove(int dir, sprite p, int sprite_index, bitmap bmp, int sprite_height, int sprite_width, int check_col) 
	//canmove(dir, player, INDEX, playfield, PLAYER_HEIGHT, PLAYER_WIDTH, COL_PLAYFIELD);
	//sprite width = PLAYER_WIDTH
	//sprite height = PLAYER_HEIGHT
	//check_col is the pixel CSet column to check against, 16 for the player?
	{
		//int col[8]; 
		//bool coll = true;
		switch(dir)
		{
			
			case DIR_RIGHT:
			{
				TraceS("Right");
				/*
				for ( int q = 0; q < sprite_height; ++q )
				{
					col[q] = bmp->GetPixel(p->X+sprite_width, p->Y+q) * 10000;
					Trace(bmp->GetPixel(p->X-1, p->Y+q));
				}
				*/
				for ( int q = 0; q < sprite_height; ++ q )
				{
					if ( ( (bmp->GetPixel(p->X+sprite_width, p->Y+q) * 10000) % check_col ) != 0 ) 
					{
						TraceNL(); TraceS("Pixel Colour Was: "); Trace((bmp->GetPixel(p->X+sprite_width, p->Y+q) * 10000));
						return false;
					}
				}
				return true;
			}
			case DIR_LEFT:
			{
				TraceS("Left");
				/*
				for ( int q = 0; q < sprite_height; ++q )
				{
					col[q] = bmp->GetPixel(p->X-1, p->Y+q) * 10000;
					Trace(bmp->GetPixel(p->X-1, p->Y+q));
				}
				*/
				for ( int q = 0; q < sprite_height; ++q )
				{
					if ( ( (bmp->GetPixel(p->X-1, p->Y+q) * 10000) % check_col ) != 0 ) 
					{
						TraceNL(); TraceS("Pixel Colour Was: "); Trace((bmp->GetPixel(p->X-1, p->Y+q) * 10000));
						return false;
					}
				}
				return true;
			}
			case DIR_UP:
			{
				TraceS("Up");
				/*
				for ( int q = 0; q < sprite_width; ++q )
				{
					col[q] = bmp->GetPixel(p->X+q, p->Y-1) * 10000;
					Trace(bmp->GetPixel(p->X-1, p->Y+q));
				}
				*/
				for ( int q = 0; q < sprite_width; ++ q )
				{
					if ( ( (bmp->GetPixel(p->X+q, p->Y-1) * 10000) % check_col ) != 0 ) 
					{
						TraceNL(); TraceS("Pixel Colour Was: "); Trace((bmp->GetPixel(p->X+q, p->Y-1) * 10000));
						return false;
					}
				}
				return true;
			}
			case DIR_DOWN:
			{
				TraceS("Down");
				/*
				for ( int q = 0; q < sprite_width; ++q )
				{
					col[q] = bmp->GetPixel(p->X+q, p->Y+sprite_height) * 10000;
					Trace(bmp->GetPixel(p->X-1, p->Y+q));
				}
				*/
				for ( int q = 0; q < sprite_width; ++q )
				{
					if ( ( (bmp->GetPixel(p->X+q, p->Y+sprite_height) * 10000) % check_col ) != 0 ) 
					{
						TraceNL(); TraceS("Pixel Colour Was: "); Trace((bmp->GetPixel(p->X+q, p->Y+sprite_height) * 10000));
						return false;
					}
				}
				return true;
			}
			//default: return false;
		}
		return true;
	}
}

global script Atari
{
	const int PLAYFIELD = RT_SCREEN;
	void run()
	{

		link.init();
		Player.init(player, Player.ACTION_SPRITE, Player.ACTION_COMBO, Player.ACTION_SLOT);
		playfield = Game->LoadBitmapID(PLAYFIELD);
		
		
		check_min_zc_build();
		
		while(1)
		{
			
			Player.move_sprite( player, Player.ACTION_SPRITE, playfield, Player.ACTION_HEIGHT, Player.ACTION_WIDTH, COL_PLAYFIELD );
			
			link.hold(); //call after checking inputs
			Waitdraw();
			Waitframe();
		}
	}
	
	
	void check_min_zc_build()
	{
		if ( Game->Beta < MIN_ZC_ALPHA_BUILD )
		{
			//Game->PlayMIDI(9);
			int v_too_early = 600; int req_vers[3]; itoa(req_vers, MIN_ZC_ALPHA_BUILD);
			TraceNL(); int vers[3]; itoa(vers,Game->Beta);
			TraceS("This version of Atari.qst requires Zelda Classic v2.54, Alpha (");
			TraceS(req_vers);
			TraceS("), or later.");
			TraceNL();
			TraceS("I'm detecting Zelda Classic v2.54, Alpha (");
			TraceS(vers);
			TraceS(") and therefore, I must refuse to run. :) ");
			TraceNL();
			
			while(v_too_early--)
			{
				//Screen->DrawString(7, 4, 40, 1, 0x04, 0x5F, 0, 
				//"This version of Arkanoid.qst requires Zelda Classic 2.54, Alpha 32", 
				//128);
				Screen->DrawString(7, 15, 40, 1, 0x04, 0x5F, 0, 
				"You are not using a version of ZC adequate to run         ", 
				128);
				
				Screen->DrawString(7, 15, 55, 1, 0x04, 0x5F, 0, 
				"this quest. Please see allegro.log for details.                   ", 
				128);
			
				Waitdraw();
				WaitNoAction();
			}
			Game->End();
			
		}
	}
	
}


ffc script link
{
	const int DRAWYOFS = -32768;
	const int HOLDX = 60;
	const int HOLDY = 60;
	void run(){}
	void init()
	{
		Link->Invisible = true; Link->DrawYOffset = DRAWYOFS;
	}
	void hold()
	{
		Link->X = HOLDX; Link->Y = HOLDY;
	}
}

global script Init
{
	void run()
	{
		link.init();
	}
}

global script init
{
	void run()
	{
		link.init();
	}
}

global script onContinue
{
	void run()
	{
		link.init();
	}
}

ffc script Atari_version_0_4
{
	void run(){}
}

//End file.