extends CharacterBody2D
class_name meleeenemy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player: Node2D

signal velocity_updated(direction)

@onready var meleeEnemyAnim: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemySpeed = 70
var direction = Vector2.ZERO
var attackcollisionrange = atkrng
var foundenemy : bool = false
var detection_range_node : Node2D

func _ready():
	detection_range_node = get_node("detectionrange")
	detection_range_node.connect("player_found", Callable(self, "_on_player_found"))
	detection_range_node.connect("player_lost", Callable(self, "_on_player_lost"))
	player = get_tree().get_first_node_in_group("Player")
	if player:
		push_warning("Player has been found.")
	else:
		push_warning("Player not found.")

func _on_player_found():
	foundenemy = true

func _on_player_lost():
	foundenemy = false

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

	if foundenemy:
		enemyhasfounplayer()

	update_facing_direction_enemy()
	move_and_slide()
	emit_signal("velocity_updated", direction)  # Emit the signal with the updated velocity

func _on_animated_sprite_2d_animation_finished():
	if meleeEnemyAnim.animation == "basic_attack":
		enemySpeed = 70

func enemyhasfounplayer():
		direction.x = 1 if player.global_position.x > global_position.x else -1
		velocity.x = direction.x * enemySpeed
