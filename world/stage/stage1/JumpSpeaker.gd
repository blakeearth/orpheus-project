extends Speaker

onready var pontiki: Node2D = player.get_node("Pontiki")

func _ready() -> void:
	
	current_dialogue_node = make_dialogue_node(pontiki, "b", "I guess this little adventure of ours will take...")
	var option: DialogueNode = make_dialogue_node(pontiki, "b", " a bit more effort than a leisurely stroll")
	current_dialogue_node.add_child(option)
	
	var option2: DialogueNode = make_dialogue_node(pontiki, "b", "down into the underworld. I hope you didn’t skip leg day!")
	option.add_child(option2)
	
	option = option2
	option2 = make_dialogue_node(player, "a", "...never...")
	option.add_child(option2)