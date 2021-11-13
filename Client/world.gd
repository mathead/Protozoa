extends Node2D

var food_scene = preload("res://food.tscn")
const world_size = 8000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$bg.texture_offset.x += delta * 20
	$bg.texture_offset.y += delta * 10
	if randf() < 0.001:
		var food = food_scene.instance()
		food.position = Vector2(rand_range(100, world_size - 100), rand_range(100, world_size - 100))
		add_child(food)
