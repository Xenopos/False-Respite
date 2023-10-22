extends Node

class_name healthsys

signal healthchanged
signal emitremovalofexistence
signal playerkknockback

var enemyhp : enemyhealth
@export var max_health: int = 100
@export var max_healing: int = 3 
var current_healing = max_healing
var current_health : int = 100
@export var maxpoise: int = 100
@export var current_poise: int = 0
@onready var displaymaxhealing : Label = $"../CanvasLayer/Maxhealing"
@onready var fadedisplay : Timer = $faderestorehealing
@onready var displaylabelrestoredhealing : Label = $"../CanvasLayer/Restoredhealing"
@onready var shizuka 
var _isvulnerable : bool = false


func _physics_process(_delta):
	displaymaxhealing.text = str("Total heal: " ,current_healing)


func _ready():
	shizuka = get_tree().get_first_node_in_group("Player")
	enemyhp = get_tree().get_first_node_in_group("enemyhealth")
	enemyhp.connect("restorehealthready", Callable(self, "imhigh"))
	fadedisplay.connect("timeout", Callable(self, "displayhealoff"))
	shizuka.connect("damagevulnebarility", Callable(self, "isvulerabilityon"))
	
func isvulerabilityon(isvulnerable: bool):
	_isvulnerable = isvulnerable
	
func player_take_damage(amount: int):
	if not _isvulnerable:
		if current_health != 0:
			playerkknockback.emit()
			healthchanged.emit()
			$"../SFX/hitsfx".play()
			current_health = max(0, current_health - amount)
			if current_health <= 20:
				$"../SFX/healthwarnign".play()
				$"../SFX/low healthsfx".play()
			elif current_health > 20:
				$"../SFX/healthwarnign".stop()
			if current_health <= 0:
				emitremovalofexistence.emit()
				$"../SFX/healthwarnign".stop


func heal(amount: int):
	if current_healing != 0 and current_health != 100 and current_health >= 1:
		$"../SFX/heal".play()
		displaymaxhealing.text = str("Total heal: " ,current_healing)
		current_healing -= 1
		current_health += amount
		current_health = min(current_health, max_health)
	
func imhigh():
	current_healing += 1
	if current_healing <= max_healing:  # Only display if not maxed out
		displaylabelrestoredhealing.text = "heal restored"
		fadedisplay.start(2.0)
	current_healing = min(current_healing, max_healing)  # Ensures current_healing doesn't exceed max_healing

func displayhealoff():
	displaylabelrestoredhealing.text = str(" ")
