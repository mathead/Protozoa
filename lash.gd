extends Node2D

var parent: RigidBody2D
export var active = true
export var image  = false
export var power = 100
var charge = 0
var max_charge = 0.5
var cur_time = 0
var cur_wave_size = 0
var impulse_anim = 0
var last_pos = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if not image:
		parent = get_parent()
	$Line.clear_points()
	for i in range(30):
		$Line.add_point(Vector2(0, i*3))
	save_last_pos()
		
func _process(delta):
	var target_wave_size = 4
	if active:
		target_wave_size = 7
		if impulse_anim > 0:
			target_wave_size = 25
			impulse_anim -= delta
			
	
	cur_wave_size = lerp(cur_wave_size, target_wave_size, min(1, delta/0.2))

	var offset = sin(cur_time / 5) * cur_wave_size / 2
	for i in range(5):
		$Line.set_point_position(i, Vector2(offset * sqrt(i), i*3))
	cur_time += delta * (cur_wave_size * cur_wave_size + randf() / 10)
	#if not active:
		#cur_time = 0

	var prev_point_pos = $Line.get_point_position(4)
	for i in range(5, 30):
		var pos = $Line.get_point_position(i)
		#pos.x = lerp(pos.x, prev_point_pos.x, min(1, delta/0.03))
		pos.y = i*3
		pos = lerp(global_transform.xform_inv(last_pos[i-1]), pos, min(1, delta/0.07))
		$Line.set_point_position(i, pos)
		prev_point_pos = pos
	save_last_pos()

func save_last_pos():
	last_pos = []
	for i in range(30):
		last_pos.append(global_transform.xform($Line.get_point_position(i)))

func _physics_process(delta):
	if active and not image:
		charge += delta
		if charge >= max_charge:
			parent.apply_impulse(global_position - parent.global_position, Vector2.UP.rotated(global_rotation) * power)
			impulse_anim = 0.1
			charge -= max_charge
