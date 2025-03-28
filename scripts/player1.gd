extends CharacterBody2D
class_name Player

# Movement
var next_movement_direction = Vector2.ZERO
var movement_direction = Vector2.ZERO
@export var speed: float = 300

# Animation
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Collision
@onready var collision_shape = $CollisionShape2D
var shape_query = PhysicsShapeQueryParameters2D.new()
var space_state: PhysicsDirectSpaceState2D

func _ready():
	space_state = get_world_2d().direct_space_state
	shape_query.shape = collision_shape.shape
	shape_query.collision_mask = 2  # Set to your wall collision layer

func _physics_process(_delta):
	get_input()
	
	# Update movement direction if possible
	if movement_direction == Vector2.ZERO:
		movement_direction = next_movement_direction
	if can_move_in_direction(next_movement_direction):
		movement_direction = next_movement_direction
	
	velocity = movement_direction * speed
	move_and_slide()
	
	# Handle animations
	update_animations()

func get_input():
	if Input.is_action_pressed("ui_left"):
		next_movement_direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		next_movement_direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_up"):
		next_movement_direction = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		next_movement_direction = Vector2.DOWN

func can_move_in_direction(dir: Vector2) -> bool:
	if dir == Vector2.ZERO:
		return false
		
	# More precise collision check by extending the shape query further
	shape_query.transform = global_transform.translated(dir * 16)  # 16 pixels ahead
	var result = space_state.intersect_shape(shape_query, 1)  # Only need first result
	return result.is_empty()

func update_animations():
	if not animated_sprite:
		return
		
	if movement_direction != Vector2.ZERO:
		animated_sprite.play("run")
		
		# Flip sprite based on direction
		if movement_direction.x > 0:  # Right
			animated_sprite.flip_h = false
		elif movement_direction.x < 0:  # Left
			animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")  # Assuming you have an idle animation
