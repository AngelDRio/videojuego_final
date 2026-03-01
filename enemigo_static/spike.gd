extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador1") || body.is_in_group("jugador2"):
		if body.has_method("recibir_golpe"):
			body.recibir_golpe(1, global_position)
