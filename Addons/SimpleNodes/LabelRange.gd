class_name LabelRange, "./LabelRange.svg"
extends Range

export(NodePath) var label_path: NodePath
onready var _Label: = get_node_or_null(label_path) as Label

export(bool) var show_max_value: = false

func _ready() -> void:
	connect("value_changed", self, "_on_value_changed")
	update_label()

func _on_value_changed(new_value: float)->void:
	update_label()

func update_label()->void:
	# If there's no label defined
	if !_Label:
		return
	_Label.text = str(value)
	if show_max_value:
		_Label.text += "/%s"%max_value

func get_class()->String:
	return "LabelRange"
