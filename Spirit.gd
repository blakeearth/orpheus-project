extends Path2D
class_name Spirit

const CAMERA_X_MIN: int = -500
const CAMERA_X_MAX: int = 500
const CAMERA_Y_MIN: int = -300
const CAMERA_Y_MAX: int = 300

const MAX_HEALTH = 10

var current_spiral_checkpoint: int = 0

const spiral_resolution: int = 30
const angle_adjustment: float = PI / 12

var outer_position: Vector2

var health: int = MAX_HEALTH
var singing: bool

func _ready() -> void:
	get_parent().connect("singing_started", self, "_on_singing_started")
	get_parent().connect("singing_stopped", self, "_on_singing_stopped")
	$PathFollow2D/Area2D.connect("body_entered", get_parent(), "_on_body_entered")
	# N E S W
	# 0 1 2 3
	randomize()
	var edge: int = randi() % 4
	if edge == 0:
		# North wall
		outer_position.x = rand_range(CAMERA_X_MIN, CAMERA_X_MAX)
		outer_position.y = -300
	elif edge == 1:
		# East wall
		outer_position.x = 500
		outer_position.y = rand_range(CAMERA_Y_MIN, CAMERA_Y_MAX)
	elif edge == 2:
		# South wall
		outer_position.x = rand_range(CAMERA_X_MIN, CAMERA_X_MAX)
		outer_position.y = 300
	else:
		# West wall
		outer_position.x = -500
		outer_position.y = rand_range(CAMERA_Y_MIN, CAMERA_Y_MAX)
	var spiral = calculate_spiral(Vector2(0, 0), outer_position)
	set_curve(spiral)


func _physics_process(delta: float) -> void:
	if $PathFollow2D.position.distance_to(Vector2(0, 0)) > outer_position.distance_to(Vector2(0, 0)):
		queue_free()
	var offset: int = 10
	$PathFollow2D.set_offset($PathFollow2D.get_offset() + offset) 


func calculate_spiral(centerpoint: Vector2, outerpoint: Vector2) -> Curve2D:
	# series of lines with "rotating" slopes
	# series of circles with declining radii
	var spiral: Curve2D = Curve2D.new()
	var max_radius = centerpoint.distance_to(outerpoint)
	var radius: float = max_radius
	var slope: float = (centerpoint.y - float(outerpoint.y)) / (centerpoint.x - float(outerpoint.x))
	var angle: float = atan(slope)
	var rand_angle_adjustment: float = angle_adjustment
	randomize()
	for i in range(randi() % 4):
		rand_angle_adjustment *= -1
	for i in range(randi() % 3):
		radius *= -1
	if radius < 0:
		while radius < 0:
			radius += (max_radius / spiral_resolution)
			var x: float = centerpoint.x + radius * cos(angle)
			var y: float = centerpoint.y + radius * sin(angle)
			var point: Vector2 = Vector2(x, y)
			spiral.add_point(point)
			angle += rand_angle_adjustment
	else:
		while radius > 0:
			radius -= (max_radius / spiral_resolution)
			var x: float = centerpoint.x + radius * cos(angle)
			var y: float = centerpoint.y + radius * sin(angle)
			var point: Vector2 = Vector2(x, y)
			spiral.add_point(point)
			angle += rand_angle_adjustment
	return spiral


func _on_singing_started() -> void:
	singing = true
	$HealthTimer.start()

func _on_singing_stopped() -> void:
	singing = false

func _on_HealthTimer_timeout() -> void:
	var start_color: Color = get_node("PathFollow2D/Sprite").modulate
	if singing:
		health -= 2
	elif health < MAX_HEALTH:
		health += 2
	var end_color := Color(1.0, 1.0, 1.0, float(health) / MAX_HEALTH)
	$Tween.interpolate_property(get_node("PathFollow2D/Sprite"), "modulate", start_color, end_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not $Tween.is_active():
		$Tween.start()
	if get_node("PathFollow2D/Sprite").modulate.a == 0.0:
		queue_free()

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		queue_free()
