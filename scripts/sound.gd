extends Node

var sounds = {
	"bounce":preload("res://sound/bounce.ogg"),
	"fall":preload("res://sound/fall.ogg"),
	"rain":preload("res://sound/rain_forest.ogg"),
	"swing":preload("res://sound/swing.ogg"),
	"win":preload("res://sound/win.ogg"),
	"plode":preload("res://sound/explode.ogg"),
}


var music_node = null
const play_music = true
var button_sound_callable = Callable(self,"_play_sound").bind("bounce", -5)
var sounds_from_instance_id = {}

func _ready():
	music_node = AudioStreamPlayer.new()
	add_child(music_node)

	process_mode = PROCESS_MODE_ALWAYS
	connect_buttons(get_tree().root)
	get_tree().connect("node_added",Callable(self,"on_node_added"))
	print("starts")
	_switch_music("rain",0)


func connect_buttons(root):
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		connect_buttons(child)


func on_node_added(node):
	if node is BaseButton:
		print(node)
		connect_to_button(node)


func connect_to_button(button):
	if not button.is_in_group("silent"):
		if not button.is_connected("pressed",button_sound_callable):
			button.connect("pressed",button_sound_callable)


func _switch_music(track_name, volume = -10):
	if not play_music:
		return
	if track_name == "stop":
		music_node.stop()
		music_node.stream = null
		return
	music_node.volume_db = volume
	music_node.bus = "Music"
	var track = sounds[track_name]
	if not track == music_node.stream:
		music_node.stream = sounds[track_name]
		music_node.play()


#func _switched_location(location_name : String):
	#if location_music.has(location_name):
		#_switch_music(location_music[location_name], -5)
	#else:
		#printerr("area didn't have music in soundmaster script")

func _is_sound_playing_before_time(sound : String,time = 0.0):
	for i in get_children():
		if i is AudioStreamPlayer and sounds_from_instance_id.has(i.get_instance_id()) and sounds_from_instance_id[i.get_instance_id()] == sound:
			if time != 0 and i.get_playback_position() > time:
				continue
			return true
	return false

func _play_sound(sound = "place", volume = 0,pitchvariance := 0.0, audio_bus := "SFX"):
	var soundinstance = AudioStreamPlayer.new()
	var _sound = sounds[sound]
	if _sound is Array:
		_sound = _sound.pick_random()
	soundinstance.stream = _sound
	#else:
		#soundinstance.stream = sounds[sound].pick_random()
	soundinstance.volume_db = volume + 10
	soundinstance.bus = audio_bus
	soundinstance.pitch_scale = randf_range(-pitchvariance,pitchvariance) + 1
	var id = soundinstance.get_instance_id()
	sounds_from_instance_id[id] = sound
	soundinstance.connect("finished",Callable(self,"_sound_when_done").bind(id))
	add_child(soundinstance)
	soundinstance.play()


func _sound_when_done(objecttokill):
	sounds_from_instance_id.erase(objecttokill)
	instance_from_id(objecttokill).queue_free()




#func _refresh_sound_volumes():
	#var settings = Save.game_data["options"]
	#AudioServer.set_bus_volume_db(music_bus_idx,linear_to_db(settings["music_volume"]))
	#AudioServer.set_bus_volume_db(sfx_bus_idx,linear_to_db(settings["sound_volume"]))
	#AudioServer.set_bus_volume_db(master_bus_idx,linear_to_db(settings["master_volume"]))
