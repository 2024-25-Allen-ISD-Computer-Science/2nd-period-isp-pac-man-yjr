extends CharacterBody2D
class_name Ghost

### Configuration ###
@export var move_speed: float = 400.0
@export var chase_update_interval: float = 0.5
@export var detection_radius: float = 300.0
@export var flee_speed_multiplier: float = 1.2
@export var vulnerable_time: float = 5.0

### Nodes ###
@onready var detection_area: Area2D = $DetectionArea
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

### State ###
var player: CharacterBody2D = null
var chase_timer: float = 0.0
var current_direction: Vector2 = Vector2.RIGHT
var is_vulnerable: bool = false
var respawn_position: Vector2

func _ready():
	# Setup detection area
	var circle = CircleShape2D.new()
	circle.radius = detection_radius
	detection_area.get_node("CollisionShape2D").shape = circle
	
	# Find player
	player = get_tree().get_first_node_in_group("player")
	respawn_position = global_position
	
	# Connect signals
	GameEvents.pellet_eaten.connect(_on_power_pellet_eaten)
	GameEvents.ghost_vulnerable_ended.connect(_on_vulnerability_ended)

func _physics_process(delta):
	if !player:
		return
	
	chase_timer -= delta
	
	# Update chase direction periodically
	if chase_timer <= 0 or global_position.distance_to(player.global_position) < 100:
		chase_timer = chase_update_interval
		current_direction = _calculate_movement_direction()
	
	# Apply movement
	var current_speed = move_speed * (flee_speed_multiplier if is_vulnerable else 1.0)
	velocity = current_direction * current_speed
	move_and_slide()
	
	_update_animation()

func _calculate_movement_direction() -> Vector2:
	if is_vulnerable:
		return (global_position - player.global_position).normalized()
	else:
		return (player.global_position - global_position).normalized()

func _update_animation():
	if is_vulnerable:
		sprite.play("vulnerable")
	else:
		if velocity.length() > 10:
			if abs(velocity.x) > abs(velocity.y):
				sprite.play("right" if velocity.x > 0 else "left")
			else:
				sprite.play("down" if velocity.y > 0 else "up")
		else:
			sprite.play("idle")

func _on_detection_area_body_entered(body):
	if body == player:
		if is_vulnerable:
			_on_eaten()
		else:
			GameEvents.player_hurt.emit()

func _on_eaten():
	GameEvents.ghost_eaten.emit(self)
	GameEvents.score += 200
	respawn()

func respawn():
	global_position = respawn_position
	is_vulnerable = false
	sprite.play("idle")

func _on_power_pellet_eaten():
	is_vulnerable = true
	sprite.play("idle")
	await get_tree().create_timer(vulnerable_time).timeout
	if is_vulnerable:  
		is_vulnerable = false
		sprite.play("idle")

func _on_vulnerability_ended():
	if is_vulnerable:
		is_vulnerable = false
		sprite.play("idle")
