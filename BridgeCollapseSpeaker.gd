extends Speaker

onready var pontiki: Node2D = player.get_node("Pontiki")

func _ready() -> void:
	current_dialogue_node = make_dialogue_node(pontiki, "b", "Not safe! Not safe!!!")
