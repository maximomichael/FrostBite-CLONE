extends Spatial

signal queue_Stepped(queue)
signal queue_Exited(queue)

func _ready():
	for childs in get_children():
		childs.connect("stepped", self, "on_Stepped")
		childs.connect("exited", self, "on_Exited")

func on_Stepped(ice):
	emit_signal("queue_Stepped", self)

func on_Exited(ice):
	emit_signal("queue_Exited", self)

func set_active(flag):
	for children in get_children():
		children.set_active(flag)
