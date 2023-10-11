extends State
class_name IdleState

@export var meleeEnemy : CharacterBody2D

var speed = 20
var direction = Vector2.ZERO
var wandertime : float

func random_patrol():
	direction = Vector2(randf_range(-1,0), randf_range(1,0)).normalized()
	wandertime = randf_range(1, 3)
	
func Enter():
	random_patrol()

func Update(delta: float):
	if wandertime > 0:
		wandertime -= delta
	else:
		random_patrol()

func Physics_Update(_delta):
	if meleeEnemy:
		meleeEnemy.velocity = direction * speed
		
