extends Node

class_name healthsys

signal healthchanged
signal emitremovalofexistence
signal playerkknockback


var max_health: int = 100
var max_healing: int = 3
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
	playerkknockback.emit()
	healthchanged.emit()
	current_health = max(0, current_health - amount)
	if current_health <= 0:
		emitremovalofexistence.emit()

func heal(amount):
	max_healing -= 3
	current_health += amount
	current_health = min(current_health, max_health)


