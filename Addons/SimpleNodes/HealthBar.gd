class_name HealthBar, "./HealthBar.svg"
extends LabelRange

signal death
signal health_changed(health)

export(float) var max_health: float setget set_max_health
export(float) var current_health: float setget set_current_health
export(bool) var always_visible: bool = false

func is_dead()->bool:
	return current_health <= 0

func is_max_health()->bool:
	return current_health >= max_health

func set_max_health(new_value: float)->void:
	max_health = new_value
	max_value = new_value
	set_current_health(current_health)

func set_current_health(new_value: float)->void:
	current_health = clamp(new_value, 0, max_health)
	value = current_health/max_health * max_value
	visible = is_visible()
	if is_dead():
		emit_signal("death")
	emit_signal("health_changed", current_health)

func is_visible()->bool:
	return always_visible or !(is_max_health() or is_dead())

func remove_health(amount: float)->void:
	set_current_health(current_health - amount)

func add_health(amount: float)->void:
	set_current_health(current_health + amount)

func get_class()->String:
	return "HealthBar"
