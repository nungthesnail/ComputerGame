extends Program


var last_name : String = ""


func main(args : Array = []):
	computer.make_program_current(self)
	last_name = String(args.pick_random())
	computer.printv("Hello, [color=red]{0}[/color]\n".format([last_name]))


func api(data : String):
	var splitted = data.split(" ", false)
	if splitted.size() <= 0:
		return null
	elif splitted[0] == "get_last_name":
		return last_name
	elif splitted[0] == "end":
		end()
