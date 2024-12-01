class_name Snake
extends Node2D


enum Direction { UP, DOWN, LEFT, RIGHT }

class Segment:
	var pos: Vector2i
	var dir: Direction


const TILESET_ID: int = 5

const HEAD_UP = Vector2i(0, 0)
const HEAD_DOWN = Vector2i(1, 0)
const HEAD_LEFT = Vector2i(2, 0)
const HEAD_RIGHT = Vector2i(3, 0)

const TAIL_UP = Vector2i(0, 1)
const TAIL_DOWN = Vector2i(1, 1)
const TAIL_LEFT = Vector2i(2, 1)
const TAIL_RIGHT = Vector2i(3, 1)

const BODY_HORZ = Vector2i(0, 2)
const BODY_VERT = Vector2i(1, 2)

const BODY_TL = Vector2i(2, 2)
const BODY_TR = Vector2i(3, 2)
const BODY_BL = Vector2i(0, 3)
const BODY_BR = Vector2i(1, 3)

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
@export var body_tl: Texture2D
@export var body_tr: Texture2D
@export var body_bl: Texture2D
@export var body_br: Texture2D

@onready var move_timer: Timer = $MoveTimer
@onready var head: Sprite2D = $Head
@onready var tail: Sprite2D = $Tail

var curr_direction: Direction = Direction.RIGHT
var length: int = 0
var segments: Array[Segment] = []

func _ready() -> void:
	pass


func _on_move_timer_timeout() -> void:
	pass
