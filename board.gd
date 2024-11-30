extends Node2D


@export
var grid_size: Vector2i = Vector2(28, 16)

@onready
var border: Line2D = $Border
@onready
var camera: Camera2D = %Camera

var grid_origin: Vector2
var board_size: Vector2


func _ready() -> void:
	# Get the total size of the whole grid and border
	var texsize = 40
	board_size = (Vector2.ONE * border.width) + (Vector2(grid_size) * texsize)
	
	# Zoom out the camera if necessary
	var vp_size = get_viewport_rect().size
	var size_ratio = vp_size / board_size
	var cam_zoom = min(size_ratio.x, size_ratio.y)
	if cam_zoom < 1:
		camera.zoom = Vector2.ONE * cam_zoom
	
	# Calculate where the grid should start
	grid_origin = (vp_size - board_size) / 2

	# Border points
	var half_width = border.width / 2
	var half_width_v = Vector2.ONE * half_width
	border.points = [
		grid_origin + half_width_v,
		Vector2(
			grid_origin.x + board_size.x - half_width,
			grid_origin.y + half_width
		),
		grid_origin + board_size - half_width_v,
		Vector2(
			grid_origin.x + half_width,
			grid_origin.y + board_size.y - half_width
		)
	]


func _process(delta: float) -> void:
	pass