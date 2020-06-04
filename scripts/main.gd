extends Node2D


export (PackedScene) var Mob
var score

func _ready():
	randomize()
	$Player.connect("hit", self, "game_over")
	$StartTimer.connect("timeout", self, "_on_StartTimer_timeout")
	$MobTimer.connect("timeout", self, "_on_MobTimer_timeout")
	$ScoreTimer.connect("timeout", self, "_on_ScoreTimer_timeout")
	$HUD.connect("start_game", self, "new_game")
	

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	$Player.disable()
	$Music.stop()
	$DeathSound.play()
	
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$Player.enable()
	
	
func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	
	
func _on_MobTimer_timeout():
	# choose a random location on Path2D
	$MobPath/MobSpawnLocation.offset = randi()
	
	# create a mob instance and add it to the scene
	var mob = Mob.instance()
	add_child(mob)
	
	# set mob's direction perpendicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	
	# set the mob position to a random location
	mob.position = $MobPath/MobSpawnLocation.position
	
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# set velocity (speed + direction)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
	

