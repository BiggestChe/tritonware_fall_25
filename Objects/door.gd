# Door.gd
extends StaticBody2D

# These are the functions the pressure plate will connect to.

func open():
	print("Door is opening!")
	# Example: Hide the door and disable its collision
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	# You could also play an AnimationPlayer here

func close():
	print("Door is closing!")
	# Example: Show the door and re-enable its collision
	visible = true
	$CollisionShape2D.disabled = false
