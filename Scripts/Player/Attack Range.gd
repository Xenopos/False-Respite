extends Area2D
class_name atkrange


var playerdamagetoenemy: enemyhealth
var menemy: meleeenemy
var collisiondirection: Vector2
var shizuka : Shizuka

var enemyexitedrange : bool = true
@export var debug : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	menemy = meleeenemy.new()
	playerdamagetoenemy = enemyhealth.new()
	shizuka = Shizuka.new()
	
func _physics_process(_delta):
	debugperformattack()
	yogoairborne()
	collisiondirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if collisiondirection.x > 0:
		scale.x = -1  # Face right
	elif collisiondirection.x < 0:
		scale.x = 1  # Face left

func _on_body_entered(body):
# Check if the body is an Enemy
	if body.name == "Melee_Enemy":
		var enemy_system = body.get_node("EnemySystem")
		if (enemy_system and enemy_system.has_node("Enemy_Health")):
			enemyexitedrange = false
			debug.text = str(enemyexitedrange)

func _on_body_exited(body):
# Check if the body is an Enemy
	if body.name == "Melee_Enemy":
		var enemy_system = body.get_node("EnemySystem")
		if (enemy_system and enemy_system.has_node("Enemy_Health")):
			enemyexitedrange = true
			debug.text = str(enemyexitedrange)

func debugperformattack():
	if Input.is_action_just_pressed("attack") and not enemyexitedrange:
		playerdamagetoenemy.take_damage(10) 
		push_warning("enemy hitting")

func yogoairborne():
	if shizuka.skill3active == true and Input.is_action_just_pressed("Skill3") and not enemyexitedrange:
		playerdamagetoenemy.enemygoairborne()
