extends Node2D
class_name Speaker
# some entities have "speakers"
# speakers can take control of the camera and create a text dialogue
# some speakers should have an area2d, reference thehappiecat's stuff
# send signal connected to the player to start dialogue
# it's okay to watch thehappiecat's entire video if you need/want to!!!

var current_dialogue_node: DialogueNode
var dialogue_box: Node2D
export var voluntary = true

var used: bool = false

onready var player = Globals.world().get_node("Player")

func _ready() -> void:
	var region: Area2D = Area2D.new()
	var collision: CollisionShape2D = CollisionShape2D.new()
	var circle: CircleShape2D = CircleShape2D.new()
	circle.radius = 75
	collision.shape = circle
	region.add_child(collision)
	add_child(region)
	region.connect("body_entered", self, "_on_body_entered")
	region.connect("body_exited", self, "_on_body_exited")
	Globals.gui().connect("dialogue_stopped", self, "_on_dialogue_stopped")


func get_next_dialogue_node() -> DialogueNode:
	used = true
	return current_dialogue_node


func make_dialogue_node(speaker: Node2D, box: String, text: String) -> DialogueNode:
	var new_node: DialogueNode = DialogueNode.new()
	new_node.set_speaker(speaker)
	new_node.set_box(box)
	new_node.set_text(text)
	return new_node


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body != null:
		if body.name == "Player":
			Globals.gui().set_npc_speaker(self)
			if voluntary:
				dialogue_box = load("res://gui/TalkPrompt.tscn").instance()
				dialogue_box.position = Vector2(position.x - 50, position.y - 130)
				Globals.gui().add_child(dialogue_box)
			else:
				Globals.gui().start_dialogue()



func _on_dialogue_stopped() -> void:
	if not voluntary and used:
		queue_free()
		Globals.gui().set_npc_speaker(null)


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body != null:
		if body.name == "Player":
			if voluntary:
				dialogue_box.queue_free()
			else:
				queue_free()
			Globals.gui().set_npc_speaker(null)