extends Control

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("interact"):
		start_game.emit()
		queue_free()
		


func _on_timer_timeout() -> void:
	visible = !visible	
