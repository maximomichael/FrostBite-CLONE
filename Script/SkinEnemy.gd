extends Spatial

func _ready():
	
	for enemy in get_children():
		enemy.visible = false
	
	#var value = randi() % get_child_count()
	var value = get_parent().type
	get_child(value).visible = true
