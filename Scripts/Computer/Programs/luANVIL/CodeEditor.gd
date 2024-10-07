extends Control


var parent_process : Program = null
var file_name : String = ""
var input_data : String = ""
@onready var popups : Dictionary = {
	"save_as": $Popups/SaveAs,
	"open": $Popups/Open,
	"input": $Popups/Input
}


func save():
	if !file_name.is_valid_filename():
		push_error("File name isn\'t valid")
		return
	
	var text = $VBoxContainer/SplitContainer/CodeMargin/CodeEdit.text
	FileManager.save_file("userdata/user_programs/{0}".format([file_name]), text, false)


func open():
	if !FileManager.file_exists("userdata/user_programs/{0}".format([file_name])):
		push_error("This file doesn\'t exists!")
		return
	
	var text = FileManager.load_file("userdata/user_programs/{0}".format([file_name]), false)
	$VBoxContainer/SplitContainer/CodeMargin/CodeEdit.text = text


func run():
	if parent_process:
		var code = $VBoxContainer/SplitContainer/CodeMargin/CodeEdit.text
		$VBoxContainer/SplitContainer/OutputMargin/Output.text = ""
		$VBoxContainer/SplitContainer/OutputMargin/Output.clear()
		parent_process.run(code, input_data)


func exit():
	pass


func printv(data):
	$VBoxContainer/SplitContainer/OutputMargin/Output.append_text("{0}\n".format([data]))
