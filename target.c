#include <tcclib.h>
#include "raylib.h"
#include "shared.h"

void UpdatePlayer(Player *player, EnvItem *envItems, int envItemsLength, float delta) {
     if (IsKeyDown(KEY_LEFT)) player->position.x -= PLAYER_HOR_SPD*delta;
     if (IsKeyDown(KEY_RIGHT)) player->position.x += PLAYER_HOR_SPD*delta;
     if ((IsKeyDown(KEY_SPACE) || IsKeyDown(KEY_UP)) && player->canJump)
     {
	  player->speed = -PLAYER_JUMP_SPD;
	  player->canJump = false;
     }

     int hitObstacle = 0;
     for (int i = 0; i < envItemsLength; i++) {
	  EnvItem *ei = envItems + i;
	  Vector2 *p = &(player->position);
	  if (ei->blocking &&
	      ei->rect.x <= p->x &&
	      ei->rect.x + ei->rect.width >= p->x &&
	      ei->rect.y >= p->y &&
	      ei->rect.y <= p->y + player->speed*delta)
	  {
	       hitObstacle = 1;
	       player->speed = 0.0f;
	       p->y = ei->rect.y;
	  }
     }

     if (!hitObstacle) {
	  player->position.y += player->speed*delta;
	  player->speed += G*delta;
	  player->canJump = false;
     }
     else player->canJump = true;
}
