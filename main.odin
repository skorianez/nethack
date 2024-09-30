package main

import cur "extra:curses"

main :: proc() {
    screen_init()
    defer cur.endwin()
    //defer cur.getch()
    
    level := Level{}
    level_init(&level, 1)

  
    for {
        ch := cur.getch()        
        if ch == 'q'{ break }
        newPos := player_input(&level.player, ch)
        player_check_position(&level.player, newPos, level.tiles)
        level_move_monsters(&level)

        player_draw(&level.player)
    }
}

screen_init :: proc() {
    cur.initscr()
    cur.curs_set(0)
    cur.noecho()
}
