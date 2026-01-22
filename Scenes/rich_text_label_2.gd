extends RichTextLabel

var time = 999

func _on_timer_timeout() -> void:
	time -= 1
	text = str(time)
