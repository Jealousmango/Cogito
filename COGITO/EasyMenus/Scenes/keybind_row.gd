extends HBoxContainer

@onready var action_label: Label = %ActionLabel
@onready var keyboard_button: Button = %KeyboardButton
@onready var joypad_button: Button = %JoypadButton

	
func initializeData(id: int, actionName: String):
	action_label.text = actionName
	# Get input events for keyboard and joypad
	var keyboardInputEvent = InputHelper.get_keyboard_input_for_action(actionName)
	var joypadInputEvent = InputHelper.get_joypad_input_for_action(actionName)
	
	# Update button text
	if keyboardInputEvent != null:
		if keyboardInputEvent is InputEventKey:
			var key_event = keyboardInputEvent as InputEventKey
			keyboard_button.text = key_event.as_text_key_label()
			keyboard_button.pressed.connect(_on_keyboard_rebind_button_pressed.bind(id, actionName))
			print(OS.get_keycode_string(key_event.key_label))
		#var action_0 = InputMap.get_actions()[0] 
		#var action_0_events = InputMap.action_get_events( action_0 )
		#var action_0_event_0 = action_0_events[0]
		#var button_name = OS.get_keycode_string( action_0_event_0.keycode )
		#keyboard_button.text = button_name
		
		
	if joypadInputEvent != null:
		var joypad_event = joypadInputEvent as InputEventJoypadButton
		if joypad_event != null:
			joypad_button.text = joypad_event.as_text()
			#print(OS.get_keycode_string(joypad_event.as_text))
		#joypad_button.text = joypadInputEvent.to_string()
	
func _on_keyboard_rebind_button_pressed(id: int, actionName: String):
	print("actionName " + actionName)
	print("id " + str(id))
