extends Area2D

var is_activated = false

func _ready() -> void:
	# Connect the collision signal via code (Best practice)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# 1. Check if the thing touching us is actually the player
	# (Assuming your player script starts with 'class_name Player' or is named "Player")
	if body.name == "Player":
		
		# 2. Optional: Prevent triggering it twice
		if is_activated:
			return
			
		print("Player touched the lever!")
		pull_lever()

func switch_to_level_two():
	# 1. Create a Tween for the fade effect
	
	# 2. Fade the black rect from transparent (0) to solid (1) over 3 seconds
	
	# 3. Wait for the 3 seconds to finish
	await get_tree().create_timer(3.0).timeout
	
	# 4. Switch the scene
	var scene_path = "res://Scenes/level_two.tscn"
	get_tree().change_scene_to_file(scene_path)

func pull_lever() -> void:
	is_activated = true
	
	# Visual feedback: Flip the sprite
	$Sprite2D.flip_h = true 
	
	switch_to_level_two()
	
	# OR change texture: $Sprite2D.texture = load("res://lever_on.png")
	
	# Assuming 'fade_rect' is a reference to a black ColorRect covering the screen
