tool

## A component that sizes normally and then sets subtree parameters to its own width and/or height.
class_name GGParameterSetter
extends GGComponent

#export_group("Parameter Names")

## Optional name of a parameter to save this node's width in.
export(String) var width_store := "" setget _set_width_store
func _set_width_store(value):
	if width_store == value: return
	width_store = value
	if value != "":
		if value != _cur_width_parameter:
			var top = get_top_level_component()
			if top: top.parameters.erase( _cur_width_parameter )
			_cur_width_parameter = value
		set_parameter( width_store, rect_size.x )

## Optional name of a parameter to save this node's height in.
export(String) var height_store := "" setget _set_height_store
func _set_height_store(value):
	if height_store == value: return
	height_store = value
	if value != "":
		if value != _cur_height_parameter:
			var top = get_top_level_component()
			if top: top.parameters.erase( _cur_height_parameter )
			_cur_height_parameter = value
		set_parameter( height_store, rect_size.y )

var _cur_width_parameter := ""
var _cur_height_parameter := ""

func _resolve_size( available_size:Vector2, limited:bool=false ):
	._resolve_size( available_size, limited )
	if width_store != "": set_parameter( width_store, rect_size.x )
	if height_store != "": set_parameter( height_store, rect_size.y )

