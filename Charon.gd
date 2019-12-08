extends Speaker

func _ready() -> void:
	current_dialogue_node = DialogueNode.new()
	current_dialogue_node.set_speaker(self)
	current_dialogue_node.set_box("b")
	current_dialogue_node.set_text("you waited smiling for this?")