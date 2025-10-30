extends Node2D

@export var Coin: PackedScene
@export var Powerup: PackedScene
@export var Playtime = 30

var level
var score
var time_left
var screensize
var playing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		$PowerupTimer.wait_time = randi_range(5, 10)
		$PowerupTimer.start()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = Playtime
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
func spawn_coins():
	$LevelSound.play()
	for i in range(4 + level):
		var coin = Coin.instantiate()
		$CoinContainer.add_child(coin)
		coin.screensize = screensize
		coin.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))


func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func _on_player_pickup(type) -> void:
	match type:
		"coin":
			score += 1
			$CoinSound.play()
			$HUD.update_score(score)
		"powerup":
			time_left += 5
			$PowerupSound.play()
			$HUD.update_timer(time_left)


func _on_player_hurt() -> void:
	game_over()
	
func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	$HUD.show_game_over()
	$Player.die()


func _on_powerup_timer_timeout() -> void:
	var powerup = Powerup.instantiate()
	add_child(powerup)
	powerup.screensize = screensize
	powerup.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
