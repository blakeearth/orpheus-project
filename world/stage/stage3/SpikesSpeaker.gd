extends Speaker

onready var pontiki: Node2D = player.get_node("Pontiki")

func _ready() -> void:
	
	current_dialogue_node = make_dialogue_node(pontiki, "b", "Who is responsible for the interior design here?!")
	var option: DialogueNode = make_dialogue_node(pontiki, "b", "It's obvious that neither they, nor Hades and Persephone,")
	current_dialogue_node.add_child(option)
	
	var option2: DialogueNode = make_dialogue_node(pontiki, "b", "have ever had a child! I mean look at these stalagmites!")
	option.add_child(option2)
	
	option = option2
	option2 = make_dialogue_node(player, "a", "It’s like they’re trying to impale someone!")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "I kinda like it, it adds to")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "the whole death and despair vibe.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "Makes it feel sorta punk.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "What’s punk?")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "*shrugs*")
	option.add_child(option2)