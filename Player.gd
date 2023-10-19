class_name Shizuka extends CharacterBody2D

#------------------------------------#
@export var SPEED = 80.0
@export var JUMP_VELOCITY = -180.0
#------------------------------------#
@onready var dash_value = 200
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timercountdown: Timer = $Timer
@onready var dashParticles: GPUParticles2D = $DashParticles
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var skill3area : Area2D 
@export var anysingepointdamage : Area2D
@export var anysingepointdamager : Area2D
#------------------------------------#
var skill3active = true
var skill2active  = true
var lockskill : bool = false
var animationstay: bool = false
var direction: Vector2 = Vector2.ZERO
@onready var onair: bool = false 
var isAttacking: bool = false
@export var AttackCombo: int = 0
var DashDirection: Vector2 = Vector2(0, 0)
var canDash: bool = false
var isDashing: bool = false
var IsJumping: bool = false
var IsDashingAttack: bool = false
var holdingSkill1: bool = false
var timer: float = 0.0
var fillSpeed: float = 0.3 # Fill up in 3 seconds
var set_emitting  : bool  = false
var Allow_jump : bool = true
@export var cooldown_timer: Timer

#skills flags for applying damage

var skill1online : bool 
var skill2online : bool 
var skill3online : bool 


#... Other variables
@onready var dash_speed: float = 600
@onready var dash_duration: float = 0.1
@onready var skill1cd : Label = $Label
var enemyparent
#------------------------------------#

#------------------------------------#
func _ready():
	add_to_group("Player")
	anysingepointdamage.connect("applydamagedash" , Callable( self, "allowedskill1toapplydamage"))
	anysingepointdamager.connect("applydamage", Callable(self, "allowedskill2toapplydamage"))
	skill3area.connect("applyskill3damage", Callable(self, "allowskill3toapplydamage"))
	timercountdown.connect("timeout", Callable(self, "_on_Timer_timeout"))
	cooldown_timer.connect("timeout", Callable(self, "_on_CooldownTimer_timeout"))
	skill2active  = true
	skill3active  = true
	enemyparent = get_tree().get_first_node_in_group("enemyhealth")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		onair = true
	else:
		onair = false

	if not isDashing:
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
	Skill_activation()
	doJump()

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
		or animated_sprite.animation == "attack"
		or animated_sprite.animation == "attack2"
		or animated_sprite.animation == "dash"
		or animated_sprite.animation == "spin"
		or animated_sprite.animation == "execute"
		or animated_sprite.animation == "jump"
	):
		animationstay = false
		SPEED = 80.0
		gravity = 480

func doJump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and Allow_jump:
		jump()

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

	if Input.is_action_just_pressed("dash") and not isDashing:
		start_dash()

func start_dash():
		dashParticles.emitting = true
		isDashing = true
		$SFX/dash.play()
		animated_sprite.play("dash")
		velocity = DashDirection.normalized() * dash_speed
		animationstay = true
		timercountdown.start(dash_duration)

func Skill_activation():
	if not lockskill:
		if (Input.is_action_just_pressed("Skill1") and is_on_floor() and not isAttacking and not isDashing):
			skill1activate()
		elif (Input.is_action_just_released("Skill1") and is_on_floor() and not lockskill and not isDashing):
			skill1releaseactivate()
		if (Input.is_action_just_pressed("Skill2") and not is_on_floor() and not isDashing):
			skill2activate()
		if (Input.is_action_just_pressed("Skill3") and not isDashing):
			skill3activate()

func skill1activate():
	if not lockskill and not Allow_jump:
		Allow_jump = false
		animated_sprite.play("dash ready")
		animationstay = true
		SPEED = 0
		$SFX/charge.play()
		
func skill1releaseactivate():
	if not isDashing and not lockskill:
		isDashing = true

		Allow_jump = true
		animated_sprite.play("dash attack")
		if skill1online:
			enemyparent.take_damage(10)
			push_warning("skill1 release activated")
		$SFX/execute.play()
		velocity = DashDirection.normalized() * dash_speed
		animationstay = true
		start_cooldown(1.0)
		$SFX/charge.stop()
		timercountdown.start(dash_duration)
		
func skill2activate():
	if not lockskill and Allow_jump:
		animated_sprite.play("spin")
		if skill2online:
			enemyparent.take_damage(10)
			push_warning("skill2 activated")
		$SFX/spiiin.play()
		if onair == true:
			animationstay = true
		if not onair:
			animationstay = false
		start_cooldown(0.5)

func skill3activate():
	if not lockskill:
		skill3active = true
		if skill3online:
			push_warning("skill3 activated")
			animated_sprite.play("upyogo")
		enemyparent.take_damage(10)
		animationstay = true  
		SPEED = 0  
		$SFX/up.play()
		start_cooldown(1.0)  

#-------------------------------------#
#cooldown timers  x
func start_cooldown(duration):
	skill1cd.text = str("Skill not ready")
	push_warning("Starting cooldown for seconds", duration)
	lockskill = true
	cooldown_timer.start(duration)

func _on_CooldownTimer_timeout():
	lockskill = false
	skill3active = false
	skill1cd.text = str("Skill Ready")

func checkspin():
	if animated_sprite.animation == "jump":
		skill2active = true
	else:
		skill2active = false

func _on_Timer_timeout():
	isDashing = false
	dashParticles.emitting = false
	SPEED = 80.0 # Resetting the speed to the default


func allowedskill1toapplydamage(canapplied1: bool):
	skill1online = canapplied1
func allowedskill2toapplydamage(canapplied2: bool):
	skill2online = canapplied2
func allowskill3toapplydamage(canapplied3: bool):
	skill3online = canapplied3
