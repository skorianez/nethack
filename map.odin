package main

import cur "extra:curses"
import "core:math/rand"

Room :: struct {
    position : Position,
    height, width : i32,
    doors: [4]Position, 
    // monsters : ^Monster,
    // itens : ^Item,
}

Map :: struct {
    rooms : [dynamic]Room
}


map_init_rooms :: proc(m : ^Map)  {

    append(&m.rooms, room_init(13, 13, 6, 8))
   //append(&m.rooms, room_init(40, 2, 6, 8))
    //append(&m.rooms, room_init(40, 10, 8, 12))

}

map_draw :: proc(m: ^Map) {
    for &room in m.rooms {
        room_draw(&room)
    }
}

map_debug :: proc(m : ^Map) {
    row : i32 = 2
    for &room, idx in m.rooms {
        cur.mvprintw(row, 0, "Room:%d\b COL:%d -> x+w:%d | ROW:%d -> y+h:%d", 
            idx, 
            room.position.x, room.position.x + room.width - 1,
            room.position.y, room.position.y + room.height - 1,
        )
        
        room_debug(&room, row + 1)
        row += 6
    }
}

room_debug :: proc(r : ^Room, posy : i32) {
    
    cur.mvprintw(posy, 0     ,"Door Top    : COL:%d, FIX:%d", r.doors[0].x , r.doors[0].y)
    cur.mvprintw(posy + 1, 0 ,"Door Bottom : COL:%d, FIX:%d", r.doors[1].x , r.doors[1].y)
    cur.mvprintw(posy + 2, 0 ,"Door Left   : FIX:%d, ROW:%d", r.doors[2].x , r.doors[2].y)
    cur.mvprintw(posy + 3, 0 ,"Door Right  : FIX:%d, ROW:%d", r.doors[3].x , r.doors[3].y)
}


room_init :: proc(x, y, h, w : i32) -> Room {
    d : [4]Position

    d[0] = {
        i32(rand.uint32()) %% (w - 2) + x + 1,
        y
    } // top door

    d[1] = {
        i32(rand.uint32()) %% (w - 2) + x + 1,
        y + h - 1
    } // bottom door
    
    d[2] = {
        x, 
        i32(rand.uint32()) %% (h - 2) + y + 1
    } // left door
    
    d[3] = {
        x + w - 1,
        i32(rand.uint32()) %% (h - 2) + y + 1
    } // right door

    return {
        doors = d,
        position = {x,y},
        height = h,
        width = w,
    }
}

room_draw :: proc(r : ^Room) {
    // draw top and bottom
    for x := r.position.x; x < r.position.x + r.width; x += 1 {
        cur.mvprintw(r.position.y, x, "-")
        cur.mvprintw(r.position.y + r.height - 1, x, "-")
    }

    // draw and side walls
    for y := r.position.y + 1; y < r.position.y + r.height - 1 ; y += 1 {
        // side wall
        cur.mvprintw(y, r.position.x, "|")
        cur.mvprintw(y, r.position.x + r.width - 1, "|")

        // floors
        for x := r.position.x + 1 ; x < r.position.x + r.width -1 ; x += 1 {
            cur.mvprintw(y, x, ".")
        }
    }

    // draw ports
    for i in 0..<4 {
        cur.mvprintw(r.doors[i].y, r.doors[i].x, "+")
    }
}
