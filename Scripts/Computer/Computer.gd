extends Node
class_name Computer


var commands : Dictionary = JSON.parse_string(
	FileAccess.get_file_as_string("res://Scripts/Computer/commands_list.json")
)
var programs : Dictionary = JSON.parse_string(
	FileAccess.get_file_as_string("res://Scripts/Computer/program_list.json")
)

var output_callback : Callable
var ui = null
var computer_name : String = ""

var program_list : Array[Program] = []
var current_program : Array[Program] = []


func start():
	# run_program("res://Scripts/Computer/Programs/TestTask.tres")
	pass


func _process(delta):
	for program in program_list:
		if program.back_processing:
			program.process(delta)


func recept_input(data : String):
	printv("> [i]{0}[/i]\n".format([data]))
	
	if current_program.size() > 0:
		current_program[-1].accept_input(data)
		return
	
	handle_command(data)

#---------------------

func handle_command(data : String):
	var splitted = data.split(" ", false)
	if splitted.size() <= 0 || !(splitted[0] in commands.keys()):
		return
	
	if splitted[0] == "shutdown":
		shutdown()
	elif splitted[0] == "run":
		if splitted.size() < 2:
			return
		if !(splitted[1] in programs.keys()):
			return
		if !ResourceLoader.exists(programs[splitted[1]]["path"]):
			return
		if programs[splitted[1]]["avaible"] != "all":
			if !(computer_name in programs[splitted[1]]["avaible"].split("|")):
				return
		
		run_program(programs[splitted[1]]["path"], splitted.slice(2))
	else:
		run_program(commands[splitted[0]]["path"], splitted.slice(1))


func shutdown():
	if ui:
		ui.shutdown()


func run_program(path : String, args : Array = []):
	var program : Program = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_REPLACE)
	program.output_callback = output_callback
	program.computer = self
	program_list.append(program)
	var ret = program.main(args)
	
	if ret is String:
		output_callback.call(ret)


func make_program_current(prog : Program):
	if !(prog in program_list):
		return
	
	current_program.append(prog)


func dispose_program(prog : Program):
	if !prog in program_list:
		return
	var i = program_list.find(prog)
	program_list[i] = null
	program_list.pop_at(i)
	
	if prog in current_program:
		current_program.pop_at(current_program.find(prog))


func printv(something):
	output_callback.call(something)


func print_help(something : String):
	ui.set_help_text(something)
