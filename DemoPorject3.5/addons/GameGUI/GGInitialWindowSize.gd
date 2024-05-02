tool

## A control that sets the initial window size to be its own size if it is the base
## node of the scene. Facilitates testing child scenes individually with a customized aspect
## ratio similar to what their bounds will be when placed in the parent scene.
class_name GGInitialWindowSize
extends GGComponent

## The desired initial size of the window. Only takes effect when this node is the base node
## of a scene at runtime.
export(Vector2) var initial_window_size := Vector2(1280,720) setget _set_initial_window_size
	
func _set_initial_window_size(value):
	if initial_window_size == value: return
	initial_window_size = value

	var viewport = get_viewport()
	if not viewport: return  # engine is setting the initial value of this property
	if not Engine.is_editor_hint() or viewport != get_parent(): return

	if value != rect_size:
		rect_size = value
		request_layout()

func _ready():
	if get_parent() == get_viewport() and not Engine.is_editor_hint():
		#DisplayServer.window_set_size( initial_window_size )
		OS.set_window_size(Vector2(initial_window_size.x, initial_window_size.y))
		
		#var screen_size = Vector2(DisplayServer.screen_get_size())
		#var pos = Vector2i( (screen_size-initial_window_size)/2.0 )
		#DisplayServer.window_set_position( pos )
		
		var screen_size = OS.get_screen_size()
		var pos = Vector2( (screen_size - initial_window_size) * 0.5 )
		OS.set_window_position( pos )

		#set_anchors_and_offsets_preset( LayoutPreset.PRESET_FULL_RECT )
	else:
		initial_window_size = Vector2(rect_size)

func _enter_tree():
	._enter_tree()
	if get_parent() == get_viewport():
		#resized.connect( _on_resized )
		connect("resized", self, "_on_resized")

func _exit_tree():
	._exit_tree()
	#if resized.is_connected( _on_resized ):
	#	resized.disconnect( _on_resized )
	if is_connected("resized", self, "_on_resized"):
		disconnect("resized", self, "_on_resized")

func _on_resized():
	if Engine.is_editor_hint(): initial_window_size = rect_size
