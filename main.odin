package main

import cur "extra:curses"

main :: proc() {
    screen_init()
    defer cur.endwin()
    //defer cur.getch()
    
    mapa := Map{}
    map_init(&mapa)

    user := player_init() // TODO: put in map?
    player_draw(&user)

    for {
        ch := cur.getch()        
        if ch == 'q'{ break }
        newPos := player_input(&user, ch)
        player_check_position(&user, newPos, mapa.level)

        player_draw(&user)
    }
}

screen_init :: proc() {
    cur.initscr()
    cur.curs_set(0)
    cur.noecho()
}
