extends KinematicBody2D

const FLOOR_NORMAL = Vector2(0, -1)
const STAY_ON_FLOOR = 3
const MAX_HOPE = 100
const MAX_BREATH = 100

onready var tween = $Camera2D/Tween

var gravity: int = 1000
var jump_speed: int = 400
var jumps: int = 1
var max_speed: int = 200

var queue_jump: bool

var direction: int
var velocity: Vector2

var hope_level: int = 100
var breath_level: int = 100
var singing = false
var singing_pressed = false
var in_dialogue = false

signal singing_started
signal singing_stopped

signal hope_changed
signal breath_changed


func _ready() -> void:
	connect("hope_changed", Globals.gui(), "_on_hope_changed")
	connect("breath_changed", Globals.gui(), "_on_breath_changed")
	Globals.gui().connect("dialogue_stopped", self, "_on_dialogue_stopped")
	Globals.gui().connect("speaker_changed", self, "_on_speaker_changed")
	Globals.gui().set_hope_max_value(MAX_HOPE)
	Globals.gui().set_breath_max_value(MAX_BREATH)


func _physics_process(delta) -> void:
	if queue_jump == true:
		velocity.y = -jump_speed
		queue_jump = false
	elif not is_on_floor():
		if is_on_ceiling():
			velocity.y = 0
		velocity.y += delta * gravity
	else:
		jumps = 1
		velocity.y = STAY_ON_FLOOR
	velocity.x = direction * max_speed
	if velocity.x != 0:
		if not $AnimatedSprite.playing:
			$AnimatedSprite.playing = true
			$AnimatedSprite.frame = 2
	elif is_on_floor():
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 3
	if velocity.y != 0 and not is_on_floor():
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 2
	if velocity.x != 0 or velocity.y != 0:
		$Pontiki.queue_position(position)
	move_and_slide(velocity, FLOOR_NORMAL)


func lock_camera_to_player():
	$Camera2D.set_as_toplevel(false)
	$Camera2D.position = Vector2(0, 0)


func pan_camera_to(n2: Node2D):
	$Camera2D.set_as_toplevel(true)
	tween.interpolate_property($Camera2D, "position", position, n2.position, 0.6, Tween.TRANS_CUBIC, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()


func die() -> void:
	$Camera2D.set_as_toplevel(true)
	tween.interpolate_property($Camera2D, "position", position, get_node("../Stage/SpawnPoint").position, 1, Tween.TRANS_CUBIC, Tween.EASE_IN)
	position = get_node("../Stage/SpawnPoint").position
	if not tween.is_active():
		tween.start()
	for child in get_children():
		if child.get_script() == Spirit:
			child.queue_free()
	hope_level = MAX_HOPE
	breath_level = MAX_BREATH
	emit_signal("breath_changed", hope_level)
	emit_signal("hope_changed", breath_level)


func _unhandled_input(event: InputEvent) -> void:
	if not in_dialogue:
		if Input.is_action_just_pressed("jump") and is_on_floor() and jumps > 0:
			jumps -= 1
			queue_jump = true
		direction = 0
		if Input.is_action_pressed("move_right"):
			$AnimatedSprite.flip_h = false
			direction = 1
		if Input.is_action_pressed("move_left"):
			$AnimatedSprite.flip_h = true
			direction = -1
		if Input.is_action_just_pressed("sing"):
			if breath_level > 0:
				singing = true
				singing_pressed = true
				$BreathTimer.start()
				emit_signal("singing_started")
		elif Input.is_action_just_released("sing"):
			singing = false
			singing_pressed = false
			emit_signal("singing_stopped")


func _on_SpiritTimer_timeout() -> void:
	randomize()
	for i in range(3):
		var spirit: PathFollow2D = load("res://Spirit.tscn").instance()
		add_child(spirit)
	if singing:
		emit_signal("singing_started")


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body == self:
		hope_level -= 20
		if hope_level < 0:
			die()
		if $HopeTimer.is_stopped():
			$HopeTimer.start()
		emit_signal("hope_changed", hope_level)


func _on_BreathTimer_timeout() -> void:
	if not in_dialogue:
		if singing:
			breath_level -= 1
		else:
			if breath_level < MAX_BREATH and not singing_pressed:
				breath_level += 1
		if breath_level < 0:
			singing = false
			emit_signal("singing_stopped")
		emit_signal("breath_changed", breath_level)


func _on_HopeTimer_timeout() -> void:
	if not in_dialogue:
		if hope_level < MAX_BREATH:
				hope_level += 3
		emit_signal("hope_changed", hope_level)


func _on_dialogue_stopped() -> void:
	in_dialogue = false
	$SpiritTimer.paused = false
	lock_camera_to_player()


func _on_speaker_changed(speaker: Node2D) -> void:
	in_dialogue = true
	$SpiritTimer.paused = true
	pan_camera_to(speaker)

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	if not in_dialogue:
		lock_camera_to_player()
