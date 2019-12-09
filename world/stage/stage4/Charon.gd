extends Speaker

var last_node: DialogueNode

onready var pontiki: Node2D = player.get_node("Pontiki")

func _ready() -> void:
	last_node = current_dialogue_node

	current_dialogue_node = make_dialogue_node(self, "b", "...coin...")
	var option: DialogueNode = make_dialogue_node(player, "a", "See what I mean?")
	current_dialogue_node.add_child(option)

	var option2: DialogueNode = make_dialogue_node(pontiki, "b", "Charon here is the ferryman across the Styx,")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "but he charges a drachma. If you can’t pay-")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(self, "b", "...no...coin... then...wait")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "Yeah, that doesn’t sound so bad right? Wrong!")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "He makes you wait a hundred years!")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "Honestly, this is such a monopoly of")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "vital divine realm services")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "that I’m appalled Hades hasn’t made some attempt")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "to regulate this! We should just take the boat ourselves!")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "With all the spirits stuck here...")
	option.add_child(option2)


	option = option2
	option2 = make_dialogue_node(pontiki, "b", "he couldn't possibly stop us all!")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(self, "b", "...welcome...to...try...")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "Oh? You think you could stop us?")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "You and what army? Oh that’s right!")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "You and no army, not unless you’re violating")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "the treaty of Orthrys and maintaining an armed force")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "not lead by a god of war!")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "We’ll just hop in your boat and cross all by ourselves.")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(self, "b", "...no...army...")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(self, "b", "*gestures to the boat*")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(self, "b", "...welcome...to... try...heheheheheh...")
	option.add_child(option2)