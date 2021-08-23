extends StaticBody

signal has_trigged

export (String) var object_id
export (String) var details
export (bool) var collectable
export (int) var drop_amount



func get_message():
	emit_signal("has_trigged")
	return details
	
