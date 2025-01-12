extends Button  # This attaches the script to the Button node

# Path to the scene you want to load
var new_scene_path : String = "res://scenes/story_initial.tscn"  # Replace with your actual scene path

func _ready():
	# Connect the button's "pressed" signal to the function
	self.pressed.connect(_on_button_pressed)

# This function is called when the button is pressed
func _on_button_pressed():
	get_tree().change_scene_to_file(new_scene_path)  # Use change_scene() with the scene path
