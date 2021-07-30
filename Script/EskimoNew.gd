extends Spatial

var time = 0

func _process(delta):
	$Body/Feet_Left.rotation.x = global_transform.origin.y / 4
	$Body/Feet_Right.rotation.x = global_transform.origin.y / 4
	$Body/Hand_Left.rotation.x = -global_transform.origin.y
	$Body/Hand_Right.rotation.x = -global_transform.origin.y
	
	time += delta
	
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		$Body/Feet_Left.transform.origin.z = sin(time * 20) * .2
		$Body/Feet_Right.transform.origin.z = -sin(time * 20) * .2
	else:
		$Body/Feet_Left.transform.origin.z = 0 
		$Body/Feet_Right.transform.origin.z = 0
		
	
func deathPlayer():
	$Body/AnimationPlayer.play("Death")
	
func run():
	$Body/AnimationPlayer.play("Run")
	set_process(false)
