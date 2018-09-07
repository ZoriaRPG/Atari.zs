const float MOVE_RATE = 1;

const int PLAYER_WIDTH = 5;
const int PLAYER_HEIGHT = 8;

global script Atari
{
	void run()
	{

		ffc player = Screen->LoadFFC(1);
		player->Data = 188;
		bitmap playfield = Game->LoadBitmapID(RT_SCREEN);
		Link->Invisible = true; Link->DrawYOffset = -32768;
		while(1)
		{
			Link->X = 60; 
			Link->Y = 60;
			if ( Input->Press[CB_LEFT] ) 
			{
				if ( canmove(DIR_LEFT, player, playfield) )
				{
					--player->X;
				}
			}
			if ( Input->Hold[CB_LEFT] ) 
			{
				if ( canmove(DIR_LEFT, player, playfield) )
				{
					--player->X;
				}
			}
			if ( Input->Press[CB_DOWN] ) 
			{
				if ( canmove(DIR_DOWN, player, playfield) )
				{
					++player->Y;
				}
			}
			if ( Input->Hold[CB_DOWN] ) 
			{
				if ( canmove(DIR_DOWN, player, playfield) )
				{
					++player->Y;
				}
			}
			if ( Input->Press[CB_UP] ) 
			{
				if ( canmove(DIR_UP, player, playfield) )
				{
					--player->Y;
				}
			}
			if ( Input->Hold[CB_UP] ) 
			{
				if ( canmove(DIR_UP, player, playfield) )
				{
					--player->Y;
				}
			}
			if ( Input->Press[CB_RIGHT] ) 
			{
				if ( canmove(DIR_RIGHT, player, playfield) )
				{
					++player->X;
				}
			}
			if ( Input->Hold[CB_RIGHT] ) 
			{
				if ( canmove(DIR_RIGHT, player, playfield) )
				{
					++player->X;
				}
			}
			Waitdraw();
			Waitframe();
		}
	}
	bool canmove(int dir, ffc p, bitmap bmp)
	{
		int col[8]; bool coll = true;
		switch(dir)
		{
			case DIR_LEFT:
			{
				for ( int q = 0; q < 8; ++q )
				{
					col[q] = bmp->GetPixel(p->X-1, p->Y+q) * 10000;
				}
				
				for ( int q = 0; q < 8; ++q )
				{
					if ( ( col[q] % 16 ) != 0 ) 
					{
						return false;
					}
				}
				return true;
			}
			case DIR_RIGHT:
			{
				for ( int q = 0; q < 8; ++q )
				{
					col[q] = bmp->GetPixel(p->X+PLAYER_WIDTH, p->Y+q) * 10000;
				}
				for ( int q = 0; q < 8; ++ q )
				{
					if ( ( col[q] % 16 ) != 0 ) 
					{
						TraceNL(); TraceS("Pixel Colour Was: "); Trace(col);
						return false;
					}
				}
				return true;
			}
			case DIR_UP:
			{
				for ( int q = 0; q < 5; ++q )
				{
					col[q] = bmp->GetPixel(p->X+q, p->Y-1) * 10000;
				}
				for ( int q = 0; q < 8; ++ q )
				{
					if ( ( col[q] % 16 ) != 0 ) 
					{
						return false;
					}
				}
				return true;
			}
			case DIR_DOWN:
			{
				for ( int q = 0; q < 5; ++q )
				{
					col[q] = bmp->GetPixel(p->X+q, p->Y+PLAYER_HEIGHT) * 10000;
				}
				for ( int q = 0; q < 8; ++ q )
				{
					if ( ( col[q] % 16 ) != 0 ) 
					{
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