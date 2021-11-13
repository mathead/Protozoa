extends MarginContainer

var comp: Node2D
var protozoa: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in $GridContainer.get_children():
		button.connect("button_down", self, "button_down", [button])
		button.connect("button_up", self, "button_up", [button])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if comp:
		comp.global_position = get_viewport().get_mouse_position()
		comp.look_at(protozoa.get_global_transform_with_canvas().origin)
		comp.rotate(3*PI/2)
	
func button_down(button):
	comp = button.get_node("comp").duplicate()
	add_child(comp)
	comp.scale.x = 1 / protozoa.get_node("Camera2D").zoom.x
	comp.scale.y = 1 / protozoa.get_node("Camera2D").zoom.y
	
func button_up(button):
	if not Geometry.is_point_in_polygon(protozoa.get_global_transform_with_canvas().affine_inverse().xform(get_viewport().get_mouse_position()), protozoa.get_node("Polygon2D").polygon):
		comp.queue_free()
	else:
		var pos = comp.global_position
		remove_child(comp)
		protozoa.add_child(comp)
		comp.position = protozoa.get_global_transform_with_canvas().affine_inverse().xform(pos)
		comp.scale = Vector2.ONE
		comp.attach()
	comp = null
