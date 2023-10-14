extends Node

class_name Skills

var shizuka = Shizuka.new()

@onready var spriteanim : AnimatedSprite2D = $AnimatedSprite2D
var skillanimstay : bool = true
var lockskill : bool = true
@onready var cooldown_timer : Timer = $CooldownTimer # Assuming you've added a Timer node named "CooldownTimer" to the Skills node

func _ready():
	cooldown_timer.connect("timeout", Callable(self, "_on_CooldownTimer_timeout"))

func _physics_process(delta):
	Skill_activation()

func Skill_activation():
	if lockskill:
		return # Exit early if skills are locked

	if (Input.is_action_just_pressed("Skill1") and shizuka.is_on_floor() and not shizuka.isAttacking):
		activate_skill1()
		start_cooldown(3.0) # adjust as needed

	elif (Input.is_action_just_pressed("Skill2") and not shizuka.is_on_floor()):
		activate_skill2()
		start_cooldown(2.0) # adjust as needed

	elif (Input.is_action_just_pressed("Skill3")):
		activate_skill3()
		start_cooldown(3.0) # ; adjust as needed

func activate_skill1():
	shizuka.Allow_jump = false
	spriteanim.play("dash ready")
	shizuka.animationstay = true
	shizuka.SPEED = 0
	$SFX/charge.play()

	# Consider adding the released behavior within another function or signal for more precise control

func activate_skill2():
	spriteanim.play("spin")
	$SFX/spiiin.play()
	if shizuka.onair:
		skillanimstay = true
	else:
		skillanimstay = false

func activate_skill3():
	spriteanim.play("upyogo")
	skillanimstay = true
	shizuka.SPEED = 0
	$SFX/up.play()

func start_cooldown(duration):
	lockskill = true
	cooldown_timer.start(duration)

func _on_CooldownTimer_timeout():
	lockskill = false

func _on_animated_sprite_2d_animation_finished():
	if (
		spriteanim.animation == "dash attack"
		or spriteanim.animation == "spin"
		or spriteanim.animation == "upyogo"
	):
		pass  # Add desired behavior when certain animations end
