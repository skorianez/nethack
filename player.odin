package main

import cur "extra:curses"

Player :: struct {
    position : Position,
    health: int,
}

player_init :: proc() -> Player {
    return {
        position = {14 , 14 },
        health = 20,
    }
}

player_draw :: proc(p : ^Player) {
    cur.mvprintw(p.position.y, p.position.x, "@")
}

player_input :: proc(p : ^Player, input : i32) {
    newX, newY := p.position.x, p.position.y
    switch input {
        case 'w', 'W':
            newY -= 1
        case 's', 'S':
            newY += 1
        case 'a', 'A':
            newX -= 1
        case 'd', 'D':
            newX += 1
    }
    player_check_position(p, newY, newX)
}

player_move :: proc(p : ^Player, y,x :i32 ) {
    cur.mvprintw(p.position.y, p.position.x, ".")
    p.position.x = x
    p.position.y = y
    player_draw(p)
}

player_check_position :: proc(p : ^Player, y, x :i32 ) {
    switch cur.mvinch(y, x) {
        case '.':
            player_move(p, y, x)
    }
}