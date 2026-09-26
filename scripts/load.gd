extends Node

class ItemInfo:
	var texture : Texture2D
	func _init(_texture) -> void:
		texture = _texture

const mouse = preload("res://ui/mouse.tres")

enum Items {BOUNCE,SWING}

var items : Dictionary[Items, ItemInfo] = {
	Items.BOUNCE:ItemInfo.new(preload("res://ui/item/item-b.tres")),
	Items.SWING:ItemInfo.new(preload("res://ui/item/item-a.tres"))
}
