extends CharacterBody2D
class_name meleeenemy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player : Shizuka
#
signal velocity_updated(direction)
var enemychildhealth

@onready var attackcollisionrange = $AttackRange
@onready var meleeEnemyAnim: AnimatedSprite2D = $AnimatedSprite2D

@export var enemySpeed = 70
var direction = Vector2.ZERO
var foundenemy : bool = false
var detection_range_node : Node2D
var playerhealth : healthsys
var normalattackative : bool = false
var pierceattackactive : bool = false
var animationlock : bool = false
@export var enemyjumpvelocity : int = -300

#enemy behavior flags
var enemybelow20 : bool = false
var staydead : bool  = false
#dash timer and such
var dashdirection = Vector2.ZERO
var enemyisdashing: bool = false
@export  var enemydash_speed: int = 1000
var deads : bool = false

# Cooldown Timer and related variables
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
var isAttackOnCooldown: bool = false
var hasAttacked : bool = false  

#shader 
@onready var hitenemyfxtimerr : Timer = $hitenemyfxtimer

#skillpierce
@onready var stunnedduration : Timer = $timers/stuntime
@onready var stunimmunduration : Timer = $timers/stunimmunity

#stun behavior
var stunned : bool  = false
var stunimmunetrigger : bool = false
@export var maxstuncounter : int  = 3
var stuncounter = maxstuncounter
var isairborne: bool = true

var chasedtohell: bool = false
var ispierceoncooldown: bool = false
var iskillpierce : bool = false

@onready var skillpiercecooldown : Timer = $timers/skillpiercecd
var knockbacktrigger: bool = false



func _ready():
	randomize()
	deads = false
	skillpiercecooldown.connect("timeout", Callable(self, "skillpierceoncd"))
	stunimmunduration.connect("timeout", Callable(self, "stunimmunecd"))
	detection_range_node = get_node("detectionrange")
	detection_range_node.connect("player_found",Callable( self, "_on_player_found"))
	detection_range_node.connect("player_lost", Callable(self, "_on_player_lost"))
	player = get_tree().get_first_node_in_group("Player")
	playerhealth = get_tree().get_first_node_in_group("shizukahealth")
	enemychildhealth = get_tree().get_first_node_in_group("enemyhealth")
	enemychildhealth.connect("enemyrage", Callable(self, "commitwarcrime"))
	attackcollisionrange.connect("player_ready_to_be_attacked", Callable(self, "enemynrmlattk"))
	attack_cooldown_timer.connect("timeout", Callable(self, "_on_AttackCooldownTimer_timeout"))
	enemychildhealth.connect("enemydeathtrigger", Callable(self, "enemyisdead"))
	hitenemyfxtimerr.connect("timeout", Callable(self, "hitenemyfxtimer" ))
	enemychildhealth.connect("enemyhealthchanged", Callable(self, "hitenemyfxtriggercd"))
	stunnedduration.connect("timeout", Callable(self, "stuncd"))
	player.connect("enemyairborne", Callable(self, "enemyairborned"))
	enemychildhealth.connect("applyknock", Callable(self, "hellow"))


func hellow():
	if not deads:
		velocity.y = -150
		
func skillpierceoncd():
	iskillpierce = true
	ispierceoncooldown = false
func stuncd():
	stunned = false

func stunimmunecd():
	stunimmunetrigger = false

func hitenemyfxtriggercd():
	if not deads:
		meleeEnemyAnim.material.set_shader_parameter("flash_modifier", 1)
		hitenemyfxtimerr.start(0.1)

func hitenemyfxtimer():
	meleeEnemyAnim.material.set_shader_parameter("flash_modifier", 0)

func _on_player_found():
	foundenemy = true
	
func _on_player_lost():
	foundenemy = false

	
