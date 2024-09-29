package main

import cur "extra:curses"

main :: proc() {
    screen_init()
    defer cur.endwin()
    
    mapSetup()
    user := player_init()
    player_draw(&user)

    for {
        ch := cur.getch()        
        if ch == 'q'{ break }
        player_input(&user, ch)

        player_draw(&user)
    }
}


screen_init :: proc() {
    cur.initscr()
    cur.curs_set(0)
    cur.noecho()
}
