extends State

class_name ChaseState

@export var meleeEnemy: CharacterBody2D
@export var speed := 150
var player : Shizuka

func Enter(): 
	pass
	
func _ready():
	if player == null:	
		player = get_tree().get_first_node_in_group("Player")
	push_warning("Player is ready and its group is: %s" % self.is_in_group("Player"))


#func Physics_Update(delta: float):
#	var direction = Player.global_position - meleeEnemy.global_position
#
#	if direction.length() > 15:
#		meleeEnemy.velocity = direction.normalized() * speed
#	else:
#		meleeEnemy.velocity = Vector2()

