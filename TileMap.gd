extends TileMap
@onready var tile_map = %TileMap


func _process(delta):
	if Input.is_action_just_pressed("switch"):
		tile_map.scale.y = (tile_map.scale.y) *-1
