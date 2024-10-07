extends Program


var step : int = 0


func main(args : Array = []):
	waiting_input = false
	back_processing = true
	computer.print_help("Hello! It\'s your first task! Please, launch the TestProgram with argument Sasha. I ought to ask it for some data. 12345678901234567890")
	step = 1


func process(delta : float):
	var plist = computer.program_list
	if step == 1:
		for p in plist:
			if p.program_name == "test01":
				if p.api("get_last_name") == "Sasha":
					computer.print_help("You completed the task! {0}".format([delta]))
					step = 2
					p.api("end")
	elif step == 2:
		end()
