extends Timer

# This variable will keep track of elapsed seconds
var elapsed_seconds = 0

# Reference to the label
@onready var playtime_label: Label = $Label

func _ready():
	# Connect the timeout signal of this timer to its own function
	self.connect("timeout", Callable(self, "_on_Timer_timeout"))

# This function is called every second
func _on_Timer_timeout():
	elapsed_seconds += 1
	# Convert the elapsed_seconds to a time format
	var minutes = int(elapsed_seconds / 60)
	var seconds = elapsed_seconds % 60
	playtime_label.text = "%02d:%02d" % [minutes, seconds]
