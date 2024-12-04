class_name Snake
extends Node2D


enum Direction {UP, DOWN, LEFT, RIGHT}

class Segment:
	var spr: Sprite2D
	var pos: Vector2i
	var in_dir: Direction
	var out_dir: Direction

@export_group('Properties')
@export var ai_controlled: bool = false

@export_group('Dependencies')
@export var board: Board

@export_group('Textures')
@export_subgroup('Head')
@export var head_up: Texture2D
@export var head_down: Texture2D
@export var head_left: Texture2D
@export var head_right: Texture2D

@export_subgroup('Tail')
@export var tail_up: Texture2D
@export var tail_down: Texture2D
@export var tail_left: Texture2D
@export var tail_right: Texture2D

@export_subgroup('Body Straight')
@export var body_horizontal: Texture2D
@export var body_vertical: Texture2D
@export_subgroup('Body Bent')
@export var body_ul: Texture2D
@export var body_ur: Texture2D
@export var body_dl: Texture2D
@export var body_dr: Texture2D

@onready var head_texture_mapping: Array[Texture2D] = [head_up, head_down, head_left, head_right]
@onready var tail_texture_mapping: Array[Texture2D] = [tail_up, tail_down, tail_left, tail_right]

@onready var head_spr: Sprite2D = $Head
@onready var tail_spr: Sprite2D = $Tail

@onready var texture_size: int = head_up.get_size().x as int
@onready var head: Segment = Segment.new()
@onready var tail: Segment = Segment.new()
var curr_direction: Direction = Direction.RIGHT
var length: int = 2
var body_segments: Array[Segment] = []
var next_move: Direction
var move_sequence: Array[Direction] = []
var is_dead: bool = false


signal dead


func _ready() -> void:
	head.spr = head_spr
	head.pos = Vector2i(1, 0)
	head.in_dir = Direction.LEFT
	head.out_dir = Direction.RIGHT
	tail.spr = tail_spr
	tail.pos = Vector2i(0, 0)
	tail.in_dir = Direction.LEFT
	tail.out_dir = Direction.RIGHT
	next_move = Direction.RIGHT
	update_sprites()


func direction_to_vector(dir: Direction) -> Vector2i:
	match dir:
		Direction.UP:
			return Vector2i(0, -1)
		Direction.DOWN:
			return Vector2i(0, 1)
		Direction.LEFT:
			return Vector2i(-1, 0)
		Direction.RIGHT:
			return Vector2i(1, 0)
		_:
			return Vector2i.ZERO


func direction_opposite(dir: Direction) -> Direction:
	match dir:
		Direction.UP:
			return Direction.DOWN
		Direction.DOWN:
			return Direction.UP
		Direction.LEFT:
			return Direction.RIGHT
		Direction.RIGHT:
			return Direction.LEFT
	return Direction.UP


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('move_up') and head.out_dir != Direction.DOWN:
		next_move = Direction.UP
	elif event.is_action_pressed('move_down') and head.out_dir != Direction.UP:
		next_move = Direction.DOWN
	elif event.is_action_pressed('move_left') and head.out_dir != Direction.RIGHT:
		next_move = Direction.LEFT
	elif event.is_action_pressed('move_right') and head.out_dir != Direction.LEFT:
		next_move = Direction.RIGHT
	

func move() -> void:
	# Do nothing if we're dead
	if is_dead:
		return

	if ai_controlled and not move_sequence.is_empty():
		next_move = move_sequence.pop_front()

	# Save some of the head's data before moving
	var old_head_pos = head.pos
	var old_head_in = head.in_dir

	# Move head
	head.in_dir = direction_opposite(next_move)
	head.out_dir = next_move
	head.pos += direction_to_vector(next_move)

	if (head.pos == board.apple_grid_pos or Input.is_action_pressed('expand')) and board.apple != null:
		# Extend and then don't move anything else
		# Make a new body segment
		var new_seg: Segment = make_new_segment()
		new_seg.pos = old_head_pos
		new_seg.in_dir = old_head_in
		new_seg.out_dir = direction_opposite(head.in_dir)
		body_segments.push_front(new_seg)
		length += 1
		board.place_apple()
	else:
		# Move everything else (only the last segment of the body and the tail actually move)
		var no_segments = body_segments.is_empty()
		var last: Segment = head if no_segments else body_segments.pop_back()
		# Move tail
		tail.pos += direction_to_vector(tail.out_dir)
		tail.in_dir = direction_opposite(last.out_dir)
		tail.out_dir = last.out_dir
		# Move the last segment (if it's not the head)
		if not no_segments:
			last.pos = old_head_pos
			last.in_dir = old_head_in
			last.out_dir = direction_opposite(head.in_dir)
			body_segments.push_front(last)
	
	update_sprites()

	# Did we just lose?
	if not valid_position(head.pos):
		game_over()


func valid_position(pos: Vector2i) -> bool:
	var x_invalid = pos.x < 0 or pos.x >= board.grid_size.x
	var y_invalid = pos.y < 0 or pos.y >= board.grid_size.y
	if x_invalid or y_invalid:
		return false
	if pos == tail.pos:
		return false
	for seg in body_segments:
		if pos == seg.pos:
			return false
	return true


func make_new_segment() -> Segment:
	var seg: Segment = Segment.new()
	seg.spr = Sprite2D.new()
	seg.spr.centered = false
	add_child(seg.spr)
	return seg


func update_sprites() -> void:
	head.spr.texture = head_texture_mapping[head.out_dir]
	head.spr.position = head.pos * texture_size
	tail.spr.texture = tail_texture_mapping[tail.out_dir]
	tail.spr.position = tail.pos * texture_size
	for seg in body_segments:
		seg.spr.texture = body_texture_mapping(seg.in_dir, seg.out_dir)
		seg.spr.position = seg.pos * texture_size


func body_texture_mapping(in_dir: Direction, out_dir: Direction) -> Texture2D:
	if in_dir == direction_opposite(out_dir):
		if in_dir in [Direction.UP, Direction.DOWN]:
			return body_vertical
		else:
			return body_horizontal
	else:
		# The way these are written will return true no matter the order of in_dir and out_dir
		# in terms of up/left, left/up, etc.
		# This works because we already accounted for the case of opposite directions in the
		# last if statement.
		if in_dir in [Direction.UP, Direction.LEFT] and out_dir in [Direction.UP, Direction.LEFT]:
			return body_ul
		elif in_dir in [Direction.UP, Direction.RIGHT] and out_dir in [Direction.UP, Direction.RIGHT]:
			return body_ur
		elif in_dir in [Direction.DOWN, Direction.LEFT] and out_dir in [Direction.DOWN, Direction.LEFT]:
			return body_dl
		elif in_dir in [Direction.DOWN, Direction.RIGHT] and out_dir in [Direction.DOWN, Direction.RIGHT]:
			return body_dr
		
		assert(false, 'Invalid direction combination for body segment')
		return null


func game_over():
	is_dead = true
	dead.emit()