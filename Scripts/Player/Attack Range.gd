extends Area2D

var playerdamagetoenemy : enemyhealth
var shizuka : Shizuka
# Called when the node enters the scene tree for the first time.
func _ready():
	playerdamagetoenemy = enemyhealth.new()
	shizuka = Shizuka.new()
	
func _physics_process(_delta):
	performbasicattack()
	if shizuka.direction.x > 0:
		scale.x = 1   # Face right
	elif shizuka.direction.x < 0:
		scale.x = -1  # Face left
func _on_body_entered(body):
# Check if the body is an Enemy
	if body.name == "Melee_Enemy":
		var enemy_system = body.get_node("EnemySytem")
		if (enemy_system and enemy_system.has_node("Enemy_Health")):
			performbasicattack()
			push_warning("enemy hit")

func performbasicattack():
	if Input.is_action_just_pressed("attack"):
		playerdamagetoenemy.take_damage(10)
		push_warning("enemy hitting")
