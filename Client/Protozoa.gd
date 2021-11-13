tool
extends RigidBody2D

var widths = [60, 80, 70, 60, 50]
var last_pos
var initial_pos
var offset
const SEGMENT_HEIGHT = 40

func _ready():
	var curve = Curve2D.new()
	curve.add_point(Vector2.ZERO, Vector2.ZERO, Vector2(widths[0], 0))
	var h = 0
	for i in range(len(widths)):
		var w = widths[i]
		var nextw = 0 if i == len(widths) - 1 else widths[i+1]
		h += SEGMENT_HEIGHT
		curve.add_point(Vector2(w, h), Vector2(-(nextw - w) / 4, -20), Vector2((nextw - w) / 4, 20))
	h += SEGMENT_HEIGHT
	curve.add_point(Vector2(0, h), Vector2(widths[-1]/2, 0))
	var points = curve.tessellate(3)

	var polygon = PoolVector2Array()
	for p in points:
		polygon.append(p)
	points.invert()
	for p in points:
		if p.x == 0:
			continue
		p.x = -p.x
		polygon.append(p)
		
	# move so the origin is the center of mass
	var total = 0
	points.invert()
	for p in points:
		total += p.x
	var s = 0
	for p in points:
		s += p.x
		if s >= total / 2:
			offset = p.y
			break
	for p in len(polygon):
		polygon[p].y -= offset
		
	$Polygon2D.polygon = polygon
	$Polygon2D2.polygon = polygon
#	initial_pos = polygon
#	save_last_pos()
#
#func save_last_pos():
#	last_pos = []
#	for p in $Polygon2D.polygon:
#		last_pos.append(global_transform.xform(p))

func _draw():
	_ready()

func _process(delta):
	$Lash.active = $Eye.active
	$Lash2.active = $Eye.active and $Eye2.active or $Eye3.active
	$Lash3.active = $Eye2.active or not ($Eye.active or $Eye2.active or $Eye3.active or randf() > 0.1)
	
#	if last_pos and initial_pos:
#		for i in len($Polygon2D.polygon):
#			$Polygon2D.polygon[i] = lerp(global_transform.xform_inv(last_pos[i]), initial_pos[i], 1 - (initial_pos[0].y - initial_pos[i].y) / 300.0)
#	save_last_pos()
