extends Area2D
class_name atkrange

var collisiondirection: Vector2

signal applydamagedash(canapplied1)
signal applydamage(canapplied3)

var enemyexitedrange : bool = true
@export var debug : Label
var maineenemy
var newenemy
# Called when the node enters the scene tree for the first time.
func _ready():
	maineenemy = get_tree().get_first_node_in_group("Enemy")
	
func _physics_process(_delta):
	collisiondirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if collisiondirection.x > 0:
		scale.x = -1  # Face right
	elif collisiondirection.x < 0:
		scale.x = 1  # Face left

func _on_body_entered(body):
	if body.name == "Melee_Enemy":
			applydamage.emit(true)
			applydamagedash.emit(true)
			enemyexitedrange = false
 
func _on_body_exited(body):
	if body.name == "Melee_Enemy":
			applydamage.emit(false)
			applydamagedash.emit(false)
			enemyexitedrange = false


