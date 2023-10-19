class_name Shizuka extends CharacterBody2D

#------------------------------------#
@export var SPEED = 80.0
@export var JUMP_VELOCITY = -180.0

#------------------------------------#
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dashParticles: GPUParticles2D = $DashParticles
@onready var skill1particles: GPUParticles2D = $skill1particlesready
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
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
var Allow_jump : bool = true

#skills flags for applying damage
var skill1online : bool =  false
var skill2online : bool =  false
var skill3online : bool =  false

#dash var
@onready var dash_cd : float = 0.3
@onready var isdashcd : bool = false
@onready var dash_speed: float = 600
@onready var dash_duration: float = 0.1
@onready var skill1cd : Label = $Label
var enemyparent : enemyhealth
#------------------------------------#
var nowdead : bool = false
#------------------------------------#
#UI handler
signal skill1on(_isbuttontrigger1)
signal skill2on(_isbuttontrigger2)
signal skill3on(_isbuttontrigger3)
signal jumpon(_isbuttontrigger4)

#signals used
@export var cooldown_timer: Timer
@onready var shizukahealth : healthsys = $HealthSystem
@onready var timercountdown: Timer = $Timer
@export var skill3area : Area2D 
@export var anysingepointdamage : Area2D
@export var dashcd : Timer 

func _ready():
	skill1particles.emitting = false
	add_to_group("Player")
	dashParticles.emitting = false
	#onreadysignals
	shizukahealth.connect("emitdeadstoplayer", Callable(self, "playerisnowdead"))
	dashcd.connect("timeout", Callable(self, "dashcooldownd"))
	
	anysingepointdamage.connect("applydamagedash" , Callable( self, "allowedskill1toapplydamage"))
	anysingepointdamage.connect("applydamage", Callable(self, "allowedskill3toapplydamage"))
	skill3area.connect("applyskill2damage", Callable(self, "allowskill2toapplydamage"))
	
	timercountdown.connect("timeout", Callable(self, "_on_Timer_timeout"))
	cooldown_timer.connect("timeout", Callable(self, "_on_CooldownTimer_timeout"))
	skill2active  = true
	skill3active  = true
	#getparent
	enemyparent = get_tree().get_first_node_in_group("enemyhealth")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		onair = true
		jumpon.emit(false)
	else:
		onair = false

	if not isDashing and not nowdead:
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
	if not animationstay and not nowdead:
		if direction.x != 0:
			animated_sprite.play("run")
		elif direction.x == 0 or isAttacking:
			animated_sprite.play("idle")

func update_facing_direction():
	if direction.x < 0 and not nowdead:
		animated_sprite.flip_h = false
	elif direction.x > 0 and not nowdead:
		animated_sprite.flip_h = true

func doJump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and Allow_jump and not nowdead:
		jumpon.emit(true)
		jump()

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


func attack():
	if (
		Input.is_action_just_pressed("attack")
		and AttackCombo == 0
		and isDashing == false
		and not nowdead
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
		and not nowdead
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

	if Input.is_action_just_pressed("dash") and not isDashing and not isdashcd and not nowdead:
		start_dash()

func start_dash():
		dashParticles.emitting = true
		isDashing = true
		$SFX/dash.play()
		animated_sprite.play("dash")
		velocity = DashDirection.normalized() * dash_speed
		animationstay = true
		timercountdown.start(dash_duration)
		isdashcd = true
		dashcd.start(dash_cd)

func Skill_activation():
	if not lockskill and not nowdead:
		if (Input.is_action_just_pressed("Skill1") and is_on_floor() and not isAttacking and not isDashing):
			skill1activate()
			skill1on.emit(true)
		elif (Input.is_action_just_released("Skill1") and is_on_floor() and not lockskill and not isDashing):
			skill1releaseactivate()
		if (Input.is_action_just_pressed("Skill2") and not is_on_floor() and not isDashing):
			skill2activate()
			skill2on.emit(true)
		if (Input.is_action_just_pressed("Skill3") and not isDashing):
			skill3activate()
			skill3on.emit(true)

func skill1activate():
	skill1particles.emitting = true
	if not lockskill and not Allow_jump:
		skill1on.emit(true)
		Allow_jump = false
		animated_sprite.play("dash ready")
		animationstay = true
		SPEED = 0
		$SFX/charge.play()
		
func skill1releaseactivate():
	if not isDashing and not lockskill:
		skill1particles.emitting = false
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
			enemyparent.take_damage(10)
		animated_sprite.play("upyogo")
		animationstay = true  
		SPEED = 0  
		$SFX/up.play()
		start_cooldown(1.0)  

#-------------------------------------#
#cooldown timers  
func start_cooldown(duration):
	skill1cd.text = str("Skill not ready")
	lockskill = true
	cooldown_timer.start(duration)

func _on_CooldownTimer_timeout():
	skill1on.emit(false)
	skill2on.emit(false)
	skill3on.emit(false)
	lockskill = false
	skill3active = false
	skill1cd.text = str("Skill Ready")

func checkspin():
	if animated_sprite.animation == "jump":
		skill2active = true
	else:
		skill2active = false

#--------------------------------------#
#dash  function
func _on_Timer_timeout():
	isDashing = false
	dashParticles.emitting = false
	SPEED = 80.0 # Resetting the speed to the default

func dashcooldownd():
	isdashcd = false
	SPEED = 80.0
#------------------------------------#
# flags for applying skill damage
func allowedskill1toapplydamage(canapplied1: bool):
	skill1online = canapplied1
func allowskill2toapplydamage(canapplied2: bool):
	skill2online = canapplied2
func allowedskill3toapplydamage(canapplied3: bool):
	skill3online = canapplied3

	
#--------------------------------------#
#check if the player is dead
func playerisnowdead():
	animationstay = true
	nowdead = true
	animated_sprite.play("Death")
	push_warning("deads none reduced to shit")
