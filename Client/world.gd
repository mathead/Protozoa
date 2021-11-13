extends Node2D

var food_scene = preload("res://food.tscn")
const world_size = 8000
var editor
var camera: Camera2D
const ANIM_DURATION = 1

func _ready():
	set_process_input(true) 
	editor = $Editor.get_child(0)
	editor.protozoa = $Protozoa
	editor.visible = false
	camera = $Protozoa.get_node("Camera2D")

func _process(delta):
	$bg.texture_offset.x += delta * 20
	$bg.texture_offset.y += delta * 10
	if randf() < 0.001:
		var food = food_scene.instance()
		food.position = Vector2(rand_range(100, world_size - 100), rand_range(100, world_size - 100))
		add_child(food)

func _input(ev):
	if ev is InputEventKey and ev.pressed and not ev.echo:
		editor.visible = !editor.visible
		#camera.position.x = -300 if editor.visible else 0
		$Tween.seek(10)
		$Tween.reset_all()
		$Tween.interpolate_property(camera, "position:x", camera.position.x, -200 if editor.visible else 0, ANIM_DURATION, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$Tween.interpolate_property(camera, "zoom", camera.zoom, Vector2(0.5, 0.5) if editor.visible else Vector2(1, 1), ANIM_DURATION, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		if editor.visible:
			camera.rotating = true
			$Tween.interpolate_property(camera, "rotation", -$Protozoa.rotation, 0, ANIM_DURATION, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		else:
			$Tween.interpolate_property(camera, "global_rotation", camera.global_rotation, 0, ANIM_DURATION, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			$Tween.interpolate_callback(camera, 1, "set_rotating", false)
		$Tween.start()
