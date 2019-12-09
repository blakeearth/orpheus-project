extends Speaker

"""
Pontiki- “Seems like we’re getting close to the Styx...and the most extortionist being since the Graeae…”
"""

onready var pontiki: Node2D = player.get_node("Pontiki")

func _ready() -> void:
	
	current_dialogue_node = make_dialogue_node(pontiki, "b", "Seems like we’re getting close to the Styx..")
	var option: DialogueNode = make_dialogue_node(pontiki, "b", ".and the most extortionist being since the Graeae...")
	current_dialogue_node.add_child(option)
