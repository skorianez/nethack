package main

import cur "extra:curses"
import "core:math/rand"

Monster :: struct {
    symbol : cur.chtype,
    health : int,
    attack : int,
    speed : int,
    defence : int,
    pathfinding: int,
    position: Position,
}

monster_select :: proc(level: int, room : ^Room) -> Monster {
    mtemp : Monster
    mt : u32 // Monster type
    switch level {
        case 1,2,3:
            mt = (rand.uint32() %% 2) + 1
        case 4,5:
            mt = (rand.uint32() %% 2) + 2
        case 6:
            mt = 3
           
    }
    switch mt {
        case 1:
            mtemp = monster_spider()
        case 2:
            mtemp = monster_goblin()
        case 3:
            mtemp = monster_troll()
    }
    monster_position(&mtemp, room)
    monster_draw(&mtemp)
    return mtemp
}

monster_position :: proc(m :^Monster, r : ^Room){
    m.position.x = i32(rand.uint32()) %% (r.width - 2) + r.position.x + 1
    m.position.y = i32(rand.uint32()) %% (r.height - 2) + r.position.y + 1
}

monster_draw :: proc(m: ^Monster) {
    cur.mvaddch(m.position.y, m.position.x, m.symbol)
}

monster_spider :: proc() -> Monster {
    return {
        symbol = 'X',
        health = 2,
        attack = 1,
        speed = 1,
        defence = 1,
        pathfinding = 1,
    }
}

monster_goblin :: proc() -> Monster {
    return {
        symbol = 'G',
        health = 5,
        attack = 3,
        speed = 1,
        defence = 1,
        pathfinding = 2,
    }
}

monster_troll :: proc() -> Monster {
    return {
        symbol = 'T',
        health = 15,
        attack = 5,
        speed = 1,
        defence = 1,
        pathfinding = 1,
    }
}
