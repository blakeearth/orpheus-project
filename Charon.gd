extends Speaker

var last_node: DialogueNode

func _ready() -> void:
	last_node = current_dialogue_node
	
	current_dialogue_node = make_dialogue_node(self, "b", "you waited smiling for this?")
	var option: DialogueNode = make_dialogue_node(player, "a", "i see it, i like it, i want it, i got it.")
	current_dialogue_node.add_child(option)
	
	var option2: DialogueNode = make_dialogue_node(self, "b", "well ok then")
	option.add_child(option2)
	
	option = option2
	option2 = make_dialogue_node(player, "a", "yep.")
	option.add_child(option2)