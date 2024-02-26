extends HBoxContainer
signal rebind_keyboard_key(action_name)

@onready var action_label: Label = %ActionLabel
@onready var keyboard_button: Button = %KeyboardButton
@onready var joypad_button: Button = %JoypadButton

var action_name: String

func set_action_name(new_action_name: String):
	action_name = new_action_name
	refresh_data()

func refresh_data():
	action_label.text = action_name
	var keyboard_input = InputHelper.get_keyboard_input_for_action(action_name)
	var joypad_input = InputHelper.get_joypad_input_for_action(action_name)
	
	
	if keyboard_input != null:
		keyboard_button.text = keyboard_input.as_text()
		keyboard_button.pressed.connect(_on_keyboard_rebind_button_pressed.bind(action_name))	
		if keyboard_input is InputEventKey:
			var event_key = keyboard_input as InputEventKey
			#keyboard_button.text = event_key.as_text_key_label()
			#keyboard_button.pressed.connect(_on_keyboard_rebind_button_pressed.bind(action_name))
			print(OS.get_keycode_string(event_key.key_label))
			
	if joypad_input != null:
		joypad_button.text = joypad_input.as_text()
		joypad_button.pressed.connect(_on_joypad_rebind_button_pressed.bind(action_name))
		
		var joypad_event = joypad_input as InputEventJoypadButton
		if joypad_event != null:
			var event_key = joypad_input.as_text()
			#print(OS.get_keycode_string(event_key.key_label))
			
			#joypad_button.text = joypadInputEvent.to_string()
			#joypad_button.pressed.connect(_on_joypad_rebind_button_pressed.bind(action_name))
	
	#joypad_button.text = joypad_input.as_text()
	
			

#func initializeData(id: int, actioname: String):
	#action_label.text = actionName
	# Get input events for keyboard and joypad
	#var keyboardInputEvent = InputHelper.get_keyboard_input_for_action(actionName)
	#var joypadInputEvent = InputHelper.get_joypad_input_for_action(actionName)
	
	# Update button text
	#if keyboardInputEvent != null:
		#if keyboardInputEvent is InputEventKey:
			#var key_event = keyboardInputEvent as InputEventKey
			#keyboard_button.text = key_event.as_text_key_label()
			#keyboard_button.pressed.connect(_on_keyboard_rebind_button_pressed.bind(id, actionName))
			#print(OS.get_keycode_string(key_event.key_label))
		#var action_0 = InputMap.get_actions()[0] 
		#var action_0_events = InputMap.action_get_events( action_0 )
		#var action_0_event_0 = action_0_events[0]
		#var button_name = OS.get_keycode_string( action_0_event_0.keycode )
		#keyboard_button.text = button_name
		
		
	#if joypadInputEvent != null:
		#var joypad_event = joypadInputEvent as InputEventJoypadButton
		#if joypad_event != null:
			#joypad_button.text = joypad_event.as_text()
			#print(OS.get_keycode_string(joypad_event.as_text))
		#joypad_button.text = joypadInputEvent.to_string()
	
func _on_keyboard_rebind_button_pressed(action_name: String):
	#emit_signal("rebind_keyboard_key", action_name)
	rebind_keyboard_key.emit(action_name)

func _on_joypad_rebind_button_pressed(action_name: String):
	print("action_name " + action_name)
