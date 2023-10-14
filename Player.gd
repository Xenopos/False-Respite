extends CharacterBody2D
class_name Shizuka

@export var SPEED = 80.0
@export var JUMP_VELOCITY = -180.0


@onready var dash_value = 200
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var progressBar: ProgressBar = $ProgressBar
@onready var timercountdown: Timer = $Timer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animationstay: bool = false
var direction: Vector2 = Vector2.ZERO
var onair: bool = false
var isAttacking: bool = false
@export var AttackCombo: int = 0
var DashDirection: Vector2 = Vector2(0, 0)
var canDash: bool = false
var isDashing: bool = false
var HealthPoints: int = 3
var StaminaPoints: int = 100
var IsJumping: bool = false
var IsDashingAttack: bool = false
var holdingSkill1: bool = false
var timer: float = 0.0
var fillSpeed: float = 0.3 # Fill up in 3 seconds
var set_emitting  : bool  = false
var Allow_jump : bool = true

func _ready():
	add_to_group("Player")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		onair = true
	else:
		onair = false

	if holdingSkill1 == true:
		timer += 1
		progressBar.value += 1
		
	elif not holdingSkill1:
		progressBar.value = 0
		
	else: 
		progressBar.value = 0

		if timer >= fillSpeed:
			holdingSkill1 = false
			Skills()

	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animation()
	update_facing_direction()
	attack()
	dash()
	Skills()	

func update_animation():
	if not animationstay:
		if direction.x != 0:
			animated_sprite.play("run")
		elif direction.x == 0 or isAttacking:
			animated_sprite.play("idle")

func update_facing_direction():
	if direction.x < 0:
		animated_sprite.flip_h = false
	elif direction.x > 0:
		animated_sprite.flip_h = true

func jump():
	velocity.y = JUMP_VELOCITY
	animationstay = true
	$SFX/jump.play()
	animated_sprite.play("jump")

func _on_animated_sprite_2d_animation_finished():
	if (
		animated_sprite.animation == "upyogo"
		or animated_sprite.animation == "dash attack"
		or animated_sprite.animation == "jump"
		or animated_sprite.animation == "attack"
		or animated_sprite.animation == "attack2"
		or animated_sprite.animation == "dash"
		or animated_sprite.animation == "spin"
		or animated_sprite.animation == "execute"
	):
		animationstay = false
		SPEED = 80.0
		gravity = 480
		progressBar.value = 0
		
func attack():
	if (
		Input.is_action_just_pressed("attack")
		and AttackCombo == 0
		and isDashing == false
		):
		SPEED = 30
		$SFX/attacksfx.play()
		AttackCombo += 1
		isAttacking = true
		animated_sprite.play("attack")
		animationstay = true
	elif (
		Input.is_action_just_pressed("attack")
		and AttackCombo == 1
		and isDashing == false
	):
		SPEED = 30
		AttackCombo -= 1
		isAttacking = true
		animated_sprite.play("attack2")
		animationstay = true
		$SFX/attacksfx.play()
	else:
		isAttacking = false

func dash():
	if Input.is_action_pressed("ui_left"):
		DashDirection = Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		DashDirection = Vector2(1, 0)
	if Input.is_action_just_pressed("dash"):
		Dodash()

func Dodash():
	$SFX/dash.play()
	animated_sprite.play("dash")
	DashDirection = direction.normalized()
	SPEED = DashDirection * dash_value
	animationstay = true
	SPEED = 400
	set_emitting = true
	if direction.x == 0:
		SPEED = 80
	else:
		SPEED = 400

# !!Skill1 needs to be rooted, can activate after progress value == 100 and is on floor
func Skills():
	if Input.is_action_just_pressed("Skill1") and is_on_floor():
		Allow_jump = false
		animated_sprite.play("dash ready")
		animationstay = true
		SPEED = 0
		$SFX/charge.play()
		holdingSkill1 = true
		timer = 0.0
		progressBar.value = 0

		
	if (
		Input.is_action_just_released("Skill1")
		and is_on_floor()
		and not isAttacking
		):
		Allow_jump = true
		animated_sprite.play("dash attack")
		$SFX/execute.play()
		holdingSkill1 = false
		velocity = DashDirection.normalized() * 1200
		animationstay = true
		$SFX/charge.stop()
		if direction.x == 0:
			SPEED = 80
		else:
			SPEED = 400

	if Input.is_action_just_pressed("Skill2") and not is_on_floor():
		animated_sprite.play("spin")
		$SFX/spiiin.play()
		if onair == true:
			animationstay = true
		if not onair:
			animationstay = false

	if Input.is_action_just_pressed("Skill3"):
		animated_sprite.play("upyogo")
		animationstay = true
		SPEED = 0
		$SFX/up.play()

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and Allow_jump:
		jump()
