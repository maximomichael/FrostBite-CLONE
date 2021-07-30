extends Spatial

signal stepped(ice)
signal exited(ice) 

func _ready():
	$AnimationIce.play(GameControl.get_ice_forms())
	yield(get_tree().create_timer(.1), "timeout")
	$AnimationIce.pause_mode = Node.PAUSE_MODE_INHERIT

func _on_Area_area_entered(area):
	$AnimationFloat.play("Float")
	$Waves.emitting = true
	emit_signal("stepped", self)

func set_active(flag):
	if flag:
		$ice01.get_active_material(0).albedo_color = Color(1, 1, 1)
	else:
		$ice01.get_active_material(0).albedo_color = Color(.1, .3, 1)
	
func _on_Area_area_exited(area):
	emit_signal("exited", self)
