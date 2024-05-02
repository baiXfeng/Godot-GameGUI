tool

## Lays out its children in a layered stack with pixel or proportional margins.
class_name GGMarginLayout
extends GGComponent

enum MarginType {
	PROPORTIONAL,  ## Specify margins between 0.0 and 1.0, similar to anchors.
	FIXED,         ## Margins have fixed pixel sizes.
	PARAMETER      ## Margins use parameters as their pixel sizes.
}

#export_group("Margins")

## Specifies the type of margin that will surround the child content area.
export(int, "PROPORTIONAL", "FIXED", "PARAMETER") var margin_type := MarginType.PROPORTIONAL setget _set_margin_type
	
func _set_margin_type(value):
	if margin_type == value: return
	
	var ref_node: Control = _get_reference_node()
	if ref_node:
		var ref_size = ref_node.rect_size
		if value == MarginType.PROPORTIONAL:
			if margin_type == MarginType.FIXED and ref_size.x and ref_size.y:
				left_margin /= ref_size.x
				top_margin /= ref_size.y
				right_margin /= ref_size.x
				bottom_margin /= ref_size.y
			else:
				left_margin = 0.0
				top_margin = 0.0
				right_margin = 0.0
				bottom_margin = 0.0
		elif value == MarginType.FIXED:
			if margin_type == MarginType.PROPORTIONAL and ref_size.x and ref_size.y:
				left_margin = int( left_margin * ref_size.x )
				top_margin = int( top_margin * ref_size.y )
				right_margin = int( right_margin * ref_size.x )
				bottom_margin = int( bottom_margin * ref_size.y )
			else:
				left_margin = 0
				top_margin = 0
				right_margin = 0
				bottom_margin = 0
	else:
		if value == MarginType.PROPORTIONAL:
			if margin_type == MarginType.FIXED and rect_size.x and rect_size.y:
				left_margin /= rect_size.x
				top_margin /= rect_size.y
				right_margin = 1.0 - (right_margin/rect_size.x)
				bottom_margin = 1.0 - (bottom_margin/rect_size.y)
			else:
				left_margin = 0.0
				top_margin = 0.0
				right_margin = 1.0
				bottom_margin = 1.0
		elif value == MarginType.FIXED:
			if margin_type == MarginType.PROPORTIONAL and rect_size.x and rect_size.y:
				left_margin = int( left_margin * rect_size.x )
				top_margin = int( top_margin * rect_size.y )
				right_margin = int( (1.0 - right_margin) * rect_size.x )
				bottom_margin = int( (1.0 - bottom_margin) * rect_size.y )
			else:
				left_margin = 0
				top_margin = 0
				right_margin = 0
				bottom_margin = 0

	margin_type = value
	request_layout()

## [b]Proportional[/b] Margin Type, no [member reference_node][br]  0.0: no margin[br]  0.25: 25% margin, etc.[br]
## [b]Proportional[/b] Margin Type, [member reference_node] set[br]  0.0: no margin[br]  0.25: margin is 25% size of ref node, etc.[br]
## [b]Fixed[/b] Margin Type[br]  0: no margin[br]  25: 25 pixel margin, etc.[br]
export(float, 0.0, 1.0, 0.0001) var left_margin:float = 0.0 setget _set_left_margin
	
func _set_left_margin(value):
	if left_margin == value: return
	left_margin = value
	if left_margin <= 0.000:
		left_margin = 0.0
	elif left_margin >= 1.000:
		left_margin = 1.0
	request_layout()

## [b]Proportional[/b] Margin Type, no [member reference_node][br]  0.0: no margin[br]  0.25: 25% margin, etc.[br]
## [b]Proportional[/b] Margin Type, [member reference_node] set[br]  0.0: no margin[br]  0.25: margin is 25% size of ref node, etc.[br]
## [b]Fixed[/b] Margin Type[br]  0: no margin[br]  25: 25 pixel margin, etc.[br]
export(float, 0.0,1.0,0.0001) var top_margin:float = 0.0 setget _set_top_margin
	
func _set_top_margin(value):
	if top_margin == value: return
	top_margin = value
	if top_margin <= 0.000:
		top_margin = 0.0
	elif top_margin >= 1.000:
		top_margin = 1.0
	request_layout()

## [b]Proportional[/b] Margin Type, no [member reference_node][br]  0.0: no margin[br]  0.75: 25% margin, etc.[br]
## [b]Proportional[/b] Margin Type, [member reference_node] set[br]  0.0: no margin[br]  0.25: margin is 25% size of ref node, etc.[br]
## [b]Fixed[/b] Margin Type[br]  0: no margin[br]  25: 25 pixel margin, etc.[br]
export(float, 0.0,1.0,0.0001) var right_margin:float = 1.0 setget _set_right_margin
	
func _set_right_margin(value):
	if right_margin == value: return
	right_margin = value
	request_layout()

## [b]Proportional[/b] Margin Type, no [member reference_node][br]  0.0: no margin[br]  0.75: 25% margin, etc.[br]
## [b]Proportional[/b] Margin Type, [member reference_node] set[br]  0.0: no margin[br]  0.25: margin is 25% size of ref node, etc.[br]
## [b]Fixed[/b] Margin Type[br]  0: no margin[br]  25: 25 pixel margin, etc.[br]
export(float, 0.0,1.0,0.0001) var bottom_margin:float = 1.0 setget _set_bottom_margin
	
