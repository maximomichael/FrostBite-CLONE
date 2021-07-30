extends Spatial
enum directions {left = -1, right = 1}

export(int, 1, 20) var velocity = 3
export(directions) var direction = 1

var activeIce = true
var complete = false
var ice_gap = 30
var ocuped = []
var playerJump = false
export(int) var level

func _ready():
	for childrs in get_children():
		childrs.connect("queue_Stepped", self, "on_Queue_Stepped") 
		childrs.connect("queue_Exited", self, "on_Queue_Exited")
	
func _process(delta):
	$QueueIce01.translate(Vector3(1,0,0) * velocity * direction * delta)
	$QueueIce02.translate(Vector3(1,0,0) * velocity * direction * delta)
	verifyDistance()
	
	if Input.is_action_just_pressed("ui_accept"):
		if ocuped.size():
			direction *= -1
			get_tree().call_group("Igloo", "remove_Block")
	
func verifyDistance():
	if direction > 0:
		if $QueueIce01.transform.origin.x > ice_gap:
			$QueueIce01.transform.origin.x =  $QueueIce02.transform.origin.x - ice_gap
			
		if $QueueIce02.transform.origin.x > ice_gap:
			$QueueIce02.transform.origin.x =  $QueueIce01.transform.origin.x - ice_gap
			
	if direction < 0:
		if $QueueIce01.transform.origin.x < -ice_gap:
			$QueueIce01.transform.origin.x =  $QueueIce02.transform.origin.x + ice_gap
			
		if $QueueIce02.transform.origin.x < -ice_gap:
			$QueueIce02.transform.origin.x =  $QueueIce01.transform.origin.x + ice_gap

func on_Queue_Stepped(queue):
	ocuped.append(queue)
	if activeIce and playerJump:
		playerJump = false
		get_tree().call_group("Igloo", "add_Block")
		activeIce = false
		GameControl.ice_stepped()
		for children in get_children():
			children.set_active(activeIce)
	
	var all_active = true
	
	for lane in get_tree().get_nodes_in_group("ice_lane"):
		if lane.activeIce:
			all_active = false
			
	if all_active:
		yield(get_tree().create_timer(.3), "timeout")
		if !complete:
			for lane in get_tree().get_nodes_in_group("ice_lane"):
				lane.set_active(true)

func on_Queue_Exited(queue):
	if ocuped.size():
		ocuped.remove(ocuped.find(queue))

func set_active(flag):
	activeIce = flag
	for children in get_children():
		children.set_active(flag)

func set_complete():
	complete = true

func player_jump():
	playerJump = true
	
