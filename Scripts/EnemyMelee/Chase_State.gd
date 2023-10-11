extends State
class_name ChaseState

@export var meleeEnemy: CharacterBody2D
@export var speed := 150
@onready var Player = get_tree().get_first_node_in_group("Player")

func Enter():
	Player = get_tree().get_first_node_in_group("Player")

func _ready():
	push_warning("Player is ready and its group is:", self.is_in_group("Player"))

#func Physics_Update(delta: float):
#	var direction = Player.global_position - meleeEnemy.global_position
#
#	if direction.length() > 15:
#		meleeEnemy.velocity = direction.normalized() * speed
#	else:
#		meleeEnemy.velocity = Vector2()

