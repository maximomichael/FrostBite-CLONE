extends Spatial


func _ready():
	hide_Blocks()
	showActiveBlocks()


func add_Block():
	if GameControl.blocks < 16:
		GameControl.blocks += 1
		new_Block(GameControl.blocks)
		
func new_Block(value):
	if value < 10:
		get_node("Wall_0" + str(value)).visible = true
	elif value >= 10 and value <= 14:
		get_node("Wall_" + str(value)).visible = true
	elif value == 15:
		get_node("Chimney").visible = true
	elif value == 16:
		get_node("Door").visible = true
		get_tree().call_group("ice_lane", "set_complete")
		
func remove_Block():
	if GameControl.blocks > 0 and GameControl.blocks < 16:
		if GameControl.blocks < 10:
			get_node("Wall_0" + str(GameControl.blocks)).visible = false
			pass
		elif GameControl.blocks >= 10 and GameControl.blocks <= 14:
			get_node("Wall_" + str(GameControl.blocks)).visible = false
		elif GameControl.blocks == 15:
			get_node("Chimney").visible = false
		elif GameControl.blocks == 16:
			get_node("Door").visible = false
			get_tree().call_group("ice_lane", "set_complete")

		GameControl.blocks -= 1
		
func hide_Blocks():
	for blocks in get_children():
		blocks.visible = false

func hide_block(id):
	if id < 10:
		get_node("Wall_0" + str(id)).visible = false
		pass
	elif id >= 10 and id <= 14:
		get_node("Wall_" + str(id)).visible = false
	elif id == 15:
		get_node("Chimney").visible = false
	elif id == 16:
		get_node("Door").visible = false
	
func showActiveBlocks():
	for value in GameControl.blocks:
		new_Block(value + 1)
		
