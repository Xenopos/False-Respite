extends Node2D


# Called when the node enters the scene tree for the first time.
var enemy_scene = load("res://melee_enemy.tscn")
var new_enemy = enemy_scene.duplicate()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(new_enemy)

		

