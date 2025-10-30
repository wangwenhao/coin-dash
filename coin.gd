extends Area2D

var sizescreen

func pickup():
	#monitoring = false
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "scale", $AnimatedSprite2D.scale * 3, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1, 0), 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
