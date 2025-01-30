extends Area2D

# Signal to notify that the pellet was collected
signal collected

func _on_Pellet_body_entered(body):
	# Check if the body is the player
	if body.is_in_group("player"): 
		emit_signal("collected")  # Notify the collection
		queue_free()  # Remove the pellet from the scene
