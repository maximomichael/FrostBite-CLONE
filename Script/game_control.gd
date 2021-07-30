extends Node

const nextLifeStep = 5000
var nextLife = nextLifeStep
var blocks = 0
var lifes = 3
var score = 0
var gameTime = 45
var time =  gameTime
var frames = 0
var stage = 1
var iceVelocity = 1

var grupsSeq = [0,0,1,1,2,1,2,1,0,2,1,2,1]
var grups = [
	[0],
	[0, 8],
	[0, 4, 8]
]

var formsSeq = [0,0,1,1,2,1,2,0,1,2,1,2,1]
var ice_forms = [
	"Close",
	"Open",
	"Open_Closed"
]

signal valueChanged()

# warning-ignore:unused_argument
func _process(delta):
	frames += 1
	if frames % 60 == 0:
		time -= 1
		emit_signal("valueChanged")
		
func died():
	lifes -= 1
	time = gameTime
	get_tree().paused = true
	set_process(false)
	yield(get_tree().create_timer(2), "timeout")
	get_tree().paused = false
	set_process(true)
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	
func nextLevel():
	for value in range(16):
		addScore(10)
		emit_signal("valueChanged")
		yield(get_tree().create_timer(.05), "timeout")
		get_tree().call_group("Igloo", "hide_block", 16 - value)
		
# warning-ignore:unused_variable
	for value in range(time):
		addScore(10)
		time -= 1
		emit_signal("valueChanged")
		yield(get_tree().create_timer(.05), "timeout")
		
	blocks = 0
	yield(get_tree().create_timer(.8), "timeout")
	get_tree().paused = false
	iceVelocity += .25
	time = gameTime
	stage += 1
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func ice_stepped():
	addScore(min(10 * stage, 90))
	emit_signal("valueChanged")

func fish_got():
	get_tree().paused = true
# warning-ignore:unused_variable
	for value in range(20):
		addScore(10)
		emit_signal("valueChanged")
		yield(get_tree().create_timer(.01), "timeout")
	get_tree().paused = false
	

func get_grups():
	if stage < grupsSeq.size():
		var grup = grupsSeq[stage - 1]
		return grups[grup]
	else:
		return grups[randi() % grups.size()]

func get_ice_forms():
	if stage < formsSeq.size():
		var form = formsSeq[stage-1]
		return ice_forms[form]
	else:
		return ice_forms[randi() % ice_forms.size()]
		
func addScore(value):
	score += value
	moreLife()

func moreLife():
	if score > nextLife:
		lifes += 1
		nextLife += nextLifeStep		
