extends Node
class_name enemyhealth


var menemycurrenthealth : int = 100
var menemymaxpoise : int = 0
var enemy_parent : Node2D

func _ready():
	enemy_parent = get_tree().get_first_node_in_group("Enemy")
	if enemy_parent:
		push_warning("Found")
	else:
		push_warning("fuck you")
			
func _physics_process(_delta):
	pass

func enemy_check_health():
	if menemycurrenthealth <= 0:
		pass
		
func takecontinousdamage():
	pass

func take_damage_skill1(amount: int):
	menemycurrenthealth -= amount
	enemy_check_health()

func take_damage(amount: int):
	push_warning("Enemy damage taken ", menemycurrenthealth)
	menemycurrenthealth -= amount
	enemy_check_health()

func enemygoairborne():
	pass

