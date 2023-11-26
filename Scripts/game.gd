extends Node2D
# список текстур
var textures = [preload("res://Sprites/S3.png"),
preload("res://Sprites/S1.png"),
preload("res://Sprites/S2.png")]
# номер клетки
var currentPlayer = 1
# матрица крестиков-ноликов
var pieces = []
# Отдельная яйчейка
var spaceEmpty

func _ready():
	var emptyPiece = preload("res://Scenes/main.tscn").instantiate()
	emptyPiece.init(1, 3)
	add_child(emptyPiece)
	spaceEmpty = emptyPiece
	# выключаем видимость панельки победы
	$GameOverMenu.visible = false
	# обозначаем кто сейчас ходит
	writePlayer()
	# создание матрицы
	for y in range(3):
		var row = []
		for x in range(3):
			# отдельно добавляем 9 сцен и с каждой работаем
			var piece = preload("res://Scenes/main.tscn").instantiate()
			# устанавливаем позицию
			piece.init(y, x)
			# добавляем сцену piece в game
			add_child(piece)
			# добавляем сцену piece в список
			row.append(piece)
			# вызываем соединение сигнала 
			piece.dropped.connect(nextTurn)
		pieces.append(row)
		
func newGame():
	pieces = []
	currentPlayer = 1
	_ready()
	
func stalemate() -> bool:
	for i in range(3):
		for j in range(3):
			if pieces[i][j].get_state() == 0:
				return false
	return true

func get_current_player() -> int:
	# получаем инфо по номер клетки
	return currentPlayer
	
func get_texture(player: int) -> Texture2D:
	# получаем текстуру 
	return textures[player]

func nextTurn():
	if won():
		writeWinner()
		return
	# меняем номер
	currentPlayer = 2 if currentPlayer == 1 else 1
	
	if stalemate():
		writeStaleMate()
	else:
		writePlayer()

func won() -> bool:
	return checkCols() or checkDiag() or checkRows()

func checkDiag() -> bool:
	# проверка диагоналей
	# проверяем \ дигональ
	var player = pieces[0][0].get_state()
	if player != 0:
		var won = true
		for i in range(3):
			if pieces[i][i].get_state() != player:
				won = false
				break
		if won:
			return true
	# проверяем / диагональ
	player = pieces[0][2].get_state()
	if player != 0:
		var won = true
		for i in range(3):
			if pieces[i][2 - i].get_state() != player:
				won = false
				break
		if won:
			return true
	return false
	
func checkCols() -> bool:
	for j in range(3):
		# проверяет вышки столбцов
		var player = pieces[0][j].get_state()
		if player == 0:
			continue
		var won = true
		for i in range(3):
			# сравнивает ||| с вышкой столба
			if pieces[i][j].get_state() != player:
				won = false
				break
		if won:
			return true
	return false
	
func checkRows() -> bool:
	for i in range(3):
		# проверяет начало строк
		var player = pieces[i][0].get_state()
		if player == 0:
			continue
		var won = true
		for j in range(3):
			# сравнивает ||| с вышкой столба
			if pieces[i][j].get_state() != player:
				won = false
				break
		if won:
			return true
	return false
		
func writeWinner():
	var gameOver: CanvasLayer = get_node("GameOverMenu")
	gameOver.visible = true
	gameOver.setText(currentPlayer, "player")
	
func writePlayer():
	spaceEmpty.separateEmpty()
	
func writeStaleMate():
	var gameOver: CanvasLayer = get_node("GameOverMenu")
	gameOver.visible = true
	gameOver.setText(currentPlayer, "nobody")

func _on_game_over_menu_restart():
	newGame()
