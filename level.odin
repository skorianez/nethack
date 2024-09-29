package main

import cur "extra:curses"
import "core:math/rand"

// TODO: fazer dinamico e baseado no tamanho
MAXLEVELROW :: 25
MAXLEVELCOL :: 100

Level :: struct {
    level : int,
    tiles : [MAXLEVELROW][MAXLEVELCOL]cur.chtype,
    rooms : [dynamic]Room,
    monsters: [dynamic]Monster,
}

level_init :: proc(l : ^Level, level : int) {
    l.level = level
    append(&l.rooms, room_init(13, 13, 6, 8))
    append(&l.rooms, room_init(40, 2, 6, 8))
    append(&l.rooms, room_init(40, 10, 8, 12)) 
    level_draw(l)
    tiles_save_position(&l.tiles)
}

level_draw :: proc(l: ^Level) {
    for &room in l.rooms {
        room_draw(&room)
    }
    door_connect(&l.rooms[0].doors[3], &l.rooms[2].doors[1])
    door_connect(&l.rooms[1].doors[2], &l.rooms[0].doors[0])
}

level_debug :: proc(l : ^Level) {
    row : i32 = 2
    for &room, idx in l.rooms {
        cur.mvprintw(row, 0, "Room:%d\b COL:%d -> x+w:%d | ROW:%d -> y+h:%d", 
            idx, 
            room.position.x, room.position.x + room.width - 1,
            room.position.y, room.position.y + room.height - 1,
        )
        
        room_debug(&room, row + 1)
        row += 6
    }
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

tiles_debug :: proc(l : ^[MAXLEVELROW][MAXLEVELCOL]cur.chtype ){
    ymax, xmax := cur.getmaxyx(cur.stdscr)
    // assert(MAXLEVELROW > ymax, "Muitas linhas")
    // assert(MAXLEVELCOL > xmax, "Muitas colunas")
    yt := MAXLEVELROW > ymax ? ymax : MAXLEVELROW
    xt := MAXLEVELROW > xmax ? xmax : MAXLEVELCOL
    cur.clear()
    cur.refresh()
    for y in 0..<yt {
        for x in 0..<xt {
            cur.mvaddch(y, x, cur.chtype(l[y][x]))
            //cur.mvaddch(y,x,'+')
        }
    }
    cur.mvprintw(0,0,"** COPIA **")
    
}