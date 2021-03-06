extends Button

class_name StepCell

signal cell_revealed(value) # receiver can count or detect gameover
signal cell_flagged(value) # true or false to count used flags

onready var overlay := $Overlay
var alt_cmd := false 
var count := 0
var flagged := false setget set_flagged

var neighbours : Array = [] # other cells

func _ready() -> void:
	overlay.visible = false

func reset() -> void:
	count = 0
	overlay.visible = false
	disabled = false
	flagged = false # no setter, no signal 

func _pressed() -> void:
	if alt_cmd:
		self.flagged = not flagged
	else:
		reveal()

func reveal(propagate: bool = true) -> void:
	if self.flagged or self.disabled: # avoid propagation
		return
	overlay.frame = count
	overlay.visible = true
	self.disabled = true
	if count == 0:
		for c in neighbours:
			var cell : StepCell = c
			cell.reveal()
	if propagate:
		emit_signal("cell_revealed", count)

func place_mine() -> void:
	self.count = 9
	for c in neighbours:
		c.count = c.count + 1 if c.count < 9 else c.count

func set_flagged(value: bool) -> void:
	flagged = value
	overlay.frame = 11 #flag frame
	overlay.visible = value
	emit_signal("cell_flagged", value)

func _on_StepCell_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_MASK_LEFT:
				alt_cmd = false
			BUTTON_MASK_RIGHT:
				alt_cmd = true