func update_facing_direction_enemy():
	if not deads:
		if direction.x < 0:
			meleeEnemyAnim.flip_h = false
		elif direction.x > 0:
			meleeEnemyAnim.flip_h = true

	if not animationlock and not deads:
		if direction.x != 0:
			meleeEnemyAnim.play("run")
		elif direction.x == 0:
			meleeEnemyAnim.play("idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if foundenemy:
		chasedtohell = true
	
	if chasedtohell:
		enemyhasfounplayer()
	
	update_facing_direction_enemy()
	move_and_slide()
	emit_signal("velocity_updated", direction) 

func datkdelay():
	var distance_to_player = player.global_position.distance_to(global_position)
	if distance_to_player < 10:
		playerhealth.player_take_damage(10)

func enemynrmlattk():
	if(not isAttackOnCooldown and not hasAttacked and not deads and not stunned and not iskillpierce):
		velocity.x = 0
		direction.x = 0
		meleeEnemyAnim.play("basic_attack")
		animationlock = true 
		hasAttacked = true
		start_attack_cooldown(1.2) 
		if enemybelow20 and not deads:
			if randf() < 0.3:
				await get_tree().create_timer(0.5).timeout
				meleeEnemyAnim.play("basic_attack")
				animationlock = true 
				playerhealth.player_take_damage(5)

func enemypierceattk():
	if (not deads and not stunned and not iskillpierce and not hasAttacked and not ispierceoncooldown):
		ispierceoncooldown = true
		enemySpeed = 200
		iskillpierce = true
		meleeEnemyAnim.play("skill_pierce")
		animationlock = true
		skillpiercecooldown.start(5.0)


func _on_animated_sprite_2d_animation_finished():
	if  meleeEnemyAnim.animation == "jump":
		animationlock = false
	if  meleeEnemyAnim.animation == "basic_attack":
		var distance_to_player = player.global_position.distance_to(global_position)
		if distance_to_player < 10:
			playerhealth.player_take_damage(10)
		animationlock = false
	elif meleeEnemyAnim.animation == "skill_pierce":
		playerhealth.player_take_damage(10)
		enemySpeed = 70
		animationlock = false
	if meleeEnemyAnim.animation == "stun":
		stunned  = false
		animationlock = false
		
func enemyhasfounplayer():
	var distance_to_player = player.global_position.distance_to(global_position)
	if distance_to_player > 10 and not deads and not stunned:
		if enemybelow20:
			enemySpeed = 100
		else:
			enemySpeed = 70
		direction.x = 1 if player.global_position.x > global_position.x else -1
		velocity.x = direction.x * enemySpeed
		if player.global_position.y < self.global_position.y - 10:
			enemydojump()
		if player.global_position.y > self.global_position.y - 40:  
			position.y += 1
	else:
		velocity.x = 0
		direction.x = 0
		enemynrmlattk()

# Cooldown functions
func start_attack_cooldown(duration):
	attack_cooldown_timer.start(duration)
	isAttackOnCooldown = true

func _on_AttackCooldownTimer_timeout():
	isAttackOnCooldown = false
	hasAttacked = false  # Reset the attack flag when cooldown ends

#-------------------------------------#
func enemystartdash():
	if direction.x < 1:
		dashdirection = Vector2(-1, 0)
	if direction.x > 1:
		dashdirection = Vector2(1, 0)

	if not enemyisdashing:
		enemydash()

func enemydash():
	enemyisdashing = true
	meleeEnemyAnim.play("jump")
	velocity = dashdirection.normalized() * enemydash_speed
	animationlock = true
	
func enemydojump():
	await get_tree().create_timer(0.3).timeout
	if is_on_floor() and not deads:
		enemyjump() 

func enemyairborned():
	if not deads and not stunimmunetrigger:
		if stuncounter == 0:
			stuncounter = maxstuncounter
			stunimmunetrigger = true
			stunimmunduration.start(5.0)
		stuncounter -= 1
		stunned = true
		velocity.y = -250
		animationlock = true
		meleeEnemyAnim.play("stun")

func enemyjump():
	velocity.y = enemyjumpvelocity
	animationlock = true
	meleeEnemyAnim.play("jump")
	$SFX/jump.play()
func commitwarcrime(isenemyrage):
	enemybelow20 = isenemyrage
	push_warning("now go commit warcrime")

func enemyisdead():
		staydead = true
		deads = true
		velocity.x = 0
		meleeEnemyAnim.play("death")
		animationlock = false
		resetscene()

func resetscene():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://area_2d.tscn")
