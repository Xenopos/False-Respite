extends CharacterBody2D
class_name meleeenemy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player: Node2D

signal velocity_updated(direction)

@onready var meleeEnemyAnim: AnimatedSprite2D = $AnimatedSprite2D
var enemySpeed = 70
var direction = Vector2.ZERO
@onready var attackcollisionrange = $AttackRange
var foundenemy : bool = false
var detection_range_node : Node2D
var playerhealth : healthsys
var normalattackative : bool = false
var pierceattackactive : bool = false
var animationlock : bool = false

# Cooldown Timer and related variables
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
var isAttackOnCooldown: bool = false
var hasAttacked : bool = false  # New variable to ensure enemynrmlattk is called only once

func _ready():
	detection_range_node = get_node("detectionrange")
	detection_range_node.connect("player_found",Callable( self, "_on_player_found"))
	detection_range_node.connect("player_lost", Callable(self, "_on_player_lost"))
	player = get_tree().get_first_node_in_group("Player")
	playerhealth = healthsys.new()

	if player:
		push_warning("Player has been found.")
	else:
		push_warning("Player not found.")
	
	# Connect the signals
	attackcollisionrange.connect("player_ready_to_be_attacked", Callable(self, "enemynrmlattk"))
	#attackcollisionrange.connect("player_no_longer_ready_to_attack", Callable(self, "_reset_attack_flag"))
	attack_cooldown_timer.connect("timeout", Callable(self, "_on_AttackCooldownTimer_timeout"))

func _on_player_found():
	foundenemy = true

func _on_player_lost():
	foundenemy = false
	
func update_facing_direction_enemy():
	if direction.x < 0:
		meleeEnemyAnim.flip_h = false
	elif direction.x > 0:
		meleeEnemyAnim.flip_h = true

	if not animationlock:
		if direction.x != 0:
			meleeEnemyAnim.play("run")
		elif direction.x == 0:
			meleeEnemyAnim.play("idle")
		animationlock = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if foundenemy:
		enemyhasfounplayer()
	
	update_facing_direction_enemy()
	move_and_slide()
	emit_signal("velocity_updated", direction) 

func enemynrmlattk():
	if not isAttackOnCooldown and not hasAttacked :
		enemySpeed = 50
		meleeEnemyAnim.play("basic_attack")
		playerhealth.player_take_damage(10) 
		animationlock = true 
		hasAttacked = true
		start_attack_cooldown(0.9) 

func enemypierceattk():
	enemySpeed = 200
	meleeEnemyAnim.play("skill_pierce")
	playerhealth.player_take_damage(50)
	animationlock = true
		
func _on_animated_sprite_2d_animation_finished():
	if meleeEnemyAnim.animation == "basic_attack":
		enemySpeed = 70
		animationlock = false

func enemyhasfounplayer():
	var distance_to_player = player.global_position.distance_to(global_position)
	if distance_to_player > 20:
		direction.x = 1 if player.global_position.x > global_position.x else -1
		velocity.x = direction.x * enemySpeed
	else:
		velocity.x = 0
		enemynrmlattk()
		
# Cooldown functions
func start_attack_cooldown(duration):
	attack_cooldown_timer.start(duration)
	isAttackOnCooldown = true

func _on_AttackCooldownTimer_timeout():
	isAttackOnCooldown = false
	hasAttacked = false  # Reset the attack flag when cooldown ends

# Reset the attack flag when the player is no longer ready to be attacked
#func _reset_attack_flag():
#	pass
