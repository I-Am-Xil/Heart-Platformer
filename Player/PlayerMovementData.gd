class_name PlayerMovementData
extends Resource

@export var speed = 100.0
@export var acceleration = 1000.0
@export var air_acceleration = 400.0
@export var friction = 800.0
@export var air_resistance = 200.0
@export var jump_velocity = -350.0
@export var gravity_scale = 1.0

# Derived constants
var short_jump = jump_velocity / 2.0
