tool

class_name GGRichTextLabel
extends RichTextLabel

#-------------------------------------------------------------------------------
# GAMEGUI PROPERTIES
#-------------------------------------------------------------------------------

#export_group("Text Size")

# Check to lock in the current font size and reference node height as reference
# values that will be used to scale the font size.
export(int, "DEFAULT", "SCALE", "PARAMETER") var text_size_mode := GGComponent.TextSizeMode.DEFAULT setget _set_text_size_mode
	
func _set_text_size_mode(value):
	if text_size_mode == value: return
	text_size_mode = value
	if not get_parent(): return  # resource loading is setting properties

	match value:
		GGComponent.TextSizeMode.DEFAULT:
			reference_node_height = 0
			for style_name in reference_font_sizes.keys():
				reference_font_sizes[style_name] = 0

		GGComponent.TextSizeMode.SCALE:
			var ref_node: Control = _get_reference_node()
			if ref_node:
				reference_node_height = floor(ref_node.rect_size.y)
			for style_name in reference_font_sizes.keys():
				var style_size_name = style_name + "_font_size"
				reference_font_sizes[style_name] = get_theme_font_size( style_size_name )
			
			printt(reference_node, ref_node)

		GGComponent.TextSizeMode.PARAMETER:
			reference_node_height = 0
			for style_name in reference_font_sizes.keys():
				reference_font_sizes[style_name] = 0
			for style_name in text_size_parameters.keys():
				var var_name = text_size_parameters[style_name]
				if not has_parameter(var_name): var_name = text_size_parameters["normal"]
				if has_parameter(var_name):
					var cur_size = int(get_parameter(var_name))
					if cur_size:
						var style_size_name = style_name + "_font_size"
						add_theme_font_size_override( style_size_name, cur_size )
	
func get_theme_font_size(name: String, theme_type: String = "") -> int:
	return 0
	
func add_theme_font_size_override(name: String, size: int):
	pass
	
## A node that will be used as a height reference for scaling this node's text.
export(NodePath) var reference_node = null setget _set_reference_node
	
func _set_reference_node(value):
	if reference_node == value: return
	reference_node = value
	var ref_node: Control = get_node(reference_node as NodePath)
	if ref_node and reference_node_height == 0:
		reference_node_height = int(ref_node.rect_size.y)
		request_layout()
	
func _get_reference_node() -> Control:
	if reference_node == null:
		return null
	return get_node(reference_node as NodePath) as Control
	

## The height of the [RichTextLabel] node that the [member reference_font_size] was designed for.
## This is used to scale the font based on the current height of the reference node.
export(int) var reference_node_height := 0 setget _set_reference_node_height
	
func _set_reference_node_height(value):
	if reference_node_height == value: return
	reference_node_height = value
	request_layout()

## The original size of each font style.
export var reference_font_sizes:Dictionary = {"normal":0,"bold":0,"italics":0,"bold_italics":0,"mono":0}

## The names of the parameters to use when [member text_size_mode] is [b]Parameter[/b].
## The parameter for style "normal" will be the default for any other style that does not specify a
## parameter.
export(Dictionary) var text_size_parameters:Dictionary = {"normal":"","bold":"","italics":"","bold_italics":"","mono":""} setget _set_text_size_parameters
	
func _set_text_size_parameters(value):
	if text_size_parameters == value: return
	text_size_parameters = value

	if text_size_mode == GGComponent.TextSizeMode.PARAMETER:
		for style_name in text_size_parameters.keys():
			var var_name = text_size_parameters[style_name]
			if not has_parameter(var_name): var_name = text_size_parameters["normal"]
			if has_parameter(var_name):
				var cur_size = int(get_parameter(var_name))
				if cur_size:
					var style_size_name = style_name + "_font_size"
					add_theme_font_size_override( style_size_name, cur_size )

#export_group("Component Layout")

## The horizontal scaling mode for this node.
export(int, "EXPAND_TO_FILL", "ASPECT_FIT", "ASPECT_FILL", "PROPORTIONAL", "SHRINK_TO_FIT", "FIXED", "PARAMETER") var horizontal_mode := GGComponent.ScalingMode.EXPAND_TO_FILL \
	setget _set_horizontal_mode
	
