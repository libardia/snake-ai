class_name Snake
extends Node2D


enum Direction {UP, DOWN, LEFT, RIGHT}

class Segment:
	func _init(sprite: Sprite2D, position: Vector2i, in_direction: Direction, out_direction: Direction) -> void:
		spr = sprite
		pos = position
		in_dir = in_direction
		out_dir = out_direction
	var spr: Sprite2D
	var pos: Vector2i
	var in_dir: Direction
	var out_dir: Direction


@export_group('Dependencies')
@export var board: Board

@export_group('Textures')
@export_subgroup('Head')
@export var head_up: Texture2D
@export var head_down: Texture2D
@export var head_left: Texture2D
@export var head_right: Texture2D
@onready var head_textures: Array[Texture2D] = [head_up, head_down, head_left, head_right]

@export_subgroup('Tail')
@export var tail_up: Texture2D
@export var tail_down: Texture2D
@export var tail_left: Texture2D
@export var tail_right: Texture2D
@onready var tail_textures: Array[Texture2D] = [tail_up, tail_down, tail_left, tail_right]

@export_subgroup('Body Straight')
@export var body_horizontal: Texture2D
@export var body_vertical: Texture2D
@export_subgroup('Body Bent')
@export var body_ul: Texture2D
@export var body_ur: Texture2D
@export var body_dl: Texture2D
@export var body_dr: Texture2D

@onready var head_spr: Sprite2D = $Head
@onready var tail_spr: Sprite2D = $Tail
@onready var texture_size: int = head_up.get_size().x as int

var curr_direction: Direction = Direction.RIGHT
var length: int = 2
var head: Segment
var tail: Segment
var body_segments: Array[Segment] = []


func _ready() -> void:
	head = Segment.new(head_spr, Vector2i(1, 0), Direction.RIGHT, Direction.RIGHT)
	tail = Segment.new(tail_spr, Vector2i(0, 0), Direction.RIGHT, Direction.RIGHT)
	update()


func directions_to_body_texture(in_dir: Direction, out_dir: Direction) -> Texture2D:
	if Util.all_in([in_dir, out_dir], [Direction.UP, Direction.DOWN]):
		return body_vertical
	if Util.all_in([in_dir, out_dir], [Direction.LEFT, Direction.RIGHT]):
		return body_horizontal
	
	# if Util.all_in([in_dir, out_dir], [Direction.UP, Direction.LEFT]):
	# 	return body_ul
	# if Util.all_in([in_dir, out_dir], []):
	# 	return body_ur
	# if Util.all_in([in_dir, out_dir], []):
	# 	return body_dl
	# if Util.all_in([in_dir, out_dir], []):
	# 	return body_dr

	return null


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


func move() -> void:
	# Move head, then check if we've hit the apple
	match head.out_dir:
		Direction.UP:
			head.pos += Vector2i(0, -1)
		Direction.DOWN:
			head.pos += Vector2i(0, 1)
		Direction.LEFT:
			head.pos += Vector2i(-1, 0)
		Direction.RIGHT:
			head.pos += Vector2i(1, 0)

	if head.pos == board.apple_grid_pos:
		# Extend and then don't move anything else
		board.place_apple()
	else:
		# Move everything else (only the last segment of the body and the tail actually move)
		var last: Segment = body_segments.pop_back() if body_segments.size() > 0 else head
		
	update()


func update() -> void:
	head.spr.texture = head_textures[head.out_dir]
	head.spr.position = head.pos * texture_size
	tail.spr.texture = tail_textures[tail.out_dir]
	tail.spr.position = tail.pos * texture_size
	for seg in body_segments:
		seg.spr.texture = directions_to_body_texture(seg.in_dir, seg.out_dir)
		seg.spr.position = seg.pos * texture_size
