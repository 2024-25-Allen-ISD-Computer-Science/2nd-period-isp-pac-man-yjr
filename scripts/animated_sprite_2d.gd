extends AnimatedSprite2D  # Since the script is attached to AnimatedSprite2D

func _ready():
	# Access the parent node (CharacterBody2D)
	var character_body = get_parent()  # This will return the CharacterBody2D node

	# Check if the parent exists
	if character_body:
		print("CharacterBody2D node found!")
	
	# Play the "run" animation
	play("run")
