extends Camera2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"../Player".position.x > position.x and $"../Player".position.x >= 70:
		position.x = round($"../Player".position.x)
