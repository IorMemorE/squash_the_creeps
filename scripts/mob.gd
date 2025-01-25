class_name Mob
extends CharacterBody3D
signal squashed
@export
var min_speed := 10
@export
var max_speed := 18

func _on_visible_notifier_screen_exited() -> void:
	queue_free()
	
func _physics_process(_delta: float) -> void:
	self.move_and_slide()

func initialize(start_position, player_position):
	self.look_at_from_position(
		start_position, player_position, Vector3.UP
	)
	self.rotate_y(randf_range(-PI / 4, PI / 4))
	var random_speed := randi_range(min_speed,max_speed)
	self.velocity = Vector3.FORWARD * random_speed
	self.velocity = self.velocity.rotated(Vector3.UP,self.rotation.y)
	self.position.y += 0.5
	$AnimationPlayer.speed_scale = float(random_speed) / min_speed
	
func squash():
	squashed.emit()
	queue_free()
