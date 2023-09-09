extends CodeEdit

@onready var text_theme = load("res://theme_file.tres") as Theme

# Called when the node enters the scene tree for the first time.
func _ready():
	text_theme.set("default_font_size", 20)

func _input(_event):
	if Input.is_action_pressed("size_up"):
		text_theme.set("default_font_size", clamp(text_theme.get("default_font_size") + 1, 0, 200))
	elif Input.is_action_just_pressed("size_down"):
		text_theme.set("default_font_size", clamp(text_theme.get("default_font_size") - 1, 0, 200))
