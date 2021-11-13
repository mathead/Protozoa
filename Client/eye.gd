tool
extends Node2D

var active = true

func _draw():
	draw_circle(Vector2(0, 0), 15, Color("d5c916"))
	if active:
		draw_circle(Vector2(0, 0), 5, Color.white)
	else:
		draw_circle(Vector2(0, 0), 5, Color.black)

func _physics_process(delta):
	#print($Area2D.get_overlapping_bodies(), not $Area2D.get_overlapping_bodies().empty())
	active = not $Area2D.get_overlapping_bodies().empty()
	update()
