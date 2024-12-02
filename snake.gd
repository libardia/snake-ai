class_name Snake
extends Node2D


enum Direction {UP, DOWN, LEFT, RIGHT, UP_LEFT, UP_RGIHT, DOWN_LEFT, DOWN_RGIHT}

class Segment:
	var spr: Sprite2D
	var pos: Vector2i
	var dir: Direction


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
@export var body_tl: Texture2D
@export var body_tr: Texture2D
@export var body_bl: Texture2D
@export var body_br: Texture2D
@onready var body_textures: Array[Texture2D] = [body_vertical, body_vertical, body_horizontal, body_horizontal, body_tl, body_tr, body_bl, body_br]

@onready var move_timer: Timer = $MoveTimer
@onready var head_spr: Sprite2D = $Head
@onready var tail_spr: Sprite2D = $Tail
@onready var texture_size: int = head_up.get_size().x as int

var curr_direction: Direction = Direction.RIGHT
var length: int = 2
var head: Segment = Segment.new()
var tail: Segment = Segment.new()
var body_segments: Array[Segment] = []


func _ready() -> void:
	move_timer.timeout.connect(move)
	head.spr = head_spr
	head.dir = Direction.RIGHT
	head.pos = Vector2i(1, 0)
	tail.spr = tail_spr
	tail.dir = Direction.LEFT
	tail.pos = Vector2i(0, 0)
	update()
	

func move() -> void:
	update()


func update() -> void:
	head.spr.texture = head_textures[head.dir]
	head.spr.position = head.pos * texture_size
	tail.spr.texture = tail_textures[tail.dir]
	tail.spr.position = tail.pos * texture_size
	for seg in body_segments:
		seg.spr.texture = body_textures[seg.dir]
		seg.spr.position = seg.pos * texture_size
