extends Area2D

#--Physics Variables
@export var push_force = Vector2(100,0)
const MAX_VELOCITY := 100

#if jumps on block
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Rigidbody")	:
		#print("i got touched")
		#var direction = Input.get_axis("left_1", "right_1")
#
		#
		#body.apply_central_impulse(push_force * direction)
		#print(push_force)
		#body.set_collision_layer_value(1, true)
#
#
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body.is_in_group("Rigidbody")	:
		#print("im off")
#
		#body.set_collision_layer_value(1, false)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Rigidbody")	:
		print("i got touched")
		var direction = Input.get_axis("left_1", "right_1")

		
		body.apply_central_impulse(push_force * direction)
		print(push_force)
		body.set_collision_layer_value(1, true)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Rigidbody")	:
		print("im off")

		body.set_collision_layer_value(1, false)
