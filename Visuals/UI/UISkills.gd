class_name uiskillhandler extends Control

#signals

#handlers
@onready var Skill1 : AnimatedSprite2D = $Skill1
@onready var Skill2 : AnimatedSprite2D = $Skill2
@onready var Skill3 : AnimatedSprite2D = $Skill3
@onready var Jump : AnimatedSprite2D = $Jump

@onready var triggerskill1button : bool = false
@onready var triggerskill2button : bool = false
@onready var triggerskill3button : bool = false
@onready var triggerjumpbutton : bool = false

var player
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player.connect("skill1on", Callable(self,("_skill1activebutton")))
	player.connect("skill2on", Callable(self,("_skill2activebutton")))
	player.connect("skill3on", Callable(self,("_skill3activebutton")))
	player.connect("jumpon", Callable(self,("_jumpactivebutton")))
	
func _physics_process(_delta):
	if triggerskill1button:
		Skill1.play("Skill1hold")
	else:
		Skill1.play("Skill1")
	if triggerskill2button:
		Skill2.play("Skill2hold")
	else:
		Skill2.play("Skill2")
	if triggerskill3button:
		Skill3.play("Skill3hold")
	else:
		Skill3.play("Skill3")
	if triggerjumpbutton:
		Jump.play("Jumphold")
	else:
		Jump.play("Jump")

func _skill1activebutton(_isbuttontrigger1: bool):
	triggerskill1button = _isbuttontrigger1
func _skill2activebutton(_isbuttontrigger2: bool):
	triggerskill2button = _isbuttontrigger2
func _skill3activebutton(_isbuttontrigger3: bool):
	triggerskill3button = _isbuttontrigger3
func _jumpactivebutton(_isbuttontrigger4: bool):
	triggerjumpbutton = _isbuttontrigger4

