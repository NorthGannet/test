extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var SPEED = 300.0
var lastDirection = Vector2.ZERO
var lockAction = false

func _physics_process(delta: float) -> void:
	_handle_input()
	move_and_slide()
	
func _handle_input() -> void:
	var inDirection = Input.get_vector("char_left","char_right","char_up","char_down")
	velocity = inDirection * SPEED
	
	if inDirection != lastDirection:
		var action = "idle_"
		if inDirection != Vector2.ZERO:
			lastDirection = inDirection		
			action = "run_"
		_change_animation(inDirection, action)
		
	if Input.is_action_just_pressed("char_attack"):
		_change_animation(inDirection, "attack_", true)
	
func _change_animation(inDirection: Vector2, action: String = "idle_", locking: bool = false) -> void:
	if lockAction:
		return
	lockAction = locking
		
	#Setting the animation
	if lastDirection.x > 0:
		sprite.flip_h = false
		sprite.play(action+"right")
	elif lastDirection.x < 0:
		sprite.flip_h = true
		sprite.play(action+"right")
	elif lastDirection.y > 0:
		sprite.play(action+"down")
	else:
		sprite.play(action+"up")
		
func _on_animated_sprite_2d_animation_finished() -> void:
	lockAction = false
	
	var inDirection = Input.get_vector("char_left","char_right","char_up","char_down")
	var action = "idle_"
	var lock = false
	
	if inDirection != Vector2.ZERO:
		lastDirection = inDirection		
		action = "run_"
	
	if Input.is_action_just_pressed("char_attack"):
		action = "attack_"
		lock = true
	
	_change_animation(inDirection, action, lock)
