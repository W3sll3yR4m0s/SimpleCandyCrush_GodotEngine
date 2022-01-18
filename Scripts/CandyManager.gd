extends Node

#========================================================#
onready var movesBoard = get_parent().get_node("MovesBoard")
onready var bar = get_parent().get_node("Bar")

var candyPreload = preload("res://Scenes/Candy.tscn")
var boxPreload = preload("res://Scenes/Box.tscn")

var matrix = []

var level = 2

var obj1
var obj2

#var allow_Selection = true # WR #
var canPlay = false

signal played
signal add_points(points)

#var goX_Previous # WR #
#var goY_Previous # WR #

#var timerInter_ON = false # WR #
#========================================================#

func _ready():
	level = Global.currentLevel
	
	clear_matrix()
	read_level()
	rand_matrix()
	find_pattern()

func read_level():
	var file = File.new()
	file.open("res://LevelData/level" + str(level) + ".txt", file.READ)
	var text = file.get_as_text()
	var lines = text.split("\n")
	file.close()
	
	for x in range(9):
		for y in range(12):
			if lines[y][x] == "1":
				matrix[x][y] = generate_box(x, y)
	
	movesBoard.set_moves(int(lines[12]))
	bar.set_max(int(lines[13]))

func clear_matrix():
	for x in range(9):
		matrix.append([])
		matrix[x] = []
		
		for y in range(12):
			matrix[x].append([])
			matrix[x][y] = null

func rand_matrix():
	for x in range(9):
		for y in range(12):
			if matrix[x][y] == null:
				matrix[x][y] = generate_candy(x , y)

# GERA OS DOCES #
func generate_candy(x, y):
	var newCandy = candyPreload.instance()
	
	newCandy.set_data(x, y)
	newCandy.connect("selectedCandy", self, "obj_selected")
	newCandy.add_to_group("candy")
	
	add_child(newCandy)
	return newCandy

# GERA AS CAIXAS #
func generate_box(x, y):
	var newBox = boxPreload.instance()
	
	newBox.set_data(x, y)
	newBox.add_to_group("box")
	
	add_child(newBox)
	return newBox

func is_candy(obj):
	if obj != null and obj.is_in_group("candy"):
		return true
	else:
		return false

func obj_selected(obj, selected):
	if not canPlay:
		obj.deselect()
		return
	
	if selected: # and allow_Selection # # WR #
		if obj1 == null:
			obj1 = obj
		else:
#			allow_Selection = false # WR #
			
			obj2 = obj
			
			if (tests_proximity()):
				canPlay = false
				emit_signal("played")
				#jogar
				#print("jogada")
#				if (get_node("Timer").start() == true):
#					yield(get_node("Timer"), "timeout")
#				else:
				swap_positions()
				
				get_node("Timer").start()
				yield(get_node("Timer"), "timeout")
				
#				obj1.deselect()
#				obj2.deselect()
#				cleanObjects()
			else:
				deselect_Here() # WR #
				cleanObjects()


func tests_proximity():
	if ( ( obj1.x == obj2.x and abs(obj1.y - obj2.y) == 1 ) or ( obj1.y == obj2.y and abs(obj1.x - obj2.x) == 1 ) ):
		return true
	else:
		return false

func cleanObjects():
	obj1 = null
	obj2 = null
	
#	allow_Selection = true # WR #

func _on_Timer_timeout():
	if (find_pattern()):
		#válida
		pass
	else:
		#inválida
		swap_positions()
		canPlay = true
	
	deselect_Here() # WR #
	cleanObjects()

func find_pattern():
	var to_remove = []
	var valid = false
	
	for y in range(12):
		for x in range(1, 8):
			#var c0 = matrix[x-1][y].numberColor if matrix[x-1][y] != null else null # Antes das caixas! #
			var c0 = matrix[x-1][y].numberColor if is_candy(matrix[x-1][y]) else null
			var c1 = matrix[x][y].numberColor if is_candy(matrix[x][y]) else null
			var c2 = matrix[x+1][y].numberColor if is_candy(matrix[x+1][y]) else null
			if c0 == c1 and c1 == c2 and c0 != null:
				add_to_remove(to_remove, matrix[x-1][y])
				add_to_remove(to_remove, matrix[x][y])
				add_to_remove(to_remove, matrix[x+1][y])
				valid = true
	for x in range(9):
		for y in range(1, 11):
			var c0 = matrix[x][y-1].numberColor if is_candy(matrix[x][y-1]) else null
			var c1 = matrix[x][y].numberColor if is_candy(matrix[x][y]) else null
			var c2 = matrix[x][y+1].numberColor if is_candy(matrix[x][y+1]) else null
			if c0 == c1 and c1 == c2 and c0 != null:
				add_to_remove(to_remove, matrix[x][y-1])
				add_to_remove(to_remove, matrix[x][y])
				add_to_remove(to_remove, matrix[x][y+1])
				valid = true
	
	for t in to_remove:
		if t.special:
			emit_signal("add_points", 5)
		else:
			emit_signal("add_points", 1)
		
		remove_child(t)
		matrix[t.x][t.y] = null
	
	#mover para baixo
	move_down()
	get_node("Inter").start()
	
