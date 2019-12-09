extends Node2D

var pos_queue: Array
var facing_offset: int = -40 + 100
var processing_queue: bool = false


func _ready() -> void:
	set_as_toplevel(true)


func _physics_process(delta) -> void:
	# add to pos_queue the needed distance to the ground
	# and the distance away from the player
	if pos_queue.size() > 0 and pos_queue.size() > rand_range(2, 15):
		processing_queue = true
	elif pos_queue.size() == 0:
		processing_queue = false
		$AnimatedSprite.playing = false
	if processing_queue:
		$AnimatedSprite.playing = true
		var pos_queue_adjusted: Vector2 = pos_queue.pop_front()
		if pos_queue[0].x < pos_queue[1].x:
			$AnimatedSprite.flip_h = false
			facing_offset = lerp(facing_offset, -80 + 100, 0.025)
		elif pos_queue[0].x > pos_queue[1].x:
			$AnimatedSprite.flip_h = true
			facing_offset = lerp(facing_offset, 80 + 100, 0.025)
		position = Vector2(pos_queue_adjusted.x + facing_offset, pos_queue_adjusted.y + 37)


func queue_position(pos: Vector2) -> void:
	# takes the player's position
	pos_queue.append(pos)