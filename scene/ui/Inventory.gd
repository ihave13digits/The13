extends CanvasLayer



func _on_ItemList_item_selected(index):
	get_parent().player.equip_item($Center/List.get_item_text(index).to_lower())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_parent().player.has_control = true
	queue_free()
