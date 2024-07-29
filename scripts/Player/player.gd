extends CharacterBody2D


const SPEED : float = 300.0
const JUMP_VELOCITY : float = -400.0
const FRICTION  : int = 1000
var shot_knockback_power: int = 400

var shoted : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var mouser_pos : Vector2

@onready var sprite = $AnimatedSprite2D
@onready var shotgun = $Shotgun
@onready var recharge_bar = $RechargeSkillCheck
@onready var shotgun_sprite = shotgun.get_node("AnimatedSprite2D")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if !is_on_floor() and !shoted:
		sprite.play("jump")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction != 0 and is_on_floor():
		sprite.play("run")
		
	if direction > 0 and !shoted:
		sprite.flip_h = false
		if velocity.x < SPEED :
			velocity.x = direction * SPEED
		else:
			velocity.x -= FRICTION * delta
		
	elif direction < 0 and !shoted:
		sprite.flip_h = true
		if velocity.x > -SPEED:
			velocity.x = direction * SPEED
		else:
			velocity.x += FRICTION * delta
			
	else:
		if !shoted and is_on_floor():
			sprite.play("idle")
		if velocity.x > SPEED:
			velocity.x -= FRICTION * delta
		elif velocity.x < -SPEED:
			velocity.x += FRICTION * delta
		elif !shoted:
			velocity.x = 0
	
	move_and_slide()

	# Negativo = arriba
	# 0 = Derecha
	# 3 = Izquirda
	# vector2.x = cos(angle)
	# vector2.y = sin(angle)
func shot_shotgun():
	if recharge_bar.ammo > 0:
		shoted = true
		sprite.play("shoted")
		recharge_bar.ammo -= 1
		if recharge_bar.ammo == 0:
			recharge_bar.recharge()
		shotgun.shot()
		var angle = global_position.angle_to_point(get_global_mouse_position())
		# TODO hacer que haya menos knockback si acabas de saltar
		if velocity.y < -300:
			velocity.y = -200
		if velocity.y > -100:
			velocity.y = 30 # Pequeña desventaja si saltas cayendo
		velocity.y += sin(angle) * shot_knockback_power * -1
			 
		velocity.x += cos(angle) * shot_knockback_power * -1
	else: 
		# TODO: animacion de sin balas
		pass

func recharge_shotgun():
	recharge_bar.recharge()
	# TODO
	
func _input(event):
	if Input.is_action_just_pressed("primary_action"):
		shot_shotgun()
	if Input.is_action_just_pressed("recharge") and !recharge_bar.recharging:
		recharge_shotgun()

func _process(delta):
	mouser_pos = get_viewport().get_mouse_position()
	# Flip player and shotgun
	if  mouser_pos.x < 300:
		shotgun_sprite.flip_v = true
		shotgun.position.x = -20
	elif mouser_pos.x > 340:
		shotgun_sprite.flip_v = false
		shotgun.position.x = 20
		
	if is_on_floor():
		shoted = false

