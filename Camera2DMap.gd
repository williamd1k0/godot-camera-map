@tool
class_name Camera2DMap
extends VisibleOnScreenNotifier2D

enum MapMode {
	OFFSET=1,
	ZOOM=2,
	ROTATION=4
}

@export var camera_target :Camera2D
@export_flags("OFFSET","ZOOM","ROTATION") var map_properties :int = 1|2|4
@export var x_offset_range :Vector2 = Vector2(-50, 50)
@export var y_offset_range :Vector2 = Vector2(-50, 50)
@export var zoom_range :Vector2 = Vector2(0.5, 2)
@export var texture_map :Texture2D :
	set (tex):
		texture_map = tex
		_setup_texture.call_deferred()
var map_cache :Image

func _ready() -> void:
	screen_entered.connect(set_map_enabled.bind(true))
	screen_exited.connect(set_map_enabled.bind(false))

func _process(delta: float) -> void:
	if map_cache == null: return
	var local_point = to_local(camera_target.global_position)
	if rect.has_point(local_point):
		var data := get_camera_map_data_for_point(local_point.floor())
		if map_properties & MapMode.ZOOM:
			camera_target.zoom = data.zoom
		if map_properties & MapMode.OFFSET:
			camera_target.offset = data.offset
		if map_properties & MapMode.ROTATION:
			camera_target.rotation = data.rotation

func _draw() -> void:
	if Engine.is_editor_hint() or get_tree().debug_navigation_hint: 
		draw_texture(texture_map, Vector2.ZERO)
		draw_rect(rect, Color.CYAN, false)

func _setup_texture() -> void:
	if texture_map != null:
		texture_map.changed.connect(_update_map_rect)
		_update_map_rect()

func _update_map_rect() -> void:
	rect = Rect2(Vector2.ZERO, texture_map.get_size())

func set_map_enabled(enabled:bool) -> void:
	if enabled:
		map_cache = texture_map.get_image()
	else:
		map_cache = null

func parse_zoom(map_data:Color) -> Vector2:
	if map_properties & MapMode.ZOOM:
		return Vector2.ONE * lerpf(zoom_range.x, zoom_range.y, map_data.b)
	return Vector2.ONE

func parse_offset(map_data:Color) -> Vector2:
	if map_properties & MapMode.OFFSET:
		return Vector2(lerpf(x_offset_range.x, x_offset_range.y, map_data.r), lerpf(y_offset_range.x, y_offset_range.y, map_data.g))
	return Vector2.ZERO

func parse_rotation(map_data:Color) -> float:
	if map_properties & MapMode.ROTATION:
		return lerpf(0, 2*PI, map_data.a)
	return 0
	
func get_camera_map_data_for_point(point:Vector2i) -> Dictionary:
	var map_data := map_cache.get_pixelv(point)
	return {
		"zoom": parse_zoom(map_data),
		"offset": parse_offset(map_data),
		"rotation": parse_rotation(map_data),
	}
