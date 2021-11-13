extends Control

var widths = [50, 70, 100, 80, 70, 30]
var protozoa

func _ready():
	modulate.a = 0.1

func init():
	widths = protozoa.widths
	for c in $VBoxContainer.get_children():
		$VBoxContainer.remove_child(c)
		
	for i in range(len(widths)):
		var w = widths[i]
		var slider = HSlider.new()
		slider.max_value = 200
		slider.value = w
		slider.rect_min_size.y = protozoa.SEGMENT_HEIGHT
		slider.connect("mouse_entered", self, "_on_mouse_entered")
		slider.connect("mouse_exited", self, "_on_mouse_exited")
		slider.connect("value_changed", self, "slider_changed", [i])
		$VBoxContainer.add_child(slider)
		
	update()

func update():
	$VBoxContainer.rect_position.y = -protozoa.offset + protozoa.SEGMENT_HEIGHT / 2

func slider_changed(value, index):
	widths[index] = value
	protozoa.widths = widths.duplicate()
	protozoa._ready()
	update()

func _on_mouse_entered():
	modulate.a = 1

func _on_mouse_exited():
	modulate.a = 0.1
