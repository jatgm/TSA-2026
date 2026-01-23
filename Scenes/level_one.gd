extends Node2D

const l2hud = preload("res://Scenes/l2hud.tscn")
const l2pp = preload("res://Scenes/l2post.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_lever_switch() -> void:
	
	$HUD.queue_free()
	add_child(l2hud.instantiate())
	$"Post Processing".queue_free()
	add_child(l2hud.instantiate())
	
	$Player.position = Vector2(70,91)
	$Camera2D.position = Vector2(128,52)
