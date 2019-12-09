extends Node2D

signal loading_started
signal loading_stopped


var stage_path: String


func _ready() -> void:
	connect("loading_started", Globals.gui(), "_on_loading_started")
	connect("loading_stopped", Globals.gui(), "_on_loading_stopped")
	Globals.gui().connect("curtain_dropped", self, "_on_curtain_dropped")


func change_stage(new_stage_path: String) -> void:
	stage_path = new_stage_path
	emit_signal("loading_started")


func _on_curtain_dropped() -> void:
	$Stage.free()
	var new_stage: Node = load(stage_path).instance()
	call_deferred("add_child", new_stage)
	$Player.position = new_stage.get_node("SpawnPoint").position
	$Player.call_deferred("die")
	new_stage.name = "Stage"
	emit_signal("loading_stopped")