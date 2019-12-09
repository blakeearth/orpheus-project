extends Speaker

onready var pontiki: Node2D = player.get_node("Pontiki")

func _ready() -> void:

	current_dialogue_node = make_dialogue_node(pontiki, "b", "Hey, are you okay? You don’t look so good.")
	var option: DialogueNode = make_dialogue_node(player, "a", "Sorry, I just...")
	current_dialogue_node.add_child(option)
	
	var option2: DialogueNode = make_dialogue_node(pontiki, "b", "Don’t worry about it. If you need to stop")
	option.add_child(option2)
	
	option = option2
	option2 = make_dialogue_node(pontiki, "b", "and catch your breath that’s fine,")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "and if you ever want to talk about it, I’m here.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "*nods*")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "Maybe try putting it out of your mind?")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "I’ve heard you’re a good singer,")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "why don’t you show me whether or not")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "you’ve earned that reputation.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "Sure")
	option.add_child(option2)

	player.start_spirits()