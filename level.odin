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
    append(&l.rooms, room_init(13, 13, 6, 8))
    append(&l.rooms, room_init(40, 2, 6, 8))
    append(&l.rooms, room_init(40, 10, 8, 12)) 
    
    level_draw(l)
    tiles_save_position(&l.tiles)

    l.player = player_new(14, 14, 20) 
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

level_draw :: proc(l: ^Level) {
    for &room in l.rooms {
        room_draw(&room)
    }
    door_connect(&l.rooms[0].doors[3], &l.rooms[2].doors[1])
    door_connect(&l.rooms[1].doors[2], &l.rooms[0].doors[0])
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