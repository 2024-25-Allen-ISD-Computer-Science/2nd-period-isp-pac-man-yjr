extends CanvasLayer

@onready var pellet_counter = $MarginContainer/HBoxContainer/PelletCounter
@onready var ghost_status = $MarginContainer/HBoxContainer/GhostStatus
@onready var lives_display = $MarginContainer/HBoxContainer/LivesDisplay

var total_pellets = 0
var pellets_eaten = 0
var lives = 3
var ghosts_vulnerable = false

func _ready():
	# Connect to game events
	GameEvents.pellet_eaten.connect(_on_pellet_eaten)
	GameEvents.ghost_vulnerable.connect(_on_ghost_vulnerable)
	GameEvents.player_hurt.connect(_on_player_hurt)
	
	update_pellet_display()
	update_lives_display()

func _on_pellet_eaten():
	pellets_eaten += 1
	update_pellet_display()
	
	# Check pellets eaten
	if pellets_eaten >= total_pellets:
		GameEvents.emit_signal("level_complete")

func _on_ghost_vulnerable(status):
	ghosts_vulnerable = status
	update_ghost_status()

func _on_player_hurt():
	lives -= 1
	update_lives_display()
	if lives <= 0:
		GameEvents.emit_signal("game_over")

func update_pellet_display():
	pellet_counter.text = "Pellets: %d/%d" % [pellets_eaten, total_pellets]

func update_ghost_status():
	ghost_status.text = "Ghosts: %s" % ["VULNERABLE" if ghosts_vulnerable else "DANGER"]
	ghost_status.modulate = Color(0,1,0) if ghosts_vulnerable else Color(1,0,0)

func update_lives_display():
	lives_display.text = "Lives: %d" % lives
