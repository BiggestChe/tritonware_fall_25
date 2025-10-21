extends Area2D

@export var push_force = Vector2(100, 0)
const MAX_VELOCITY := 100

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Rigidbody"):
		print("I got touched by a Rigidbody")
		var direction = Input.get_axis("left_1", "right_1")
		body.apply_central_impulse(push_force * direction)
		body.set_collision_layer_value(1, true)

	# 🟢 Detect player collision and trigger win
	elif body.is_in_group("Players"):
		print("Player touched this block!")
		
		GameManager.win()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Rigidbody"):
		print("I'm off")
		body.set_collision_layer_value(1, false)
