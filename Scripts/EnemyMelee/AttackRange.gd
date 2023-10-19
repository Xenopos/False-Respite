extends Area2D
class_name atkrng

# Signal to notify when the player is ready to be attacked
signal player_ready_to_be_attacked

var parentenemy = meleeenemy  # Similarly, this will cause an error if 'meleeenemy' isn't defined elsewhere.
var playerisreadytobeattacked : bool = false

# Signals
signal player_no_longer_ready_to_attack

func _ready():
	# Initialize parentenemy assuming the meleeenemy is the direct parent of this node
	var parent_enemy = get_parent()
	if parent_enemy and parent_enemy is meleeenemy:
		parentenemy = parent_enemy
		parentenemy.connect("velocity_updated", Callable(self, "_on_velocity_updated"))

func _on_velocity_updated(direction):  # Callback when the velocity is updated
	if direction.x == 1:
		scale.x = -1
	elif direction.x == -1:
		scale.x = 1

func _on_body_entered(body):
	if body.name == "Player":
		var enemy_system = body.get_node("HealthSystem")
		if enemy_system:
			playerisreadytobeattacked = true
			emit_signal("player_ready_to_be_attacked")

func _on_body_exited(body):
	if body.name == "Player":
		var enemy_system = body.get_node("HealthSystem")
		if enemy_system:
			playerisreadytobeattacked = false
			emit_signal("player_ready_to_be_attacked")

func _physics_process(_delta):
	pass
