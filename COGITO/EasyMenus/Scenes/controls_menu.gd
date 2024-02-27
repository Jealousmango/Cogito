extends Control
signal  close

@export var keybind_config_data: Node

var config = ConfigFile.new()
var input_map: Array[StringName] = InputMap.get_actions()
var keybind_rows := Dictionary()

# The Set data type isn't available with GDScript
# A Dictionary can be used for similar performance
var inputActionBlacklistDict := {
	"ui_accept" : null,
	"ui_select" : null,
	"ui_cancel" : null,
	"ui_focus_next" : null,
	"ui_focus_prev" : null,
	"ui_left" : null,
	"ui_right" : null,
	"ui_up" : null,
	"ui_down" : null,
	"ui_page_up" : null,
	"ui_page_down" : null,
	"ui_home" : null,
	"ui_end" : null,
	"ui_cut" : null,
	"ui_copy" : null,
	"ui_paste" : null,
	"ui_undo" : null,
	"ui_redo" : null,
	"ui_text_completion_query" : null,
	"ui_text_accept" : null,
	"ui_text_replace" : null,
	"ui_text_newline" : null,
	"ui_text_newline_blank" : null,
	"ui_text_newline_above" : null,
	"ui_text_text_indent" : null,
	"ui_text_dedent" : null,
	"ui_text_backspace" : null,
	"ui_text_backspace_word" : null,
	"ui_text_word" : null,
	"ui_text_word.macos" : null,
	"ui_text_backspace_all_to_left" : null,
	"" : null,
}

# These actions should not be included in the rebind menu
var inputActionBlacklist: Array[StringName] = ["ui_accept", "ui_select", "ui_cancel", "ui_focus_next", "ui_focus_prev", "ui_left", "ui_right", "ui_up", "ui_down", "ui_page_up","ui_page_down", "ui_home","ui_end", "ui_cut", "ui_copy", "ui_paste","ui_undo", "ui_redo", "ui_text_completion_query", "ui_text_completion_accept", "ui_text_accept", "ui_text_replace", "ui_text_newline", "ui_text_newline_blank", "ui_text_newline_above", "ui_text_text_indent", "ui_text_dedent", "ui_text_backspace", "ui_text_backspace_word", "ui_text_word.macos","ui_text_backspace_all_to_left", "ui_text_backspace_all_to_left.macos", "ui_text_delete", "ui_text_delete_word", "ui_text_text_delete_word.macos", "ui_text_delete_all_to_right", "ui_text_delete_all_to_right.macos", "ui_text_caret_left", "ui_text_caret_word_left", "ui_text_caret_word_left.macos", "ui_text_caret_right", "ui_text_completion_replace", "ui_text_indent", "ui_text_backspace_word.macos","ui_text_delete_word.macos", "ui_text_caret_word_right", "ui_text_caret_word_right.macos", "ui_text_caret_up", "ui_text_caret_down", "ui_text_caret_line_start", "ui_text_caret_line_start.macos", "ui_text_caret_line_end", "ui_text_caret_line_end.macos", "ui_text_caret_page_up", "ui_text_caret_page_down", "ui_text_caret_document_start", "ui_text_caret_document_start.macos", "ui_text_caret_document_end", "ui_text_caret_document_end.macos", "ui_text_caret_add_below", "ui_text_caret_add_below.macos", "ui_text_caret_add_above", "ui_text_caret_add_above.macos", "ui_text_scroll_up", "ui_text_scroll_up.macos", "ui_text_scroll_down", "ui_text_scroll_down.macos", "ui_text_select_all", "ui_text_select_word_under_caret", "ui_text_select_word_under_caret.macos", "ui_text_add_selection_for_next_occurrence", "ui_text_clear_carets_and_selection", "ui_text_toggle_insert_mode", "ui_menu", "ui_text_submit", "ui_graph_duplicate", "ui_graph_delete", "ui_filedialog_up_one_level", "ui_filedialog_refresh", "ui_filedialog_show_hidden", "ui_swap_input_direction"]

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
		if !inputActionBlacklist.has(action):
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
