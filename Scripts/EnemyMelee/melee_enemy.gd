extends CharacterBody2D
class_name meleeenemy
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player: Node2D

@onready var meleeEnemyAnim: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemySpeed = 80
var direction = Vector2.ZERO

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if player:
		push_warning("Player has been found.")
	else:
		push_warning("Player not found.")


func update_facing_direction_enemy():
	if direction.x < 0:
		meleeEnemyAnim.flip_h = false
	elif direction.x > 0:
		meleeEnemyAnim.flip_h = true

	if direction.x != 0:  
		meleeEnemyAnim.play("run")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if player:
		direction.x = 1 if player.global_position.x > global_position.x else -1
		velocity.x = direction.x * enemySpeed

	update_facing_direction_enemy()
	move_and_slide()
