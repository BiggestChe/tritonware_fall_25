extends Area2D

@export var push_force = Vector2(100, 0)
const MAX_VELOCITY := 100

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		print("Player touched this block!")
		
		GameManager.win()

#
