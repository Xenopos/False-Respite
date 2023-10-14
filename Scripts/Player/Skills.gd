extends Node

class_name Skills

var shizuka: Shizuka 
@export var spriteanim: AnimatedSprite2D 
var skillanimstay: bool = true
var lockskill: bool = false
@export var cooldown_timer: Timer 

func _ready():
	push_warning("Ready function executed")
	cooldown_timer.connect("timeout", Callable(self, "_on_CooldownTimer_timeout"))
	shizuka = Shizuka.new()

func _physics_process(_delta):
	print("_physics_process executed")
	Skill_activation()

func Skill_activation():
	if not lockskill:
		if (Input.is_action_just_pressed("Skill1") and shizuka.is_on_floor() and not shizuka.isAttacking):
			skill1activate()
		elif (Input.is_action_just_released("Skill1") and shizuka.is_on_floor()):
			skill1releaseactivate()
		if (Input.is_action_just_pressed("Skill2") and not shizuka.is_on_floor()):
			skill2activate()
		if (Input.is_action_just_pressed("Skill3")):
			skill3activate()

func skill1activate():
	if not lockskill:
		push_warning("skill1 activated")
		shizuka.Allow_jump = false
		spriteanim.play("dash ready")
		shizuka.animationstay = true
		shizuka.SPEED = 0
		$"../SFX/charge".play()
		start_cooldown(5.0)

func skill1releaseactivate():
	push_warning("skill1 release activated")
	shizuka.Allow_jump = true
	spriteanim.play("dash attack")
	$"../SFX/execute".play()
	shizuka.velocity = shizuka.DashDirection.normalized() * 1200
	skillanimstay = true
	$"../SFX/charge".stop()
	if shizuka.direction.x == 0:
		shizuka.SPEED = 80
	else:
		shizuka.SPEED = 400

func skill2activate():
	if not lockskill:
		push_warning("skill2 activated")
		spriteanim.play("spin")
		$"../SFX/spiiin".play()
		if shizuka.is_on_floor():
			skillanimstay = true
		else:
			skillanimstay = false
		start_cooldown(5.0)

func skill3activate():
	if not lockskill:
		push_warning("skill3 activated")
		spriteanim.play("upyogo")
		skillanimstay = true
		shizuka.SPEED = 0
		$"../SFX/charge".play()
		start_cooldown(5.0)

func start_cooldown(duration):
	push_warning("Starting cooldown for {} seconds".format(duration))
	lockskill = true
	cooldown_timer.start(duration)

func _on_CooldownTimer_timeout():
	push_warning("Cooldown timer timed out")
	lockskill = false

func _on_animated_sprite_2d_animation_finished():
	print("Animation finished:", spriteanim.animation)
	if spriteanim.animation in ["dash attack", "spin", "upyogo"]:
		# Add desired behavior when certain animations end
		pass
