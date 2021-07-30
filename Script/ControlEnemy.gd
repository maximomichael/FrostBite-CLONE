extends Spatial

const PRE_ENEMY = preload("res://Scene/Enemy.tscn")
export(NodePath) var container
var enemyList = []
var grupo = []

func _ready():
	randomize()
	
	grupo = GameControl.get_grups()
	
	for list in get_children():
		enemyList.append(null)

	for control in get_children():
		generate_Enemy(control)

func generate_Enemy(control):
	var dirChanger = 1
	if rand_range(1, 10) <= 5:
		dirChanger *= -1
	
	if container:
		var iniX = 20.0 + rand_range(0, 5)
		var type = min(GameControl.stage - 1, randi() % PRE_ENEMY.instance().get_type_count())
		for value in grupo:
			var enemy = PRE_ENEMY.instance()
			enemy.global_transform.origin = Vector3((iniX + value) * -dirChanger, 0, control.global_transform.origin.z)
			enemy.levelEnemy = control.level
			enemy.direction = dirChanger
			enemy.velocity = control.velocity * 2
			enemy.type = type
			enemyList[enemy.levelEnemy] = enemy
			enemy.connect("tree_exited", self, "on_tree_exited")
			get_node(container).add_child(enemy)
		
func on_tree_exited():
	if get_tree():
		yield(get_tree().create_timer(0.1), "timeout")
		for element in get_children():
			if !weakref(enemyList[element.level]).get_ref():
				generate_Enemy(element)
