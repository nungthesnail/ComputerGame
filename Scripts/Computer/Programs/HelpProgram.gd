extends Program


func main(args : Array = []):
	waiting_input = false
	var commands = JSON.parse_string(FileAccess.get_file_as_string(
		"res://Scripts/Computer/commands_list.json"
	))
	
	if args.size() <= 0:
		computer.printv(commands["help"]["description"])
	elif args[0] in commands.keys():
		computer.printv(commands[args[0]]["description"])
	else:
		computer.printv("There\'s no program or command named \"{0}\"\n".format([args[0]]))
	
	end()

