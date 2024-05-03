tool
extends EditorPlugin
	
func _enter_tree():
	# Initialization of the plugin goes here.
	"""
	add_custom_type( "GGButton",               "Button",        _load("GGButton.gd"), _load("Icons/GGButton.svg") )
	add_custom_type( "GGComponent",            "Container",     _load("GGComponent.gd"), _load("Icons/GGComponent.svg") )
	add_custom_type( "GGFiller",               "GGComponent",   _load("GGFiller.gd"), _load("Icons/GGFiller.svg") )
	add_custom_type( "GGHBox",                 "GGComponent",   _load("GGHBox.gd"), _load("Icons/GGHBox.svg") )
	add_custom_type( "GGInitialWindowSize",    "GGComponent",   _load("GGInitialWindowSize.gd"), _load("Icons/GGInitialWindowSize.svg") )
	add_custom_type( "GGLabel",                "Label",         _load("GGLabel.gd"), _load("Icons/GGLabel.svg") )
	add_custom_type( "GGLayoutConfig",         "Node2D",        _load("GGLayoutConfig.gd"), _load("Icons/GGLayoutConfig.svg") )
	add_custom_type( "GGLimitedSizeComponent", "GGComponent",   _load("GGLimitedSizeComponent.gd"), _load("Icons/GGLimitedSizeComponent.svg") )
	add_custom_type( "GGMarginLayout",         "GGComponent",   _load("GGMarginLayout.gd"), _load("Icons/GGMarginLayout.svg") )
	add_custom_type( "GGNinePatchRect",        "GGComponent",   _load("GGNinePatchRect.gd"), _load("Icons/GGNinePatchRect.svg") )
	add_custom_type( "GGParameterSetter",      "GGComponent",   _load("GGParameterSetter.gd"), _load("Icons/GGParameterSetter.svg") )
	add_custom_type( "GGOverlay",              "GGComponent",   _load("GGOverlay.gd"), _load("Icons/GGOverlay.svg") )
	add_custom_type( "GGRichTextLabel",        "RichTextLabel", _load("GGRichTextLabel.gd"), _load("Icons/GGRichTextLabel.svg") )
	add_custom_type( "GGTextureRect",          "TextureRect",   _load("GGTextureRect.gd"), _load("Icons/GGTextureRect.svg") )
	add_custom_type( "GGVBox",                 "GGComponent",   _load("GGVBox.gd"), _load("Icons/GGVBox.svg") )
	"""
	
func _exit_tree():
	# Clean-up of the plugin goes here.
	"""
	remove_custom_type( "GGButton" )
	remove_custom_type( "GGComponent" )
	remove_custom_type( "GGFiller" )
	remove_custom_type( "GGHBox" )
	remove_custom_type( "GGInitialWindowSize" )
	remove_custom_type( "GGLabel" )
	remove_custom_type( "GGLayoutConfig" )
	remove_custom_type( "GGLimitedSizeComponent" )
	remove_custom_type( "GGMarginLayout" )
	remove_custom_type( "GGNinePatchRect" )
	remove_custom_type( "GGParameterSetter" )
	remove_custom_type( "GGOverlay" )
	remove_custom_type( "GGRichTextLabel" )
	remove_custom_type( "GGTextureRect" )
	remove_custom_type( "GGVBox" )
	"""
	
func _load(file: String) -> Resource:
	return load("res://addons/GameGUI/" + file)
	
