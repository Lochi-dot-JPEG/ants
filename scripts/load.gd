extends Node

class ItemInfo:
	var texture : Texture2D
	var name : String
	func _init(_texture, _name) -> void:
		texture = _texture
		name = _name

const mouse = preload("res://ui/mouse.tres")

enum Items {BOUNCE,SWING}

var items : Dictionary[Items, ItemInfo] = {
	Items.BOUNCE:ItemInfo.new(
		preload("res://ui/item/item-b.tres"), 
		"Bounce"
	),
	Items.SWING:ItemInfo.new(
		preload("res://ui/item/item-a.tres"), 
		"Swing"
	),
}
