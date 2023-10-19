extends Area2D
class_name atkrange
	

var playerdamagetoenemy: enemyhealth
var menemy: meleeenemy
var collisiondirection: Vector2
var shizuka : Shizuka

signal applydamagedash(canapplied1)
signal applydamage(canapplied3)

var enemyexitedrange : bool = true
@export var debug : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	menemy = meleeenemy.new()
	playerdamagetoenemy = enemyhealth.new()
	shizuka = Shizuka.new()
	
func _physics_process(_delta):
	debugperformattack()
	collisiondirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if collisiondirection.x > 0:
		scale.x = -1  # Face right
	elif collisiondirection.x < 0:
		scale.x = 1  # Face left

func _on_body_entered(body):
	if body.name == "Melee_Enemy":
		var enemy_system = body.get_node("Enemy_Health")
		if (enemy_system):
			applydamage.emit(true)
			applydamagedash.emit(true)
			enemyexitedrange = false
			debug.text = str("fuck you ") + str(enemyexitedrange) 

func _on_body_exited(body):
	if body.name == "Melee_Enemy":
		var enemy_system = body.get_node("Enemy_Health")
		if (enemy_system):
			applydamage.emit(false)
			applydamagedash.emit(false)
			enemyexitedrange = true
			debug.text = str(enemyexitedrange)

func debugperformattack():
	if Input.is_action_just_pressed("attack") and not enemyexitedrange:
		playerdamagetoenemy.take_damage(10) 

