extends Control

func _on_yes_pressed():
	Core.exit()
	get_tree().quit()

func _on_no_pressed():
	queue_free()
