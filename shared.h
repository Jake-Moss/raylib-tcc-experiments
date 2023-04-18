#ifndef __SHARED
#define __SHARED

#define G 400
#define PLAYER_JUMP_SPD 350.0f
#define PLAYER_HOR_SPD 200.0f

typedef struct Player {
    Vector2 position;
    float speed;
    bool canJump;
} Player;

typedef struct EnvItem {
    Rectangle rect;
    int blocking;
    Color color;
} EnvItem;

typedef void* (*script_UpdatePlayer)(Player *player, EnvItem *envItems, int envItemsLength, float delta);

typedef struct script_t {
    char* path;
    void* program;

    script_UpdatePlayer UpdatePlayer;
} script_t;

#endif
