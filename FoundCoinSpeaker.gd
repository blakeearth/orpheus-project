extends Speaker

"""
Pontiki- “Not safe! Not safe!!!”
"""

onready var pontiki: Node2D = player.get_node("Pontiki")

func _ready() -> void:
	current_dialogue_node = make_dialogue_node(pontiki, "b", "Drachma? Money makes the world go ‘round...even when you’re dead...")
