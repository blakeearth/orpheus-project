extends Node2D

export var level_scene_path: String
export var active: bool = true

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if active and body != null:
		if body.name == "Player":
			Globals.world().change_stage(level_scene_path)
