extends Node2D

# Strength of pull by aqdjacent points
export var elasticity = 0.01
export var width = 10000
export var level = 50
export var depth = 900
export var foam_thickness = 3
export var maximum_amplitude = 15
# Resolution of simulation
export var resolution = 50
export var foam_color = Color(1, 1, 1, 0.5)
export var floor_color = Color(0, 0, 1, 1)
export var surface_color = Color(0, 0.5, 0.5, 0.3)

var surface_points = Array()
var floor_points = Array()

func _ready():
	surface_points = make_surface_points()
	floor_points = make_floor_points()

func _draw():
	draw_water()

func _physics_process(delta):
	update()
	for point in surface_points:
		update_point(point)

func make_surface_points():
	var new_surface_points = Array()
	for i in range(resolution):
		var point = Dictionary()
		point['coord'] = Vector2((float(i) / resolution) * width - (width / 2), level)
		point['velocity'] = 0
		point['index'] = i
		new_surface_points.append(point)
	return new_surface_points

func make_floor_points():
	var new_floor_points = Array()
	for i in range(resolution):
		var point = Dictionary()
		point['coord'] = Vector2((float(i) / (resolution)) * width - (width / 2), level + depth)
		point['velocity'] = 0
		point['index'] = i
		new_floor_points.append(point)
	return new_floor_points

func update_point(point):
	var ordinary_value = get_ordinary_value(point['coord'].x)
	var acceleration = 0
	# If neighbor does not exist, substitute with this point's value
	var left_neighbor_value = point['coord'].y
	var right_neighbor_value = point['coord'].y
	if point['index'] > 0:
		left_neighbor_value = surface_points[point['index'] - 1]['coord'].y
	if point['index'] < len(surface_points) - 1:
		right_neighbor_value = surface_points[point['index'] + 1]['coord'].y
	# Lerp between current location and "desired" location
	point['coord'].y = lerp(point['coord'].y, (ordinary_value + left_neighbor_value + right_neighbor_value) / 3, elasticity) + point['velocity']
	# Apply Euler's method to velocity based again on "desired" location
	acceleration = -elasticity * (3 * point['coord'].y - ordinary_value - left_neighbor_value - right_neighbor_value)
	point['velocity'] += acceleration

func get_ordinary_value(x):
	var value = level
	if rand_range(0, 1) > 1 - (resolution / float(resolution * 10)):
		value += maximum_amplitude * rand_range(-1, 1)
	return value

func make_splash(coord, velocity):
	var closest_point = get_closest_point(coord.x)
	closest_point['velocity'] = velocity / 60
	for i in range(resolution/100):
		if closest_point['index'] != 0 and closest_point['index'] != (resolution - 1):
			surface_points[closest_point['index'] - (i + 1)]['velocity'] = closest_point['velocity'] / (i + 1)
			surface_points[closest_point['index'] + (i + 1)]['velocity'] = closest_point['velocity'] / (i + 1)
		else:
			print("Splashing object is trying to affect points outside the water.")

func get_closest_point(x):
	var closest_point = surface_points[0]
	for point in surface_points:
		if abs(point['coord'].x - x) < abs(closest_point['coord'].x - x):
			closest_point = point
	return closest_point

func draw_water():
	for i in range(resolution-1):
		draw_polygon([surface_points[i]['coord'], surface_points[i + 1]['coord'], floor_points[i]['coord']], PoolColorArray([surface_color, surface_color, floor_color]))
		draw_polygon([floor_points[i]['coord'], floor_points[i + 1]['coord'], surface_points[i + 1]['coord']], PoolColorArray([floor_color, floor_color, surface_color]))
		draw_line(surface_points[i]['coord'], surface_points[i + 1]['coord'], foam_color, foam_thickness)