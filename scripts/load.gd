extends Node

class ItemInfo:
	var texture : Texture2D
	func _init(_texture) -> void:
		texture = _texture

var items = {
	"bounce":ItemInfo.new(preload("res://ui/item/item-b.tres")),
	"swing":ItemInfo.new(preload("res://ui/item/item-a.tres"))
}
