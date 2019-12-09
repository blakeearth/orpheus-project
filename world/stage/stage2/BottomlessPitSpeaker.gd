extends Speaker


onready var pontiki: Node2D = player.get_node("Pontiki")

func _ready() -> void:
	
	current_dialogue_node = make_dialogue_node(pontiki, "b", "Whoa! Hold up! Be careful here")
	var option: DialogueNode = make_dialogue_node(pontiki, "b", "we don’t wanna fall down that hole...")
	current_dialogue_node.add_child(option)
	
	var option2: DialogueNode = make_dialogue_node(player, "a", "*whistles*")
	option.add_child(option2)
	
	option = option2
	option2 = make_dialogue_node(player, "a", "How far do you think it goes down?")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "Asphodel...if you’re lucky...")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "Tartarus if you’re not.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "Isn’t Asphodel on our way?")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "Yeah, but don’t get any funny ideas.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "Sure, this is technically a short-cut, but")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "isn’t the point of our trip to get your girlfriend-")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "Wife")
	option.add_child(option2)
	
	option = option2
	option2 = make_dialogue_node(pontiki, "b", "-and get you two out of here alive?")
	option.add_child(option2)
	
	option = option2
	option2 = make_dialogue_node(pontiki, "b", "If you decide to use this literal laundry-chute")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "to Hades you might get to her faster,")
	option.add_child(option2)


	option = option2
	option2 = make_dialogue_node(pontiki, "b", "but by Zeus you aren’t coming back out.")
	option.add_child(option2)