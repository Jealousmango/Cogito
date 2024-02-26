extends MarginContainer

@onready var rebind_title = %RebindTitle
@onready var input_text = %InputText
@onready var save_dialog = $CenterContainer/Graphics/Panel/VBoxContainer/SaveDialog


func set_action_name_title(action_name: String):
	rebind_title.text = action_name
	input_text.text = "Listening for input..."
	#InputHelper.connect("key_pressed", _on_input_detected)
	
func set_input_text(new_input_text: String):
	input_text.text = new_input_text

func _unhandled_input(event):
	if event.is_pressed():
		input_text.text = event.as_text()
		var result = InputHelper.set_keyboard_input_for_action(rebind_title.text, event, false)
		print("Remap result: " + str(result))
		var current_key = InputHelper.get_keyboard_input_for_action(rebind_title.text)
		print("Current Key: " + current_key.as_text())
		print("Jump: " + InputHelper.get_keyboard_input_for_action(rebind_title.text).as_text())
		

func _on_input_detected(event: InputEvent):
	print("input detected: " + event.as_text())
	if event.is_action_pressed("jump"):
		input_text.text = str(KEY_SPACE)
