extends Control

class_name GameApp

onready var mine_field : MineField = $HBoxContainer/MineField

onready var message_label := $HBoxContainer/Controls/Message
onready var start_button := $HBoxContainer/Controls/StartButton

onready var mine_add_btn := $HBoxContainer/Controls/MineSettings/PlusBtn
onready var mine_remove_btn := $HBoxContainer/Controls/MineSettings/MinusBtn
onready var mine_input := $HBoxContainer/Controls/MineSettings/LineEdit

var settings_mine_count := 10 setget set_settings_mine_count

onready var flag_lbl := $HBoxContainer/Controls/FlagCounter/Label

var gui_controls : Array

func _ready() -> void:
	mine_field.game = self
	get_tree().paused = true
	message_label.text = "Let's play!"
	mine_input.text = str(settings_mine_count)
	gui_controls = [mine_add_btn, mine_remove_btn, mine_input]
	# add all controls to gui controls to disable them while playing

func _on_StartButton_pressed() -> void:
	message_label.text = "Let's play!"
	get_tree().paused = false
	toggle_gui_disabled(true)
	mine_field.generate_game(settings_mine_count)
	start_button.disabled = true
	update_flag_counter(0)

func game_over(message: String) -> void:
	get_tree().paused = true
	toggle_gui_disabled(false)
	message_label.text = message
	start_button.disabled = false

func toggle_gui_disabled(disabled: bool) -> void:
	for control in gui_controls:
		if control is Button:
			control.disabled = disabled
		elif control is LineEdit:
			control.editable = not disabled

func update_flag_counter(count: int) -> void:
	flag_lbl.text = str(count) # format with 0 padding

func _on_PlusBtn_pressed() -> void:
	self.settings_mine_count += 1

func _on_MinusBtn_pressed() -> void:
	self.settings_mine_count -= 1

func _on_Mine_text_entered(new_text: String) -> void:
	self.settings_mine_count = int(new_text)

func set_settings_mine_count(new_value: int) -> void:
	settings_mine_count = min(40, new_value)
	settings_mine_count = max(5, settings_mine_count)
	mine_input.text = str(settings_mine_count)