func _set_horizontal_mode(value):
	if horizontal_mode == value: return
	horizontal_mode = value
	if value in [GGComponent.ScalingMode.ASPECT_FIT,GGComponent.ScalingMode.ASPECT_FILL]:
		if vertical_mode in [GGComponent.ScalingMode.PROPORTIONAL,GGComponent.ScalingMode.FIXED,GGComponent.ScalingMode.PARAMETER]: vertical_mode = value
		if layout_size.x  < 0.0001: layout_size.x = 1
		if layout_size.y  < 0.0001: layout_size.y = 1
	elif vertical_mode in [GGComponent.ScalingMode.ASPECT_FIT,GGComponent.ScalingMode.ASPECT_FILL]:
		if not (value in [GGComponent.ScalingMode.EXPAND_TO_FILL,GGComponent.ScalingMode.SHRINK_TO_FIT,GGComponent.ScalingMode.PARAMETER]): vertical_mode = value
	if value == GGComponent.ScalingMode.PROPORTIONAL:
		if layout_size.x < 0.0001 or layout_size.x > 1: layout_size.x = 1
		if layout_size.y < 0.0001 or layout_size.x > 1: layout_size.y = 1
	request_layout()

## The vertical scaling mode for this node.
export(int, "EXPAND_TO_FILL", "ASPECT_FIT", "ASPECT_FILL", "PROPORTIONAL", "SHRINK_TO_FIT", "FIXED", "PARAMETER") var vertical_mode := GGComponent.ScalingMode.EXPAND_TO_FILL \
	setget _set_vertical_mode
	
func _set_vertical_mode(value):
	if vertical_mode == value: return
	vertical_mode = value
	if value in [GGComponent.ScalingMode.ASPECT_FIT,GGComponent.ScalingMode.ASPECT_FILL]:
		if horizontal_mode in [GGComponent.ScalingMode.PROPORTIONAL,GGComponent.ScalingMode.FIXED,GGComponent.ScalingMode.PARAMETER]: horizontal_mode = value
		if abs(layout_size.x)  < 0.0001: layout_size.x = 1
		if abs(layout_size.y)  < 0.0001: layout_size.y = 1
	elif horizontal_mode in [GGComponent.ScalingMode.ASPECT_FIT,GGComponent.ScalingMode.ASPECT_FILL]:
		if not (value in [GGComponent.ScalingMode.EXPAND_TO_FILL,GGComponent.ScalingMode.SHRINK_TO_FIT,GGComponent.ScalingMode.PARAMETER]): horizontal_mode = value
	if value == GGComponent.ScalingMode.PROPORTIONAL:
		if layout_size.x < 0.0001 or layout_size.x > 1: layout_size.x = 1
		if layout_size.y < 0.0001 or layout_size.x > 1: layout_size.y = 1
	request_layout()

## Pixel values for scaling mode [b]Fixed[/b], fractional values for [b]Proportional[/b], and aspect ratio values for [b]Aspect Fit[/b] and [b]Aspect Fill[/b].
export(Vector2) var layout_size := Vector2(0,0) setget _set_layout_size
	
func _set_layout_size(value):
	if layout_size == value: return
	# The initial Vector2(0,0) may come in as e.g. 0.00000000000208 for x and y
	if abs(value.x) < 0.00001: value.x = 0
	if abs(value.y) < 0.00001: value.y = 0
	layout_size = value
	request_layout()

## The name of the parameter to use for the [b]Parameter[/b] horizontal scaling mode.
export(String) var width_parameter := "" setget _set_width_parameter
	
func _set_width_parameter(value):
	if width_parameter == value: return
	width_parameter = value
	if value != "" and has_parameter(value):
		request_layout()

## The name of the parameter to use for the [b]Parameter[/b] vertical_mode scaling mode.
export(String) var height_parameter := "" setget _set_height_parameter
	
func _set_height_parameter(value):
	if height_parameter == value: return
	height_parameter = value
	if value != "" and has_parameter(value):
		request_layout()

## Automatically set to indicate that default properties have been set
## for this node. Uncheck to reset those defaults.
export(bool) var is_configured := false

# Internal editor use to detect font size changes and request an updated layout.
var _current_node_height := 0
var _current_font_sizes:Dictionary = {"normal":0,"bold":0,"italics":0,"bold_italics":0,"mono":0}

# GameGUI framework use
var is_width_resolved  := false  ## Internal GameGUI use.
var is_height_resolved := false  ## Internal GameGUI use.

#-------------------------------------------------------------------------------
# GGRICHTEXTLABEL METHODS
#-------------------------------------------------------------------------------
func _ready():
	_configure()

func _process(_delta):
	_configure()
	_check_for_modified_font_size()

