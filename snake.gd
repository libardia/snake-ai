extends Node2D


@export var board: Board

@onready var move_timer: Timer = $MoveTimer
@onready var snake_tiles: TileMapLayer = $SnakeTiles

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


func _ready() -> void:
	snake_tiles.set_cell(Vector2i(0, 0), TILESET_ID, HEAD_UP)


func _on_move_timer_timeout() -> void:
	pass
