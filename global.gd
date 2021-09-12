extends Node

#order time limits
const ORDER_PUKE_THRESHOLD = 5 #spawn puke after x seconds
const ORDER_ZOMBIE_THRESHOLD_START = 15 #spawn weakest zombie after x seconds
const ORDER_ZOMBIE_THRESHOLD_END = 25 #spawn strongest zombie after x seconds

##enemies
#puke
const ENEMY_PUKE_SLOWDOWN_PERCENT = 0.5
const ENEMY_PUKE_DAMAGE_IMPACT = 1
const ENEMY_PUKE_LIFETIME = 15

#zombies
