extends Node
@export
var mob_scene: PackedScene

func _on_mob_timer_timeout() -> void:
	var mob:Mob = mob_scene.instantiate()
	var mob_spawn_location:PathFollow3D = $"SpawnPath/SpawnLocation"
	assert(mob_spawn_location != null)
	mob_spawn_location.progress_ratio = randf()
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	self.add_child(mob)
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed)

func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()
	

func _ready() -> void:
	$UserInterface/Retry.hide()
	
func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept") 
		and $UserInterface/Retry.visible
	):
		get_tree().reload_current_scene()
