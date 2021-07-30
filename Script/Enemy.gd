extends Spatial

enum directions {left = -1, right = 1}

export(int, 1, 20) var velocity = 4
export(directions) var direction = -1
export var levelEnemy = 3
var type = 0  
onready var homePosition = global_transform.origin

func _process(delta):
	translate(Vector3(1, 0, 0) * velocity * direction * delta)
	
	if(homePosition.distance_to(global_transform.origin) > abs(homePosition.x) * 2):
		queue_free()

func get_type_count():
	return $Skin.get_child_count()
