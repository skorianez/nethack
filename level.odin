package main

import cur "extra:curses"
import "core:math/rand"

// TODO: fazer dinamico e baseado no tamanho
MAXLEVELROW :: 25
MAXLEVELCOL :: 100

Position :: struct {
    x, y: i32,
}

Level :: struct {
    level : int,
    tiles : [MAXLEVELROW][MAXLEVELCOL]cur.chtype,
    rooms : [dynamic]Room,
    player : Player,
    monsters: [dynamic]Monster,
}

level_init :: proc(l : ^Level, level : int) {
    l.level = level

    // CREATE ROOM
    for g in 0..<6 {
        append(&l.rooms, room_init(g))
    }
    
    // DRAW ROOM
    for &room in l.rooms {
        room_draw(&room)
    }
    // SAVE POSITION
    tiles_save_position(&l.tiles)

    // CONNECT DOORS
    //door_connect(&l.rooms[0].doors[3], &l.rooms[2].doors[1])
    //door_connect(&l.rooms[1].doors[2], &l.rooms[0].doors[0])

    // ADD A PLAYER
    l.player = player_new() 
    level_add_player(l)
    level_add_monsters(l)
}

level_add_monsters :: proc(l: ^Level) {
    coin := [2]bool {false, true}
    for &x in l.rooms {
        if rand.choice(coin[:])  {
            append(&l.monsters, monster_select(l.level, &x))
        }
    }
}

level_add_player :: proc(l: ^Level) {
    l.player.position.x = l.rooms[3].position.x + 1
    l.player.position.y = l.rooms[3].position.y + 1
}

tiles_save_position :: proc(l: ^[MAXLEVELROW][MAXLEVELCOL]cur.chtype) {
    //positions : [MAXLEVELROW][MAXLEVELCOL]u8
    for y in 0..<MAXLEVELROW {
        for x in 0..<MAXLEVELCOL {
            l[y][x] = cur.mvinch(i32(y), i32(x))
        }
    }
    //return positions
}

level_move_monsters :: proc(l: ^Level) {
    for &m in l.monsters {
        if m.health <= 0 {
            continue
        }

        cur.mvaddch(m.position.y, m.position.x, '.')

        if m.pathfinding == 1 {
            pathfinding_random(&m.position)
        } else {
            pathfinding_seek(&m.position, l.player.position)
        }

        monster_draw(&m)
    }
}

pathfinding_seek :: proc(start : ^Position, dest: Position) {
    // step left
    if (abs((start.x - 1) - dest.x) < abs(start.x - dest.x)) && 
        (cur.mvinch(start.y, start.x - 1) == '.') {
            start.x -= 1
    // step right
    } else if (abs((start.x + 1) - dest.x) < abs(start.x - dest.x)) && 
        (cur.mvinch(start.y, start.x + 1) == '.') {
            start.x += 1
    // step down
    } else if (abs((start.y + 1) - dest.y) < abs(start.y - dest.y)) && 
        (cur.mvinch(start.y + 1, start.x) == '.') {
            start.y += 1
    // step up
    } else if (abs((start.y - 1) - dest.y) < abs(start.y - dest.y)) && 
        (cur.mvinch(start.y - 1, start.x) == '.') {
            start.y -= 1
    }
}

pathfinding_random :: proc(pos : ^Position) {
    random := rand.uint32() %% 5
    switch random {
        case 0:
            if cur.mvinch(pos.y - 1, pos.x) == '.'
            {
                pos.y -= 1
            }
        case 1:
            if cur.mvinch(pos.y + 1, pos.x) == '.'
            {
                pos.y += 1
            }
        case 2:
            if cur.mvinch(pos.y , pos.x - 1) == '.'
            {
                pos.x -= 1
            }
        case 3:
            if cur.mvinch(pos.y , pos.x + 1) == '.'
            {
                pos.x += 1
            }
        case 4:
            // nothing
    }
}

game_hub :: proc(level :  ^Level) {
    cur.mvprintw(25, 0, "    Level: %d", level.level)
    cur.printw("    Gold: %d", level.player.gold)
    cur.printw("    HP: %d(%d)", level.player.health, level.player.max_health )
    cur.printw("    Attack: %d", level.player.attack)
    cur.printw("    Exp: %d", level.player.exp)
    cur.printw("         ")
}