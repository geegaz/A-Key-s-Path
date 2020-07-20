extends Camera2D

var shaking: bool
var shake_amount: float
var shake_time: float
var elapsed_time: float

func _ready():
	randomize()
	shaking = false

func _process(delta):
	if shaking:
		_shake_process(delta)

func set_limits(rect):
	var map_limits = rect.get_global_rect()
	self.limit_left = map_limits.position.x
	self.limit_right = map_limits.end.x
	self.limit_top = map_limits.position.y
	self.limit_bottom = map_limits.end.y

func shake(amount: float, time: float):
	shake_amount = amount
	shake_time = time
	elapsed_time = 0.0
	shaking = true

func _shake_process(delta):
	if elapsed_time > shake_time:
		shaking = false
		offset = Vector2.ZERO
	else:
		offset =  Vector2(randf(), randf()) * shake_amount
		elapsed_time += delta

