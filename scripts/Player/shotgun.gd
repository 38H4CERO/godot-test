extends Node2D
var mouse_pos : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func shot():
	$AnimatedSprite2D.play("shot")
	$AudioStreamPlayer2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
