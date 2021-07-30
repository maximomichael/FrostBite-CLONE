extends Spatial

signal stepped(ice)
signal exited(ice) 

func _on_Area_area_entered(area):
	$AnimationFloat.play("AnimationSink")
	$Waves.emitting = true
	emit_signal("stepped", self)

func set_active(flag):
	if flag:
		$Cylinder.get_active_material(0).albedo_color = Color(1, 1, 1)
	else:
		$Cylinder.get_active_material(0).albedo_color = Color(.1, .3, 1)
	

func _on_Area_area_exited(area):
	emit_signal("exited", self)
