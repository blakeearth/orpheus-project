extends KinematicBody2D

const FLOOR_NORMAL = Vector2(0, -1)
const STAY_ON_FLOOR = 30
const MAX_HOPE = 100
const MAX_BREATH = 100

onready var tween = $Camera2D/Tween

var gravity: int = 1000
var jump_speed: int = 400
var jumps: int = 1
var max_speed: int = 150
var spawn_point: Vector2 = Vector2(0, 425)

var queue_jump: bool

var direction: int
var velocity: Vector2

var hope_level: int = 100
var breath_level: int = 100
var singing = false
var singing_pressed = false

signal singing_started
signal singing_stopped

signal box_a_text_changed
signal box_b_text_changed

signal hope_changed
signal breath_changed


func _ready() -> void:
	connect("box_a_text_changed", Globals.gui(), "_on_box_a_text_changed")
	connect("box_b_text_changed", Globals.gui(), "_on_box_b_text_changed")
	connect("hope_changed", Globals.gui(), "_on_hope_changed")
	connect("breath_changed", Globals.gui(), "_on_breath_changed")
	Globals.gui().set_hope_max_value(MAX_HOPE)
	Globals.gui().set_breath_max_value(MAX_BREATH)
	emit_signal("box_a_text_changed", "Orpheus: Hello, world!")


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
	if velocity.x != 0 or velocity.y != 0:
		$Pontiki.queue_position(position)
	move_and_slide(velocity, FLOOR_NORMAL)


func die() -> void:
	$Camera2D.set_as_toplevel(true)
	print($Camera2D.position)
	tween.interpolate_property($Camera2D, "position", position, spawn_point, 0.6, Tween.TRANS_CUBIC, Tween.EASE_IN)
	position = spawn_point
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
	if Input.is_action_just_pressed("jump") and is_on_floor() and jumps > 0:
		jumps -= 1
		queue_jump = true
	direction = 0
	if Input.is_action_pressed("move_right"):
		direction = 1
	if Input.is_action_pressed("move_left"):
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
	var spirit: PathFollow2D = load("res://Spirit.tscn").instance()
	spirit.singing = true
	add_child(spirit)
	if singing:
		emit_signal("singing_started")


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body == self:
		hope_level -= 80
		if hope_level < 0:
			die()
		if $HopeTimer.is_stopped():
			$HopeTimer.start()
		emit_signal("hope_changed", hope_level)


func _on_BreathTimer_timeout() -> void:
	if singing:
		breath_level -= 1
	else:
		if breath_level < MAX_BREATH && not singing_pressed:
			breath_level += 1
	if breath_level < 0:
		singing = false
		emit_signal("singing_stopped")
	emit_signal("breath_changed", breath_level)


func _on_HopeTimer_timeout() -> void:
	if hope_level < MAX_BREATH:
			hope_level += 3
	emit_signal("hope_changed", hope_level)


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	print(position)
	print($Camera2D.position)
	$Camera2D.set_as_toplevel(false)
	$Camera2D.position = Vector2(0, 0)