func _check_for_modified_font_size():
	if not Engine.is_editor_hint(): return

	var any_modified = false

	match text_size_mode:
		GGComponent.TextSizeMode.DEFAULT:
			for style_name in _current_font_sizes.keys():
				var style_size_name = style_name + "_font_size"
				var cur_size = get_theme_font_size( style_size_name )
				if cur_size != _current_font_sizes[style_name]:
					_current_font_sizes[style_name] = cur_size
					any_modified = true

		GGComponent.TextSizeMode.SCALE:
			for style_name in _current_font_sizes.keys():
				if _current_font_sizes[style_name] != reference_font_sizes[style_name]:
					_current_font_sizes[style_name] = reference_font_sizes[style_name]
					any_modified = true
			
			var ref_node: Control = _get_reference_node()
			if ref_node:
				var h = int(ref_node.rect_size.y)
				if _current_node_height != h:
					_current_node_height = h
					any_modified = true

		GGComponent.TextSizeMode.PARAMETER:
			pass

	if any_modified: request_layout()

func _configure():
	if not is_configured and rect_size.y > 0:
		is_configured = true
		bbcode_enabled = true
		scroll_active = false
		horizontal_mode  = GGComponent.ScalingMode.EXPAND_TO_FILL
		vertical_mode = GGComponent.ScalingMode.FIXED
		if abs(layout_size.x) < 0.0001 and abs(layout_size.y) < 0.0001:
			layout_size = Vector2( get_content_width(), get_content_height() )
		if text == "": text = "[center]GGRichTextLabel"
	
func get_content_width() -> int:
	return rect_size.x as int
	
#-------------------------------------------------------------------------------
# GAMEGUI API
#-------------------------------------------------------------------------------

## Returns the specified parameter's value if it exists in a [GGComponent]
## parent or ancestor. If it doesn't exist, returns [code]0[/code] or a
## specified default result.
func get_parameter( parameter_name:String, default_result=0 ):
	var top = get_top_level_component()
	if top and top.parameters.has(parameter_name):
		return top.parameters[parameter_name]
	else:
		return default_result

## Returns the root of this [GGComponent] subtree.
func get_top_level_component()->GGComponent:
	var cur = self
	while cur and (not cur is GGComponent or not cur._is_top_level):
		cur = cur.get_parent()
	return cur

## Returns [code]true[/code] if the specified parameter exists in a
## [GGComponent] parent or ancestor.
func has_parameter( parameter_name:String )->bool:
	var top = get_top_level_component()
	if top:
		return top.parameters.has(parameter_name)
	else:
		return false

## Sets the named parameter's value in the top-level [GGComponent] root of this subtree.
func set_parameter( parameter_name:String, value ):
	var top = get_top_level_component()
	if top: top.parameters[parameter_name] = value

# Called when this component is about to compute its size. Any size computations
# relative to reference nodes higher in the tree should be performed here.
func _on_resolve_size( available_size:Vector2 ):
	if Engine.is_editor_hint():
		match text_size_mode:
			GGComponent.TextSizeMode.DEFAULT:
				# Save current font size theme override size to check for editor changes
				for style_name in _current_font_sizes.keys():
					var style_size_name = style_name + "_font_size"
					_current_font_sizes[style_name] = get_theme_font_size( style_size_name )

			GGComponent.TextSizeMode.SCALE:
				# Save current font reference size to check for editor changes
				var ref_node: Control = _get_reference_node()
				if ref_node:
					_current_node_height = int( ref_node.rect_size.y )

				for style_name in reference_font_sizes.keys():
					_current_font_sizes[style_name] = reference_font_sizes[style_name]

	match text_size_mode:
		GGComponent.TextSizeMode.SCALE:
			var ref_node: Control = _get_reference_node()
			if ref_node and reference_node_height:
				var cur_scale = floor(ref_node.rect_size.y) / reference_node_height

				# Override the size of each font
				for style_name in reference_font_sizes.keys():
					var cur_size = reference_font_sizes[style_name] * cur_scale
					if cur_size:
						var style_size_name = style_name + "_font_size"
						add_theme_font_size_override( style_size_name, cur_size )

		GGComponent.TextSizeMode.PARAMETER:
			for style_name in text_size_parameters.keys():
				var var_name = text_size_parameters[style_name]
				if not has_parameter(var_name): var_name = text_size_parameters["normal"]
				if has_parameter(var_name):
					var cur_size = int(get_parameter(var_name))
					if cur_size:
						var style_size_name = style_name + "_font_size"
						add_theme_font_size_override( style_size_name, cur_size )

	layout_size = Vector2( get_content_width(), get_content_height() )
	rect_size = layout_size

## Layout is performed automatically in most cases, but request_layout() can be
## called for edge cases.
func request_layout():
	var top = get_top_level_component()
	if top: top.request_layout()