#	timerInter_ON = true # WR #
	
	return valid
	#return false

func move_down():
	for y in range(11, -1, -1):
		var x = 0
		#for x in range(9):
		while (x <= 8):
			if y == 0:
				if matrix[x][y] == null:
					matrix[x][y] = generate_candy(x, y)
				
			#if matrix[x][y] != null:
			if is_candy(matrix[x][y]):
				
				# Acompanhar passo a passo! #
#				followStepByStep(matrix[x][y].x, matrix[x][y].y) # FALHEI! #
				#matrix[x][y].select()
				
				#var timer = Timer.new()
				#timer.set_wait_time(0.5)
				#timer.start()
				#add_child(timer)
				#yield(timer, "timeout")
				#remove_child(timer)
				
				#matrix[x][y].deselect()
				
				var moved = false
				var toY
				for i in range(y + 1, 12):
					if matrix[x][i] == null:
						toY = i
						moved = true
					elif matrix[x][i].is_in_group("box"):
						continue
					else:
						break
				
				if moved:
					matrix[x][y].move_to(x, toY)
					matrix[x][toY] = matrix[x][y]
					matrix[x][y] = null
			#x += 1
			if y == 0 and matrix[x][y] == null:
				pass
			else:
				x += 1
#	# Verificar padrões novamente, ao final de cada linha #
#	find_pattern()

# Troca as posições #
func swap_positions():
	# WR #
#	if ( get_node("Inter").start() == true ):
##	if ( timerInter_ON == true ):
#		yield(get_node("Inter"), "timeout")
	######
	if (obj1 != null and obj2 != null and obj1 != obj2):
		obj1.move_to(obj2.x, obj2.y)
		obj2.move_to(obj1.x, obj1.y)
		matrix[obj1.x][obj1.y] = obj2
		matrix[obj2.x][obj2.y] = obj1
#		if ( get_node("Inter").start() == true ):
#			yield(get_node("Inter"), "timeout")

# Adiciona à lista de remoção #
func add_to_remove(list, obj):
	if not list.has(obj):
		list.append(obj)

# FALHEI AQUI!! #
# Código para acompanhar, "lentamente", o passo a passo do código da função move_down() #
#func followStepByStep(x, y):
#	matrix[x][y].select()
#	
#	var timer = Timer.new()
#	timer.set_wait_time(0.5)
#	timer.start()
#	add_child(timer)
#	yield(timer, "timeout")
#	remove_child(timer)
#	
#	matrix[x][y].deselect()

# Verifica se surgiram novos padrões após aplicado o move_down() #
# ATENÇÃO: O tempo de espera (Wait Time) do Timer "Inter" é muito relevante! #
# pois este tempo deve ser suficientemente grande a ponto de se concluir a verificação #
# VERIFIQUEI QUE É MELHOR DEIXAR "Timer" e "Inter" COM O MESMO INTERVALO DE TEMPO #
# ISSO CORRIGE O BUG DE "Selecionar" ALGUM "Candy" ANTES DO FINAL DO TEMPO DE ESPERA #
# O QUE ACARRETA EM TOTAL DESORDEM DO COMPORTAMENTO PADRÃO DE CADA FUNÇÃO EM CASO DE #
# "Cliques" MUITO RÁPIDOS #
func _on_Inter_timeout():
	if not find_pattern():
		get_node("Inter").stop()
		
#		timerInter_ON = false # WR #
		
		canPlay = true
		if movesBoard.moves == 0:
			print("Acabou!!")
			if bar.win():
				Transition.put_above("res://Scenes/WinScreen.tscn")
			else:
				print("PERDEU!!")
				Transition.put_above("res://Scenes/LooseScreen.tscn")
		if bar.recordMax():
			Transition.put_above("res://Scenes/WinScreen.tscn")

func deselect_Here():
	if ( obj1 != null ):
		obj1.deselect()
	if ( obj2 != null ):
		obj2.deselect()

