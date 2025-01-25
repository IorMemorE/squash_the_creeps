extends CharacterBody3D
@export
var speed := 14
@export 
var fall_acceleration := 75
@export
var jump_impulse := 20
@export
var bounce_impulse := 16
var target_velocity := Vector3.ZERO

signal hit

func die():
	hit.emit()
	queue_free()

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
		$AnimationPlayer.speed_scale = 4
	else: 
		$AnimationPlayer.speed_scale = 1

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not self.is_on_floor(): 
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	elif Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)

		if collision.get_collider() == null:
			continue
		if not collision.get_collider().is_in_group("mobs"):
			continue
		
		var mob = collision.get_collider()
		if Vector3.UP.dot(collision.get_normal()) > 0.1:
			mob.squash()
			target_velocity.y = bounce_impulse
			break
	velocity = target_velocity
	self.move_and_slide()
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func _on_mob_detector_body_entered(body: Node3D) -> void:
	if body as Mob != null:
		self.die()