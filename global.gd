extends Node

######## GENERAL ########
const MOVEMENT_BASE_SPEED = 200 #base movement speed for every object on street


######## ORDERS ########
#creation
const ORDER_MAX_QUEUED = 3 #no more than x orders more than inventory space
const ORDER_COOLDOWN_MIN = 3 #wait at least x seconds before new order; also skip this time if no orders active at all
const ORDER_COOLDOWN_MAX = 15 #wait no longer than 30 seconds before creating new order

#time limits / enemies spawn
const ORDER_PUKE_THRESHOLD = 2 #spawn puke after x seconds
const ORDER_ZOMBIE_THRESHOLD_START = 4 #spawn weakest zombie after x seconds
const ORDER_ZOMBIE_THRESHOLD_END = 8 #spawn strongest zombie after x seconds

#score reward
const ORDER_REWARD_POINTS_DELIVERED = 50 # for EVERY delieverd order
const ORDER_REWARD_POINTS_RANDOM = 9 # add between 0 and x random points (variation)
const ORDER_REWARD_POINTS_INTIME = 50 # additional points for intime order (no enemy/pizza still good)
const ORDER_REWARD_POINTS_COMBO = 25 #additional points for amount of conescutive good orders

#money reward
const ORDER_REWARD_MONEY_GOOD = 15 # money for good pizza
const ORDER_REWARD_MONEY_MEDIUM = 5 # money for puke pizza
const ORDER_REWARD_MONEY_BAD = 0 # money for bad pizza
const ORDER_REWARD_MONEY_RANDOM = 5 #between 0 and x money extra (variation)

######## INVENTORY ########
const INVENTORY_UPGRADE_COST_BASE = 3 #upgrade base cost
const INVENTORY_UPGRADE_COST_INCREASE = 3 #ignored on first upgrade, added twice on seconds upgrade etc
const INVENTORY_SLOTS_MAX = 5

######## ENEMIES ########
#puke
const ENEMY_PUKE_SLOWDOWN_PERCENT = 0.5
const ENEMY_PUKE_DAMAGE_IMPACT = 1
const ENEMY_PUKE_LIFETIME = 15

#zombies
const ENEMY_ZOMBIE_DEFAULT_SPEED=0.4
const ENEMY_ZOMBIE_SPEED_ON_PLAYER_DETECTED=0.8
const ENEMY_ZOMBIE_DAMAGE=1
const ENEMY_ZOMBIE_FOLLOWING_TIMEOUT=4
const ENEMY_ZOMBIE_ATTACK_COOLDOWN=0.5
const ENEMY_ZOMBIE_VISION_RANGE=200
const ENEMY_ZOMBIE_VISION_BACK_DIVISOR=3
