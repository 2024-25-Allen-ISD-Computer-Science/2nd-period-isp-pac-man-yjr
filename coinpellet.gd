# Pellet.gd
extends Area2D

@export var respawn_time := 5.0

func _on_body_entered(body):
	if body.is_in_group("player"):
		GameEvents.pellet_eaten.emit(self)
		GameEvents.score += 10
		$CollisionShape2D.set_deferred("disabled", true)
		visible = false
		await get_tree().create_timer(respawn_time).timeout
		respawn()

func respawn():
	$CollisionShape2D.disabled = false
	visible = true
	GameEvents.pellet_respawned.emit(self)
