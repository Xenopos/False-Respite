class_name meleeenemy extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var patrol_points = []
var current_target = Vector2()
var time_since_change = 0.0
var time_to_wait = 2.0
var player: Node2D = null

@onready var meleeenemyanim : AnimatedSprite2D = $AnimatedSprite2D
@onready var Enemy_speed = 10
@onready var direction = Vector2.ZERO


func _ready():
	patrol_points.append(Vector2(1, 5))
	choose_random_patrol_point()

func update_facing_direction_enemy():
	if direction.x < 0:
		meleeenemyanim.flip_h = false
	elif direction.x > 0:
		meleeenemyanim.flip_h = true
	if direction.x  > 0:
		meleeenemyanim.play("run")

func choose_random_patrol_point():
	current_target = patrol_points[randi() % patrol_points.size()]
	time_since_change = 0.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if position.distance_to(current_target) < 5:
		time_since_change += delta
		if time_since_change > time_to_wait:
			choose_random_patrol_point()
	else:
		direction = current_target - position
		direction = direction.normalized()
		velocity.x = direction.x * Enemy_speed
	update_facing_direction_enemy()
	move_and_slide()