func _set_bottom_margin(value):
	if bottom_margin == value: return
	bottom_margin = value
	if bottom_margin <= 0.000:
		bottom_margin = 0.0
	elif bottom_margin >= 1.000:
		bottom_margin = 1.0
	request_layout()

## [b]Parameter[/b] Margin Type[br]  "": no left margin[br]  "abc": left margin is [code]get_parameter("abc")[/code] pixels, etc.
export(String) var left_parameter:String = "" setget _set_left_parameter
	
func _set_left_parameter(value):
	if left_parameter == value: return
	left_parameter = value
	request_layout()

## [b]Parameter[/b] Margin Type[br]  "": no top margin[br]  "abc": top margin is [code]get_parameter("abc")[/code] pixels, etc.
export(String) var top_parameter:String = "" setget _set_top_parameter
	
func _set_top_parameter(value):
	if top_parameter == value: return
	top_parameter = value
	request_layout()

## [b]Parameter[/b] Margin Type[br]  "": no right margin[br]  "abc": right margin is [code]get_parameter("abc")[/code] pixels, etc.
export(String) var right_parameter:String = "" setget _set_right_parameter
	
func _set_right_parameter(value):
	if right_parameter == value: return
	right_parameter = value
	request_layout()

## [b]Parameter[/b] Margin Type[br]  "": no bottom margin[br]  "abc": bottom margin is [code]get_parameter("abc")[/code] pixels, etc.
export(String) var bottom_parameter:String = "" setget _set_bottom_parameter
	
func _set_bottom_parameter(value):
	if bottom_parameter == value: return
	bottom_parameter = value
	request_layout()

func _resolve_shrink_to_fit_height( available_size:Vector2 ):
	._resolve_shrink_to_fit_height( available_size )

	match margin_type:
		MarginType.PROPORTIONAL:
			var ref_node: Control = _get_reference_node()
			if ref_node:
				rect_size.y += int( top_margin * ref_node.rect_size.y )
				rect_size.y += int( bottom_margin * ref_node.rect_size.y )
			else:
				rect_size.y += int( available_size.y * top_margin )
				rect_size.y += int( available_size.y * bottom_margin )
		MarginType.FIXED:
			rect_size.y += top_margin
			rect_size.y += bottom_margin
		MarginType.PARAMETER:
			rect_size.y += get_parameter(top_parameter,0)
			rect_size.y += get_parameter(bottom_parameter,0)

func _resolve_shrink_to_fit_width( available_size:Vector2 ):
	._resolve_shrink_to_fit_width( available_size )

	match margin_type:
		MarginType.PROPORTIONAL:
			var ref_node: Control = _get_reference_node()
			if ref_node:
				rect_size.x += int( left_margin * ref_node.rect_size.x )
				rect_size.x += int( right_margin * ref_node.rect_size.x )
			else:
				rect_size.x += int( available_size.x * left_margin )
				rect_size.x += int( available_size.x * right_margin )
		MarginType.FIXED:
			rect_size.x += left_margin
			rect_size.x += right_margin
		MarginType.PARAMETER:
			rect_size.x += get_parameter(left_parameter,0)
			rect_size.x += get_parameter(right_parameter,0)

func _with_margins( rect:Rect2 )->Rect2:
	match margin_type:
		MarginType.PROPORTIONAL:
			var ref_node: Control = _get_reference_node()
			if ref_node:
				var left = int( left_margin * ref_node.rect_size.x )
				var right = int( right_margin * ref_node.rect_size.x )
				var top = int( top_margin * ref_node.rect_size.y )
				var bottom = int( bottom_margin * ref_node.rect_size.y )
				var x = rect.position.x + left
				var y = rect.position.y + top
				var x2 = rect.position.x + (rect.size.x - right)
				var y2 = rect.position.y + (rect.size.y - bottom)
				var w = x2 - x
				var h = y2 - y
				if w < 0: w = 0
				if h < 0: h = 0
				return Rect2( x, y, w, h )
			else:
				var x = rect.position.x + floor( rect.size.x * left_margin )
				var y = rect.position.y + floor( rect.size.y * top_margin )
				var x2 = rect.position.x + floor( rect.size.x * right_margin )
				var y2 = rect.position.y + floor( rect.size.y * bottom_margin )
				var w = x2 - x
				var h = y2 - y
				if w < 0: w = 0
				if h < 0: h = 0
				return Rect2( x, y, w, h )
		MarginType.FIXED:
			var x = rect.position.x + left_margin
			var y = rect.position.y + top_margin
			var x2 = rect.position.x + (rect.size.x - right_margin)
			var y2 = rect.position.y + (rect.size.y - bottom_margin)
			var w = x2 - x
			var h = y2 - y
			if w < 0: w = 0
			if h < 0: h = 0
			return Rect2( x, y, w, h )
		MarginType.PARAMETER:
			var x = rect.position.x + get_parameter(left_parameter,0)
			var y = rect.position.y + get_parameter(top_parameter,0)
			var x2 = rect.position.x + (rect.size.x - get_parameter(right_parameter,0))
			var y2 = rect.position.y + (rect.size.y - get_parameter(bottom_parameter,0))
			var w = x2 - x
			var h = y2 - y
			if w < 0: w = 0
			if h < 0: h = 0
			return Rect2( x, y, w, h )
		_: return rect

