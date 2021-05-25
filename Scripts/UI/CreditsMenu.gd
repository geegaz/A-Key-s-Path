extends Control

export(NodePath) var auto_scroll_timer_path = "AutoScrollTimer"
export(NodePath) var scroll_container_path = "ScrollContainer"
onready var scrollbar: VScrollBar = get_node(scroll_container_path).get_v_scrollbar()

