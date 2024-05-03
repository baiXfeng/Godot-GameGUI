tool

class_name GGNinePatchRect
extends GGComponent

export(Texture) var texture:Texture setget _set_texture
func _set_texture(value):
	texture = value
	if not texture: return
	_texture_region = Rect2( 0, 0, texture.get_width(), texture.get_height() )
	_update_piece_rects()

export(bool) var draw_center := true setget _set_draw_center
func _set_draw_center(value):
	draw_center = value
	#queue_redraw()
	update()

#export_group("Patch Margin")

export(int) var left := 0 setget _set_left
func _set_left(value):
	left = clamp( value, 0, _texture_region.size.x )
	_update_piece_rects()

export(int) var top := 0 setget _set_top
func _set_top(value):
	top = clamp( value, 0, _texture_region.size.y )
	_update_piece_rects()

export(int) var right := 0 setget _set_right
func _set_right(value):
	right = clamp( value, 0, _texture_region.size.x )
	_update_piece_rects()

export(int) var bottom := 0 setget _set_bottom
func _set_bottom(value):
	bottom = clamp( value, 0, _texture_region.size.y )
	_update_piece_rects()

#export_group("Fill Mode")

export(int, "STRETCH", "TILE", "TILE_FIT") var horizontal_fill := FillMode.STRETCH setget _set_horizontal_fill
func _set_horizontal_fill(value):
	horizontal_fill = value
	#queue_redraw()
	update()

export(int, "STRETCH", "TILE", "TILE_FIT") var vertical_fill := FillMode.STRETCH setget _set_vertical_fill
func _set_vertical_fill(value):
	vertical_fill = value
	#queue_redraw()
	update()

var _texture_region:Rect2
var _piece_rects:Array = []

func _draw():
	if rect_size.x == 0 or rect_size.y == 0 or not texture: return

	var _left = left
	var _right = right
	var _top = top
	var _bottom = bottom

	if left + right > rect_size.x or top + bottom > rect_size.y:
		var scale_x = rect_size.x / (_left + _right)
		var scale_y = rect_size.y / (_top + _bottom)
		var scale = min( scale_x, scale_y )

		_left = floor( _left * scale )
		_right = ceil( _right * scale )
		_top = floor( _top * scale )
		_bottom = ceil( _bottom * scale )

	var mid_w = max( rect_size.x - (_left+_right), 0 )
	var mid_h = max( rect_size.y - (_top+_bottom), 0 )

	var pos = rect_position
	if _top > 0:
		if _left > 0:   draw_texture_rect_region( texture, Rect2(pos,Vector2(_left,_top)), _piece_rects[0], modulate )
		pos += Vector2( _left, 0 )
		fill_texture( texture, Rect2(pos,Vector2(mid_w,_top)), _piece_rects[1], horizontal_fill, vertical_fill, modulate )
		pos += Vector2( mid_w, 0 )
		if _right > 0:  draw_texture_rect_region( texture, Rect2(pos,Vector2(_right,_top)), _piece_rects[2], modulate )

	pos = Vector2( rect_position.x, pos.y + _top )
	if mid_h > 0:
		fill_texture( texture, Rect2(pos,Vector2(_left,mid_h)), _piece_rects[3], horizontal_fill, vertical_fill, modulate )
		pos += Vector2( _left, 0 )
		if draw_center and mid_w > 0:  fill_texture( texture, Rect2(pos,Vector2(mid_w,mid_h)), _piece_rects[4], horizontal_fill, vertical_fill, modulate )
		pos += Vector2( mid_w, 0 )
		fill_texture( texture, Rect2(pos,Vector2(_right,mid_h)), _piece_rects[5], horizontal_fill, vertical_fill, modulate )

	pos = Vector2( rect_position.x, pos.y + mid_h )
	if _bottom > 0:
		if _left > 0:   draw_texture_rect_region( texture, Rect2(pos,Vector2(_left,_bottom)), _piece_rects[6], modulate )
		pos += Vector2( _left, 0 )
		fill_texture( texture, Rect2(pos,Vector2(mid_w,_bottom)), _piece_rects[7], horizontal_fill, vertical_fill, modulate )
		pos += Vector2( mid_w, 0 )
		if _right > 0:  draw_texture_rect_region( texture, Rect2(pos,Vector2(_right,_bottom)), _piece_rects[8], modulate )

func _update_piece_rects():
	var x = _texture_region.position.x
	var y = _texture_region.position.y
	var w = _texture_region.size.x
	var h = _texture_region.size.y
	var mid_w = max( w - (left+right), 0 )
	var mid_h = max( h - (top+bottom), 0 )

	_piece_rects = []

	_piece_rects.push_back( Rect2     (      x, y, left,  top) )  # TL
	_piece_rects.push_back( Rect2(      x+left, y, mid_w, top) )  # T
	_piece_rects.push_back( Rect2( x+(w-right), y, right, top) )  # TR

	_piece_rects.push_back( Rect2(           x, y+top, left,  mid_h) )  # L
	_piece_rects.push_back( Rect2(      x+left, y+top, mid_w, mid_h) )  # M
	_piece_rects.push_back( Rect2( x+(w-right), y+top, right, mid_h) )  # R

	_piece_rects.push_back( Rect2(           x, y+(h-bottom), left,  bottom) )  # BL
	_piece_rects.push_back( Rect2(      x+left, y+(h-bottom), mid_w, bottom) )  # B
	_piece_rects.push_back( Rect2( x+(w-right), y+(h-bottom), right, bottom) )  # BR

	#queue_redraw()
	update()
