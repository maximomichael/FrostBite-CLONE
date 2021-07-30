extends CanvasLayer

func _ready():
	updateHUD()
# warning-ignore:return_value_discarded
	GameControl.connect("valueChanged", self, "onValueChanged")

func onValueChanged():
	updateHUD()
	
func updateHUD():
	$Score.text = str(GameControl.score)
	$Time.text = str(GameControl.time) + "º"
	$Lifes.text = str(GameControl.lifes)
	
