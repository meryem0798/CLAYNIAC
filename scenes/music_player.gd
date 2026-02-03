extends Node


var current_music = null
@onready var player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func play_music(music: AudioStream):
	if current_music == music:
		return
	
	current_music = music
	player.stream = music
	
	if music is AudioStreamOggVorbis:
		music.loop = true
	
	player.play()


func stop_music():
	player.stop()
	current_music = null


func _on_audio_stream_player_2d_finished() -> void:
	player.play()
