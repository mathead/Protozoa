extends Node2D

var food_scene = preload("res://food.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$bg.texture_offset.x += delta * 20
	$bg.texture_offset.y += delta * 10
	if randf() < 0.001:
		var food = food_scene.instance()
		food.position = Vector2(rand_range(100, get_viewport().size.x - 100), rand_range(100, get_viewport().size.y - 100))
		add_child(food)
