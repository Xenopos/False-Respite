extends CharacterBody2D
class_name Shizuka
#------------------------------------#
@export var SPEED = 80.0
@export var JUMP_VELOCITY = -230

#------------------------------------#
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dashParticles: GPUParticles2D = $DashParticles
@onready var skill1particles: GPUParticles2D = $skill1particlesready
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var ultswqoosh : AnimationPlayer = $ultswqoosh
#------------------------------------#

var lockskill : bool = false
var animationstay: bool = false
var direction: Vector2 = Vector2.ZERO
var onair: bool = false 
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
var skill3active = true
var skill2active  = false
var skill1active = false

#dash var
@export var dash_cd : float = 0.8
var isdashcd : bool = false
var dash_speed: float = 600
var dash_duration: float = 0.15 # dash length
@onready var skill1cd : Label = $CanvasLayer/Label2
var enemyparent : enemyhealth
var mainenemy1
#------------------------------------#
var nowdead : bool = false
#------------------------------------#
#UI handler
signal skill1on(_isbuttontrigger1)
signal skill2on(_isbuttontrigger2)
signal skill3on(_isbuttontrigger3)
signal jumpon(_isbuttontrigger4)
signal enemyairborne
signal ulton(_ibuttontriggerult)

#signals used
@export var cooldown_timer: Timer
@onready var shizukahealth : healthsys = $HealthSystem
@onready var timercountdown: Timer = $Timer
@export var skill2area : Area2D 
@export var anysingepointdamage : Area2D
@onready var dashcd : Timer = $dashcooldown
#skills timer sets for applying damage
@onready var skill2_cd_timer: Timer = $skill2_cd_timer
@onready var skill1_cd_timer : Timer = $skill1_cd_timer
var resetskill2damage: bool = true
var resetskill1damage : bool = true

#hitfxtimer
@onready var hitfxtimer : Timer = $hitfxtimer

#basic attack and skill damage
@export var skill1damage: int = 10
@export var skill2damage: int = 10
@export var skill3damage: int = 10
@export var basicatkdamage: int = 10

#vulnerability handler
signal damagevulnebarility(isvulnerable)

#ult trigger
var ultimateactive : bool = false
var ultimateactiveset : bool = false

@onready var ulttimer : Timer = $ulttimer
@export var ultcountdown : float = 30
@export var ultdamage : int = 100

#basicattacktimer
@onready var basicatkcd: Timer = $attackcd
var basicatkoncd : bool = false
#pause menu
#imnpale
var impaleactive : bool = false
var impalehit : bool = false

var newenemy 

signal applydamagetoenemy(amount)
@onready var spriteult : Sprite2D = $Sprite2D

func _ready():
	spriteult.hide()
	ultcountdown = 30
	ulttimer.start(ultcountdown)
	ulttimer.connect("timeout", Callable(self, "allowultimate"))
	basicatkcd.connect("timeout", Callable(self, "_basicatkcd"))
	hitfxtimer.connect("timeout", Callable(self, "hitfxtimercd"))
	skill1particles.emitting = false
	add_to_group("Player")
	dashParticles.emitting = false
	shizukahealth.connect("playerkknockback", Callable(self, "applyknockbacktoshishi"))
	#onreadysignals
	shizukahealth.connect("healthchanged", Callable(self,"emitdamagefx"))
	shizukahealth.connect("emitremovalofexistence", Callable(self, "playerisnowdead"))
	dashcd.connect("timeout", Callable(self, "dashcooldownd"))
	skill1_cd_timer.connect("timeout", Callable(self, "_on_skill1_cd_timer_timeout"))
	skill2_cd_timer.connect("timeout", Callable(self, "_on_skill2_cd_timer_timeout"))
	anysingepointdamage.connect("applydamagedash" , Callable( self, "allowedskill1toapplydamage"))
	anysingepointdamage.connect("applydamage", Callable(self, "allowedskill3toapplydamage"))
	skill2area.connect("applyskill2damage", Callable(self, "allowskill2toapplydamage"))
	timercountdown.connect("timeout", Callable(self, "_on_Timer_timeout"))
	cooldown_timer.connect("timeout", Callable(self, "_on_CooldownTimer_timeout"))
	#getparent
	enemyparent = get_tree().get_first_node_in_group("enemyhealth")
	mainenemy1 = get_tree().get_first_node_in_group("Enemy")


