package main

import cur "extra:curses"

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

tiles_debug :: proc(l : ^[MAXLEVELROW][MAXLEVELCOL]cur.chtype ){
    ymax, xmax := cur.getmaxyx(cur.stdscr)
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

room_debug :: proc(r : ^Room, posy : i32) {
    
    cur.mvprintw(posy, 0     ,"Door Top    : COL:%d, FIX:%d", r.doors[0].x , r.doors[0].y)
    cur.mvprintw(posy + 1, 0 ,"Door Left   : FIX:%d, ROW:%d", r.doors[1].x , r.doors[1].y)
    cur.mvprintw(posy + 2, 0 ,"Door Bottom : COL:%d, FIX:%d", r.doors[2].x , r.doors[2].y)
    cur.mvprintw(posy + 3, 0 ,"Door Right  : FIX:%d, ROW:%d", r.doors[3].x , r.doors[3].y)
}

health_debug :: proc(l :^Level) {
    ypos, xpos := cur.getmaxyx(cur.stdscr)
    cur.move(ypos - 1,2)
    cur.printw("Player: %d ", l.player.health)
    for m in l.monsters {
        cur.printw("- Monster[%c]: %d ", m.symbol , m.health)
    }
}