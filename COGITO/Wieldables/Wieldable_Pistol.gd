extends Node3D

@export_group("Pistol Settings")
## Path to the projectile prefab scene
@export var projectile_prefab : PackedScene
## Speed the projectile spawns with
@export var projectile_velocity : float
## Node the projectile spawns at
@onready var bullet_point = $Bullet_Point

## The Field Of View change when aiming down sight. In degrees.
@export var ads_fov = 65
@export var default_position : Vector3

@export_group("Audio")
@export var sound_primary_use : AudioStream
@export var sound_secondary_use : AudioStream
@export var sound_reload : AudioStream

@export_group("General Wieldable Settings")
## Item resource that this wieldable refers to.
@export var item_reference : WieldableItemPD
## Visible parts of the wieldable. Used to hide/show on equip/unequip.
@export var wieldable_mesh : Node3D

@export_group("Animations")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

@export var anim_equip: String = "equip"
@export var anim_unequip: String = "unequip"
@export var anim_action_primary: String = "action_primary"
@export var anim_action_secondary: String = "action_secondary"
@export var anim_reload: String = "reload"

### Every wieldable needs the following functions:
### equip(_player_interaction_component), unequip(), action_primary(), action_secondary(), reload()

var player_interaction_component : PlayerInteractionComponent # Stores the player interaction component

func _ready():
	wieldable_mesh.hide()

# This gets called by player interaction compoment when the wieldable is equipped and primary action is pressed
func action_primary(_passed_item_reference : InventoryItemPD, _is_released: bool):
	if _is_released:
		return
	
	# Not firing if animation player is playing. This enforces fire rate.
	if animation_player.is_playing():
		return
	
	# Sound and animation
	animation_player.play(anim_action_primary)
	audio_stream_player_3d.stream = sound_primary_use
	audio_stream_player_3d.play()
	
	_passed_item_reference.subtract(1) #Reducing ammo count
	
	# Gettting camera_collision pos from player interaction component:
	var _camera_collision = player_interaction_component.Get_Camera_Collision()
	var Direction = (_camera_collision - bullet_point.get_global_transform().origin).normalized()
	
	# Spawning projectile
	var Projectile = projectile_prefab.instantiate()
	bullet_point.add_child(Projectile)
	Projectile.damage_amount = _passed_item_reference.wieldable_damage
	Projectile.set_linear_velocity(Direction * projectile_velocity)
	Projectile.reparent(get_tree().get_current_scene())
	


func action_secondary(is_released:bool):
	var camera = get_viewport().get_camera_3d()
	if is_released:
		# ADS Camera Zoom OUT
		var tween_cam = get_tree().create_tween()
		tween_cam.tween_property(camera,"fov", 75, .2)
		var tween_pistol = get_tree().create_tween()
		tween_pistol.tween_property(self,"position", default_position, .2)
	else:
		# ADS Camera Zoom IN
		var tween_cam = get_tree().create_tween()
		tween_cam.tween_property(camera,"fov", ads_fov, .2)
		var tween_pistol = get_tree().create_tween()
		tween_pistol.tween_property(self,"position", Vector3(0,default_position.y,default_position.z), .2)


# Function called when wieldable reload is attempted
func reload():
	animation_player.play(anim_reload)
	audio_stream_player_3d.stream = sound_reload
	audio_stream_player_3d.play()


# Function called when wieldable is unequipped.
func equip(_player_interaction_component: PlayerInteractionComponent):
	animation_player.play(anim_equip)
	player_interaction_component = _player_interaction_component


# Function called when wieldable is unequipped.
func unequip():
	animation_player.play(anim_unequip)
