extends Node

onready var hope_bar := $CanvasLayer/HUD/Bars/HopeBar/ProgressBar
onready var breath_bar := $CanvasLayer/HUD/Bars/BreathBar/ProgressBar
onready var a_box := $CanvasLayer/HUD/DialogueBoxes/A/RichTextLabel
onready var b_box := $CanvasLayer/HUD/DialogueBoxes/B/RichTextLabel
onready var hope_tween := $CanvasLayer/HUD/HopeTween
onready var breath_tween := $CanvasLayer/HUD/BreathTween
onready var dialogue_tween := $CanvasLayer/HUD/DialogueTween
onready var dialogue_alpha_tween := $CanvasLayer/HUD/DialogueAlphaTween
onready var bars_alpha_tween := $CanvasLayer/HUD/BarsAlphaTween
onready var loading_alpha_tween := $CanvasLayer/LoadingScreen/LoadingAlphaTween
onready var loading_screen := $CanvasLayer/LoadingScreen
onready var pontiki_tween := $CanvasLayer/LoadingScreen/PontikiTween

var animated_hope: float = 0
var animated_breath: float = 0

var a_visible_characters: float = 0
var b_visible_characters: float = 0

var bars_full: bool = false

var in_dialogue: bool = false
var was_in_dialogue: bool = false
var skipped_dialogue: bool = false
var current_dialogue_choice: int = 0
var current_dialogue_node: DialogueNode
var current_speaker: Node2D
var first_speaker: Node2D

var loading: bool = false

signal dialogue_started
signal speaker_changed
signal dialogue_stopped

# curtain down when loading screen is active
signal curtain_dropped


func _ready() -> void:
	$CanvasLayer/HUD/DialogueBoxes.modulate.a = 0
	$CanvasLayer/LoadingScreen.modulate.a = 0


func set_hope_max_value(new_max_value: int) -> void:
	hope_bar.max_value = new_max_value
	update_hope(new_max_value)


func set_breath_max_value(new_max_value: int) -> void:
	breath_bar.max_value = new_max_value
	update_breath(new_max_value)


