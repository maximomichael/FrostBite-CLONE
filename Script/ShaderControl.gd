extends Spatial

var time = 0
export(Array, NodePath) var meshes


func _process(delta):
	if !get_tree().paused:
		time += delta * 2
	for m in meshes:
		get_node(m).mesh.surface_get_material(0).set_shader_param("time", time)
	pass
