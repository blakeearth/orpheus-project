extends Node2D

# Declare member variables here. Examples:
# var a: int = 2
export var level_scene_path: String

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body != null:
		if body.name == "Player":
			Globals.world().change_stage(level_scene_path)
