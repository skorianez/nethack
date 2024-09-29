package main

import cur "extra:curses"

mapSetup :: proc() {
    cur.mvprintw(13, 13, "--------")
    cur.mvprintw(14, 13, "|......|")
    cur.mvprintw(15, 13, "|......|")
    cur.mvprintw(16, 13, "|......|")
    cur.mvprintw(17, 13, "|......|")
    cur.mvprintw(18, 13, "--------")

    cur.mvprintw(2, 40, "--------")
    cur.mvprintw(3, 40, "|......|")
    cur.mvprintw(4, 40, "|......|")
    cur.mvprintw(5, 40, "|......|")
    cur.mvprintw(6, 40, "|......|")
    cur.mvprintw(7, 40, "--------")

    cur.mvprintw(10, 40, "------------")
    cur.mvprintw(11, 40, "|..........|")
    cur.mvprintw(12, 40, "|..........|")
    cur.mvprintw(13, 40, "|..........|")
    cur.mvprintw(14, 40, "|..........|")
    cur.mvprintw(15, 40, "------------")
}

