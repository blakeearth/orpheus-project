extends Node
class_name DialogueNode

var speaker: Node2D
var text: String

var box: String = "b"


func set_speaker(new_speaker: Node2D) -> void:
	speaker = new_speaker


func get_speaker() -> Node2D:
	return speaker


func set_box(new_box: String) -> void:
	box = new_box


func get_box() -> String:
	return box


func set_text(new_text: String) -> void:
	text = new_text


func get_text() -> String:
	var dialogue_name: String = speaker.name
	if speaker.name == "Player":
		dialogue_name = "Orpheus"
	return dialogue_name + ": " + text