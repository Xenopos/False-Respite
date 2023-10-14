extends Node

class_name State

var Player : CharacterBody2D

@export var current_skill_state : State
@export var initial_skill_state : State
var Player_skill_state : Dictionary  = {}


func _ready():
	for child in get_children():
		if child is State:
			Player_skill_state[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
		else:
			push_warning(child.name)

func _process(delta):
	if current_skill_state:
		current_skill_state.Update(delta)

func _physics_process(delta):
	if current_skill_state:
		current_skill_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	if state != current_skill_state:
		return 
	var new_state = state.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_skill_state:
		current_skill_state.Exit()
		
	new_state.Enter()
	current_skill_state = new_state

