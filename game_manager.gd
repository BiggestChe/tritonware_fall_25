extends Node

var player_1: CharacterBody2D
var player_2: CharacterBody2D

var level_2_path = "res://Levels/Level2.tscn"
var level_3_path = "res://Levels/Level3.tscn"

func _ready() -> void:
	await get_tree().process_frame  # wait until everything is loaded

	# 🔹 Find players by group (both must call add_to_group("player") in _ready)
	var players = get_tree().get_nodes_in_group("Players")
	

	if players.size() < 2:
		push_error("❌ Could not find two players in the scene!")
		return

	player_1 = players[0] as CharacterBody2D
	player_2 = players[1] as CharacterBody2D

	if player_1 and player_2:
		print("✅ GameManager initialized: Players found and connected.")

func win() -> void:
	
	#play animation or whatever
	print("🏁 You win!")
func lose() -> void:
	
	print("💀 You lost!")
	
	reset()
	
func reset():
	
	get_tree().reload_current_scene()

func switch_level_2():
	# Use change_scene_to_file to load the next level
	get_tree().change_scene_to_file(level_2_path)

func switch_level_3():
	# Use change_scene_to_file to load the next level
	get_tree().change_scene_to_file(level_3_path)
	