func update_hope(new_value: int) -> void:
	hope_tween.interpolate_property(self, NodePath("animated_hope"), animated_hope, new_value, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not hope_tween.is_active():
		hope_tween.start()


func update_breath(new_value: int) -> void:
	breath_tween.interpolate_property(self, NodePath("animated_breath"), animated_breath, new_value, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not breath_tween.is_active():
		breath_tween.start()


func update_box_a_text(new_text: String) -> void:
	a_box.text = new_text
	a_visible_characters = 0
	var new_text_length: int = new_text.length()
	dialogue_tween.interpolate_property(self, NodePath("a_visible_characters"), a_visible_characters, new_text_length, 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not dialogue_tween.is_active():
		dialogue_tween.start()


func update_box_b_text(new_text: String) -> void:
	b_box.text = new_text
	b_visible_characters = 0
	var new_text_length: int = new_text.length()
	dialogue_tween.interpolate_property(self, NodePath("b_visible_characters"), b_visible_characters, new_text_length, 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not dialogue_tween.is_active():
		dialogue_tween.start()


func fade_bars_to(end_alpha: float) -> void:
	var start_color = $CanvasLayer/HUD/Bars.modulate
	var end_color = Color(1.0, 1.0, 1.0, end_alpha)
	bars_alpha_tween.interpolate_property($CanvasLayer/HUD/Bars, "modulate", start_color, end_color, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not bars_alpha_tween.is_active():
		bars_alpha_tween.start()


func fade_dialogue_box_to(end_alpha: float) -> void:
	var start_color = $CanvasLayer/HUD/DialogueBoxes.modulate
	var end_color = Color(1.0, 1.0, 1.0, end_alpha)
	dialogue_alpha_tween.interpolate_property($CanvasLayer/HUD/DialogueBoxes, "modulate", start_color, end_color, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not dialogue_alpha_tween.is_active():
		dialogue_alpha_tween.start()


func _process(delta) -> void:
	var round_hope_value: int = round(animated_hope)
	var round_breath_value: int = round(animated_breath)
	var round_a_visible_characters: int = round(a_visible_characters)
	var round_b_visible_characters: int = round(b_visible_characters)
	a_box.visible_characters = round_a_visible_characters
	b_box.visible_characters = round_b_visible_characters
	hope_bar.value = round_hope_value
	breath_bar.value = round_breath_value
	if not bars_full && breath_bar.value == breath_bar.max_value && hope_bar.value == hope_bar.max_value:
		fade_bars_to(0.0)
		bars_full = true
	elif not breath_bar.value == breath_bar.max_value || not hope_bar.value == hope_bar.max_value:
		fade_bars_to(1.0)
		bars_full = false


func set_npc_speaker(new_speaker: Speaker) -> void:
	current_speaker = new_speaker


func start_dialogue() -> void:
	first_speaker = current_speaker
	in_dialogue = true
	Globals.world().get_node("TunnelPlayer").play(5)
	fade_dialogue_box_to(1.0)
	emit_signal("speaker_changed", current_speaker)
	current_dialogue_node = current_speaker.get_next_dialogue_node()
	execute_dialogue_node(current_dialogue_node)


func execute_dialogue_node(n: DialogueNode):
	var box: String = n.get_box()
	if box == "a":
		update_box_a_text(n.get_text())
	elif box == "b":
		update_box_b_text(n.get_text())


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if $CanvasLayer/HUD/DialogueTween.is_active():
			# player is trying to skip dialogue
			print("skip")
			a_visible_characters = -1
			b_visible_characters = -1
			skipped_dialogue = true
			$CanvasLayer/HUD/DialogueTween.stop(self)
			$CanvasLayer/HUD/DialogueTween.set_active(false)
		if was_in_dialogue and not skipped_dialogue:
			# player wants to dismiss the dialogue or continue
			# with the conversation
			pass
		elif current_speaker != null and not skipped_dialogue:
			if not in_dialogue:
				first_speaker = current_speaker
				in_dialogue = true
				fade_dialogue_box_to(1.0)
				current_dialogue_node = current_speaker.get_next_dialogue_node()
				execute_dialogue_node(current_dialogue_node)
				emit_signal("speaker_changed", current_dialogue_node.get_speaker())
			elif in_dialogue:
				skipped_dialogue = false
				print("continuing the dialogue")
				var options: Array = current_dialogue_node.get_children()
				if options.size() > 1:
					# create a list they can select between
					pass
				elif options.size() == 1:
					current_dialogue_node = options[0]
					if current_speaker != current_dialogue_node.get_speaker():
						current_speaker = current_dialogue_node.get_speaker()
						emit_signal("speaker_changed", current_speaker)
					execute_dialogue_node(current_dialogue_node)
				else:
					print("allowing dialogue to end")
					print("dismissing")
					in_dialogue = false
					skipped_dialogue = false
					current_speaker = first_speaker
					fade_dialogue_box_to(0.0)
					Globals.world().get_node("TunnelPlayer").stop()
					emit_signal("dialogue_stopped")
		skipped_dialogue = false


func _on_DialogueAlphaTween_tween_completed(object: Object, key: NodePath) -> void:
	if $CanvasLayer/HUD/DialogueBoxes.modulate.a == 0.0:
		a_visible_characters = -1
		b_visible_characters = -1
		a_box.text = ""
		b_box.text = ""


func _on_hope_changed(hope: int) -> void:
	update_hope(hope)
	Globals.world().get_node("Player/SpiritTimer").start()


func _on_breath_changed(breath: int) -> void:
	update_breath(breath)


func _on_loading_started() -> void:
	loading = true
	var start_color = $CanvasLayer/LoadingScreen.modulate
	var end_color = Color(1.0, 1.0, 1.0, 1.0)
	loading_alpha_tween.interpolate_property($CanvasLayer/LoadingScreen, "modulate", start_color, end_color, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$CanvasLayer/LoadingScreen/LoadingTimer.start()
	if not loading_alpha_tween.is_active():
		loading_alpha_tween.start()
	print("timer started")
	Globals.world().get_node("LoadingScreenPlayer").play()


func _on_loading_stopped() -> void:
	loading = false
	print("loading stopped")


func _on_LoadingTimer_timeout() -> void:
	if not loading:
		print("disabling loading screen")
		var start_color = $CanvasLayer/LoadingScreen.modulate
		var end_color = Color(1.0, 1.0, 1.0, 0.0)
		loading_alpha_tween.interpolate_property($CanvasLayer/LoadingScreen, "modulate", start_color, end_color, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$CanvasLayer/LoadingScreen/LoadingTimer.stop()
		if not loading_alpha_tween.is_active():
			loading_alpha_tween.start()
	pontiki_tween.stop($CanvasLayer/LoadingScreen/Panel/AnimatedSprite)
	pontiki_tween.set_active(false)
	$CanvasLayer/LoadingScreen/Panel/AnimatedSprite.position = Vector2(-60, 565)
	Globals.world().get_node("LoadingScreenPlayer").stop()


func _on_LoadingAlphaTween_tween_completed(object: Object, key: NodePath) -> void:
	if loading:
		var start_position: Vector2 = $CanvasLayer/LoadingScreen/Panel/AnimatedSprite.position
		var end_position: Vector2 = Vector2(1100, 565)
		pontiki_tween.interpolate_property($CanvasLayer/LoadingScreen/Panel/AnimatedSprite, "position", start_position, end_position, 5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		if not pontiki_tween.is_active():
			pontiki_tween.start()
		emit_signal("curtain_dropped")
