extends Reference
class_name GGCommon

static func get_node(owner: Node, path: NodePath) -> Node:
	if path == null or path.is_empty():
		return null
	var index = path.get_name_count() - 1
	var last_name = path.get_name(index)
	match last_name:
		"..":
			var current: Node = owner
			for i in path.get_name_count():
				current = current.get_parent()
				if current == null:
					return null
			return current
		".":
			return null
	return owner.get_node(path)
	
static func get_theme_font_size(owner: Control, name: String, theme_type: String = "") -> int:
	if owner == null:
		return 0
	var font: Font = owner.get_font("font")
	if font == null:
		return 0
	return font.get_height() as int
	
static func add_theme_font_size_override(owner: Control, name: String, size: int):
	if owner == null:
		return
	
	
