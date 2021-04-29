extends Button

class_name StepCell

onready var overlay := $Overlay
var alt_cmd := false 
var count := 0
var flagged := false setget set_flagged

var neighbours : Array = [] # other cells

func _ready() -> void:
	overlay.visible = false


func _pressed() -> void:
	if alt_cmd:
		self.flagged = not flagged
	elif not flagged:
		reveal()

func reveal() -> void:
	overlay.frame = count
	overlay.visible = true
	self.disabled = true
	if count == 0:
		pass #open nearby cells
	elif count == 9:
		pass # explode

func place_mine() -> void:
	self.count = 9
	for c in neighbours:
		c.count = min(9, c.count+1)

func set_flagged(value: bool) -> void:
	flagged = value
	overlay.frame = 11 #flag frame
	overlay.visible = value

func _on_StepCell_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_MASK_LEFT:
				alt_cmd = false
			BUTTON_MASK_RIGHT:
				alt_cmd = true
