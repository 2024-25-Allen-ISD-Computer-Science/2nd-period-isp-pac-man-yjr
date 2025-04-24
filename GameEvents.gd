extends Node
# player
signal player_spawned
signal player_hurt
signal player_died
signal score_changed(new_score: int)
#pellet
signal pellet_eaten(pellet: Node2D)
signal pellet_respawned(pellet: Node2D)

# ghost
signal ghost_chase_started(ghost: Node2D)
signal ghost_vulnerable_started
signal ghost_vulnerable_ended
signal ghost_eaten(ghost: Node2D)

# state
var score := 0:
	set(value):
		score = value
		score_changed.emit(score)

var lives := 3:
	set(value):
		lives = value
		if lives <= 0:
			player_died.emit()

var is_ghost_vulnerable := false:
	set(value):
		is_ghost_vulnerable = value
		if value:
			ghost_vulnerable_started.emit()
		else:
			ghost_vulnerable_ended.emit()

func reset_game():
	score = 0
	lives = 3
	is_ghost_vulnerable = false
