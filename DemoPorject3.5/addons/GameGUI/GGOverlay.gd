tool

## Positions its children at arbitrary coordinates within its own bounds, similiar to a sprite.
## Not intended for use with an actual Sprite2D; use GGTextureRect or other Control types as
## children. Typically used with a single child node.
class_name GGOverlay
extends GGComponent

enum PositioningMode {
	PROPORTIONAL,  ## Specify child position as a fraction between 0.0 and 1.0.
	FIXED,         ## Child position is a fixed pixel offset.
	PARAMETER      ## Use a parameter as the child's relative pixel offset.
}

enum ScaleFactor {
	CONSTANT,      ## Scale using a fixed scale factor.
	PARAMETER      ## Scale using a subtree parameter.
}

#export_group("Child Position and Scale")

## The child positioning mode.
export(int, "PROPORTIONAL", "FIXED", "PARAMETER") var positioning_mode := PositioningMode.PROPORTIONAL setget _set_positioning_mode
func _set_positioning_mode(value):
	if positioning_mode == value: return
	match value:
		PositioningMode.PROPORTIONAL:
			if positioning_mode == PositioningMode.FIXED:
				child_x /= rect_size.x
				child_y /= rect_size.y
			else:
				child_x = 0.5
				child_y = 0.5
		PositioningMode.FIXED:
			if positioning_mode == PositioningMode.PROPORTIONAL:
				child_x = int( child_x * rect_size.x )
				child_y = int( child_y * rect_size.y )
			else:
				child_x = int(rect_size.x / 2.0)
				child_y = int(rect_size.y / 2.0)
	positioning_mode = value
	request_layout()

## The child 'x' offset within this component. Use 0.0-1.0 for positioning mode [b]Proportional[/b] and integer values for [b]Fixed[/b].
export(float, 0.0, 1.0, 0.0001) var child_x:float = 0.5 setget _set_child_x
func _set_child_x(value):
	if child_x == value: return
	child_x = value
	if child_x <= 0.0:
		child_x = 0.0
	elif child_x >= 1.0:
		child_x = 1.0
	request_layout()

## The child 'y' offset within this component. Use 0.0-1.0 for positioning mode [b]Proportional[/b] and integer values for [b]Fixed[/b].
export(float, 0.0, 1.0, 0.0001) var child_y:float = 0.5 setget _set_child_y
func _set_child_y(value):
	if child_y == value: return
	child_y = value
	if child_y <= 0.0:
		child_y = 0.0
	elif child_y >= 1.0:
		child_y = 1.0
	request_layout()

## The parameter name to use for the child 'x' offset.
export(String) var child_x_parameter := "" setget _set_child_x_parameter
func _set_child_x_parameter(value):
	if child_x_parameter == value: return
	child_x_parameter = value
	request_layout()

## The parameter name to use for the child 'y' offset.
export(String) var child_y_parameter := "" setget _set_child_y_parameter
func _set_child_y_parameter(value):
	if child_y_parameter == value: return
	child_y_parameter = value
	request_layout()

## The horizontal scale mode.
export(int, "CONSTANT", "PARAMETER") var h_scale_factor := ScaleFactor.CONSTANT setget _set_h_scale_factor
func _set_h_scale_factor(value):
	if h_scale_factor == value: return
	h_scale_factor = value
	request_layout()

## The vertical scale mode.
export(int, "CONSTANT", "PARAMETER") var v_scale_factor := ScaleFactor.CONSTANT setget _set_v_scale_factor
func _set_v_scale_factor(value):
	if v_scale_factor == value: return
	v_scale_factor = value
	request_layout()

## The horizontal scale factor to use when [member h_scale_factor] is [b]Constant[/b].
export(float, 0.0, 1.0, 0.0001) var h_scale_constant:float = 1.0 setget _set_h_scale_constant
func _set_h_scale_constant(value):
	if h_scale_constant == value: return
	h_scale_constant = value
	if h_scale_constant <= 0.0:
		h_scale_constant = 0.0
	elif h_scale_constant >= 1.0:
		h_scale_constant = 1.0
	request_layout()

## The vertical scale factor to use when [member v_scale_factor] is [b]Constant[/b].
export(float, 0.0, 1.0, 0.0001) var v_scale_constant:float = 1.0 setget _set_v_scale_constant
func _set_v_scale_constant(value):
	if v_scale_constant == value: return
	v_scale_constant = value
	if v_scale_constant <= 0.0:
		v_scale_constant = 0.0
	elif v_scale_constant >= 1.0:
		v_scale_constant = 1.0
	request_layout()

## The horizontal scale factor to use when [member h_scale_factor] is [b]Parameter[/b].
export(String) var h_scale_parameter:String = "" setget _set_h_scale_parameter
func _set_h_scale_parameter(value):
	if h_scale_parameter == value: return
	h_scale_parameter = value
	request_layout()

## The vertical scale factor to use when [member v_scale_factor] is [b]Parameter[/b].
export(String) var v_scale_parameter:String = "" setget _set_v_scale_parameter
func _set_v_scale_parameter(value):
	if v_scale_parameter == value: return
	v_scale_parameter = value
	request_layout()

func _get_scale()->Vector2:
	var sx := 0.0
	var sy := 0.0

	match h_scale_factor:
		ScaleFactor.CONSTANT:
			sx = h_scale_constant
		ScaleFactor.PARAMETER:
			sx = get_parameter( h_scale_parameter )

	match v_scale_factor:
		ScaleFactor.CONSTANT:
			sy = v_scale_constant
		ScaleFactor.PARAMETER:
			sy = get_parameter( v_scale_parameter )

	return Vector2(sx,sy)

func _perform_child_layout( available_bounds:Rect2 ):
	for i in range(get_child_count()):
		var child = get_child(i)
		if not child is Control or not child.visible: continue

		var x_pos := 0
		var y_pos := 0
		match positioning_mode:
			PositioningMode.PROPORTIONAL:
				x_pos = available_bounds.size.x * child_x
				y_pos = available_bounds.size.y * child_y
			PositioningMode.FIXED:
				x_pos = child_x
				y_pos = child_y
			PositioningMode.PARAMETER:
				x_pos = get_parameter( child_x_parameter, child_x )
				y_pos = get_parameter( child_y_parameter, child_y )

		# Adjust x_pos and y_pos for SIZE_SHRINK_X.
		if child.size_flags_horizontal & (SizeFlags.SIZE_SHRINK_CENTER | SizeFlags.SIZE_FILL):
			x_pos -= int(child.rect_size.x / 2.0)
		elif child.size_flags_horizontal & SizeFlags.SIZE_SHRINK_END:
			x_pos -= int(child.rect_size.x)

		if child.size_flags_vertical & (SizeFlags.SIZE_SHRINK_CENTER | SizeFlags.SIZE_FILL):
			y_pos -= int(child.rect_size.y / 2.0)
		elif child.size_flags_vertical & SizeFlags.SIZE_SHRINK_END:
			y_pos -= int(child.rect_size.y)

		_perform_component_layout( child, Rect2(Vector2(x_pos,y_pos),child.rect_size) )

func _resolve_child_sizes( available_size:Vector2, limited:bool=false ):
	var scale = _get_scale()

	for i in range(get_child_count()):
		var child = get_child(i)
		if not child is Control or not child.visible: continue

		# Resolve once at full size to get the child's full size
		_resolve_child_size( child, available_size, limited )

		# Apply the scale factor to the child
		_resolve_child_size( child, (child.rect_size * scale).floor(), limited )

