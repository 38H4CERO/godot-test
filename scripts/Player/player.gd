extends CharacterBody2D


const SPEED : int = 300.0
const JUMP_VELOCITY : int= -400.0
const FRICTION  : int = 8
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

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction > 0 and !shoted:
		if velocity.x < SPEED :
			velocity.x = direction * SPEED
		else:
			velocity.x -= FRICTION
		
	elif direction < 0 and !shoted:
		if velocity.x > -SPEED:
			velocity.x = direction * SPEED
		else:
			velocity.x += FRICTION
			
	else:
		if velocity.x > SPEED:
			velocity.x -= FRICTION
		elif velocity.x < -SPEED:
			velocity.x += FRICTION
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
		recharge_bar.ammo -= 1
		if recharge_bar.ammo == 0:
			recharge_bar.recharge()
		shoted = true
		shotgun.shot()
		var angle = global_position.angle_to_point(get_global_mouse_position())
		if velocity.y > 0:
			velocity.y = 30 # Pequeña desventaja si saltas cayendo
		velocity.y += sin(angle) * shot_knockback_power * -1
			 
		velocity.x += cos(angle) * shot_knockback_power * -1
	else: 
		# TODO animacion de sin balas
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
		sprite.flip_h = true
		shotgun_sprite.flip_v = true
		shotgun.position.x = -20
	elif mouser_pos.x > 340:
		sprite.flip_h = false 
		shotgun_sprite.flip_v = false
		shotgun.position.x = 20
		
	if is_on_floor():
		shoted = false

