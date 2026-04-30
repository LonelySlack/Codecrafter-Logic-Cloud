extends Node

@onready var music_player = AudioStreamPlayer.new()

# Dictionary mapping level IDs to { "stream": Audio, "volume": float }
# Volume is in decibels (0 is full, -10 is quieter, -20 is very quiet)
var track_list = {
	"main": {
		"stream": preload("res://audio/AQILCUMONTHISBEAT.ogg"),
		"volume": -5
	}
}

var current_track_id = ""

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.bus = "Music"

func play_track(track_id: String):
	if track_id == current_track_id:
		return 
	
	if track_list.has(track_id):
		var track_data = track_list[track_id]
		current_track_id = track_id
		_fade_to_track(track_data["stream"], track_data["volume"])

func _fade_to_track(new_stream: AudioStream, target_volume: float):
	var tween = create_tween()
	
	# 1. Fade out current music to silence
	tween.tween_property(music_player, "volume_db", -80.0, 0.8).set_trans(Tween.TRANS_SINE)
	
	# 2. Swap the track
	tween.tween_callback(func(): 
		music_player.stream = new_stream
		music_player.play()
	)
	
	# 3. Fade up to the SPECIFIC volume defined for this track
	tween.tween_property(music_player, "volume_db", target_volume, 0.8).set_trans(Tween.TRANS_SINE)
	
func play_track_instant(track_id: String):
	if track_id == current_track_id:
		return 
	
	if track_list.has(track_id):
		var track_data = track_list[track_id]
		current_track_id = track_id
		
		# Set properties immediately without a Tween
		music_player.stop() # Stop current track
		music_player.stream = track_data["stream"]
		music_player.volume_db = track_data["volume"]
		music_player.play()
		
		print("System: Instant track swap to ", track_id)
	else:
		print("Audio Error: Track ID not found: ", track_id)
	
func stop_track():
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80, 1.0)
	tween.finished.connect(func(): music_player.stop())
	current_track_id = ""
