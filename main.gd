extends Control

@onready var openDialog: FileDialog = $openDialog
@onready var newDialog: FileDialog = $newDialog
@onready var code_editor: CodeEdit = $CodeEdit

var current_file
var current_path
var has_opened_file: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	has_opened_file = false
	
	var cmdline_args = OS.get_cmdline_args() as PackedStringArray
	print(OS.get_cmdline_args())
	
	# Check if app has been opened with a file
	if cmdline_args.is_empty():
		print("no commandline args")
	else:
		print("found commandline args")
		
		var path = cmdline_args[0]
		has_opened_file = true
		current_path = path
		current_file = FileAccess.open(path, FileAccess.READ)
		code_editor.text = current_file.get_as_text()
		

func _on_open_pressed():
	# Show open dialog
	openDialog.show()

func _on_save_pressed():
	if has_opened_file == true:
		current_file = FileAccess.open(current_path, FileAccess.WRITE)
		
		# Store the code_editor's node text variable into the current file
		current_file.store_string(code_editor.text)
		
		current_file = FileAccess.open(current_path, FileAccess.READ)

func _on_open_dialog_file_selected(path):
	has_opened_file = true
	current_path = path
	current_file = FileAccess.open(path, FileAccess.READ)
	code_editor.text = current_file.get_as_text()

func _on_new_pressed():
	# Show the New dialog, this is different
	# than the open dialog because it
	# overrides existing files or creates new ones.
	newDialog.show()

func _on_new_dialog_file_selected(path):
	has_opened_file = true
	current_path = path
	current_file = FileAccess.open(path, FileAccess.WRITE)
	current_file.store_string("")
	code_editor.text = ""
