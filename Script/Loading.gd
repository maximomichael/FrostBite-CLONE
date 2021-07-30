extends Spatial

var frames = 0

func _ready():
	$Waves.emitting = true


func _process(delta):
	if frames >= 3:
		get_tree().change_scene("res://Scene/Tests.tscn")
	frames += 1
