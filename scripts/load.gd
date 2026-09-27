extends Node

class ItemInfo:
	var texture : Texture2D
	var name : String
	var item_node : PackedScene
	func _init(_texture, _name, _node) -> void:
		texture = _texture
		name = _name
		item_node = _node

const mouse = preload("res://ui/mouse.tres")
const creature = preload("res://entities/creature/creature.tscn")

enum Items {BOUNCE,SWING,BOMB}

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
