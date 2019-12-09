extends Speaker

"""
Pontiki- “How old is this thing? This looks like it was built back when Poseidon was in charge...it can’t be safe…”

Orpheus- “Do you see any other way across?”

Pontiki- “Well...no…”

Orpheus- “Well, unless you want to take the ‘laundry-chute to Hades’ it looks like we’re taking the bridge.”
"""

onready var pontiki: Node2D = player.get_node("Pontiki")

func _ready() -> void:
	
	current_dialogue_node = make_dialogue_node(pontiki, "b", "How old is this thing? This looks like it")
	var option: DialogueNode = make_dialogue_node(pontiki, "b", "was built back when Poseidon was in charge...")
	current_dialogue_node.add_child(option)
	
	var option2: DialogueNode = make_dialogue_node(pontiki, "b", "it can’t be safe...")
	option.add_child(option2)
	
	option = option2
	option2 = make_dialogue_node(player, "a", "Do you see any other way across?")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(pontiki, "b", "Well...no...")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", "Well, unless you want to take the")
	option.add_child(option2)

	option = option2
	option2 = make_dialogue_node(player, "a", " ‘laundry-chute to Hades’ it looks like we’re taking the bridge.")
	option.add_child(option2)