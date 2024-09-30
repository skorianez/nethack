package main

import cur "extra:curses"

Player :: struct {
    position : Position,
    health: int,
    max_health : int,
    attack: int,
    gold: int,
    exp: int,

}

HEALTH :: 20
player_new :: proc() -> Player {
    return {
        health = HEALTH,
        max_health = HEALTH,
        attack = 1,
    }
}

player_draw :: proc(p : ^Player) {
    cur.mvprintw(p.position.y, p.position.x, "@")
}

player_input :: proc(p : ^Player, input : i32) -> Position{
    newPos := p.position
    switch input {
        case 'w', 'W':
            newPos.y -= 1
        case 's', 'S':
            newPos.y += 1
        case 'a', 'A':
            newPos.x -= 1
        case 'd', 'D':
            newPos.x += 1
    }
    return newPos
}

player_move :: proc(p : ^Player, pos :Position, level : [MAXLEVELROW][MAXLEVELCOL]cur.chtype ) {
    cur.mvaddch(p.position.y, p.position.x, level[p.position.y][p.position.x])
    p.position = pos
    player_draw(p)
}

player_check_position :: proc(level : ^Level, pos: Position) {
//player_check_position :: proc(p : ^Player, pos : Position, level : [MAXLEVELROW][MAXLEVELCOL]cur.chtype) {
    switch cur.mvinch(pos.y, pos.x) {
        case '.', '#', '+':
            player_move(&level.player, pos, level.tiles)
        case 'X', 'G', 'T':
            combat(&level.player, monster_at(pos, level.monsters[:]), true)
    }
}