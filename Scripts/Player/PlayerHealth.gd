extends Node

class_name healthsys

signal healthchanged
signal emitremovalofexistence
signal playerkknockback


var max_health: int = 100
var max_healing: int = 3
var current_healing = max_healing
var current_health : int = 100
@export var maxpoise: int = 100
@export var current_poise: int = 0
@onready var displaymaxhealing : Label = $Maxhealing

func _physics_process(_delta):
	pass

func _ready():
	displaymaxhealing.text = str("Heal " ,current_healing)

func set_max_health(value):
	max_health = value
	current_health = max_health

func player_take_damage(amount: int):
	if current_health != 0:
		playerkknockback.emit()
		healthchanged.emit()
		current_health = max(0, current_health - amount)
		if current_health <= 0:
			emitremovalofexistence.emit()

func heal(amount: int):
	if current_healing != -1:
		displaymaxhealing.text = str("Heal " ,current_healing)
		current_healing -= 1
		current_health += amount
		current_health = min(current_health, max_health)
	


