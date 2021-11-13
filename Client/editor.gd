extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var prot_pos
var comp: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	prot_pos = $Protozoa.position
	for button in $GridContainer.get_children():
		button.connect("button_down", self, "button_down", [button])
		button.connect("button_up", self, "button_up", [button])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Protozoa.position = prot_pos
	$Protozoa.rotation = 0
	
	if comp:
		comp.global_position = get_viewport().get_mouse_position()
		comp.look_at($Protozoa.global_position)
		comp.rotate(3*PI/2)
	
func button_down(button):
	comp = button.get_node("comp").duplicate()
	add_child(comp)
	
func button_up(button):
	if not Geometry.is_point_in_polygon($Protozoa.global_transform.xform_inv(get_viewport().get_mouse_position()), $Protozoa.get_node("Polygon2D").polygon):
		comp.queue_free()
	else:
		var pos = comp.global_position
		remove_child(comp)
		$Protozoa.add_child(comp)
		comp.global_position = pos
		comp.attach()
	comp = null
