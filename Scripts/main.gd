extends Node2D

# создаём переменную для X и O
var state: int = 0
# создаём переменную возможности клика
var clicked: bool = false
# сиигнал который меняет X и O
signal dropped
# Выбирает позицию для клетки
func init(row: int, col: int):
	position = Vector2(col * 20, row * 20)
# по нажатии на кнопку происходит...
func _on_button_pressed():
	# если нажато,то новое значение уже нельзя поставить 
	if clicked:
		return
	clicked = true
	# берём родителя для последующих махинаций
	var parent = get_node("..")
	if parent.won():
		return
	# получаем спрайт клетки 
	var sprite: Sprite2D = get_node("empty")
	#Выбираем X и O
	state = parent.get_current_player()
	# Получаем загрузку определённой текстуры 
	var nexTexture: Texture2D = parent.get_texture(state)
	#  Меняем техтуру на новую 
	sprite.set_texture(nexTexture)
	#
	dropped.emit()
	
func separateEmpty():
	var parent = get_node("..")
	var sprite: Sprite2D = get_node("empty")
	state = parent.get_current_player()
	var nexTexture: Texture2D = parent.get_texture(state)
	sprite.set_texture(nexTexture)
	dropped.emit()
func get_state() -> int:
	return state
