extends Node

class_name healthsys

signal healthchanged

@export var max_health: int = 100
var current_health : int = 100
@export var maxpoise: int = 100
@export var current_poise: int = 0
@export var max_stamina: int = 100
@export var current_stamina: int = max_stamina

func _physics_process(_delta):
	pass

func _ready():
	pass

func set_max_health(value):
	max_health = value
	current_health = max_health

func set_health(value):
	current_health = clamp(value, 0, max_health)
	if current_health == 0:
		checkplayerdeath()

func player_take_damage(amount):
	push_warning("current health", current_health)
	healthchanged.emit()
	current_health = max(0, current_health - amount)
	if current_health < 0:
		checkplayerdeath()

func heal(amount):
	current_health += amount
	current_health = min(current_health, max_health)

func checkplayerdeath():
	if current_health <= 0:
		handle_death()

func handle_death():
	push_warning("The player has died!")

