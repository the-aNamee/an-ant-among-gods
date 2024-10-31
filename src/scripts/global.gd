extends Node2D

var difficulty: int:
	set(new_difficulty):
		bolder_speed = POSIBLE_BOLDER_SPEEDS[new_difficulty]
		meteor_time = POSIBLE_METEOR_TIMES[new_difficulty]
		meteor_multiplayer = POSIBLE_METEOR_MULTIPLYERS[new_difficulty]
		ares_speed = POSIBLE_ARES_SPEEDS[new_difficulty]
		spear_throw_time = POSIBLE_SPEAR_THROW_TIMES[new_difficulty]
		difficulty = new_difficulty

const EASY = 0
const NORMAL = 1
const HARD = 2
const IMPOSIBLE = 3

const DEBUG_START_WITH_CRATERS = false

var bolder_speed: float
const POSIBLE_BOLDER_SPEEDS = [4, 2, 1, 0.5]
var meteor_time: float
const POSIBLE_METEOR_TIMES = [0.5, 0.1, 0.05, 0.05]
var meteor_multiplayer: int
const POSIBLE_METEOR_MULTIPLYERS = [1, 1, 2, 2]
var ares_speed: float
const POSIBLE_ARES_SPEEDS = [50, 75, 90, 100]
var spear_throw_time: float
const POSIBLE_SPEAR_THROW_TIMES = [2, 1, 0.75, 0.5]

var going_back = false
var spear_time = 0.0
var player_name = ""
