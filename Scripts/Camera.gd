extends Camera2D

var shaking: bool
var shake_amount: float
var shake_time: float
var elapsed_time: float

var original_pos: Vector2

func _ready():
	randomize()
	shaking = false
	original_pos = offset

func _process(delta):
	if shaking:
		_shake_process(delta)

func shake(amount: float, time: float):
	shake_amount = amount
	shake_time = time
	elapsed_time = 0.0
	shaking = true

func _shake_process(delta):
	if elapsed_time > shake_time:
		shaking = false
		offset = original_pos
	else:
		offset =  Vector2(randf(), randf()) * shake_amount
		elapsed_time += delta

