extends Control

@onready var openDialog: FileDialog = $openDialog
@onready var newDialog: FileDialog = $newDialog
@onready var saveDialog: FileDialog = $saveDialog
@onready var unsavedChangesDialog: ConfirmationDialog = $UnsavedChangesDialog
@onready var code_editor: CodeEdit = $CodeEdit

var current_file
var current_path
var has_opened_file: bool
var has_unsaved_changes: bool

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if has_unsaved_changes:
			unsavedChangesDialog.show()
		else:
			get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready():
	has_unsaved_changes = false
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

func _process(delta):
	# Set title
	if has_unsaved_changes:
		if has_opened_file:
			DisplayServer.window_set_title("godot-code-edit " + '"' + current_path + '"' + " (unsaved changes!)")
		else:
			DisplayServer.window_set_title("godot-code-edit (unsaved changes!)")
	else:
		if has_opened_file:
			DisplayServer.window_set_title("godot-code-edit " + '"' + current_path + '"')
		else:
			DisplayServer.window_set_title("godot-code-edit")

func _on_open_pressed():
	# Show open dialog
	openDialog.show()

func _on_save_pressed():
	if has_opened_file:
		current_file = FileAccess.open(current_path, FileAccess.WRITE)
		
		# Store the code_editor's node text variable into the current file
		current_file.store_string(code_editor.text)
		
		current_file = FileAccess.open(current_path, FileAccess.READ)
		
		has_unsaved_changes = false
	elif has_opened_file == false and has_unsaved_changes or has_opened_file == false:
		# The save dialog is the same as the new dialog but instead it overwrites
		# the selected file with the text inside code_editor.text.
		saveDialog.show()

func _on_open_dialog_file_selected(path):
	has_opened_file = true
	current_path = path
	current_file = FileAccess.open(path, FileAccess.READ)
	code_editor.text = current_file.get_as_text()

func _on_new_pressed():
	# Show the New dialog, this is different
	# than the open dialog because it
	# overrides existing files or creates new ones.+
	newDialog.show()

func _on_new_dialog_file_selected(path):
	has_opened_file = true
	current_path = path
	current_file = FileAccess.open(path, FileAccess.WRITE)
	current_file.store_string("")
	code_editor.text = ""


func _on_code_edit_text_changed():
	has_unsaved_changes = true


func _on_unsaved_changes_dialog_confirmed():
	get_tree().quit()


func _on_unsaved_changes_dialog_canceled():
	unsavedChangesDialog.hide()

func _on_save_dialog_file_selected(path):
	has_opened_file = true
	has_unsaved_changes = false
	current_path = path
	current_file = FileAccess.open(path, FileAccess.WRITE)
	current_file.store_string(code_editor.text)
	current_file = FileAccess.open(current_path, FileAccess.READ)
