extends Node2D

@export var player: CharacterBody2D
@export var bounces := 3
@export var max_length := 2000.0

@onready var line: Line2D = $Line2D
@onready var end_marker: Node2D = $End

var active := false

func _ready():
	# The Line2D will now draw relative to this Node2D's position.
	line.visible = false
	line.width = 5
	# Ensure the End marker is a child of the main scene, not this node.
	# If it is a child, you may need to manage its position differently.

func _process(_delta):
	# Simplified active check
	active = Input.is_action_pressed("fire_laser")
	
	if active:
		line.visible = true
		fire_laser()
	else:
		line.visible = false
		end_marker.visible = false

func fire_laser():
	# 1. Align this node (the laser's origin) with the player
	# This sets up the local coordinate system for the Line2D.
	global_position = player.global_position
	global_rotation = player.global_rotation
	
	var remaining_length = max_length
	# The first point of the laser starts at this node's local origin (0,0)
	var current_origin = global_position
	# The direction is based on this node's new rotation
	var current_direction = Vector2.RIGHT.rotated(global_rotation)

	line.clear_points()
	# The first point in the Line2D is its own local origin.
	line.add_point(Vector2.ZERO)
	
	var space_state = get_world_2d().direct_space_state

	for i in range(bounces + 1):
		var target = current_origin + current_direction * remaining_length
		var query = PhysicsRayQueryParameters2D.create(current_origin, target)
		query.exclude = [player]
		query.collision_mask = 2 # Mirrors on layer 2

		var result = space_state.intersect_ray(query)
		if result:
			var hit_point = result.position
			var normal = result.normal
			var collider = result.collider
			
			# 2. Convert the GLOBAL hit_point to this node's LOCAL space
			line.add_point(to_local(hit_point))

			if is_instance_valid(collider) and collider.is_in_group("mirror"):
				remaining_length -= current_origin.distance_to(hit_point)
				current_origin = hit_point
				current_direction = current_direction.bounce(normal)

				if remaining_length <= 0:
					end_marker.global_position = hit_point
					end_marker.visible = true
					return
				
				# Move origin slightly to avoid self-collision on next raycast
				current_origin += current_direction * 0.1
				
			else: # Hit a non-mirror object
				end_marker.global_position = hit_point
				end_marker.visible = true
				return
		else: # No collision
			var end_point = current_origin + current_direction * remaining_length
			
			# 3. Convert the GLOBAL end_point to LOCAL space as well
			line.add_point(to_local(end_point))
			end_marker.global_position = end_point
			end_marker.visible = true
			return
