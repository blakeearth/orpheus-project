extends Node2D
class_name Speaker
# some entities have "speakers"
# speakers can take control of the camera and create a text dialogue
# some speakers should have an area2d, reference thehappiecat's stuff
# send signal connected to the player to start dialogue
# it's okay to watch thehappiecat's entire video if you need/want to!!!

var current_dialogue_node: DialogueNode
var dialogue_box: Node2D

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


func get_next_dialogue_node() -> DialogueNode:
	return current_dialogue_node


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body != null:
		if body.name == "Player":
			dialogue_box = load("res://gui/TalkPrompt.tscn").instance()
			dialogue_box.position = Vector2(position.x - 50, position.y - 130)
			Globals.gui().set_npc_speaker(self)
			Globals.gui().add_child(dialogue_box)


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body != null:
		if body.name == "Player":
			Globals.gui().set_npc_speaker(null)
			dialogue_box.queue_free()