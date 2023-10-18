extends HBoxContainer

class_name skillsiconcontainer

@onready var skill1spriteicon : AnimatedSprite2D = $Skill1
@onready var skill2spriteicon : AnimatedSprite2D = $Skill2
@onready var skill3spriteicon : AnimatedSprite2D = $Skill3
@onready var skill4spriteicon : AnimatedSprite2D = $Skill4
@onready var jumpsprite : AnimatedSprite2D = $Jump

var shizuka : Shizuka


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		jumpsprite.play("Jumphold")
	else:
		jumpsprite.play("Jump")
# Called when the node enters the scene tree for the first time.
func _ready():
	shizuka = Shizuka.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
