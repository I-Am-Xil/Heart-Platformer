extends CharacterBody2D


@export var movement_data : PlayerMovementData

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var wall_jump_timer = $WallJumpTimer

@onready var starting_position = global_position

var air_jump = false
var just_wall_jumped = false
var was_on_wall = false


func _physics_process(delta):
	var input_axis = Input.get_axis("move_left", "move_right")
	
	apply_gravity(delta)
	just_wall_jumped = handle_wall_jump()
	handle_jump()
	handle_movement(input_axis, delta)
	handle_coyote_jump_timer()
	update_animation(input_axis)


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta


func handle_wall_jump():
	was_on_wall = is_on_wall_only()
	if not was_on_wall and not is_wall_jump_timer_active(): return false
	if was_on_wall:
		wall_jump_timer.start()
	
	var wall_normal = get_wall_normal()
	
	if Input.is_action_just_pressed("jump"):
		if wall_normal.x != 0:
			var wall_jump_vector = -(wall_normal + Vector2.UP).normalized() * movement_data.jump_velocity * 0.8
			velocity = wall_jump_vector
			return true


func handle_jump():
	if is_on_floor():
		air_jump = true
	
	if is_on_floor() or is_coyote_jump_timer_active():
		if Input.is_action_pressed("jump"):
			velocity.y = movement_data.jump_velocity
			# If coyote_jump_timer.wait_time > 0.1, uncomment next line. This stops the coyote jump bug it's overkill otherwise
			#coyote_jump_timer.stop()
	else:
		if Input.is_action_just_released("jump") and velocity.y < movement_data.short_jump:
			velocity.y = movement_data.short_jump
		
		if Input.is_action_just_pressed("jump") and air_jump and just_wall_jumped == false:
			velocity.y = movement_data.short_jump
			air_jump = false


func handle_movement(input_axis, delta):
	if input_axis != 0:
		increase_velocity_x(input_axis, delta)
	else:
		reduce_velocity_x(delta)


func increase_velocity_x(input_axis, delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)


func reduce_velocity_x(delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)


func update_animation(input_axis):
	if input_axis:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if is_on_floor() == false:
		animated_sprite_2d.play("jump")


func is_coyote_jump_timer_active():
	return coyote_jump_timer.time_left > 0


func is_wall_jump_timer_active():
	return wall_jump_timer.time_left > 0


func handle_coyote_jump_timer():
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()


func _on_hazard_detector_area_entered(_area):
	global_position = starting_position
