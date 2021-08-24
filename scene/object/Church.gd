extends StaticBody

onready var bell_timer = $BellTimer
onready var bell_sound = $BellSound

func _ready():
	bell_timer.start()



func _on_BellTimer_timeout():
	bell_sound.playing = true
	bell_timer.wait_time = randi() % 555 + 111
