extends TileMap
@onready var tile_map = $"."
@onready var heaven_paralax = %"heaven-paralax"
@onready var hell_paralax = %"hell-paralax"
@export var realm = "heaven"
@onready var trap = %trap



func _process(delta):
	if Input.is_action_just_pressed("switch"):
		tile_map.scale.y = (tile_map.scale.y) * -1
		heaven_paralax.scale.y *= -1
		hell_paralax.scale.y *= -1
		trap.scale.y *= -1
		if heaven_paralax.offset.y == 1050 :
			heaven_paralax.offset.y = 0
		else:
			heaven_paralax.offset.y = 1050

		if hell_paralax.offset.y == 1050 :
			hell_paralax.offset.y = 0
		else:
			hell_paralax.offset.y = 1050

		if realm == "heaven":
			realm = "hell"
		else:
			realm = "heaven"

#coucou
