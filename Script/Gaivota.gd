extends Spatial

func _ready():
	rotate(Vector3(0,1, 0), (PI/2) * get_parent().get_parent().direction)
