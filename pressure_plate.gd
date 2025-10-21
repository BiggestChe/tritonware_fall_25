extends Area2D

# 1. Define the custom signals this plate will emit
signal pressed
signal released

# 2. This counter tracks how many "valid" things are on the plate.
#    This is crucial so it doesn't "release" if one player steps off
#    but another is still on.
var overlapping_bodies = 0

func _on_body_entered(body):
	if not body.is_in_group("Players") and not body.is_in_group("Rigidbody"):
		return 

	overlapping_bodies += 1

	if overlapping_bodies == 1:
		
		#emit signal to open door
		emit_signal("pressed")
		print("Plate pressed!")
		# Optional: Change sprite, play sound
		# $Sprite2D.frame = 1 

func _on_body_exited(body):
	if not body.is_in_group("player"):
		return

	overlapping_bodies -= 1

	if overlapping_bodies == 0:
		emit_signal("released")
		print("Plate released!")
		# Optional: Change sprite back
		# $Sprite2D.frame = 0
