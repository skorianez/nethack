package main

import cur "extra:curses"

Room :: struct {
    position : Position,
    height, width : i32,
    // monsters : ^Monster,
    // itens : ^Item,
}

Map :: struct {
    rooms : [dynamic]Room
}


map_init :: proc() -> Map {
    rooms : [dynamic]Room

    append(&rooms, room_init(13, 13, 6, 8))
    append(&rooms, room_init(40, 2, 6, 8))
    append(&rooms, room_init(40, 10, 8, 12))

    return {
        rooms = rooms,
    }
}

map_draw :: proc(m: ^Map) {
    for &midx in m.rooms {
        room_draw(&midx)
    }
}

room_init :: proc(x,y,h,w : i32) -> Room {
    return {
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
        for x := r.position.x + 1 ; x < r.position.x + r.width -1 ; x += 1 {
            cur.mvprintw(y, x, ".")
        }
    }
}
