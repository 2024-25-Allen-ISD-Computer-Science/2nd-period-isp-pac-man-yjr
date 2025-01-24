extends CharacterBody2D

@export var walk_speed : float = 200.0  # Character's walking speed
@export var camera_offset : Vector2 = Vector2(0, -100)  # Camera offset from character

# AnimatedSprite2D for handling the animations
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Camera2D node
@onready var camera : Camera2D = $Camera2D

func _ready():
	# Initialize the camera (attach it to the character)
	camera.offset = camera_offset

func _process(delta):
	# Handle movement input using the built-in ui_* actions
	var movement = Vector2.ZERO  # Create a local vector to store the input

	if Input.is_action_pressed("ui_up"):
		movement.y -= 1
	if Input.is_action_pressed("ui_down"):
		movement.y += 1
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_right"):
		movement.x += 1

	# Normalize movement to avoid diagonal speed boost
	movement = movement.normalized() * walk_speed

	# Apply the movement to the velocity
	velocity = movement

	# Apply movement and handle collisions
	move_and_slide()

	# Handle animations based on movement direction
	if velocity.length() > 0:
		if velocity.y < 0:
			play_animation("n-walk")  # North walk
		elif velocity.y > 0:
			play_animation("s-walk")  # South walk
		elif velocity.x > 0:
			play_animation("e-walk")  # East walk
	else:
		play_animation("idle")  # Idle animation when not moving

func play_animation(animation_name: String) -> void:
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)