func allowultimate():
	ulton.emit(true)
	ultimateactive = true

func _basicatkcd():
	basicatkoncd = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		onair = true
		jumpon.emit(false)
	else:
		onair = false
	
	
	if not ultimateactiveset:
		if not isDashing and not nowdead:
			direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			if direction:
				velocity.x = direction.x * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
			if Input.is_action_just_pressed("ui_down"):
				self.position.y += 1
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://area_2d.tscn")


	move_and_slide()
	update_animation()
	update_facing_direction()
	attack()
	dash()
	Skill_activation()
	doJump()
	skill2()
	commithealing()
	skill1()
	ultimatebull()
	
func skill1():
	if skill1online and skill1active and resetskill1damage:
		enemyparent.take_damage(skill1damage)
		skill1active = false
		resetskill1damage = false
		skill1_cd_timer.start(0.9)
		
func skill2():
	if skill2online and resetskill2damage and skill2active:
		enemyparent.take_damage(skill2damage)
		velocity.y = -200
		resetskill2damage = false
		skill2active = false  # Deactivate the skill
		skill2_cd_timer.start(0.1)  # Start the cooldown

func _on_skill1_cd_timer_timeout():
	resetskill1damage = true
func _on_skill2_cd_timer_timeout():
	resetskill2damage = true  # Reactivate the skill once the cooldown ends

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
		animated_sprite.animation == "attack"
		or animated_sprite.animation == "attack2"
		or animated_sprite.animation == "dash"
		or animated_sprite.animation == "spin"
		or animated_sprite.animation == "execute"
		or animated_sprite.animation == "jump"
	):
		Allow_jump = true
		animationstay = false
		SPEED = 80.0
		gravity = 480
	if animated_sprite.animation == "dash attack":
		animationstay = false
		skill1active = false
		SPEED = 80.0
		gravity = 480
	if animated_sprite.animation == "upyogo":
		animationstay = false
		if skill3online:
			enemyparent.take_damage(skill3damage)
			enemyairborne.emit()
	if animated_sprite.animation == "bye":
			Allow_jump = true
			SPEED = 80.0
			animationstay = false
	if animated_sprite.animation == "impale":
			animationstay = false

func ultimatebull():
	var distance_to_enemy = mainenemy1.global_position.distance_to(global_position)
	if Input.is_action_just_pressed("ult skill") and distance_to_enemy < 200 and ultimateactive and Allow_jump:
		animated_sprite.play("bye")
		Allow_jump = false
		ulton.emit(false)
		velocity.x = 0
		awaitanimate()
		velocity.y = 0
		gravity = 0
		ulttimer.start(ultcountdown)
		ultimatebulldelaydamage()
		ultimateactiveset = true
		ultimateactive = false
		animationstay = true

func awaitanimate():
	await get_tree().create_timer(1).timeout
	$SFX/ultsfx.play()
	spriteult.show()
	ultswqoosh.play("ult")

func ultimatebulldelaydamage():
	await get_tree().create_timer(1.5).timeout
	spriteult.hide()
	ultswqoosh.stop()
	ultimateactiveset = false
	gravity = 480
	applydamagetoenemy.emit(ultdamage)

func attack():
	if (Input.is_action_just_pressed("attack") and AttackCombo == 0 and isDashing == false and not nowdead and not basicatkoncd):
		if skill3online:
			enemyparent.take_damage(basicatkdamage)
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
		and not basicatkoncd
	):
		if skill3online:
			enemyparent.take_damage(basicatkdamage)
		SPEED = 30
		AttackCombo -= 1
		isAttacking = true
		animated_sprite.play("attack2")
		animationstay = true
		$SFX/attacksfx.play()
		basicatkoncd = true
		basicatkcd.start(0.2)
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
		damagevulnebarility.emit(true)
		dashParticles.emitting = true
		isDashing = true
		$SFX/dash.play()
		animated_sprite.play("dash")
		velocity = DashDirection.normalized() * dash_speed
		animationstay = true
		timercountdown.start(dash_duration)
		isdashcd = true
		dashcd.start(dash_cd)

