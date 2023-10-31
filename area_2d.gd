extends TileMap
class_name spawntochild

var mob_scene = preload("res://Scenes/melee_enemy.tscn")
@onready var spawn : Node2D = $Node2D
@export var limitedspawnL: int = 1
var enemyhandler

func _ready():
	enemyhandler = get_tree().get_first_node_in_group("Enemy")
	spawntheshit()
func _physics_process(_delta):
	pass
	
func spawntheshit():
		if limitedspawnL != 0:
			limitedspawnL -= 1
			var enemy_instance = mob_scene.instantiate()
			enemy_instance.add_to_group("Enemy")
			spawn.add_child(enemy_instance)
