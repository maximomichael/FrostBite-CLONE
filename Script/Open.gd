extends Spatial

func _ready():
	$BackgroundBlack.queue_free()
	get_tree().paused = true
	yield(get_tree().create_timer(.1), "timeout")
	get_tree().paused = false 
