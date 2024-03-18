extends Control
signal  close

@export var keybind_config_data: Node

var config = ConfigFile.new()
var input_map: Array[StringName] = InputMap.get_actions()
var keybind_rows := Dictionary()


# These actions should not be included in the rebind menu


@onready var keybind_row = preload("res://COGITO/EasyMenus/Scenes/keybind_row.tscn")
@onready var keybind_container = %VBoxContainer
@onready var scroll_container = $MarginContainer/ScrollContainer
@onready var rebind_menu = %RebindMenu


func go_back():
	save_options()
	emit_signal("close")

func save_options():
	pass
	#config.set_value(OptionsConstants.section_name,OptionsConstants.sfx_volume_key_name, sfx_volume_slider.hslider.value)
	#config.save(OptionsConstants.config_file_name)
	
func on_open():
	load_options()

func load_options():
	#var err = config.load(OptionsConstants.config_file_name)
	var array_start_time = Time.get_ticks_usec()
	#print(array_start_time)
	
	for action in input_map:
		if !ContolMenuConstants.INPUT_ACTION_BLACKLIST_ARRAY.has(action):
			var new_keybind_row = keybind_row.instantiate()
			keybind_container.add_child(new_keybind_row)
			keybind_rows[action] = new_keybind_row
			if new_keybind_row.has_method("set_action_name"):
				new_keybind_row.set_action_name(action)
				#new_keybind_row.connect("rebind_keyboard_key", _on_keyboard_rebind_button_pressed)
				new_keybind_row.rebind_keyboard_key.connect(_on_keyboard_rebind_button_pressed)
			#print(action)
		#if !inputActionBlacklistDict.has(action):
			#print("dict didn't have value")
			#print(action)
	#var arrayEndTime = Time.get_ticks_usec()
	#var dictStartTime = Time.get_ticks_usec()
	#print(dictStartTime)
	#
	#for action in inputMap:
		#if !inputActionBlacklistDict.has(action):
			#print(action)
	#var dictEndTime = Time.get_ticks_usec()
	#var totalArrayTime = arrayEndTime - array_start_time
	#var totalDictTime = dictEndTime - dictStartTime
	#
	#print("Array Total Time:")
	#print(totalArrayTime)
	#print("Dict Total Time:")
	#print(totalDictTime)
	
func _ready() -> void:
	InputHelper.device_changed.connect(_on_input_device_changed)

func _on_keyboard_rebind_button_pressed(action_name : String):
	print("controls menu saw rebind keyboard " + action_name)
	scroll_container.hide()
	rebind_menu.show()
	if rebind_menu.has_method("set_action_name_title"):
		rebind_menu.set_action_name_title(action_name)

func _on_input_device_changed(device: String, device_index: int) -> void:
	print("XBox? ", device == InputHelper.DEVICE_XBOX_CONTROLLER)
	print("Device index? ", device_index) # Probably 0
