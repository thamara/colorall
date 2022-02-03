extends Node2D

func click():
	$MouseClick.visible = true
	$Timer.start()

func _on_Timer_timeout():
	$MouseClick.visible = false
