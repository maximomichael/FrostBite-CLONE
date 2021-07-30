extends Spatial

var level = 4
var levelHorizon = 0
var oldLevel = level
var newIces = []
var oldIceX
var multVelocity
var newRotationZ
var enemy
var oldEnemy
var iglooDoor = false
var bear = false
var freezed = false

func _ready():
	newRotationZ = Quat($Body/Skin.transform.basis)

func _process(delta):
	levelHorizon = 0
	multVelocity = 1
	
	if bear:
		translate(Vector3(-1,0,0) * 12 * delta)
		return
	
	if not newIces.size() and !$Tween.is_active() and level < 4:
		died()
		return
	
	if enemy and !$Tween.is_active():
		var direction = enemy.global_transform.origin.x - oldEnemy
		transform.origin.x += direction
		oldEnemy = enemy.global_transform.origin.x
		return
	
	if !$Tween.is_active():
		if Input.is_action_pressed("ui_up"):
			if level < 4:
				level += 1
				get_tree().call_group("ice_lane", "player_jump")
			newRotationZ = Quat(Basis().rotated(Vector3(0,1,0), PI))
			
			
			if level == 4 and iglooDoor and GameControl.blocks == 16:
				$VisibilityNotifier.disconnect("camera_exited", self, "_on_VisibilityNotifier_camera_exited")
				$Body/Skin.transform.basis = Basis()
				global_transform.origin.x = iglooDoor.global_transform.origin.x
				$Animation.play("Enter_Igloo")
				get_tree().paused = true
				yield(get_tree().create_timer(2), "timeout")
				get_node("Body/Skin").visible = false
				GameControl.nextLevel()
				
				
		if Input.is_action_pressed("ui_down"):
			if level > 0:
				level -= 1
				get_tree().call_group("ice_lane", "player_jump")
			newRotationZ = Quat(Basis().rotated(Vector3(0,1,0), 0))
			
	if oldLevel != level:
		$Tween.interpolate_method(self, "ChangeLevel", oldLevel, level, .90, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		enemy = null
	
	if newIces.size():
		var distance = newIces[newIces.size() - 1].global_transform.origin.x - oldIceX
		transform.origin.x += distance
		oldIceX = newIces[newIces.size() - 1].global_transform.origin.x
	else:
		multVelocity = min(.8, .8 * (GameControl.iceVelocity / 2))
		
	if Input.is_action_pressed("ui_left"):
		levelHorizon -= 1
		newRotationZ = Quat(Basis().rotated(Vector3(0,1,0), -PI / 2))

	if Input.is_action_pressed("ui_right"):
		levelHorizon += 1
		newRotationZ = Quat(Basis().rotated(Vector3(0,1,0), PI / 2))

	transform.origin.x += levelHorizon * 10 * multVelocity * delta;
	$Body/Skin.transform.basis = $Body/Skin.transform.basis.slerp(Basis(newRotationZ), .2)
	oldLevel = level
	
	if GameControl.time == 0:
		freezed = true
		$Body/Skin.transform.basis = Basis()
		died()

		
	transform.origin.x = clamp(transform.origin.x, -25, 25)

func died():
	$VisibilityNotifier.disconnect("camera_exited", self, "_on_VisibilityNotifier_camera_exited")
	
	if not bear and !level == 4 and not freezed:
		$Animation.play("Death_Player")
		$Body/Waves.emitting = true
		$Splash.emitting = true
	
	for control in $Body/Skin.get_children():
		if control.has_method("deathPlayer"):
			control.deathPlayer()
			
	GameControl.died()

func ChangeLevel(value):
	transform.origin.z = value * -4
	var jump = abs(value - oldLevel)
	var parabola = abs(pow(jump, 2) - jump) 
	$Body.transform.origin.y = sin(parabola) * 10
	
func _on_AreaFeet_area_entered(area):
	newIces.append(area)
	oldIceX = newIces[newIces.size() - 1].global_transform.origin.x

func _on_AreaFeet_area_exited(area):
	if newIces.size():
		newIces.remove(newIces.find(area))
		if newIces.size():
			oldIceX = newIces[newIces.size() - 1].global_transform.origin.x

func _on_AreaEnemy_area_entered(area): #Verificar se tocou no inimigo
	if area.collision_layer == 2:
		if area.get_parent().levelEnemy == level:
			if area.get_parent().type == 1:
				GameControl.fish_got()
				area.monitorable = false
				area.get_parent().visible = false
			else:
				enemy = area
				oldEnemy = enemy.global_transform.origin.x
	elif area.collision_layer == 16:
		$Tween.stop_all()
		global_transform.origin.z = area.global_transform.origin.z
		bear = true	 		
		multVelocity = 1.2
		$Body/Skin.transform.basis = Basis(Vector3(0, -PI / 2, 0))
		for skin in $Body/Skin.get_children():
			if skin.has_method("run"):
				skin.run()
		
func _on_AreaDoorDetector_area_entered(area):
	iglooDoor = area

# warning-ignore:unused_argument
func _on_AreaDoorDetector_area_exited(area):
	iglooDoor = false
	
# warning-ignore:unused_argument
func _on_VisibilityNotifier_camera_exited(camera):
	died()
	pass
