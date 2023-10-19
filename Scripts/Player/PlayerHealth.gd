extends Node

class_name healthsys

signal healthchanged
signal emitdeadstoplayer

var max_health: int = 100
var current_health : int = 100
@export var maxpoise: int = 100
@export var current_poise: int = 0

func _physics_process(_delta):
	pass

func _ready():
	pass

func set_max_health(value):
	max_health = value
	current_health = max_health

func player_take_damage(amount: int):
	healthchanged.emit()
	current_health = max(0, current_health - amount)
	if current_health <= 0:
		emitdeadstoplayer.emit()

func heal(amount):
	current_health += amount
	current_health = min(current_health, max_health)





