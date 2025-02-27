extends Button

var new_scene_path : String = "res://scenes/level1.tscn"

func _ready():
	# Avoid duplicate signal connections
	if not self.pressed.is_connected(_on_button_pressed):
		self.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	print("Button was pressed!")
	var error = get_tree().change_scene_to_file(new_scene_path)
	if error != OK:
		print("Error changing scene! Code:", error)
