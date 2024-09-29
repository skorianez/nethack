package main

import cur "extra:curses"
import "core:fmt"

Player :: struct {
    position : Position,
    health: int,
}

player_new :: proc(y_pos, x_pos : i32 , health : int ) -> Player {
    return {
        position = {x_pos , y_pos },
        health = health,
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

    floor := fmt.ctprintf("%c", level[p.position.y][p.position.x])
    cur.mvprintw(p.position.y, p.position.x, floor)
    
    p.position = pos
    player_draw(p)
}

player_check_position :: proc(p : ^Player, pos : Position, level : [MAXLEVELROW][MAXLEVELCOL]cur.chtype) {
    switch cur.mvinch(pos.y, pos.x) {
        case '.', '#', '+':
            player_move(p, pos, level)
    }
}