func skill_impale():
	if not lockskill and Allow_jump:
		velocity.y = -100
		animated_sprite.play("impale")
		animationstay = true
		impaleapplydamage()
		if onair == true:
			skill2active = true
			animationstay = true
		if not onair:
			skill2active = false
		start_cooldown(0.5)
		impaledealaydown()

func impaledealaydown():
	await get_tree().create_timer(0.4).timeout
	velocity.y = 500
		
func impaleapplydamage():
	pass

func Skill_activation():
	if not lockskill and not nowdead and not ultimateactiveset:
		if (Input.is_action_just_pressed("Skill1") and is_on_floor() and not isAttacking and not isDashing):
			skill1activate()
			skill1on.emit(true)
		elif (Input.is_action_just_released("Skill1") and is_on_floor() and not lockskill and not isDashing):
			skill1releaseactivate()
			skill1on.emit(true)
		if (Input.is_action_just_pressed("Skill2") and not is_on_floor() and not isDashing):
			skill2activate()
			skill2on.emit(true)
		if (Input.is_action_just_pressed("Skill3") and not isDashing):
			skill3activate()
			skill3on.emit(true)
		if (Input.is_action_just_pressed("skillimpale") and not isDashing):
			skill_impale()
			skill2on.emit(true)
			
func skill1activate():
	if not lockskill and not Allow_jump:
		skill1on.emit(true)
		Allow_jump = false
		animated_sprite.play("dash ready")
		animationstay = true
		SPEED = 0
		Engine.time_scale = 0.05
		$SFX/charge.play()


func skill1releaseactivate():
	if not isDashing and not lockskill:
		skill1particles.emitting = false
		skill1active = true
		isDashing = true
		Allow_jump = true
		animated_sprite.play("dash attack")
		$SFX/execute.play()
		velocity = DashDirection.normalized() * dash_speed
		animationstay = true
		start_cooldown(1.0)
		$SFX/charge.stop()
		timercountdown.start(dash_duration)

func slowrever():
	await get_tree().create_timer(1.5).timeout
	Engine.time_scale = 1

func skill2activate():
	if not lockskill and Allow_jump:
		animated_sprite.play("spin")
		$SFX/spiiin.play()
		if onair == true:
			skill2active = true
			animationstay = true
		if not onair:
			skill2active = false
		start_cooldown(0.5)

func skill3activate():
	if not lockskill:
		skill3active = true
		animated_sprite.play("upyogo")
		animationstay = true  
		SPEED = 0  
		$SFX/up.play()
		start_cooldown(1.0)  

#-------------------------------------#
#cooldown timers  
func start_cooldown(duration):
	impaleactive = false
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

func applyknockbacktoshishi():
	pass


#--------------------------------------#
#dash  function
func _on_Timer_timeout():
	isDashing = false
	dashParticles.emitting = false
	SPEED = 80.0 # Resetting the speed to the default

func vtime():
		damagevulnebarility.emit(false)

func dashcooldownd():
	vtime()
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

#--------------------------------------#d
#check if the player is dead
func playerisnowdead():
	velocity.x = 0
	animationstay = true
	nowdead = true
	resetscene()
	animated_sprite.play("Death")
	
func resetscene():
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://area_2d.tscn")

#------------------------------------------#
#healing
func commithealing():
	if Input.is_action_just_pressed("heal"):
		skill1particles.emitting = true
		shizukahealth.heal(20)
	else:
		skill1particles.emitting = false
#-------------------------------------#
#emit fx
func emitdamagefx():
	animated_sprite.material.set_shader_parameter("flash_modifier", 1)
	hitfxtimer.start(0.1)
func hitfxtimercd():
	animated_sprite.material.set_shader_parameter("flash_modifier", 0)
	
