extends Area2D
class_name atkrng

var parentenemy = meleeenemy
var playerisreadytobeattacked : bool = false
@onready var anim : AnimatedSprite2D = $"../AnimatedSprite2D"

func _ready():
	var parent_enemy = get_parent()  # Assuming the meleeenemy is the direct parent of this node
	if parent_enemy and parent_enemy is meleeenemy:
		parent_enemy.connect("velocity_updated", Callable(self, "_on_velocity_updated"))

func _on_velocity_updated(direcition):  # Callback when the velocity is updated
	if direcition.x == 1:
		scale.x = -1
	elif direcition.x == -1:
		scale.x = 1

func _on_body_entered(body):
	if body.name == "Player":
		var enemy_system = body.get_node("PlayerSystem")
		if (enemy_system and enemy_system.has_node("HealthSystem")):
			playerisreadytobeattacked = false
			push_warning("player entered")

func _on_body_exited(body):
	if body.name == "Player":
		var enemy_system = body.get_node("PlayerSystem")
		if (enemy_system and enemy_system.has_node("HealthSystem")):
			playerisreadytobeattacked = true
			push_warning("player exited")

func _physics_process(_delta):
	enemynrmlattack()

func enemynrmlattack():
	pass
#	if playerisreadytobeattacked:
#		anim.play("basic_attack")
#		parentenemy.enemySpeed = 0
