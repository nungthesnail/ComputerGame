extends Program


var window : Window = null
var program : Control = null
var print_callback : Callable = func (data) : pass
var output : Array[String] = []


func main(data = null):
	back_processing = true
	waiting_input = false
	computer.make_program_current(self)
	
	window = Window.new()
	window.size = Vector2(900, 450)
	window.title = "LUAnvil - Интегрированная среда разработки"
	window.close_requested.connect(end)
	program = load("res://Scripts/Computer/Programs/luANVIL/CodeEditor.tscn").instantiate()
	program.parent_process = self
	print_callback = program.printv
	window.add_child(program)
	computer.ui.get_node("Windows").add_child(window)
	window.popup_centered()
	
	computer.printv("LUAnvil запущена\n")


func end():
	window.queue_free()
	computer.printv("LUAnvil закрыта")
	super.end()


func api(data : String):
	if data == "get_output":
		return output.duplicate()


func run(code, input_data):
	output.clear()
	LuaInterpreter.create_interpreter(code, input_data, printv)
	LuaInterpreter.execute()


func printv(data):
	output.push_back("{0}".format([data]))
	print("Lua output: {0}".format([data]))
	if print_callback:
		print_callback.call(data)
