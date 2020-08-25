extends Line2D

export(int, 1, 100) var precision = 10 # number of points
export(float, 1.0, 100.0) var length = 10.0

func _ready():
	# Hide the default line
	self.width = 0.0
	# Setup the starting points
	var p0 = self.points[0]
	var p2 = self.points[-1]
	#Setup the control point
	var p1 = p0.linear_interpolate(p2, 0.5)
	p1.y += length
	
	# Create the additional points of the curve
	var temp_points = []
	for i in range(precision+1):
# warning-ignore:return_value_discarded
		temp_points.append(_quadratic_bezier(p0, p1, p2, 1.0/precision*i))
	print(temp_points)
	self.points = temp_points
	
	# Setup waving shader
	material.set_shader_param("pos1", p0.x)
	material.set_shader_param("pos2", p2.x)
	material.set_shader_param("active", true)

func _draw():
	# After setup, draw manually the segments
	# This is to avoid a jagged line caused by downscaling
	for i in range(self.points.size()-1):
		draw_line(self.points[i], self.points[i+1], Color(0.0,0.0,0.0))

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var r = q0.linear_interpolate(q1, t)
	return r
