extends Node2D

var default = load("res://assets/sprites/CrossHair/Crosshair.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(default, Input.CURSOR_ARROW, Vector2(16,16))
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
