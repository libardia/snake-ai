class_name Board
extends Node2D


@export var grid_size: Vector2i = Vector2(27, 15)

@onready var camera: Camera2D = $'../Camera'
@onready var border: Line2D = $Border
@onready var grid_origin_node: Node2D = $GridOrigin
@onready var snake: Snake = $GridOrigin/Snake
@onready var apple: Sprite2D = $GridOrigin/Apple

var board_origin: Vector2
var grid_origin: Vector2
var board_size: Vector2


func _ready() -> void:
	# Get the total size of the whole grid and border
	board_size = (Vector2.ONE * border.width * 2) + (Vector2(grid_size) * snake.texture_size)
	
	# Zoom out the camera if necessary
	var vp_size = get_viewport_rect().size
	var size_ratio = vp_size / board_size
	var cam_zoom = min(size_ratio.x, size_ratio.y)
	if cam_zoom < 1:
		camera.zoom = Vector2.ONE * cam_zoom
	
	# Calculate where the grid should start
	board_origin = (vp_size - board_size) / 2
	position = board_origin
	grid_origin = Vector2.ONE * border.width
	grid_origin_node.position = grid_origin

	# Set border points
	var half_width = border.width / 2
	var half_width_v = Vector2.ONE * half_width
	border.points = [
		half_width_v,
		Vector2(board_size.x - half_width, half_width),
		board_size - (Vector2.ONE * half_width_v),
		Vector2(half_width, board_size.y - half_width)
	]

	place_apple()


func place_apple() -> void:
	var apple_pos: Vector2i = Vector2i.ZERO
	var generate = true
	while generate:
		print('Attempting apple spawn')
		generate = false
		apple_pos.x = randi() % grid_size.x
		apple_pos.y = randi() % grid_size.y
		# Generate again if the randomly chosen position is on the snake
		if apple_pos == snake.head.pos or apple_pos == snake.tail.pos:
			generate = true
			continue
		for seg in snake.body_segments:
			if apple_pos == seg.pos:
				generate = true
				continue
		
	apple.position = Vector2(apple_pos) * snake.texture_size
