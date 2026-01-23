extends RichTextLabel

var time = 999

var start = false

func _on_timer_timeout() -> void:
	if start:
		time -= 1
		text = str(time)


func _on_intro_sequence_start_game() -> void:
	start = true
