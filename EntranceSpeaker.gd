extends Speaker

onready var pontiki: Node2D = player.get_node("Pontiki")

func _ready() -> void:
	
	current_dialogue_node = make_dialogue_node(pontiki, "b", "Are you sure about this? I’m behind you all the way...")
	var option: DialogueNode = make_dialogue_node(pontiki, "b", "if you are, but there’s no shame in backing out now.")
	current_dialogue_node.add_child(option)
	
	var option2: DialogueNode = make_dialogue_node(player, "a", "No...I’m not sure...but I’m doing it anyway.")
	option.add_child(option2)
	
	option = option2
	option2 = make_dialogue_node(pontiki, "b", "Okay then. Not gonna lie though...")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "this whole place makes my fur crawl.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "You don’t have to come with me, I can do this on my own.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "What kind of attitude is that? Let’s go get")
	option.add_child(option2)
	
	option = option2
	option2 = make_dialogue_node(pontiki, "b", "that girl of yours! Besides, I might as well do some")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "house hunting while we’re here, my old burrow has...")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "too many snakes in it.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "...")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "...")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "...")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "...it’s okay to be nervous about this… we are going into the")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "land of the dead after all...you just...")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "need to take that first step.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "I’ll be right behind you the whole way.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "Thanks.")
	option.add_child(option2)