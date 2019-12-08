extends Node

# Declare member variables here. Examples:

func gui() -> Node:
	return get_tree().get_root().get_node("Game/GUI")
