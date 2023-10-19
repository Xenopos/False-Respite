extends Area2D
class_name detection

signal player_found
signal player_lost

var playerhasbeenfound : bool = false

func _ready():
	pass

func _on_body_entered(body):
	if body.name == "Player":
		var enemy_system = body.get_node("HealthSystem")
		if (enemy_system ):
			playerhasbeenfound = true
			emit_signal("player_found")
			push_warning("player entered")

func _on_body_exited(body):
	if body.name == "Player":
		var enemy_system = body.get_node("HealthSystem")
		if (enemy_system ):
			playerhasbeenfound = false
			emit_signal("player_lost")
			push_warning("player exited")

func _physics_process(_delta):
	pass
	# You probably don't need this part if you're going to use signals.
