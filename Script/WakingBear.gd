extends Spatial
var dirs = {
	"1" : Vector3(0,-PI,0),
	"-1": Vector3(0,0,0)
}
var direction = Vector3(-1, 0, 0)
var directionX = 18
var velocity = 10.0
var rotateDestiny
var player = false


func _ready():
	rotateDestiny = dirs[str(direction.x)]
	randomize()
	restart_timer()

func _process(delta):
	translate(direction * velocity * delta)
	$Skin.global_transform.basis = $Skin.global_transform.basis.slerp(dirs[str(direction.x)], .1)

	if !player:
		if global_transform.origin.x < -directionX:
			direction.x = 1
			rotateDestiny = dirs[str(direction.x)]
			restart_timer()

		if global_transform.origin.x > directionX:
			direction.x = -1
			rotateDestiny = dirs[str(direction.x)]
			restart_timer()
		
		
			
		if $RayCast_Left.is_colliding():
			direction.x = -1
			rotateDestiny = dirs[str(direction.x)]
			restart_timer()
		
		if $RayCast_Right.is_colliding():
			direction.x = 1
			rotateDestiny = dirs[str(direction.x)]
			restart_timer()
	
func restart_timer():	
	$Timer.wait_time = rand_range(1, 10)
	$Timer.start()
	
func _on_Timer_timeout():
	direction.x *= -1
	rotateDestiny = dirs[str(direction.x)]


func _on_Area_area_entered(area):
	$Timer.stop()
	var velocity = 12
	set_process(false)
	yield(get_tree().create_timer(.2), "timeout")
	set_process(true)
	$Skin/bear/AnimationPlayer.playback_speed = velocity / 4.0
	pause_mode = PAUSE_MODE_PROCESS
	player = true
	direction.x = -1

	
