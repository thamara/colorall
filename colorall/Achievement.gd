extends Control

export (String) var achievement_name = "Achievement name"
const transparency = Color(1, 1, 1, 0)
const full_visible = Color(1, 1, 1, 1)

func _ready():
	$Name.text = achievement_name
	modulate = transparency
	$Appear.interpolate_property(self, "modulate", modulate, full_visible, 0.5)
	$Appear.start()
	$Timer.start()


func _on_Timer_timeout():
	$Tween.interpolate_property(self, "modulate", modulate, transparency, 0.3)
	$Tween.start()


func _on_Tween_tween_all_completed():
	queue_free()
	pass
