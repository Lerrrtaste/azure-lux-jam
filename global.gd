extends Node

#order time limits
const ORDER_PUKE_THRESHOLD = 2 #spawn puke after x seconds
const ORDER_ZOMBIE_THRESHOLD_START = 6 #spawn weakest zombie after x seconds
const ORDER_ZOMBIE_THRESHOLD_END = 10 #spawn strongest zombie after x seconds

##enemies
#puke
const ENEMY_PUKE_SLOWDOWN_PERCENT = 0.5
const ENEMY_PUKE_DAMAGE_IMPACT = 1
const ENEMY_PUKE_LIFETIME = 15

#zombies
const ENEMY_ZOMBIE_DEFAULT_SPEED=0.4
const ENEMY_ZOMBIE_SPEED_ON_PLAYER_DETECTED=0.8
const ENEMY_ZOMBIE_DAMAGE=2
const ENEMY_ZOMBIE_ATTACK_COOLDOWN=0.5
