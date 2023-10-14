extends Node
class_name staminasys

@export var max_stamina: int = 100
@export var current_stamina: int = 100
@export var staminaregen: int = 1
@export var regen_interval: float = 1.0  # seconds between each regen tick

var regen_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(regen_timer)
	regen_timer.wait_time = regen_interval
	regen_timer.connect("timeout", Callable(self, "_on_regen_timeout"))
	regen_timer.start()

# Consumes a specific amount of stamina
func consume_stamina(amount: int):
	if current_stamina - amount >= 0:
		current_stamina -= amount
		emit_signal("stamina_changed", current_stamina)
	else:
		print("Not enough stamina!")

# Checks if there's enough stamina to perform an action
func can_consume(amount: int) -> bool:
	return current_stamina >= amount

# Function called when the regen timer times out
func _on_regen_timeout():
	if current_stamina < max_stamina:
		current_stamina = min(current_stamina + staminaregen, max_stamina)
		emit_signal("stamina_changed", current_stamina)

# Checks if there's enough stamina to perform an action.
func has_enough_stamina(amount: int) -> bool:
	return current_stamina >= amount
