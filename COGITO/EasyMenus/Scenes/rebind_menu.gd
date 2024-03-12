extends MarginContainer

@onready var rebind_title = %RebindTitle
@onready var input_text = %InputText
@onready var save_dialog = $CenterContainer/Graphics/Panel/VBoxContainer/SaveDialog
@onready var yes_button = %YesButton
@onready var no_button = %NoButton

var action_name: String

func set_action_name_title(new_action_name: String):
	action_name = new_action_name
	rebind_title.text = action_name if !ContolMenuConstants.FRIENDLY_NAMES_DICT.has(action_name) else ContolMenuConstants.FRIENDLY_NAMES_DICT.get(action_name)
	input_text.text = "Listening for input..."
	#InputHelper.connect("key_pressed", _on_input_detected)
	
func set_input_text(new_input_text: String):
	input_text.text = new_input_text

func _unhandled_input(event):
	if event.is_pressed() and is_visible_in_tree():
		print("event.as_text(): " + event.as_text())
		var current_keyboard_keybind = InputHelper.get_keyboard_input_for_action(action_name)
		
		if current_keyboard_keybind:
			input_text.text = "Current keybind: " + str(current_keyboard_keybind) + " Incoming new Keybind: " +  InputHelper.get_label_for_input(event)
		
		var conflicting_keybind = InputMap.has_action(action_name)
		if conflicting_keybind:
			save_dialog.show()
			yes_button.pressed.connect(_on_yes_button_pressed)
			no_button.pressed.connect(_on_no_button_pressed)
		else:
			var result: Error = InputHelper.set_keyboard_input_for_action(action_name, event, false)
			print("Remap result: " + str(result))
			
		# Attempt to update keybind
		var current_key = InputHelper.get_keyboard_input_for_action(action_name)
		print("Current Key: " + current_key.as_text())
		print(input_text.text + ": " + InputHelper.get_keyboard_input_for_action(action_name).as_text())
		

func _on_input_detected(event: InputEvent):
	print("input detected: " + event.as_text())
	if event.is_action_pressed("jump"):
		input_text.text = str(KEY_SPACE)
		
func _on_yes_button_pressed():
	print("yes clicked")

func _on_no_button_pressed():
	print("no clicked")
