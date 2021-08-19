extends CanvasLayer



func _ready():
	var p = get_parent().player
	for key in p.inventory:
		if p.inventory[key] > 0:
			$Center/List.add_item(key, Data.icon[key])

func _on_ItemList_item_selected(index):
	get_parent().player.equip_item($Center/List.get_item_text(index).to_lower())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_parent().player.has_control = true
	queue_free()

func _on_Cancel_button_up():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_parent().player.has_control = true
	queue_free()
