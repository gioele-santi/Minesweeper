extends GridContainer
class_name MineField

export (PackedScene) var CellScene
var mine_count := 10
export (int) var row_count := 10
# column count is set in inspector = 10

var game # used mainly for iteraction with UI (I could send signals directly)

var cell_count := 0
var open_cell_count := 0
var flag_count := 0

var mine_pos := []

func _ready() -> void:
	fill_grid()

func fill_grid() -> void:
	cell_count = row_count * self.columns
	for i in range(cell_count):
		var newCell: StepCell = CellScene.instance()
		self.add_child(newCell)
		newCell.connect("cell_revealed", self, "_on_cell_opened")
		newCell.connect("cell_flagged", self, "_on_cell_flagged")
		# connect signals from cell
	
	#finally set neighbours reference for each cell
	for i in range(cell_count):
		var cell: StepCell = self.get_child(i)
		cell.neighbours = neighbours(i)

func reset() -> void:
	open_cell_count = 0
	flag_count = 0
	for i in range(cell_count):
		var cell : StepCell = self.get_child(i)
		cell.reset()
	mine_pos = []

func generate_game(count: int = 10) -> void:
	reset()
	randomize()
	mine_count = count # global reference used for game over
	while mine_pos.size() < mine_count:
		var new_pos = randi() % cell_count
		if mine_pos.count(new_pos) <= 0:
			mine_pos.append(new_pos)
	
	for pos in mine_pos:
		var cell: StepCell = self.get_child(pos)
		cell.place_mine()

func _on_cell_flagged(value: bool) -> void:
	self.flag_count = (flag_count + 1) if value else (flag_count - 1)
	game.update_flag_counter(flag_count)

func _on_cell_opened(value: int) -> void:
	if value == 9:
		for pos in mine_pos:
			var cell: StepCell = self.get_child(pos)
			cell.reveal(false)
		game.game_over("You lost :(")
	
	self.open_cell_count += 1
	if open_cell_count == cell_count - mine_count:
		game.game_over("You won!")

func neighbours(index: int) -> Array:
	var ret = []
	# coordinate offsets above (top) and below (bottom) - 0 if out of bounds
	var t = -self.columns if (index - self.columns) >= 0 else 0
	var b = self.columns if (index + self.columns) <  cell_count else 0
	#coordinate offsets left and right - 0 if on on border or out of bounds
	var l = -1 if (index % self.columns != 0) else 0
	var r = 1 if (index % self.columns != (self.columns-1)) else 0
	
	#elements on same line (left, index and right)
	var line = []
	# if left right are neighbours, add them to line - add later to return to keep clockwise order
	if l != 0:
		line.append(index+l)
	line.append(index)
	if r != 0:
		line.append(index+r)
	
	#check top and bottom and use line to reduce operations
	if t != 0:
		for el in line:
			ret.append(self.get_child(el+t))
	if r != 0:
		ret.append(self.get_child(index+r))
	line.invert()
	if b != 0:
		for el in line:
			ret.append(self.get_child(el+b))
	if l != 0:
		ret.append(self.get_child(index+l))
	return ret #clockwise from TL to L
