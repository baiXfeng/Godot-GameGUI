tool

## A component that can limit its size to arbitrary minimum and/or maximum values.
class_name GGLimitedSizeComponent
extends GGComponent

enum LimitType {
	UNLIMITED,  ## No size limit.
	FIXED,      ## A limited size in pixels.
	PARAMETER   ## A parameter defines the size limit in pixels.
}

#export_group("Minimum Size")

export(int, "UNLIMITED", "FIXED", "PARAMETER") var min_width  := LimitType.UNLIMITED setget _set_min_width
	
func _set_min_width(value):
	if min_width == value: return
	min_width = value
	request_layout()

export(int, "UNLIMITED", "FIXED", "PARAMETER") var min_height := LimitType.UNLIMITED setget _set_min_height
	
func _set_min_height(value):
	if min_height == value: return
	min_height = value
	request_layout()

export(Vector2) var min_size := Vector2(0,0) setget _set_min_size
	
func _set_min_size(value):
	if min_size == value: return
	min_size = value
	request_layout()

export(String) var min_width_parameter := "" setget _set_min_width_parameter
	
func _set_min_width_parameter(value):
	if min_width_parameter == value: return
	min_width_parameter = value
	request_layout()

export(String) var min_height_parameter := "" setget _set_min_height_parameter
	
func _set_min_height_parameter(value):
	if min_height_parameter == value: return
	min_height_parameter = value
	request_layout()

#export_group("Maximum Size")

export(int, "UNLIMITED", "FIXED", "PARAMETER") var max_width  := LimitType.UNLIMITED setget _set_max_width
	
func _set_max_width(value):
	if max_width == value: return
	max_width = value
	request_layout()

export(int, "UNLIMITED", "FIXED", "PARAMETER") var max_height := LimitType.UNLIMITED setget _set_max_height
	
func _set_max_height(value):
	if max_height == value: return
	max_height = value
	request_layout()

export(Vector2) var max_size := Vector2(0,0) setget _set_max_size
	
func _set_max_size(value):
	if max_size == value: return
	max_size = value
	request_layout()

export(String) var max_width_parameter := "" setget _set_max_width_parameter
	
func _set_max_width_parameter(value):
	if max_width_parameter == value: return
	max_width_parameter = value
	request_layout()

export(String) var max_height_parameter := "" setget _set_max_height_parameter
	
func _set_max_height_parameter(value):
	if max_height_parameter == value: return
	max_height_parameter = value
	request_layout()

func _effective_min_height()->int:
	match min_height:
		LimitType.FIXED:
			return int(min_size.y)
		LimitType.PARAMETER:
			return get_parameter( min_height_parameter, 0 )
		_:
			return 0

func _effective_min_width()->int:
	match min_width:
		LimitType.FIXED:
			return int(min_size.x)
		LimitType.PARAMETER:
			return get_parameter( min_width_parameter, 0 )
		_:
			return 0

func _effective_max_height()->int:
	match max_height:
		LimitType.FIXED:
			return int(max_size.y)
		LimitType.PARAMETER:
			return get_parameter( max_height_parameter, 0 )
		_:
			return 0

func _effective_max_width()->int:
	match max_width:
		LimitType.FIXED:
			return int(max_size.x)
		LimitType.PARAMETER:
			return get_parameter( max_width_parameter, 0 )
		_:
			return 0

func _resolve_size( available_size:Vector2, limited:bool=false ):
	if min_width != LimitType.UNLIMITED:
		available_size.x = max( available_size.x, _effective_min_width() )
	if min_height != LimitType.UNLIMITED:
		available_size.y = max( available_size.y, _effective_min_height() )

	if max_width != LimitType.UNLIMITED:
		available_size.x = min( available_size.x, _effective_max_width() )
	if max_height != LimitType.UNLIMITED:
		available_size.y = min( available_size.y, _effective_max_height() )

	._resolve_size( available_size, limited )
