package main

import cur "extra:curses"

main :: proc() {
    screen_init()
    defer cur.endwin()
    //defer cur.getch()
    
    level := Level{}
    level_init(&level, 1)

    user := player_new(14, 14, 20) 
    player_draw(&user)

    for {
        ch := cur.getch()        
        if ch == 'q'{ break }
        newPos := player_input(&user, ch)
        player_check_position(&user, newPos, level.tiles)

        player_draw(&user)
    }
}

screen_init :: proc() {
    cur.initscr()
    cur.curs_set(0)
    cur.noecho()
}
