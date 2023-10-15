extends Node

class_name Skills

@export var spriteanim: AnimatedSprite2D 
var skillanimstay: bool = true
var lockskill: bool = true
@export var cooldown_timer: Timer 

func _ready():
	push_warning("Ready function executed")
	cooldown_timer.connect("timeout", Callable(self, "_on_CooldownTimer_timeout"))

func _physics_process(_delta):
	print("_physics_process executed")
	Skill_activation()

func Skill_activation():
	if not lockskill:
		if (Input.is_action_just_pressed("Skill1") and is_on_floor() and not isAttacking):
			skill1activate()
		elif (Input.is_action_just_released("Skill1") and is_on_floor()):
			skill1releaseactivate()
		if (Input.is_action_just_pressed("Skill2") and not is_on_floor()):
			skill2activate()
		if (Input.is_action_just_pressed("Skill3")):
			skill3activate()

func skill1activate():
	if not lockskill:
		push_warning("skill1 activated")
		Allow_jump = false
		spriteanim.play("dash ready")
		animationstay = true
		SPEED = 0
		$"../SFX/charge".play()
		start_cooldown(5.0)

func skill1releaseactivate():
	push_warning("skill1 release activated")
	Allow_jump = true
	spriteanim.play("dash attack")
	$"../SFX/execute".play()
	velocity = DashDirection.normalized() * 1200
	skillanimstay = true
	$"../SFX/charge".stop()
	if direction.x == 0:
		SPEED = 80
	else:
		SPEED = 400

func skill2activate():
	if not lockskill:
		push_warning("skill2 activated")
		spriteanim.play("spin")
		$"../SFX/spiiin".play()
		if is_on_floor():
			skillanimstay = true
		else:
			skillanimstay = false
		start_cooldown(5.0)

func skill3activate():
	if not lockskill:
		push_warning("skill3 activated")
		spriteanim.play("upyogo")
		skillanimstay = true
		SPEED = 0
		$"../SFX/charge".play()
		start_cooldown(5.0)

func start_cooldown(duration):
	push_warning("Starting cooldown for {} seconds".format(duration))
	lockskill = true
	cooldown_timer.start(duration)

func _on_CooldownTimer_timeout():
	push_warning("Cooldown timer timed out")
	lockskill = false

