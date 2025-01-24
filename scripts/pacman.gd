extends CharacterBody2D
class_name PacMan

@export var speed = 175
@export var current_dir = "None"
@export var movement_direction := Vector2.ZERO

var velocity := Vector2()
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func get_input():
	velocity = Vector2()
	for input in inputs:
		if Input.is_action_just_pressed(input):
			current_dir = inputs
			movement_direction = inputs[input]

	velocity = movement_direction * speed

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
	if velocity.length() < 1 and movement_direction != Vector2.ZERO:
		movement_direction = Vector2.ZERO
