extends Node

enum AudioBus {
	MASTER = 0,
	MUSIC = 1,
	SFX = 2,
}

var _sound_playback: AudioStreamPlaybackPolyphonic
var _music_playback: AudioStreamPlaybackInteractive

@onready var _sfx_stream_player: AudioStreamPlayer = %SFXStreamPlayer
@onready var _music_stream_player: AudioStreamPlayer = %MusicStreamPlayer


func _ready() -> void:
	_music_stream_player.play()
	_music_playback = _music_stream_player.get_stream_playback()
	_music_stream_player.stop()

	_sfx_stream_player.play()
	_sound_playback = _sfx_stream_player.get_stream_playback()


func play_sfx(audio_stream: AudioStream) -> void:
	_sound_playback.play_stream(audio_stream)

func play_music(music_name: String) -> void:
	if not _music_stream_player.playing:
		_music_stream_player.play()

	_music_playback.switch_to_clip_by_name(music_name)
