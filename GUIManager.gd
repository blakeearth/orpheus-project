extends VBoxContainer

onready var hope_bar := $Bars/HopeBar/ProgressBar
onready var breath_bar := $Bars/BreathBar/ProgressBar
onready var a_box := $DialogueBoxes/A/RichTextLabel
onready var b_box := $DialogueBoxes/B/RichTextLabel
onready var hope_tween := $HopeTween
onready var breath_tween := $BreathTween
onready var dialogue_tween := $DialogueTween
onready var dialogue_alpha_tween := $DialogueAlphaTween
onready var bars_alpha_tween := $BarsAlphaTween

var animated_hope: float = 0
var animated_breath: float = 0

var a_visible_characters: float = 0
var b_visible_characters: float = 0

var bars_full: bool = false


func set_hope_max_value(new_max_value: int) -> void:
	hope_bar.max_value = new_max_value
	update_hope(new_max_value)


func set_breath_max_value(new_max_value: int) -> void:
	breath_bar.max_value = new_max_value
	update_breath(new_max_value)


func _on_hope_changed(hope: int) -> void:
	update_hope(hope)


func _on_breath_changed(breath: int) -> void:
	update_breath(breath)


func _on_box_a_text_changed(text: String) -> void:
	update_box_a_text(text)


func _on_box_b_text_changed(text: String) -> void:
	update_box_b_text(text)


func _on_dialogue_finished() -> void:
	fade_dialogue_box_to(0.0)


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
	var new_text_length: int = new_text.length()
	breath_tween.interpolate_property(self, NodePath("a_visible_characters"), a_visible_characters, new_text_length, 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not breath_tween.is_active():
		breath_tween.start()


func update_box_b_text(new_text: String) -> void:
	b_box.text = new_text
	var new_text_length: int = new_text.length()
	breath_tween.interpolate_property(self, NodePath("b_visible_characters"), animated_breath, new_text_length, 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not breath_tween.is_active():
		breath_tween.start()


func fade_bars_to(end_alpha: float) -> void:
	var start_color = $Bars.modulate
	var end_color = Color(1.0, 1.0, 1.0, end_alpha)
	bars_alpha_tween.interpolate_property($Bars, "modulate", start_color, end_color, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not bars_alpha_tween.is_active():
		bars_alpha_tween.start()


func fade_dialogue_box_to(end_alpha: float) -> void:
	var start_color = $DialogueBoxes.modulate
	var end_color = Color(1.0, 1.0, 1.0, end_alpha)
	dialogue_alpha_tween.interpolate_property($DialogueBoxes, "modulate", start_color, end_color, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
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