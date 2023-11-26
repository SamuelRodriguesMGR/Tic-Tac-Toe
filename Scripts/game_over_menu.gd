extends CanvasLayer

signal restart

func _on_button_pressed():
	restart.emit()

func setText(currentPlayer: int, win: String):
	if win == "nobody":
		$Panel/Label.set_text("Nobody won")
	else:
		$Panel/Label.set_text("Player %s's won" % currentPlayer)
