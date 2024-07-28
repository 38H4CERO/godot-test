extends Node2D

@onready var timer = $Timer
@onready var sprite = $AnimatedSprite2D
var recharging : bool = false
var ammo : int = 1
var max_ammo : int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	# Speed scale debe de subir y wait time bajar
	timer.wait_time = 1.05
	sprite.speed_scale = 1
	sprite.hide()

func recharge():
	recharging = true
	sprite.show()
	sprite.play()
	timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	sprite.hide()
	ammo = max_ammo
	recharging = false
