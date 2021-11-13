tool
extends RigidBody2D

export var widths = [50, 70, 100, 110, 80, 70, 50, 30, 10, 0]
var last_pos
var initial_pos

func _ready():
	var last_w = 0
	var points = [Vector2.ZERO]
	var v = Vector2.RIGHT
	for w_target in widths:
		for i in range(1, 5):
			v = lerp(v, Vector2(w_target-last_w, 4*8).normalized(), i/4.0).normalized()
			points.append(points[-1] + v*8)
			points[-1].x = abs(points[-1].x)
		last_w = w_target
	
	var polygon = PoolVector2Array()
	for p in points:
		polygon.append(p)
	var bottom = points[-1].y
	polygon.append(Vector2(0, bottom))
	points.invert()
	for p in points:
		p.x = -p.x
		polygon.append(p)
		
	# move so the origin is the center of mass
	var s = 0
	var offset
	var total = 0
	for w in widths:
		total += w
	for i in range(len(widths)):
		s += widths[i]
		if s > total / 2:
			offset = (i + 1.0 + (total / 2.0 - s) / total) / len(widths) * bottom
			break
	for p in len(polygon):
		polygon[p].y -= offset
		
	$Polygon2D.polygon = polygon
	$Polygon2D2.polygon = polygon
	initial_pos = polygon
	save_last_pos()
	
func save_last_pos():
	last_pos = []
	for p in $Polygon2D.polygon:
		last_pos.append(global_transform.xform(p))
	
func _draw():
	_ready()

func _process(delta):
	$Lash.active = $Eye.active
	$Lash2.active = $Eye.active and $Eye2.active or $Eye3.active
	$Lash3.active = $Eye2.active or not ($Eye.active or $Eye2.active or $Eye3.active or randf() > 0.1)
	
	for i in len($Polygon2D.polygon):
		$Polygon2D.polygon[i] = lerp(global_transform.xform_inv(last_pos[i]), initial_pos[i], 1 - initial_pos[i].y / 200.0)
	save_last_pos()
