extends Area2D

func _explode() -> void:
	for area in get_overlapping_areas():
		if area.is_in_group("bounce"):
			area.queue_free()
		if area.is_in_group("swing"):
			area.queue_free()

