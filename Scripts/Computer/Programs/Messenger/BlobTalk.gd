extends Program


var window : Window = null
var program : Control = null
var api_data : Dictionary = {
	"last_read_chat": ""
}


func main(data : Array = []):
	computer.make_program_current(self)
	
	window = Window.new()
	window.close_requested.connect(end)
	window.size = Vector2(800, 350)
	window.position = Vector2(50, 50)
	window.title = "BlobTalk - Просто мессенджер"
	program = load("res://Scripts/Computer/Programs/Messenger/Messenger.tscn").instantiate()
	program.parent_process = self
	window.add_child(program)
	computer.ui.get_node("Windows").add_child(window)
	window.show()
	
	computer.printv("BlobTalk started!\n")


func end():
	window.queue_free()
	computer.printv("Thank you for using BlobTalk!\n")
	# GameProgress.messenger_data.save()
	super.end()


func api(data : String):
	if data in api_data.keys():
		return api_data[data]
