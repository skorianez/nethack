package main

import cur "extra:curses"
import "core:math/rand"

combat :: proc(player : ^Player, monster : ^Monster, patck : bool ) {
    // Player attack
    if patck {  
        monster.health -= player.attack
        if monster.health > 0 {
            player.health -= monster.attack
        } else {
            monster_kill(monster)
            player.exp += 1
        }
    // Monster attack
    } else { 
        player.health -= monster.attack
        if player.health > 0 {
            monster.health -= player.attack
        }
    }
}