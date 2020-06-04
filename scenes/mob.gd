extends RigidBody2D


export var min_speed = 150
export var max_speed = 250


func _ready():
	var animation_names = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = animation_names[randi() % animation_names.size()]
	
	$VisibilityNotifier2D.connect("screen_exited", self, "_on_VisbilityNotifier2D_screen_exited")


func _on_VisbilityNotifier2D_screen_exited():
	queue_free()
