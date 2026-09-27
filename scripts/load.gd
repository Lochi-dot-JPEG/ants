extends Node

class ItemInfo:
	var texture : Texture2D
	var name : String
	var item_node : PackedScene
	func _init(_texture, _name, _node) -> void:
		texture = _texture
		name = _name
		item_node = _node

const title = "res://ui/title/title.tscn"
const mouse = preload("res://ui/mouse.tres")
const creature = preload("res://entities/creature/creature.tscn")

enum Items {BOUNCE,SWING,BOMB}

var current_level_number = 0

const levels = [
	"res://locations/lvl-1.tscn",
	"res://locations/test-area.tscn",
]

var items : Dictionary[Items, ItemInfo] = {
	Items.BOUNCE:ItemInfo.new(
		preload("res://ui/item/item-b.tres"), 
		"Bounce",
		preload("res://entities/bounce/bounce.tscn"),
	),
	Items.SWING:ItemInfo.new(
		preload("res://ui/item/item-a.tres"), 
		"Swing",
		preload("res://entities/swing/swing.tscn"),
	),
	Items.BOMB:ItemInfo.new(
		preload("res://ui/item/item-c.tres"), 
		"Bomb",
		preload("res://entities/bomb/bomb.tscn"),
	),
}
func _next_level() -> void:
	_open_level(current_level_number + 1)

func _open_level(number : int) -> void:
	if levels.size() <= number:
		printerr("No level here")
		return
	# TODO if at the last level, change to a winning screen
	get_tree().change_scene_to_file(levels[number])
	current_level_number = number
